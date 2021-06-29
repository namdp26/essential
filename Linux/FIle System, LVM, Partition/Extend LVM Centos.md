Extend LVM Centos 

### 1.  Check new Hard Disk:
Dùng lênh sau để kiểm tra các Disk có trên hệ thống `# fdisk -l` hoặc `# lsblk`
Nếu chưa thấy disk mới được add chạy lệnh sau để scan lại hard disk:
```
[root@elk ~]#ls /sys/class/scsi_host/
host0  host1  host2
# echo "- - -" > /sys/class/scsi_host/host0/scan
# echo "- - -" > /sys/class/scsi_host/host0/scan
# echo "- - -" > /sys/class/scsi_host/host0/scan
```
### 2. Tạo mới partition:
`# fdisk /dev/sdd`
- **/dev/sdd**: tương ứng với new hard disk.
- Các option như sau:
```
n (new partition)
p (primary)
(ENTER) (Use default partition number)
(ENTER) (Use default first sector)
(ENTER) (Use default last sector)
t (change the partition type)
8e (Linux LVM)
w (write)
```
### 3. Update lại partition table:
`# partx -a -v /dev/sdd`
`# fdisk -l` hoặc `# lsblk` kiểm tra lại các partition
### 4. Extend Volume Group:
`# vgextend vgBackup /dev/sdd1`
### 5. Extend Logical Volume
`# lvextend /dev/mapper/vgBackup-lvBackup -L +40G`
### 6. Update lại file system
`#xfs_growfs /dev/mapper/vgBackup-lvBackup`
### 7. Kiểm tra lại
`df -kh`
