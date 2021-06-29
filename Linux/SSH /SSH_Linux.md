### SSH là gì ?

SSH (Secure Shell) được sử dụng rộng rãi để cung cấp quyền truy cập an toàn vào các hệ thống từ xa.
Việc kết nối SSH có thể được sử dụng bẳng Username/Password. Nhưng việc truy cập sử dụng password vẫn tiềm ẩn dủi ro với việc tấn công vét cạn (brute force) hoặc người dùng để lộ password hệ thống.
Kết nối SSH sử dụng SSH Key sẽ tạo an toàn và việc kết nối trở nên nhanh chóng hơn.

### SSH hoạt động thế nào

- SSH Key hoạt động chứng thực người dùng truy cập bằng cách đối chiếu giữa Private Key và Public Key.
- Public Key có thể coi như ổ khoá lưu ở phía Server còn Private Key là chìa khoá nằm ở phía Client.

### Các thành phần của SSH Key

- Public Key (file lưu dữ liệu string) : Key này sẽ sử dụng để copy vào file ~/.ssh/authorized_keys trên phía Server Listen SSH (Có thể dùng chung Public Key cho nhiều Server SSH).
- Private Key (file lưu dữ liệu string) : FIle này được lưu ở máy Client
- Keypharse (Dạng string và cần ghi nhớ): Đây là mật khẩu để mở Private Key khi đăng nhập sẽ hỏi (nếu được kích hoạt lúc sinh SSH Key).

### 1\. SSH Key

1.  Sử dụng Key gen để sinh khoá cho SSH

- `ssh-keygen -t rsa`
    Lệnh này sẽ tạo ra một cặp SSH key sử dụng thuật toán mã hoá RSA
- Người dùng cần chỉ định file path để lưu cặp key Public và Private. (thư mục mặc định `$HOME/.ssh`

```
namdp@dell:~/.ssh$ ll
total 20
drwx------  2 namdp namdp 4096 Jun 28 15:00 ./
drwxr-xr-x 33 namdp namdp 4096 Jun 26 07:12 ../
-rw-------  1 namdp namdp 1766 Jun 28 14:57 id_rsa
-rw-r--r--  1 namdp namdp  392 Jun 28 14:57 id_rsa.pub
-rw-r--r--  1 namdp namdp 1550 Jun 27 09:02 known_hosts
namdp@dell:~/.ssh$ 

```

- Nhập Passpharse nếu sử dụng (và cần ghi nhớ password này ).

2.  Copy public key `id_rsa.pub` vào Server với đường dẫn `$HOME/.ssh/authorized_keys` có thể dùng lệnh `ssh-copy-id`

```
namdp02@ansible_lab:~/.ssh$ cat authorized_keys 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+vsRiHhMnYNkJ1BqJA80/uXMoC21cajGi/X5sgSJsUG5+hQDWd7mj/tujHXNMHK4WskwoDDO2MH6PEWeJ3HHzAlMr6hnKt645GnfhA9Y4CF5AzHNvVF+Aqrr+gpop7PYWwoOm46BrSuAV6oa5rzKKdXn4qCGgKFbiahHxD2NmG8+EzhBgc9xJQm8XBu5fZvZ8RA3qy1w9FUzKtLTrHJt9rAaWw+S4LrNzzhviTzqV/QrZGIsStx3ixdYXI8p5kHHuaDfj6RaxzzfrZZ/zE2OhV8t/a0HBOKJ7BizfmiWlpo6Wp9IR/CCapshbuu4yOhonkVdTFy6x6acMGjxnsYfj namdp@dell
```

4.  Kiểm tra kết nối đến server `ssh user@hostname` Điền Passpharse và kết nối sẽ được khởi tạo.

### 2\. SSH Agent

SSH Key sử dụng Passpharse sẽ luôn hỏi password passpharse khi tạo connect
Để tránh điều này có thể sử dụng ssh-agent (một chương trình chạy dưới background và lưu trữ key trong ram) mỗi lần ssh sử dụng key sẽ không phải nhập passpharse.

1.  Enable ssh-agent

```
namdp@dell:~$ eval "$(ssh-agent -s)"
Agent pid 10038

```

2.  Add SSH key và ssh-agent

```
namdp@dell:~$ ssh-add ~/.ssh/id_rsa
Enter passphrase for /home/namdp/.ssh/id_rsa: 
Identity added: /home/namdp/.ssh/id_rsa (/home/namdp/.ssh/id_rsa)
```

### 3\. SSH Agent Forwarding

Được sử dụng để SSH từ Server trung gian của Client, tới Server thứ 3 đã có khoá Public từ Client.

VD: Khi máy Client đã kết nối thành công tới Server 01 và Server 02 sử dụng SSH Key, có một tác vụ hoặc yêu cầu cần SSH từ Server 01 đến Server 02, SSH Agent Forwarding sẽ giúp điều này mà không cần tạo cặp Key mới trên Server 01

Nghĩa rằng Private key trên Client sẽ được Forward qua Server 01 để xác thực khi Server 01 SSH tới Server 02.
**Cấu hình trên máy Client**

- Sửa file `~/.ssh/config` thêm dòng sau

```
Host 192.168.254.240 #IP Server Agent
  ForwardAgent yes
```

- Hoặc có thể chạy trực tiếp lệnh :
```
ssh -A user@192.168.254.240
```
- Từ đây Server 01 có thể SSH tới Server 02 hoặc bất kỳ Server nào đã có Public Key từ máy Client.
