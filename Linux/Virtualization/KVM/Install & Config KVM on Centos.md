Install & Config KVM on Centos

# Hướng dẫn cài đặt & sử dụng KVM trên CentOS 7

## 1. KVM là gì?
KVM (kernel-base Virtual Machine) là một phần mềm ảo hóa cho các hệ điều hành chạy nhân Linux, dành cho CPU hỗ trợ công nghệ ảo hóa Intel-VT/ AMD-V. KVM biến máy host/server trở thành một hypervisor.
## 2. Cài đặt KVM trên CentOS 7
### 2.1. Kiểm tra xem CPU Có hỗ trợ ảo hóa không?
- Chạy lệnh sau kiểm tra xem CPU có hỗ trợ ảo hóa không
```
[root@thk_02 ~]# lscpu | grep Virtualization 
Virtualization: VT-x
Virtualization type: full
```
- Nếu kết quả lệnh này trả về khác 0 thì cpu hỗ trợ
 ```
 [root@thk_02 ~]# egrep -c "svm|vmx" /proc/cpuinfo
 4
 ```
### 2.2. Tiến hành cài đặt KVM
`# yum install qemu-kvm libvirt libvirt-python libguestfs-tools virt-install bridge-utils virt-manager`
- qemu-kvm: Phần phụ trợ cho KVM
- libvirt: cung cấp libvirt mà bạn cần quản lý qemu và KVM bằng libvirt.
- bridge-utils: chứa một tiện ích cần thiết để tạo và quản lý các thiết bị bridge.
- virt-manager: cung cấp giao diện đồ họa để quản lý máy ảo
- virt-install: Cung cấp lệnh để cài đặt máy ảo
### 2.3. Khởi động KVM
- Chạy lệnh khởi động và cho phép kvm khởi động cùng OS.
 ```
# systemctl enable libvirtd
# systemctl start libvirtd
```
- Kiểm tra các module được cài đặt.
 ```
# lsmod | grep -i kvm
  kvm_intel 188740 0
  kvm 637515 1 kvm_intel
  irqbypass 13503 1 kvm
```
### 2.4. Tạo switch bridge cho VM Connect
- Tạo Switch Bridge có tên nambr
    `brctl addbr nambr`
- Add interface vào Switch
    `sudo brctl addif nambr enp59s0`
- Xóa IP Card Physical và xin cấp IP cho card nambr
``` 
sudo brctl addif nambr enp59s0
sudo dhclient nambr
```
