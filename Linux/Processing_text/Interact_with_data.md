### Thao tác với dữ liệu
Trong linux/unix hầu hết các cấu hình, đều được thực hiện bằng dòng lệnh và file, do vậy việc thao tác với dữ liệu là rất quan trọng, bên dưới là một số công cụ Linux cung cấp sẵn để làm việc với dữ liệu linh hoạt hơn
#### 1. Grep, egrep, fgrep 
Các tiện ích này giúp cho việc tìm kiếm , lọc đầu ra từ những lệnh trước đó. 
*Cú pháp* : `grep [option] partten [file]`
VD: 
- Tim 1 file chứa các từ : `grep "word" filename`
- Tìm kiếm không phân biệt chữ hoa thường: `grep -i "word" filename`
- Tìm kiếm đệ quy `grep -R "word" filename`
- Tìm kiếm số lần xuất hiện `grep -c "word" filename`
#### 2. Sed 
Là viết tắt của stream editor có thể thực nhiều nhiều chức năng như tìm kiếm, thay thế, chèn hoặc xóa. Các tác vụ thường được sử dụng là tìm kiếm và thay thế. Sed sử dụng giúp chỉnh sửa file nhanh chóng mà không cần mở file.
*Cú pháp* : `sed [option] [script] [file]`
*Option*: 
- Thay thế 1 chuỗi: `sed 's/<string-replace>/<string-des>/' geekfile.txt` -  VD: `sed 's/unix/linux/' geekfile.txt`
- Thay thế dựa vào lân xuất hiện của dòng: `sed 's/<string-replace>/<string-des>/<number> geekfile.txt` - VD: `sed 's/unix/linux/2' geekfile.txt`
- g thay thế toàn bộ - VD: `s/unix/linux/2' geekfile.txt`
- 3g thay thế theo lần xuất hiện của từ trong dòng - VD: `echo "Welcome To The Geek Stuff" | sed 's/\(\b[A-Z]\)/\(\1\)/g'`
- Thay thế chuỗi ở 1 dòng cụ thể - VD: `sed '3 s/unix/linux/' geekfile.txt`
Ngoài ra còn nhiều option khác có thể sử dụng lệnh man để tìm hiểu.
#### 3. Awk 
Là một ngôn ngữ kịch bản, dùng để thao tác với dữ liệu và tạo báo cáo. Có thể sử dụng biến, hàm, toán tử, chuỗi. Lệnh awk cũng có thẻ đọc dữ liệu từ stdin.
Cú pháp: `awk 'BEGIN{ print "start" } pattern { commands } END{ print "end" } file`

*Gồm 3 phần tùy chọn*:
- BEGIN{command} chứa các khai báo thực thi trước khi awk đọc nội dung dữ liệu/file.
- pattern{command} gồm các điều kiện dùng để đối chiếu, lọc nội dung và các dòng của dữ liệu. {command} là các khai báo sẽ thực thi trên các dòng khớp với điều kiện (pattern).
- END{command} chứa các thực thi được khai báo chạy sau khi awk đọc dữ liệu.

*Cách thức hoạt động*:
- Chương trình được viết với Awk đọc file đầu vào theo từng dòng một
- Đối với mỗi dòng, nó sẽ so khớp dòng ấy lần lượt với các pattern, nếu khớp thì sẽ thực hiện action tương ứng
- Nếu không có pattern nào được so khớp thì sẽ không có action nào được thực hiện
- Trong cú pháp cơ bản khi làm việc với Awk, hoặc search pattern có thể vắng mặt, hoặc action có thể vắng mặt, nhưng không được khuyết cả 2
- Nếu không có search pattern, Awk sẽ thực hiện action đã cho đối với mỗi dòng của dữ liệu đầu vào
- Nếu action vắng mặt, Awk sẽ mặc định in ra tất cả những dòng khớp với pattern đã cho
- Chương trình có cặp ngoặc nhọn không chứa action nào sẽ không thực hiện gì cả, kể cả thao tác mặc định (in ra tất cả các dòng)
- Mỗi câu lệnh trong phần action được phân tách nhau bởi dấu chấm phẩy

*Ví dụ*:
- In ra từng dòng của file: `awk '{print;}' file.txt`
- In ra những dòng có chuỗi mẫu: `awk '/Thomas/' file.txt`
- In ra những trường nhât định: `awk '{print $2, $5;}' file.txt`
- Hành động khởi tạo và kết thúc: `awk 'BEGIN {print "Name\tDesignation\tDepartment\tSalary";} END {print "Report Generated\n-----------------";}' file.txt'`
- Phép so sánh: `awk '$1 > 200' file.txt`
- Cú pháp điêu kiện: `awk '$4 ~ /Technology/' file.txt`