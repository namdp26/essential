## 1. Install NTP Server
NTP (Network Time Protocol) giúp đồng bộ thời gian các Node 

**1.1. Cài đặt trên Controller Node**
```
# apt install chrony
```
**Cấu hình**
```
# vi /etc/chrony/chrony.conf**
```
Thêm các dòng :
```
server 0.vn.pool.ntp.org iburst 
server 1.asia.pool.ntp.org iburst 
server 3.asia.pool.ntp.org iburst 
allow 10.0.0.0/24
```
**Restart NTP**
```
systemctl restart chrony
```
**1.2. Cài đặt trên các node khác**
```
apt install chrony
```
**Cấu hình**
```
# vi /etc/chrony/chrony.conf
```
Thêm các dòng :
```
server controller iburst
```
**Restart NTP**
```
systemctl restart chrony
```

**1.3. Kiểm tra**
```
root@compute1:~# chronyc sources
210 Number of sources = 11
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
^* controller                    3   6    17     3    +90us[-6207ns] +/-   60ms
```

## 2. Install OpenStack Package 
**2.1. Add Repo Openstack Ussuri for Ubuntu**
```
add-apt-repository cloud-archive:ussuri
```
**2.2. Cài đặt Client trên Node Controller**
```
apt install python3-openstackclient
```
## 3. Install Database (MariaDB 10.3)
Hầu hết các Service của Openstack đều sử dụng SQL Database để lưu thông tin. Database sẽ được cài đặt trên Controller Node. Việc sử dụng MariaDB hay MySQL tuỳ thuộc vào từng distro đang sử dụng

**3.1.  Install software-properties-common**
```
apt-get install software-properties-common
```
**3.2. Import MariaDB GPG Key**
```
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
```
**3.3. Add apt repository**
```
add-apt-repository 'deb [arch=amd64] http://mirror.zol.co.zw/mariadb/repo/10.3/ubuntu bionic main'
```
**3.4. Install MariaDB** 
```
apt update

apt -y install mariadb-server mariadb-client
```
**3.5. Cấu hình**
Tạo và sửa file `/etc/mysql/mariadb.conf.d/99-openstack.cnf`
Thêm các dòng sau:
```
[mysqld]
bind-address = 10.0.0.2 #IP Controller Node

default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
```
**3.6. Restart MariaDB**
```
 service mysql restart
```
## 4. Install Message Queue (RabbitMQ)
Openstack sử dụng message queue để điều phối hoạt động và trạng thái giũa các Service. Messeage Queue service được chạy trên controller node. Hướng dẫn này sẽ sử dụng RabbitMQ

**4.1. Install the package** 
```
# apt install rabbitmq-server
```
**4.2. Create User `openstack`**
```
root@controller:~# rabbitmqctl add_user openstack 123456
Creating user "openstack"
```
**4.3. Gắn quyền write, read cho user `openstack`**
```
root@controller:~# rabbitmqctl set_permissions openstack ".*" ".*" ".*"
Setting permissions for user "openstack" in vhost "/"
```

## 5. Install Memcached
Dịch vụ Identity phục vụ việc xác thực sử dụng Memcahed để lưu trữ tokens cache. Memcache trong guide này sẽ được cài đặt trên Controlle Node.

**5.1. Install Memcache Package**
```
apt install memcached python-memcache
```
**5.2. Sửa file `/etc/memcached.conf`  cho phép truy cập qua network managerment**
```
-l 10.0.0.2
```
**5.3. Restart Memcached**
```
 service memcached restart
```

## 5. Install Etcd

Các Service của openstack có thể sử dụng Etcd, để lưu trữ thông tin key locking, cấu hình, theo dõi hoạt động của các dịch vụ khác.

**5.1. Install the etcd package**
```
# apt install etcd
```
**5.2. Sửa file `/etc/default/etcd` set các giá trị`ETCD_INITIAL_CLUSTER, ETCD_INITIAL_ADVERTISE_PEER_URLS, ETCD_ADVERTISE_CLIENT_URLS, ETCD_LISTEN_CLIENT_URLS` để có thể kết nối qua Network mgmt của controller node** 
```
root@controller:~# cat /etc/default/etcd
ETCD_NAME="controller"
ETCD_DATA_DIR="/var/lib/etcd"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster-01"
ETCD_INITIAL_CLUSTER="controller=http://10.0.0.2:2380"
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://10.0.0.2:2380"
ETCD_ADVERTISE_CLIENT_URLS="http://10.0.0.2:2379"
ETCD_LISTEN_PEER_URLS="http://0.0.0.0:2380"
ETCD_LISTEN_CLIENT_URLS="http://10.0.0.2:2379"
``` 
**5.3. Restart & enable etcd** 
```
# systemctl enable etcd
# systemctl restart etcd
```
