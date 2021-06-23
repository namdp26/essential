Set IP Centos 7

### Cấu hình  IP cho Centos 7
#### 1. Cấu hình Static IP
Vào thư mục lưu các file cấu hình cho các interface :
`# cd /etc/sysconfig/network-scripts/`
#### Tạo file cấu hình :
`# touch ifcfg-ens35`
#### Sửa file và thêm các thông tin: 
####
HWADDR=00:0c:29:8f:10:88            # Địa chỉ MAC của card mạng
TYPE=Ethernet                                                          
BOOTPROTO=static                                                   
IPADDR=192.168.1.254                    # IP Address
NETMASK=255.255.255.0                   # Netmask
GATEWAY=192.168.1.1                     # Default Gateway
DNS1=8.8.8.8                            # DNS server
DNS2=8.8.4.4
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
NAME=ens35					#Ten card mang
DEVICE=ens35
ONBOOT=yes                              # Active card mạng khi khởi động
PEERDNS=yes
PEERROUTES=yes
#####
#### Restart network service
`# systemctl restart network`

#### 2. Cấu hình Dynamic IP
#### Sửa file cấu hình `ifcfg-ens35`:
DEVICE=ens35
BOOTPROTO=DHCP
HWADDR="00:0c:29:8f:10:88"
ONBOOT=yes
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=no
NAME=ens35
#### Restart network service
`# systemctl restart network`