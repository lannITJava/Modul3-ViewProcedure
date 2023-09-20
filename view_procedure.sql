create database view_procedures;
use view_procedures;
/*
1. Tạo bảng Danh mục sản phẩm gồm các thông tin sau:
    - Mã danh mục - int - PK - auto increment
    - Tên danh mục - varchar(50) - not null - unique
    - Mô tả - text
    - Trạng thái - bit - default 1
*/
create table DMSP(
DM_id int primary key auto_increment,
DM_name varchar(50) not null unique,
DM_des text,
DM_status bit default 1
);
/*
2. Tạo bảng sản phẩm gồm các thông tin sau:
    - Mã sản phẩm - varchar(5) - PK
    - Tên sản phẩm - varchar(100) - not null - unique
    - Ngày tạo - date - default currentDate
    - Giá - float - default 0
    - Mô tả sản phẩm - text
    - Tiêu đề - varchar(200)
    - Mã danh mục - int - FK references Danh mục
    - Trạng thái - bit - default 1
*/
create table SP(
SP_id varchar(5) primary key,
SP_name varchar(100) not null unique,
SP_ngayTao  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
SP_gia float default 0,
SP_des text,
SP_title varchar(200),
DM_id int ,
foreign key (DM_id) references DMSP(DM_id),
SP_status bit default 1
);
/*
3. Thêm các dữ liệu vào 2 bảng
*/
insert into DMSP(DM_name,DM_des,DM_status)
values ('Danh mục 1','Danh mục 1',0),
('Danh mục 2','Danh mục 2',1),
('Danh mục 3','Danh mục 3',0);
insert into SP
values ('SP001','Sản phẩm 1','2023-05-26','20','Sản phẩm 1','Sản phẩm',1,1);
/*
4. Tạo view gồm các sản phẩm có giá lớn hơn 20000 gồm các thông tin sau: 
    mã danh mục, tên danh mục, trạng thái danh mục, mã sản phẩm, tên sản phẩm, 
    giá sản phẩm, trạng thái sản phẩm
*/
create view vw_SP
as
select DMSP.DM_id, DMSP.DM_name, DMSP.DM_status, SP.SP_id, SP.SP_name, SP.SP_gia, SP.SP_status
from SP
join DMSP on SP.DM_id = DMSP.DM_id
where SP.SP_gia>20000;
select * from vw_SP;
/*
5. Tạo các procedure sau:
    - procedure cho phép thêm, sửa, xóa, lấy tất cả dữ liệu, lấy dữ liệu theo mã
    của bảng danh mục và sản phẩm
*/
DELIMITER //
create procedure get_all_DMSP()
BEGIN
	select * from DMSP;
END //
DELIMITER ;
call get_all_DMSP();
DELIMITER //
create procedure insert_DM(
in id_DM int,
in name_DM varchar(50),
in des_DM text,
status_Dm bit
)
BEGIN
insert into DMSP
values (id_DM,name_DM,des_DM,status_Dm);
END //
DELIMITER ; 
call insert_DM(4,'Danh mục 4','Danh mục 4',0);
DELIMITER //
create procedure update_DM(
in id_DM int,
in name_DM varchar(50),
in des_DM text,
status_Dm bit
)
BEGIN
update DMSP
set DM_name = name_DM,
DM_des = des_DM,
DM_status = status_Dm
where DM_id = id_DM;
END //
DELIMITER ;
call update_DM('4','DM4','DM4',0);
DELIMITER //
create procedure delete_DM(
id_DM int
)
BEGIN
delete from DMSP where DM_id = id_DM;
END //
DELIMITER ;
call delete_DM(4);
DELIMITER //
create procedure get_all_SP()
BEGIN
select * from SP;
END //
DELIMITER ;
call get_all_SP();
DELIMITER //
create procedure insert_SP(
id_SP varchar(5),
name_SP varchar(100),
NgayTao_SP date,
Gia_SP float,
Des_SP text,
Title_SP varchar(200),
id_DM int ,
status_SP bit
)
BEGIN
insert into SP
values (id_SP, name_SP, NgayTao_SP, Gia_SP, Des_SP, Title_SP, id_DM, status_SP);
END //
DELIMITER ;
call insert_SP('SP003','Sản phẩm 3','2023-05-30','30000','Sản phẩm 3','Sản phẩm',3,0);
DELIMITER //
create procedure update_SP(
id_SP varchar(5),
name_SP varchar(100),
NgayTao_SP date,
Gia_SP float,
Des_SP text,
Title_SP varchar(200),
id_DM int ,
status_SP bit
)
BEGIN
update SP
set SP_name = name_SP,
Sp_NgayTao =NgayTao_SP ,
 SP_gia= Gia_SP,
SP_des = Des_SP,
SP_title = Title_SP,
DM_id = id_DM,
SP_status = Status_SP
where SP_id = id_SP; 
END //
DELIMITER ;
call update_SP('SP003','SP 3','2023-05-29','35000','SP 3','Sản phẩm',3,0);
DELIMITER //
create procedure delete_SP(
in id_SP varchar(5)
)
BEGIN
delete from SP where SP_id = id_SP;
END //
DELIMITER ;
call delete_SP('SP003');
/*
- procedure cho phép lấy ra tất cả các phẩm có trạng thái là 1
    bao gồm mã sản phẩm, tên sản phẩm, giá, tên danh mục, trạng thái sản phẩm
*/
DELIMITER //
create procedure getSP_by_status()
BEGIN
select Sp.SP_id, SP.SP_name, SP.SP_gia, DMSP.DM_name, SP.SP_status
from SP join DMSP on SP.DM_id = DMSP.DM_id 
 where SP_status = 1;
END //
DELIMITER ;
call getSP_by_status();
/*
- procedure cho phép thống kê số sản phẩm theo từng mã danh mục
*/
DELIMITER //
create procedure getSP_by_DMid()
BEGIN
select DMSP.DM_id, count(SP.SP_id)as 'Số sản phẩm'
from SP join DMSP on SP.DM_id = DMSP.DM_id 
group by DMSP.DM_id;
END //
DELIMITER ;
call getSP_by_DMid();
/*
- procedure cho phép tìm kiếm sản phẩm theo tên sản phầm: mã sản phẩm, tên
    sản phẩm, giá, trạng thái sản phẩm, tên danh mục, trạng thái danh mục
*/
DELIMITER //
create procedure getSP_by_nameSP(
name_SP varchar(100)
)
BEGIN
declare name_search varchar(32);
    set name_search = concat('%',name_SP,'%');
select SP.SP_id, SP.SP_name, SP.SP_gia, SP.SP_status, DMSP.DM_name, DMSP.DM_status
from SP
join DMSP on SP.DM_id = DMSP.DM_id 
where SP_name like name_search;
END //
DELIMITER ;
call getSP_by_nameSP('1');



