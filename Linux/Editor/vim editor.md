Các mode trong vim Editor: 

### 1. Normal Mode 
Normal mode là mode mặc định khi dùng vim, nó dùng để sử dụng để truy cập vào cá mode khác.
Trở về Normal Mode từ các mode khác "ESC"
Option:
- `h` Di chuyển sang trái của ký tự
- `j` Di chuyển xuống dòng dưới
- `k` Di chuyển lên dòng trên
- `l` Di chuyển sang phải ký tự
- `0` Di chuyển đến đầu dòng.
- `$` Di chuyển đến cuối dòng.
- `dw` Xóa từ điểm sau con trỏ
- `dd` Xóa toàn bộ dòng hiện tại.
- `u` hoàn tác lại hành động gần nhất
- `yy` Sao chép dòng vào cache
- `ZZ` Save file và thoát
- `/` Tìm kiếm từ khóa
- `gg` di chuyển đến dòng đầu tiên trong file
- `shift + g` di chuyển đến dòng cuối cùng trong file
### 2. Command ode (type: `ctrl + :` )
Option:
- `:w`   Lưu file ở hiện tại
- `:w!`  Ghi đè file hiện tại
- `:exit` Ghi file và đóng Vim
- `:wq` Ghi và thoát
- `:q` Thóa mà không lưu
- `:q!` Nếu file đã được sửa đổi mà không muốn lưu
- `:e!` Xem lại thay đổi ở lần ghi cuối
- `set nu` Đánh số thứ tự các dòng
- `%` Áp dụng trên tất các các dòng
- `s` Thay thế 
### 3. Insert Mode (type "i" from Normal Mode)
Đây là mode cần thiết nhất, dùng để chèn các ký tự vào file như các trình soạn thảo phổ biến khác.
### 4. Visual Mode (type "v" from Normal Mode)
Mode này được sử dụng để lựa chọn các dòng trong văn bản, giống như kéo chuột.
Option:
- `ctrl + v`: chọn văn bản theo các khối hình chữ nhật
- `Shift + v`: chọn văn bản theo các dòng
### 5. Replace Mode (type "R" from Normal Mode)
Chế độ này cho phép thay thế văn bản hiện có bằng cách gõ trực tiếp lên nó.
