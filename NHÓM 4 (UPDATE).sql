CREATE DATABASE QLTV;
GO

USE QLTV;
GO

CREATE TABLE SACH (
    MASH VARCHAR(10) PRIMARY KEY,
    TENSACH NVARCHAR(100),
    TACGIA NVARCHAR(100),
    NHAXB NVARCHAR(100),
    NAMXB INT
);
CREATE TABLE DOCGIA (
    MADG VARCHAR(10) PRIMARY KEY,
    HOTEN NVARCHAR(100),
    NGAYSINH DATE,
    DIACHI NVARCHAR(200),
    NGHENGHIEP NVARCHAR(100)
);
CREATE TABLE PHIEUMUON (
    SOPM INT PRIMARY KEY,
    NGAYMUON DATE,
    NGAYTRA DATE,
    MADG VARCHAR(10),
    MASH VARCHAR(10),
    FOREIGN KEY (MADG) REFERENCES DOCGIA(MADG),
    FOREIGN KEY (MASH) REFERENCES SACH(MASH)
);

INSERT INTO SACH VALUES
('S001', N'Dế Mèn Phiêu Lưu Ký', N'Tô Hoài', N'Kim Đồng', 1955),
('S002', N'Tắt Đèn', N'Ngô Tất Tố', N'Văn Học', 1939),
('S003', N'Lão Hạc', N'Nam Cao', N'Giáo Dục', 1943),
('S004', N'Chí Phèo', N'Nam Cao', N'Hội Nhà Văn', 1941),
('S005', N'Sống Mòn', N'Nam Cao', N'NXB Văn Học', 1944),
('S006', N'Harry Potter 1', N'J.K. Rowling', N'Bloomsbury', 1997),
('S007', N'Harry Potter 2', N'J.K. Rowling', N'Bloomsbury', 1998),
('S008', N'Sherlock Holmes', N'Arthur Conan Doyle', N'Penguin', 1892),
('S009', N'Đắc Nhân Tâm', N'Dale Carnegie', N'NXB Trẻ', 1936),
('S010', N'1984', N'George Orwell', N'Secker & Warburg', 1949);

INSERT INTO DOCGIA VALUES
('DG01', N'Nguyễn Văn A', '2000-01-01', N'Hà Nội', N'Sinh viên'),
('DG02', N'Trần Thị B', '1999-05-15', N'Hồ Chí Minh', N'Giáo viên'),
('DG03', N'Lê Văn C', '1985-07-20', N'Đà Nẵng', N'Kỹ sư'),
('DG04', N'Phạm Thị D', '1990-12-25', N'Huế', N'Bác sĩ'),
('DG05', N'Hoàng Văn E', '2001-03-10', N'Cần Thơ', N'Sinh viên'),
('DG06', N'Ngô Thị F', '1995-09-09', N'Hải Phòng', N'Văn phòng'),
('DG07', N'Đỗ Văn G', '1988-08-18', N'Nha Trang', N'Luật sư'),
('DG08', N'Bùi Thị H', '1997-04-22', N'Quảng Ninh', N'Kế toán'),
('DG09', N'Vũ Văn I', '1992-11-30', N'Hưng Yên', N'Giảng viên'),
('DG10', N'Phan Thị K', '1996-06-06', N'Bình Dương', N'Nhân viên IT');

INSERT INTO PHIEUMUON VALUES
(1, '2025-05-01', '2025-05-05', 'DG01', 'S001'),
(2, '2025-05-01', '2025-05-06', 'DG01', 'S003'),
(3, '2025-05-02', '2025-05-07', 'DG02', 'S004'),
(4, '2025-05-03', '2025-05-06', 'DG03', 'S001'),
(5, '2025-05-04', '2025-05-08', 'DG04', 'S004'),
(6, '2025-05-05', '2025-05-10', 'DG05', 'S003'),
(7, '2025-05-05', '2025-05-11', 'DG05', 'S006'),
(8, '2025-05-06', NULL, 'DG06', 'S007'),
(9, '2025-05-07', NULL, 'DG07', 'S008'),
(10, '2025-05-08', NULL, 'DG08', 'S009');

--- Truy vấn kết nối nhiều bảng (JOIN):
--•	Câu 1: Liệt kê tên sách, tên độc giả và ngày mượn của tất cả các lượt mượn:
SELECT S.TENSACH, D.HOTEN, P.NGAYMUON
FROM PHIEUMUON P
JOIN SACH S ON P.MASH = S.MASH
JOIN DOCGIA D ON P.MADG = D.MADG
--•	Câu 2: Cho biết danh sách độc giả đã mượn sách thuộc Nhà xuất bản "Giáo Dục": 
SELECT DISTINCT D.MADG, D.HOTEN
FROM PHIEUMUON P
JOIN SACH S ON P.MASH = S.MASH
JOIN DOCGIA D ON P.MADG = D.MADG
WHERE S.NHAXB = N'Giáo Dục'

--- Truy vấn UPDATE:
--•	Câu 1: Cập nhật địa chỉ độc giả thành “Bình Dương” nếu họ đã từng mượn bất kỳ cuốn sách nào:
UPDATE DOCGIA
SET DIACHI = N'Bình Dương'
WHERE MADG IN (
    SELECT DISTINCT MADG
    FROM PHIEUMUON)
--•	Câu 2: Cập nhật nghề nghiệp độc giả thành “Cựu sinh viên” nếu mượn sách vào hoặc trước năm 2024:
UPDATE DOCGIA
SET NGHENGHIEP = N'Cựu sinh viên'
WHERE MADG IN (
    SELECT MADG
    FROM PHIEUMUON
    WHERE YEAR(NGAYMUON) <= 2024)

--- Truy vấn DELETE:
--•	Câu 1: Xóa tất cả chi tiết mượn của những cuốn sách có năm xuất bản trước năm 2021:
DELETE FROM PHIEUMUON 
WHERE MASH IN (
    SELECT MASH FROM SACH WHERE NAMXB < 2021)
--•	Câu 2: Xoá những độc giả chưa từng mượn sách nào và có nghề nghiệp là 'Nhân viên văn phòng':
DELETE FROM DOCGIA 
WHERE NGHENGHIEP = N'Văn phòng' AND MADG NOT IN (
    SELECT MADG FROM PHIEUMUON)

--- Truy vấn GROUP BY:
--•	Câu 1: Đếm số lượng sách theo từng nhà xuất bản, chỉ lấy sách xuất bản từ năm 2020 trở đi:
SELECT NHAXB, COUNT(*) AS SoLuongSach
FROM SACH
WHERE NAMXB >= 2020
GROUP BY NHAXB
--•	Câu 2: Đếm số lượt mượn của từng độc giả, chỉ thống kê trong năm 2024, sắp xếp theo tên độc giả:
SELECT D.MADG, D.HOTEN, COUNT(*) AS SoLuotMuon
FROM PHIEUMUON P
JOIN DOCGIA D ON P.MADG = D.MADG
WHERE YEAR(P.NGAYMUON) = 2024
GROUP BY D.MADG, D.HOTEN
ORDER BY D.HOTEN

--- Truy vấn con (SUBQUERY):
--•	Câu 1: Tìm tên độc giả đã mượn sách có năm xuất bản mới nhất:
SELECT DISTINCT D.HOTEN
FROM PHIEUMUON P
JOIN SACH S ON P.MASH = S.MASH
JOIN DOCGIA D ON P.MADG = D.MADG
WHERE S.NAMXB = (SELECT MAX(NAMXB) FROM SACH)
--•	Câu 2: Tìm tên sách đã được mượn nhiều hơn 1 lần:
SELECT TENSACH
FROM SACH
WHERE MASH IN (
    SELECT MASH
    FROM PHIEUMUON
    GROUP BY MASH
    HAVING COUNT(*) > 1)

--- 2 câu truy vấn khác:
--•	Câu 1: Tìm họ tên độc giả đã từng mượn tất cả sách do NXB "Giáo Dục" xuất bản:
SELECT D.HOTEN
FROM DOCGIA D
WHERE NOT EXISTS (
    SELECT MASH
    FROM SACH
    WHERE NHAXB = N'Giáo Dục'
    EXCEPT
    SELECT P.MASH
    FROM PHIEUMUON P
    WHERE P.MADG = D.MADG)
--•	Câu 2: Liệt kê các độc giả đã mượn hơn 2 quyển sách khác nhau trong cùng một ngày, kèm theo thông tin: họ tên, ngày mượn và số lượng sách mượn:
SELECT 
    D.HOTEN,
    P.NGAYMUON,
    COUNT(DISTINCT P.MASH) AS SoLuongSachMuon
FROM DOCGIA D
JOIN PHIEUMUON P ON D.MADG = P.MADG
GROUP BY D.HOTEN, P.NGAYMUON
HAVING COUNT(DISTINCT P.MASH) > 2
