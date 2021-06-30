### Một số lệnh cơ bản thao tác với MySQL Database 
1. Login user root
`# mysql -u root -p`
2. Show password root temp
`# grep 'temporary password' /var/log/mysqld.log`
3. Đổi password root
`# mysql_secure_installation`
4. Tạo Database, xoá database
`> create database contacts;`
5. List database
`> show databases;`
6. Chọn Database
`> use contacts;`
7. List các table 
`> show tables;`
8. Tạo table với các cột
`> create table emails (date DATE, email VARCHAR(20),
message VARCHAR(250), response VARCHAR(250));`
9. Insert dữ liệu vào db
`> insert into emails (date,email,message,response) values
('2016-09-12','stan@angry.com','Where's my shipment?',
'Which shipment?');`
10. Select data
- Select toàn bộ trong table `emails`
`> select * from emails;`
11.  Select theo điều kiện `where`
`> select * from emails where email='stan@angry.com';`
12. Delete bản ghi theo điều kiện
`> delete * from emails where email='stan@angry.com';`
13. Update bản ghi
`> update complaints set email='stanley@angry.com', message='I quit' where email='stan@angry.com';`
14. Lọc theo thứ thự `order by`
`> select * from emails order by Date;`
15. Lọc theo thứ tự tăng dần của giá trị 
`> select * from emails order by Date DESC;`
16. Tạo user và gắn quyền truy cập local & remote
- Local: 
`> CREATE USER 'myuser'@'localhost' IDENTIFIED BY 'mypass';`
`> GRANT ALL ON *.* TO 'myuser'@'localhost'`
- Remote:
`> CREATE USER 'myuser'@'%' IDENTIFIED BY 'mypass';`
`> GRANT ALL ON *.* TO 'myuser'@'%';`
- Gắn quyền với Database cụ thể:
`> GRANT ALL PRIVILEGES ON database_name.* TO 'username'@'localhost';`
- Cuối cùng cần lệnh :
`> flush privileges;`

17.  Show lock table
`SHOW OPEN TABLES WHERE In_use > 0;`
18. Show all query 
`SHOW FULL PROCESSLIST`