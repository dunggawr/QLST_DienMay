-- ====================================================================
-- HỆ THỐNG QUẢN LÝ SIÊU THỊ ĐIỆN MÁY (QLST ĐIỆN MÁY)
-- DỮ LIỆU MẪU (SAMPLE DATA)
-- Phục vụ chạy thử nghiệm hệ thống và kiểm thử đơn vị
-- ====================================================================

SET NAMES 'utf8mb4';
SET CHARACTER SET utf8mb4;

USE qldst_dienmay;

-- 1. Tài khoản Thành viên: Nhân viên
-- ID 1: Quản lý
INSERT INTO tblThanhvien (id, tenDangnhap, matKhau, hoTen, ngaySinh, diaChi, email, soDienthoai, vaiTro, ghiChu)
VALUES (1, 'quanli1', '123456', 'Trần Quản Lý', '1985-03-15', '123 Cầu Giấy, Hà Nội', 'quanli1@dienmay.vn', '0911222333', 'nvquanli', 'Quản lý kinh doanh');

INSERT INTO tblNhanvien (tblThanhvienid, viTri) VALUES (1, 'Quản lý chi nhánh');
INSERT INTO tblNVQuanli (tblNhanvienid) VALUES (1);

-- ID 2: Nhân viên kho
INSERT INTO tblThanhvien (id, tenDangnhap, matKhau, hoTen, ngaySinh, diaChi, email, soDienthoai, vaiTro, ghiChu)
VALUES (2, 'kho1', '123456', 'Lê Văn Kho', '1991-07-22', '45 Giải Phóng, Hà Nội', 'kho1@dienmay.vn', '0922333444', 'nvkho', 'Thủ kho trưởng');

INSERT INTO tblNhanvien (tblThanhvienid, viTri) VALUES (2, 'Nhân viên thủ kho');
INSERT INTO tblNVKho (tblNhanvienid) VALUES (2);

-- ID 3: Nhân viên bán hàng
INSERT INTO tblThanhvien (id, tenDangnhap, matKhau, hoTen, ngaySinh, diaChi, email, soDienthoai, vaiTro, ghiChu)
VALUES (3, 'banhang1', '123456', 'Phạm Bán Hàng', '1995-10-05', '88 Kim Mã, Hà Nội', 'banhang1@dienmay.vn', '0933444555', 'nvbanhang', 'Thu ngân quầy');

INSERT INTO tblNhanvien (tblThanhvienid, viTri) VALUES (3, 'Nhân viên bán hàng tại quầy');
INSERT INTO tblNVBanhang (tblNhanvienid) VALUES (3);

-- 2. Nhân viên giao hàng (không có tài khoản)
INSERT INTO tblNVGiaohang (id, hoTen, ngaySinh, diaChi, email, soDienthoai, viTri, ghiChu)
VALUES (1, 'Hoàng Văn Giao', '1996-12-10', '10 Đại Cồ Việt, Hà Nội', 'giaohang1@dienmay.vn', '0944555666', 'Shipper siêu thị', 'Giao nội thành');

-- 3. Khách hàng đã có tài khoản
-- ID 4: KH001 - Nguyễn Văn An
INSERT INTO tblThanhvien (id, tenDangnhap, matKhau, hoTen, ngaySinh, diaChi, email, soDienthoai, vaiTro, ghiChu)
VALUES (4, 'nguyenvanan', '123456', 'Nguyễn Văn An', '1990-05-12', '12 Phố Huế, Hai Bà Trưng, Hà Nội', 'an.nguyen@email.com', '0912345678', 'khachhang', 'Khách VIP');

INSERT INTO tblKhachhang (tblThanhvienid, maKhachhang) VALUES (4, 'KH001');
INSERT INTO tblGiohang (tblKhachhangid) VALUES (4);

-- ID 5: KH002 - Trần Thị Bình
INSERT INTO tblThanhvien (id, tenDangnhap, matKhau, hoTen, ngaySinh, diaChi, email, soDienthoai, vaiTro, ghiChu)
VALUES (5, 'tranthibinh', '123456', 'Trần Thị Bình', '1993-08-20', '56 Nguyễn Tri Phương, Đà Nẵng', 'binh.tran@email.com', '0987654321', 'khachhang', 'Khách thân thiết');

INSERT INTO tblKhachhang (tblThanhvienid, maKhachhang) VALUES (5, 'KH002');
INSERT INTO tblGiohang (tblKhachhangid) VALUES (5);

-- ID 6: KH003 - Lê Hoàng Nam
INSERT INTO tblThanhvien (id, tenDangnhap, matKhau, hoTen, ngaySinh, diaChi, email, soDienthoai, vaiTro, ghiChu)
VALUES (6, 'lehoangnam', '123456', 'Lê Hoàng Nam', '1988-11-15', '78 Lê Lợi, Quận 1, TP.HCM', 'nam.le@email.com', '0905123456', 'khachhang', 'Khách mua sỉ');

INSERT INTO tblKhachhang (tblThanhvienid, maKhachhang) VALUES (6, 'KH003');
INSERT INTO tblGiohang (tblKhachhangid) VALUES (6);

-- 4. Loại mặt hàng
INSERT INTO tblLoaimathang (id, tenLoai, moTa) VALUES
(1, 'Tivi', 'Các dòng tivi Smart TV, OLED, QLED'),
(2, 'Tủ lạnh', 'Tủ lạnh Side by side, Inverter tiết kiệm điện'),
(3, 'Máy giặt', 'Máy giặt cửa trước, cửa trên công nghệ mới'),
(4, 'Điều hòa', 'Điều hòa 1 chiều, 2 chiều Inverter');

-- 5. Mặt hàng
INSERT INTO tblMathang (id, maMathang, tenMathang, hangSanxuat, giaBan, soLuongTon, moTa, tblLoaimathangid) VALUES
(1, 'MH001', 'Smart Tivi Sony 55 inch 4K', 'Sony', 15000000, 20, 'Độ phân giải 4K HDR sắc nét', 1),
(2, 'MH002', 'Smart Tivi Samsung 65 inch QLED', 'Samsung', 18000000, 15, 'Màu sắc sống động chân thực', 1),
(3, 'MH003', 'Tủ lạnh Panasonic Inverter 300L', 'Panasonic', 9500000, 25, 'Kháng khuẩn khử mùi Ag Clean', 2),
(4, 'MH004', 'Máy giặt LG Inverter 9kg cửa trước', 'LG', 8000000, 30, 'Truyền động trực tiếp AI DD', 3),
(5, 'MH005', 'Điều hòa Daikin Inverter 9000 BTU', 'Daikin', 10500000, 18, 'Làm lạnh nhanh, luồng gió Coanda', 4);

-- 6. Giao dịch mua hàng trong kỳ thống kê (Tháng 10/2026: 2026-10-01 đến 2026-10-31)

-- 6.1. Hóa đơn bán tại quầy HD001 - Khách hàng KH001 (Nguyễn Văn An)
INSERT INTO tblHoadonbanhang (id, maHoadon, ngayBan, ghiChu, tblNVBanhangid, tblKhachhangid)
VALUES (1, 'HD001', '2026-10-12', 'Khách thanh toán quẹt thẻ', 3, 4);

INSERT INTO tblChitiethoadon (tblHoadonbanhangid, tblMathangid, soLuongMua, donGia) VALUES
(1, 1, 1, 15000000), -- 1 Tivi Sony = 15.000.000
(1, 4, 1, 8000000);   -- 1 Máy giặt LG = 8.000.000
-- Tổng HD001 = 23.000.000 đ

-- 6.2. Đơn hàng trực tuyến ĐÃ XUẤT DH001 - Khách hàng KH001 (Nguyễn Văn An)
INSERT INTO tblDondathang (id, maDonhang, ngayDat, diaChiNhan, trangThai, ngayXuat, tblKhachhangid, tblNVKhoid, tblNVGiaohangid)
VALUES (1, 'DH001', '2026-10-15', '12 Phố Huế, Hà Nội', 'da_xuat', '2026-10-16', 4, 2, 1);

INSERT INTO tblChitietdondathang (tblDondathangid, tblMathangid, soLuongDat, donGia) VALUES
(1, 3, 1, 9500000);  -- 1 Tủ lạnh Panasonic = 9.500.000 đ
-- Tổng DH001 = 9.500.000 đ
-- => Tổng doanh thu của Nguyễn Văn An (KH001) = 23.000.000 + 9.500.000 = 32.500.000 đ (2 giao dịch)

-- 6.3. Hóa đơn bán tại quầy HD002 - Khách hàng KH002 (Trần Thị Bình)
INSERT INTO tblHoadonbanhang (id, maHoadon, ngayBan, ghiChu, tblNVBanhangid, tblKhachhangid)
VALUES (2, 'HD002', '2026-10-18', 'Khách chuyển khoản', 3, 5);

INSERT INTO tblChitiethoadon (tblHoadonbanhangid, tblMathangid, soLuongMua, donGia) VALUES
(2, 2, 1, 18000000); -- 1 Tivi Samsung = 18.000.000 đ
-- => Tổng doanh thu của Trần Thị Bình (KH002) = 18.000.000 đ (1 giao dịch)

-- 6.4. Đơn hàng trực tuyến ĐÃ XUẤT DH002 - Khách hàng KH003 (Lê Hoàng Nam)
INSERT INTO tblDondathang (id, maDonhang, ngayDat, diaChiNhan, trangThai, ngayXuat, tblKhachhangid, tblNVKhoid, tblNVGiaohangid)
VALUES (2, 'DH002', '2026-10-20', '78 Lê Lợi, Quận 1, TP.HCM', 'da_xuat', '2026-10-22', 6, 2, 1);

INSERT INTO tblChitietdondathang (tblDondathangid, tblMathangid, soLuongDat, donGia) VALUES
(2, 5, 2, 10500000); -- 2 Điều hòa Daikin = 21.000.000 đ
-- => Tổng doanh thu của Lê Hoàng Nam (KH003) = 21.000.000 đ (1 giao dịch)

-- 6.5. Hóa đơn tại quầy cho Khách VÃNG LAI (tblKhachhangid IS NULL)
INSERT INTO tblHoadonbanhang (id, maHoadon, ngayBan, ghiChu, tblNVBanhangid, tblKhachhangid)
VALUES (3, 'HD003', '2026-10-25', 'Khách vãng lai mua trực tiếp', 3, NULL);

INSERT INTO tblChitiethoadon (tblHoadonbanhangid, tblMathangid, soLuongMua, donGia) VALUES
(3, 4, 1, 8000000); -- 1 Máy giặt LG = 8.000.000 đ

-- 6.6. Đơn hàng trực tuyến CHỜ DUYỆT (Chưa xuất, không được tính vào doanh thu)
INSERT INTO tblDondathang (id, maDonhang, ngayDat, diaChiNhan, trangThai, ngayXuat, tblKhachhangid, tblNVKhoid, tblNVGiaohangid)
VALUES (3, 'DH003', '2026-10-28', '56 Nguyễn Tri Phương, Đà Nẵng', 'cho_duyet', NULL, 5, NULL, NULL);

INSERT INTO tblChitietdondathang (tblDondathangid, tblMathangid, soLuongDat, donGia) VALUES
(3, 1, 1, 15000000);
