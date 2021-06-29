### 1. Tmux là gì ?
Tmux (Terminal Multiplexer) - bộ ghép kênh nó cho phép chuyển qua lại giữa các chương trình trên 1 terminal. hoac tắc program là một termianl riêng mà vẫn giữ hoạt động.... Hay nói đơn giản nó sẽ chia terminal thành nhiều màn hình khác nhau.
###  2. Cài đặt tmux
`# apt install tmux` với Ubuntu 
`# yum install tmux` với RHEL	

### 3. Sử dụng tmux
- Tạo session tmux mới :
`# tmux new`
- List các session:
`# tmux ls`
- Tách session:
`CTRL +B --> gõ D --> Enter`
- Quay lại session session:
`tmux attach -t [session_name]`
VD: `tmux attach -t 0` vì chưa đặt tên cho session nên session sẽ đánh số thứ tự từ 0
- Tạo session với tên :
`# tmux new -s name`
- Xóa session :
`# tmux kill-session -t name`

### 4. Các command làm việc trong terminal của Tmux
- **Ctrl+b c**  Tạo một cửa sổ mới
- **Ctrl+b w**  Xem danh sách cửa sổ hiện tại
- **Ctrl+b n/p**  Chuyển đến cửa sổ tiếp theo hoặc trước đó
- **Ctrl+b f**  　Tìm kiếm cửa sổ
- **Ctrl+b ,**  　Đặt/Đổi tên cho cửa sổ
- **Ctrl+b &**  　Đóng cửa sổ

### 5. Cách lệnh làm việc với các panel trong 1 cửa sổ
- **Ctrl+b %**  chia đôi màn hình theo chiều dọc
- **Ctrl+b "**   chia đôi màn hình theo chiều ngang
- **Ctrl+b o/<phím mũi tên>**   Di chuyển giữa các panel
- **Ctrl+b q**    Hiện số thứ tự trên
- **Ctrl+b x**   Xoá panel
#### 6. Link tham khảo thêm
http://man.openbsd.org/cgi-bin/man.cgi/OpenBSD-current/man1/tmux.1?query=tmux&sec=1
