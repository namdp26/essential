Processing Text

### 1. Cat
`cat filename`
Lệnh này in ra màn hình nội dung của File
Các option quan trọng đi kèm :
- -n: In ra nội dung file + số thứ tự các dòng.
- -e: Đánh dấu $ ở kết thúc các dòng.
- -v: hiển thị các nội dung không in được
- tac: hiển thị file nghịch đảo so với cat

### 2. Tail & Head
`head -10 filename`: Lệnh này hiển thị 10 dòng đầu tiên trong file.
`tail /var/log/mysql`: Lệnh này in ra 10 dòng cuối trong file log mysql
Các option tail:
- -f: follow các nội dung thay đổi mới trong file, phục vụ giám sát.
- -n: In ra số dòng cuối theo số thứ tự nhập vào.
- -q: sử dụng khi muốn in ra nhiều hơn 1 tệp.
### 3. Uniq
vd:`uniq filename`
Lệnh này sử dụng khi muốnlọc các file với các dòng trùng lặp liên tiếp.
Option:
- -u: chỉ in ra các dòng không bị lặp.
- -c: đếm số lần một dòng được lặp lại.
- -d: chỉ in ra các dòng lặp lại.
### 4. Join
`join file1 file2`
Lệnh này sử dụng để nối 2 tệp dựa trên các trường đại diện trên cả 2 file
### 5. Split
Lệnh này dùng để chia/tách các tệp thành các đoạn có kích cỡ bằng nhau.
Ví dụ : `split 2 filename` lệnh này sẽ chia file thành các file nhỏ mỗi file có 2 dòng.
### 6. Paste
`paste file1 file2`
Lệnh này sử dụng để gộp các tệpthành 1 tệp duy nhất, dựa trên dấu phân cách.
Option:
- -s: Nối dữ liệu theo kiểu chuỗi (string)
- -d, : Nối dữ liệu phân cách bằng dấu phẩy.
### 7. Sort
VD: `sort file`
Lệnh sort dùng để sắp xếp các dòng của tệp văn bản theo thứ tự tăng hoặc giảm.
Option:
- -r: sắp xếp ngược.
- -n sắp xếp theo số thứ tự.
### 8. Sed
Lệnh sed dùng để thay thế chuỗi trong file
VD: `sed 's/text/replace/' file`
Lưu thay đổi ra file mới 
`sed 's/text/replace/' file > newfile > newfile`
`mv newfile file`

Hoặc :
`# sed -i 's/text/replace/' file`
### 9. Cut
Lệnh này giúp cắt, trích xuất nội dung của tệp theo cột
VD: `cut -f 2,3 filename` cột thứ 2 và 3 sẽ được hiển thị
### 10. ln
Lệnh này giúp tạo một symbolic copy của file ở bất kỳ nơi nào để có thể truy cập file một cách nhanh chóng.
**Hard link**: là 2 tệp chia sẻ 1 inode, tức là dù chúng xuấ hiện ở đâu thì 2 file vẫn có chung nội dung
Chỉ sử dụng để link được tới file không link được thư mục
Link với file sẽ vẫn tồn tài dù file được move qua nơi khác.
- cú pháp : `# ln [file nguồn] [file đích]` lệnh này sẽ link thư mục dùng hard link
- `ls -i` xem số inode của file

**soft link**: không chứa bản sao của target file, nó giống như 1  shortcut trên windows.
có thể link cả file & folder.
link sẽ mất nếu target file bị move.
- cú pháp : `# ln -s [file nguồn] [file đích] `

Tóm lại : Hard link trỏ tới 1 file có dữ liệu, còn Soft link chỉ trỏ tới một file có chứa dữ liệu trong đó.
