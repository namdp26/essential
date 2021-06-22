Add New Hard Disk Centos 6-7

## Add New Hard Disk Centos 6 or 7
## 1. Thêm trên Vsphere ESXI hoặc cắm thêm ổ cứng
## 2. Cấu hình trên Centos  
### 2.1. Ckeck new Hard Disk:
Dùng lênh sau để kiểm tra các Disk có trên hệ thống `# fdisk -l` hoặc `# lsblk`
Nếu chưa thấy disk mới được add chạy lệnh sau để scan lại hard disk:
`[root@elk ~]#ls /sys/class/scsi_host/`  
`host0  host1  host2`  
`# echo "- - -" > /sys/class/scsi_host/host0/scan`  
`# echo "- - -" > /sys/class/scsi_host/host0/scan`  
`# echo "- - -" > /sys/class/scsi_host/host0/scan`  
### 2.2. Tạo mới partition:
`# fdisk /dev/sdc`
- **/dev/sdc**: tương ứng với new hard disk.  
- Các option như sau:  
n (new partition)  
p (primary)  
(ENTER) (Use default partition number)  
(ENTER) (Use default first sector)  
(ENTER) (Use default last sector)  
t (change the partition type)  
8e (Linux LVM)  
w (write)  
### 2.3. Update lại partition table:
`# partx -a -v /dev/sdc`
### 2.4. Kiểm tra lại các block device với lệnh: `# lsblk`  
[root@elk ~]# lsblk  
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT  
fd0               2:0    1    4K  0 disk  
sda               8:0    0   50G  0 disk  
├─sda1            8:1    0    1G  0 part /boot  
└─sda2            8:2    0   49G  0 part  
  ├─centos-root 253:0    0   67G  0 lvm  /  
 └─centos-swap 253:1    0    2G  0 lvm  [SWAP]  
sdb               8:16   0   20G  0 disk  
└─sdb1            8:17   0   20G  0 part  
 └─centos-root 253:0    0   67G  0 lvm  /  
sdc               8:32   0   16G  0 disk  
└─sdc1            8:33   0   16G  0 part  
sr0              11:0    1  4.4G  0 rom  
### 2.5. Tạo Physical Volume:
`# pvcreate /dev/sdc1`
`# pvs`: để hiển thị physical volume được tạo
### 2.6. Tạo Volume Group:
`# vgcreate vgBackup /dev/sdc1`
`# vgs`: để hiển thị physical volume được tạo
- **vgBackup**: là tên Volume Group
### 2.6. Tạo Logical Volume từ Volume Group:
`# lvcreate -n lvBackup -l +100%FREE vgBackup`
`# lvs`: hiển thị logical volume 
- **n**: option tên của logical volume
- **l**: extend volume
- **100%FREE vgBackup**: Nhận toàn bộ free size từ Volume Group.
### 2.7. Tạo filesystem cho logical volume mới:
- Format ext4: `# mkfs.ext4 /dev/vgBackup/lvBackup`
- Format xfs: `# mkfs.ext4 /dev/vgBackup/lvBackup`
### 2.8. Mount folder vào logical volume:
#### Sửa file /etc/fstab và thêm dòng sau:
- Format ext4: `/dev/vgBackup/lvBackup /backup ext4 defaults 0 0`
- với Format xfs: `/dev/vgBackup/lvBackup /backup xfs defaults 0 0`
#### Tạo folder và mount:
`# mkdir /backup`
`# mount /backup`
#### Check lại hoạt động 
`#df -kh`
