Format File System

### Các định dạng file system trong Linux
Một số định dạng filesystem phổ biến được sử dụng trong Linux
1. **ext2**: Định dạng file system không cung cấp journaling (tệp nhật ký ). Tệp journaling giúp lưu một bản ghi về thay đổi của partition vào một journal (nhật ký ) phục vụ cho việc phục hồi khi có sự cố.
2. **ext3 & ext 4**: Cả hai đều cung cấp tệp nhật ký, trong khi ext4 xử lý được các tệp tới 16TB. ext4 hiện nay được sử dụng phổ biến hơn so với ext3.
3. **xfs**: Một hệ thống filesystem jounal 64 bit thích hợp sử dụng cho file lớn.
4. Ngoài ra còn có các định dạng khác như **reiserfs**, **VFAT** (một extention của FAT32), **btrfs**. 