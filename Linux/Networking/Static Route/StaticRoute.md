### 1\. Static Route

Trong môi trường mạng có sử dụng DHCP thông thường sẽ sử dụng default route (0.0.0.0) đi qua các default gateway mà máy chủ DHCP cấp sẵn để có thể truy cập Internet.
Nhưng trong một số trường hợp cụ thể như khi sử dụng VPN, VXLAN người dùng sẽ cần thiết lập một static route, đi qua gateway của VPN hoặc VXLAN để có thể kết nối tới các vùng mạng khác.

### 2\. Command add route trên Linux

- **Show Routing Table**
    Các lệnh show:
 ```
# route -n
# netstat -ln
# ip route
```

Ví dụ : Client kết nối vào 1 VPN với network tunnel (192.168.29.0/24) sử dụng Virtual NIC vpn_01 (IP: 192.168.29.100/24), gateway (IP: 192.168.29.1/24), Client cần kết nối tới vùng mạng 192.168.254.0/24 qua VPN.

- **Add static route using IP**
    Cú pháp:
```
sudo ip route add {NETWORK/MASK} via {GATEWAYIP}
```
    
	VD:
    
```
sudo ip route add 192.168.254.0/24 via 192.168.29.1
```
- **Add static route using IP & NIC**
    Cú pháp :
```
sudo ip route add {NETWORK/MASK} via {GATEWAYIP} dev {network_card_name}
```

    VD:
```
sudo ip route add 192.168.254.0/24 via 192.168.29.1 dev vpn_01
```
- **Delete route**
    Cú pháp :
 ```
 sudo ip route del <network_ip>/<cidr> via <gateway_ip> dev <network_card_name>
 ```
    hoặc :
```
sudo ip route del <network_ip>/<cidr> via <gateway_ip>
```

**Lưu ý** : Các lệnh làm việc với route đều cần quyền root

### 3\. Add route dài hạn trên Linux
Ở phần 2 đã hướng dẫn về các command add static route trên Linux, nhưng khi sử dụng bằng command các static route sẽ mất đi sau khi khởi động OS.
Để lưu vĩnh viễn các cấu hình này cần cấu hình như sau

#### 3.1. Trên RHEL/CentOS

**Sửa file cấu hình**
Trên RHEL hoặc CentOS cần tạo một file có tên tương ứng “route-namedevice” trong thư mục “/etc/sysconfig/network-scripts”
VD:
```
sudo vi /etc/sysconfig/network-scripts/route-vpn_01
```
- vpn_01 : là tên NIC cần cấu hình Static Route

Thêm dòng sau vào file route-vpn_01 :
```
192.168.254.0/24 via 192.168.29.1 dev vpn_01
```
Restart network service:
```
systemctl restart network.service
```
**Hoặc sử dụng nmcli:**
Cú pháp :
```
sudo nmcli connection modify <interface_name> +ipv4.routes "<network_ip> <gateway_ip>"
```
VD:
```
sudo nmcli connection modify vpn_01 +ipv4.routes "192.168.254.0/24 92.168.29.1 "
```
Reload nmcli :
```
sudo nmcli connection reload
```

#### 3.2.  Debian/Ubuntu

**Sửa file cấu hình `/etc/network/interfaces`**
***Thêm dòng sau:***
```
auto vpn_ 01
iface vpn_01 inet static
address 192.168.29.100
netmask 255.255.255.0
```
```
ip route add -net 192.168.254.0 netmask 255.255.0.0 gw 192.168.29.1
```
***Restart network service***
```
systemctl restart networking
```

**Sử dụng Netplan `/etc/netplan/<configuration_file>.yaml`**
Thêm dòng sau:
```network:
   version: 2
   renderer: NetworkManager
   ethernets:
     vpn_01:
       dhcp4: true
       routes:
         - to: 192.168.254.0/24
           via: 192.168.29.1
           metric: 100
``` 
Apply config
```
sudo netplan apply
```
