File Permission & Ownership

### 1. Phân quyền (Permission) 
Các quyền có trên linux:
- `r` Read 
- `w` Write 
- `x` Execute

Các đối tượng đi theo:
- `u` User
- `g` Group
- `o` Other

Octal:
- `4`  Read
- `2` Write
- `1` Execute 
Cú pháp: `# chmod +rwx <filename>` or `# chmod 777 <filename>` add quyền
VD: 
1. `# chmod o+w filename` Thêm quyền ghi cho tất cả user
2. `# chmod g-r filename`  Xóa quyền đọc với group 
3. `chmod 664 myfile.txt` Phân quyền sử dụng number
- 66: đại điện cho quyền đọc và ghi của user.
- 4: đại điện cho quyền đọc của user khác

### 2. Owership & Group
`chown user:group filename`: Thay đổi owner của 1 file hoặc folder
`chgrp group_name filename`:  Chỉ thay đổi group của 1 file hoặc folder.
- `-R` : đệ quy với trường hợp có nhiều subfolder.