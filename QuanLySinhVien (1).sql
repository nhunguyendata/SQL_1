USE MASTER
GO
IF EXISTS (SELECT * FROM SYSDATABASES WHERE NAME='QuanLySinhVien')
DROP DATABASE QuanLySinhVien
GO
CREATE DATABASE QuanLySinhVien
GO
USE QuanLySinhVien
GO
CREATE Table Khoa(MaKhoa nvarchar(4) PRIMARY KEY,
				  TenKhoa nvarchar(20),
				  SL_CBGD int CHECK (SL_CBGD BETWEEN 0 AND 4) DEFAULT 0
				  )
GO
CREATE Table MonHoc(MaMH nvarchar(4) PRIMARY KEY,
					TenMH nvarchar(30) NOT NULL,
					SoTC_ToiThieu int CHECK (SoTC_ToiThieu >=2)
					)
GO
CREATE Table GiaoVien(MaGV nvarchar(4) PRIMARY KEY CHECK (MaGV LIKE '[A-Z][0-9][0-9][FM]'),
					  TenGV nvarchar(20) NOT NULL,
					  MaKhoa nvarchar(4),
					  FOREIGN KEY (MaKhoa) REFERENCES Khoa(MaKhoa)
					  )
GO
CREATE Table SinhVien(MSSV nvarchar(6) PRIMARY KEY CHECK (MSSV LIKE '[A-Z][0-9][0-9][0-9][0-9][FM]'),
					  Ten nvarchar(30) NOT NULL,
					  PhaiNu bit,
					  DiaChi nvarchar(30) NOT NULL,
					  DienThoai nvarchar(10) CHECK (DienThoai LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
					  OR DienThoai Like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
					  MaKhoa nvarchar(4),
					  FOREIGN KEY (MaKhoa) REFERENCES Khoa(MaKhoa),
					  SoCMND nvarchar(10) UNIQUE,
					  NgaySinh date,
					  NgayNhapHoc date NOT NULL,
					  NgayVaoDoan date,
					  NgayVaoDang date,
					  NgayRaTruong date,
					  LyDoNgungHoc nvarchar(20) CHECK (LyDoNgungHoc LIKE 'Hoàn tất chương trình'
					  OR LyDoNgungHoc LIKE 'Nghỉ học giữa khóa học'
					  OR LyDoNgungHoc LIKE 'Buộc thôi học'
					  OR LyDoNgungHoc LIKE 'Xin thôi học'
					  OR LyDoNgungHoc LIKE 'Xin tạm ngừng'
					  OR LyDoNgungHoc LIKE 'Khác')
					  )
GO
CREATE Table GiangDay(MaKhoaHoc nvarchar(4) PRIMARY KEY CHECK (MaKhoaHoc LIKE '[K][0-9][0-9][0-9]'),
					  MaGV nvarchar(4),
					  FOREIGN KEY (MaGV) REFERENCES GiaoVien(MaGV),
					  MaMH nvarchar(4),
					  FOREIGN KEY (MaMH) REFERENCES MonHoc(MaMH),
					  HocKy int CHECK (HocKy LIKE '[1]'
					  OR HocKy LIKE '[2]'
					  OR HocKy LIKE '[3]'),
					  NienKhoa nvarchar(10),
					  NgayBatDauLyThuyet date,
					  NgayBatDauThucHanh date,
					  NgayKetThuc date,
					  TongSoTC int,
					  SoTCLT int CHECK (SoTCLT >=0) DEFAULT 0,
					  SoTCTH int CHECK (SoTCTH >=0) DEFAULT 0,
					  SoTietLT int,
					  SoTietTH int
					  )
GO
CREATE Table KetQua(MSSV nvarchar(6),
					MaKhoaHoc nvarchar(4),
					PRIMARY KEY (MSSV,MaKhoaHoc),
					FOREIGN KEY (MSSV) REFERENCES SinhVien(MSSV),
					FOREIGN KEY (MaKhoaHoc) REFERENCES GiangDay(MaKhoaHoc),
					DiemKTGiuaKy float,
					DiemThiLan1 float,
					DiemThiLan2 float,
					DiemKhoaHoc float
					)
GO
ALTER Table SinhVien
ADD CHECK (DATEDIFF(YEAR,NgaySinh,NgayNhapHoc) >=18),
	CHECK (DATEDIFF(YEAR,NgaySinh,NgayVaoDoan) >=16)
ALTER Table GiangDay
ADD CHECK (TongSoTC = SoTCLT + SoTCTH),
	CHECK (SoTietLT= SoTCLT * 15),
	CHECK (SoTietTH= SoTCTH * 30)

SET DATEFORMAT dmy
INSERT INTO Khoa VALUES ('CNTT',N'Công nghệ thông tin',3)
INSERT INTO Khoa VALUES ('Toan',N'Toán',1)
INSERT INTO Khoa VALUES ('Sinh',N'Sinh học',0)

INSERT INTO MonHoc VALUES ('CSDL',N'Cơ sở dữ liệu',2)
INSERT INTO MonHoc VALUES ('CTDL',N'Cấu trúc dữ liệu',3)
INSERT INTO MonHoc VALUES ('KTLT',N'Kỹ thuật lập trình',3)
INSERT INTO MonHoc VALUES ('CWIN',N'Lâp trình C trên Windows',3)
INSERT INTO MonHoc VALUES ('TRR',N'Toán rời rạc',2)
INSERT INTO MonHoc VALUES ('LTDT',N'Lý thuyết đồ thị',2)

INSERT INTO GiaoVien VALUES ('C01F',N'Phạm Thị Thảo','CNTT')
INSERT INTO GiaoVien VALUES ('T02M',N'Lâm Hoàng Vũ','TOAN')
INSERT INTO GiaoVien VALUES ('C03M',N'Trần Văn Tiến','CNTT')
INSERT INTO GiaoVien VALUES ('C04M',N'Hoàng Vương','CNTT')

INSERT INTO SinhVien VALUES ('C0001F',N'Bùi Thúy An',1,N'223 Trần Hưng Đạo, HCM','38132202','CNTT','135792468','14/08/1992','01/10/2010',NULL,NULL,'15/11/2012','Xin thôi học')
INSERT INTO SinhVien VALUES ('C0002M',N'Nguyễn Thanh Tùng',0,N'140 Cống Quỳnh, Sóc Trăng','38125678','CNTT','987654321','23/11/1992','01/10/2010',NULL,NULL,NULL,NULL)
INSERT INTO SinhVien VALueS ('T0003M',N'Nguyễn Thành Long',0,N'112/4 Cống Quỳnh, HCM','0918345623','TOAN','123456789','17/08/1991','01/10/2010','19/05/2007','01/05/2012',NULL,NULL)
INSERT INTO SinhVien VALUES ('C0004F',N'Hoàng Thị Hoa',1,N'90 Nguyễn Văn Cừ, HCM','38320123','CNTT','246813579','02/09/1991','17/10/2010',NULL,NULL,NULL,NULL)
INSERT INTO SinhVien VALUES ('T0005M',N'Trần Hồng Sơn',0,N'54 Cao Thắng, Hà Nội','38345987','TOAN','864297531','24/04/1993','15/10/2011','02/09/2010',NULL,NULL,NULL)

INSERT INTO GiangDay VALUES ('K001','C01F','CSDL',1,'2011-2012','15/09/2011','01/10/2011','02/01/2012',4,3,1,45,30)
INSERT INTO GiangDay VALUES ('K002','C04M','KTLT',1,'2011-2012','17/02/2012','01/03/2012','18/05/2012',4,2,2,30,60) ---
INSERT INTO GiangDay VALUES ('K003','C03M','CTDL',1,'2012-2013','11/09/2012','14/03/2012','03/01/2013',4,3,1,45,30)
INSERT INTO GiangDay VALUES ('K004','C04M','CWIN',1,'2012-2013','13/09/2012','13/10/2012','14/01/2013',4,2,2,30,60)
INSERT INTO GiangDay VALUES ('K005','T02M','TRR',1,'2012-2013','14/09/2012','02/10/2012','18/01/2013',2,2,0,30,0) ---
INSERT INTO GiangDay VALUES ('K006','C04M','CSDL',1,'2011-2012','15/09/2011','01/10/2011','02/01/2012',4,3,1,45,30)
INSERT INTO GiangDay VALUES ('K007','C04M','CTDL',1,'2011-2012','15/09/2011','01/10/2011','02/01/2012',4,3,1,45,30)
INSERT INTO GiangDay VALUES ('K008','C04M','TRR',1,'2011-2012','15/09/2011','01/10/2011','02/01/2012',4,3,1,45,30)
INSERT INTO GiangDay VALUES ('K009','C04M','LTDT',1,'2011-2012','15/09/2011','01/10/2011','02/01/2012',4,3,1,45,30) ---

INSERT INTO KetQua VALUES ('C0001F','K001',8.5,5,NULL,6.4)
INSERT INTO KetQua VALUES ('C0001F','K003',8.0,9,NULL,8.6)
INSERT INTO KetQua VALUES ('T0003M','K004',9.0,7,NULL,7.8)
INSERT INTO KetQua VALUES ('C0001F','K002',9.0,7,NULL,7.8) ---
INSERT INTO KetQua VALUES ('T0003M','K003',6.0,2,2.5,3.9)
INSERT INTO KetQua VALUES ('T0005M','K003',9.0,7,NULL,7.8)
INSERT INTO KetQua VALUES ('C0002M','K001',7.0,2,5,5.8)
INSERT INTO KetQua VALUES ('T0003M','K002',6.5,2,3,4.4) ---
INSERT INTO KetQua VALUES ('T0005M','K005',7.0,10,NULL,8.8) ---
INSERT INTO KetQua VALUES ('C0001F','K004',8.0,9,NULL,8.6)
--1.	Cho biết tên, địa chỉ, điện thọai của tất cả các sinh viên.

--2.	Cho biết tên các môn học và số tín chỉ tối thiểu của từng môn học.
--SELECT TenMH,SoTC_ToiThieu
----FROM MonHoc
--3.	Cho biết kết quả học tập của sinh viên có Mã số “T0003M”.
SELECT *
FROM KetQua
WHERE MSSV='T0003M'
--4.	Cho biết tên các giáo viên có ký tự thứ 3 của họ và tên là “A”.
SELECT *
FROM GiaoVien
WHERE TenGV Like N'__Ầ%'
--5.	Cho biết tên những môn học có chứa chữ “dữ” (ví dụ như các môn Cơ sở dữ liệu, Cấu trúc dữ liệu,...)
SELECT *
FROM  MonHoc
WHERE TenMH Like N'%dữ%'
--6.	Cho biết tên các giáo viên có ký tự đầu tiên của họ và tên là các ký tự “P” hoặc “L”.
SELECT *
FROM GiaoVien
WHERE TenGV Like N'P%' or TenGV like N'L%'
--7.	Cho biết tên, địa chỉ của những sinh viên có địa chỉ trên đường “Cống Quỳnh”.
SELECT *
FROM SinhVien
WHERE DiaChi Like N'%Cống Quỳnh%'
--8.	Cho biết mã môn học, tên môn học, mã khóa học và tổng số tín chỉ (TongSoTC) của những môn học có cấu trúc của mã môn học như sau: ký tự thứ 1 là “C”, ký tự thứ 3 là “D”.
SELECT *
FROM monhoc M inner join giangday G on M.mamh=G.mamh
WHERE G.mamh Like N'C_D%'
--9.	Cho biết tên các môn học được dạy trong niên khóa 2011-2012.
SELECT TenMH
FROM MONHOC M INNER JOIN GIANGDAY G 
ON M.MaMH=G.MaMH
WHERE G.NienKhoa LIKE '2011-2012'
--10.	Cho biết tên khoa, mã số sinh viên, tên, địa chỉ của các SV theo từng Khoa sắp theo thứ tự A-Z của tên sinh viên.
select TenKhoa,MSSV,Ten,DiaChi
FROM SinhVien S INNer join Khoa K
ON S.MaKhoa=K.MaKhoa
order by K.MaKhoa,Ten
--11.	Cho biết tên môn học, tên sinh viên, điểm tổng kết (DiemKhoaHoc) của sinh viên qua từng khóa học.
select TenMH,Ten,DiemKhoaHoc
from KetQua K inner join SinhVien S on S.MSSV=K.MSSV
inner join GiangDay G on K.MaKhoaHoc=G.MaKhoaHoc
inner join MonHoc M on G.MaMH=M.MaMH
--12.	Cho biết tên và điểm tổng kết của sinh viên qua từng khóa học (DiemKhoaHoc) của các SV học môn ‘CSDL’ với DiemKhoaHoc từ 6 đến 7.
SELECT MaMH,Ten,DiemKhoaHoc,NienKhoa 
FROM SINHVIEN S INNER JOIN KETQUA K ON S.MSSV=K.MSSV 
INNER JOIN GIANGDAY G ON K.MaKhoaHoc=G.MaKhoaHoc
WHERE G.MaMH='CSDL' AND DiemKhoaHoc BETWEEN 6 AND 7

--13.	Cho biết Tên sinh viên, tên môn học, mã khóa học, điểm tổng kết của sinh viên qua từng khóa học (DiemKhoaHoc) của SV có tên là ‘TUNG’.
SELECT Ten,TenMH,G.MaKhoaHoc,DiemKhoaHoc,NienKhoa FROM
SINHVIEN S INNER JOIN KETQUA K ON S.MSSV=K.MSSV 
INNER JOIN GIANGDAY G ON K.MaKhoaHoc=G.MaKhoaHoc
INNER JOIN MONHOC M ON G.MaMH=M.MaMH
WHERE Ten LIKE N'%Tùng'
--14.	Cho biết tên khoa, tên môn học mà những sinh viên trong khoa đã học. Yêu cầu khi kết quả có nhiều dòng trùng nhau, chỉ hiển thị 1 dòng làm đại diện
SELECT DISTINCT TenKhoa,TenMH FROM
KHOA K INNER JOIN GIAOVIEN GV ON K.MaKhoa=GV.MaKhoa
	   INNER JOIN GIANGDAY G ON G.MaGV=GV.MaGV
	   INNER JOIN MONHOC M ON G.MaMH=M.MaMH
--15.	Cho biết tên khoa, mã khóa học mà giáo viên của khoa có tham gia giảng dạy.
SELECT DISTINCT TenKhoa,MaKhoaHoc,TenGV FROM
KHOA K INNER JOIN GIAOVIEN GV ON K.MaKhoa=GV.MaKhoa
	   INNER JOIN GIANGDAY G ON G.MaGV=GV.MaGV
--16.	Cho biết tên những giáo viên tham gia giảng dạy môn “Ky thuat lap trinh”.
select distinct TenGV,MaMH,TenMH
from GiaoVien GV INNER JOIN GiangDay G ON GV.MaGV=G.MaGV
from GiangDay G inner join MONHOC M ON G.MaMH=G.MaMH

--17.	Cho biết mã, tên các SV có DiemKhoaHoc của 1 môn học nào đó trên 8 (kết quả các môn khác có thể <=8).
 select DISTINCT S.MSSV,Ten FROM
SINHVIEN S INNER JOIN KETQUA K ON S.MSSV=K.MSSV
		   INNER JOIN GIANGDAY G ON K.MaKhoaHoc=G.MaKhoaHoc
		   INNER JOIN MONHOC M ON G.MaMH=M.MaMH
WHERE DiemKhoaHoc>8
 
	Yêu cầu hai câu 18 và 19 sau đây, mỗi câu sẽ được viết bằng 2 cách: 
(i).-	Sử dụng 1 lệnh SELECT
(ii).-	 Sử dụng từ 2 lệnh SELECT trở lên và các lệnh này được kết với nhau qua 1 trong 2 toán tử INTERSECT hoặc UNION.
--18.	Cho biết tên sinh viên, mã môn học, tên môn học, DiemKhoaHoc của những SV đã học môn ‘CSDL’ hoặc ‘CTDL’.
--19.	Cho biết tên môn học mà giáo viên “Tran Van Tien” tham gia giảng dạy trong học kỳ 1 niên khóa 2012-2013.

--20.	Cho biết tên những sinh viên đã có điểm trong table Kết quả (yêu cầu loại bỏ các tên trùng nhau nếu có).

--21.	Cho hiển thị 35% dữ liệu có trong table table kết quả.



					


						
					  
					
