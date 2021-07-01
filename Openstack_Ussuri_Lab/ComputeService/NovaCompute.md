## Compute service overview
Use OpenStack Compute to host and manage cloud computing systems. OpenStack Compute is a major part of an Infrastructure-as-a-Service (IaaS) system. The main modules are implemented in Python.

OpenStack Compute interacts with OpenStack Identity for authentication, OpenStack Placement for resource inventory tracking and selection, OpenStack Image service for disk and server images, and OpenStack Dashboard for the user and administrative interface. Image access is limited by projects, and by users; quotas are limited per project (the number of instances, for example). OpenStack Compute can scale horizontally on standard hardware, and download images to launch instances.

OpenStack Compute consists of the following areas and their components:

nova-api service
Accepts and responds to end user compute API calls. The service supports the OpenStack Compute API. It enforces some policies and initiates most orchestration activities, such as running an instance.

nova-api-metadata service
Accepts metadata requests from instances. For more information, refer to Metadata service.

nova-compute service
A worker daemon that creates and terminates virtual machine instances through hypervisor APIs. For example:

XenAPI for XenServer/XCP

libvirt for KVM or QEMU

VMwareAPI for VMware

Processing is fairly complex. Basically, the daemon accepts actions from the queue and performs a series of system commands such as launching a KVM instance and updating its state in the database.

nova-scheduler service
Takes a virtual machine instance request from the queue and determines on which compute server host it runs.

nova-conductor module
Mediates interactions between the nova-compute service and the database. It eliminates direct accesses to the cloud database made by the nova-compute service. The nova-conductor module scales horizontally. However, do not deploy it on nodes where the nova-compute service runs. For more information, see the conductor section in the Configuration Options.

nova-novncproxy daemon
Provides a proxy for accessing running instances through a VNC connection. Supports browser-based novnc clients.

nova-spicehtml5proxy daemon
Provides a proxy for accessing running instances through a SPICE connection. Supports browser-based HTML5 client.

The queue
A central hub for passing messages between daemons. Usually implemented with RabbitMQ but other options are available.

SQL database
Stores most build-time and run-time states for a cloud infrastructure, including:

Available instance types

Instances in use

Available networks

Projects

Theoretically, OpenStack Compute can support any database that SQLAlchemy supports. Common databases are SQLite3 for test and development work, MySQL, MariaDB, and PostgreSQL.

Cài đặt trên Controller Node
**1. Tạo và cấu hình DB**
```
MariaDB [(none)]> CREATE DATABASE nova_api;
Query OK, 1 row affected (0.000 sec)

MariaDB [(none)]> CREATE DATABASE nova;
Query OK, 1 row affected (0.000 sec)

MariaDB [(none)]> CREATE DATABASE nova_cell0;
Query OK, 1 row affected (0.000 sec)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' \
    ->   IDENTIFIED BY '123456';
Query OK, 0 rows affected (0.001 sec)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' \
    ->   IDENTIFIED BY '123456';
Query OK, 0 rows affected (0.000 sec)
MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' \
    ->   IDENTIFIED BY '123456';
Query OK, 0 rows affected (0.000 sec)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' \
    ->   IDENTIFIED BY '123456';
Query OK, 0 rows affected (0.000 sec)
MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' \
    ->   IDENTIFIED BY '123456';
Query OK, 0 rows affected (0.000 sec)
MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%'    IDENTIFIED BY '123456';
Query OK, 0 rows affected (0.000 sec)
```
**2. Tạo User, Service và API**
**- Tạo User Nova**
```
root@controller:~# openstack user create --domain default --password-prompt nova
User Password:
Repeat User Password:
+---------------------+----------------------------------+
| Field               | Value                            |
+---------------------+----------------------------------+
| domain_id           | default                          |
| enabled             | True                             |
| id                  | 5058b07975944b94877facd969185911 |
| name                | nova                             |
| options             | {}                               |
| password_expires_at | None                             |
+---------------------+----------------------------------+

```
**- Add role cho user**
```
openstack role add --project service --user nova admin
```
**- Tạo Service Nova**
```
root@controller:~# openstack service create --name nova \
>   --description "OpenStack Compute" compute
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | OpenStack Compute                |
| enabled     | True                             |
| id          | 7d81ec8445cd4a11a028d6bf44b3d776 |
| name        | nova                             |
| type        | compute                          |
+-------------+----------------------------------+
```
**- Tạo API Endpoint**
```
root@controller:~# openstack endpoint create --region RegionOne \
>   compute public http://controller:8774/v2.1
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 9f9032272f9c4cdda0b3afbcf52bd5e5 |
| interface    | public                           |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 7d81ec8445cd4a11a028d6bf44b3d776 |
| service_name | nova                             |
| service_type | compute                          |
| url          | http://controller:8774/v2.1      |
+--------------+----------------------------------+
root@controller:~# openstack endpoint create --region RegionOne \
>   compute internal http://controller:8774/v2.1
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | a9c8da1f47e841d8a2a983fe556f666f |
| interface    | internal                         |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 7d81ec8445cd4a11a028d6bf44b3d776 |
| service_name | nova                             |
| service_type | compute                          |
| url          | http://controller:8774/v2.1      |
+--------------+----------------------------------+
root@controller:~# openstack endpoint create --region RegionOne \
>   compute admin http://controller:8774/v2.1
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 4075cddda4da4a1587239560bd278a6f |
| interface    | admin                            |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 7d81ec8445cd4a11a028d6bf44b3d776 |
| service_name | nova                             |
| service_type | compute                          |
| url          | http://controller:8774/v2.1      |
+--------------+----------------------------------+
```
**3. Cài đặt và cấu hình Nova Compute**
- Cài đặt Nova-Api, Conductor, Nova-Proxy và Nova Scheduler
```
apt install nova-api nova-conductor nova-novncproxy nova-scheduler
```
- Cấu hình file `/etc/nova/nova.conf` thêm các thành phần 
```
[DEFAULT]
transport_url = rabbit://openstack:123456@controller:5672/
my_ip = 10.0.0.2

[api_database]
connection = mysql+pymysql://nova:123456@controller/nova_api

[database]
connection = mysql+pymysql://nova:123456@controller/nova

[api]
auth_strategy = keystone

[keystone_authtoken]
www_authenticate_uri = http://controller:5000/
auth_url = http://controller:5000/
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = nova
password = 123456

[vnc]
enabled = true
server_listen = $my_ip
server_proxyclient_address = $my_ip

[glance]
api_servers = http://controller:9292

[oslo_concurrency]
lock_path = /var/lib/nova/tmp

[placement]
region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = http://controller:5000/v3
username = placement
password = 123456
```
- Đưa cấu hình nova-api vao DB
```
/bin/sh -c "nova-manage api_db sync" nova
```
- Đăng ký cell0 DB
```
/bin/sh -c "nova-manage cell_v2 map_cell0" nova
```
- Tạo cell1
```
/bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
```
- Đưa cấu hình vào nova-db
```
/bin/sh -c "nova-manage db sync" nova
```
- Verify nova cell0 and cell1
```
root@controller:~# /bin/sh -c "nova-manage cell_v2 list_cells" nova
+-------+--------------------------------------+------------------------------------------+-------------------------------------------------+----------+
|  Name |                           Database Connection               | Disabled |
+-------+---------------
 4.------------------------+------------------------------------------+-------------------------------------------------+----------+
| cell0 | 00000000-0000-0000-0000-000000000000 |                  none:/                  | mysql+pymysql://nova:****@controller/nova_cell0 |  False   |
| cell1 | f579266c-1a9b-462c-90e3-609e6cc00951 | rabbit://openstack:****@controller:5672/ |    mysql+pymysql://nova:****@controller/nova    |  False   |
+-------+--------------------------------------+------------------------------------------+-------------------------------------------------+----------+
root@controller:~# 
```
**4. Restart Compute services** 
```
root@controller:~# service nova-api restart
root@controller:~# service nova-scheduler restart
root@controller:~# service nova-conductor restart
root@controller:~# service nova-novncproxy restart
```
