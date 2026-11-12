-- ====================================================================
-- HỆ THỐNG QUẢN LÝ SIÊU THỊ ĐIỆN MÁY (QLST ĐIỆN MÁY)
-- CƠ SỞ DỮ LIỆU: qldst_dienmay
-- Theo chuẩn giáo trình PTIT (TS. Nguyễn Mạnh Hùng & ThS. Đỗ Thị Bích Ngọc)
-- ====================================================================

SET NAMES 'utf8mb4';
SET CHARACTER SET utf8mb4;

DROP DATABASE IF EXISTS qldst_dienmay;
CREATE DATABASE qldst_dienmay CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE qldst_dienmay;

-- --------------------------------------------------------------------
-- 1. Bảng tblThanhvien (Bảng cha chứa thông tin tài khoản & cá nhân)
-- --------------------------------------------------------------------
CREATE TABLE tblThanhvien (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tenDangnhap VARCHAR(255) NOT NULL UNIQUE,
    matKhau VARCHAR(255) NOT NULL,
    hoTen VARCHAR(255) NOT NULL,
    ngaySinh DATE NOT NULL,
    diaChi VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    soDienthoai VARCHAR(50),
    vaiTro VARCHAR(50) NOT NULL, -- 'khachhang', 'nvquanli', 'nvkho', 'nvbanhang'
    ghiChu VARCHAR(255)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 2. Bảng tblKhachhang (Kế thừa tblThanhvien)
-- --------------------------------------------------------------------
CREATE TABLE tblKhachhang (
    tblThanhvienid INT PRIMARY KEY,
    maKhachhang VARCHAR(50) NOT NULL UNIQUE,
    CONSTRAINT fk_khachhang_thanhvien FOREIGN KEY (tblThanhvienid) 
        REFERENCES tblThanhvien(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 3. Bảng tblNhanvien (Kế thừa tblThanhvien)
-- --------------------------------------------------------------------
CREATE TABLE tblNhanvien (
    tblThanhvienid INT PRIMARY KEY,
    viTri VARCHAR(255) NOT NULL,
    CONSTRAINT fk_nhanvien_thanhvien FOREIGN KEY (tblThanhvienid) 
        REFERENCES tblThanhvien(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 4. Bảng tblNVQuanli (Kế thừa tblNhanvien)
-- --------------------------------------------------------------------
CREATE TABLE tblNVQuanli (
    tblNhanvienid INT PRIMARY KEY,
    CONSTRAINT fk_nvquanli_nhanvien FOREIGN KEY (tblNhanvienid) 
        REFERENCES tblNhanvien(tblThanhvienid) ON DELETE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 5. Bảng tblNVKho (Kế thừa tblNhanvien)
-- --------------------------------------------------------------------
CREATE TABLE tblNVKho (
    tblNhanvienid INT PRIMARY KEY,
    CONSTRAINT fk_nvkho_nhanvien FOREIGN KEY (tblNhanvienid) 
        REFERENCES tblNhanvien(tblThanhvienid) ON DELETE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 6. Bảng tblNVBanhang (Kế thừa tblNhanvien)
-- --------------------------------------------------------------------
CREATE TABLE tblNVBanhang (
    tblNhanvienid INT PRIMARY KEY,
    CONSTRAINT fk_nvbanhang_nhanvien FOREIGN KEY (tblNhanvienid) 
        REFERENCES tblNhanvien(tblThanhvienid) ON DELETE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 7. Bảng tblNVGiaohang (Không có tài khoản nên không kế thừa tblThanhvien)
-- --------------------------------------------------------------------
CREATE TABLE tblNVGiaohang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hoTen VARCHAR(255) NOT NULL,
    ngaySinh DATE,
    diaChi VARCHAR(255),
    email VARCHAR(255),
    soDienthoai VARCHAR(50),
    viTri VARCHAR(255),
    ghiChu VARCHAR(255)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 8. Bảng tblLoaimathang
-- --------------------------------------------------------------------
CREATE TABLE tblLoaimathang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tenLoai VARCHAR(255) NOT NULL,
    moTa VARCHAR(255)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 9. Bảng tblMathang
-- --------------------------------------------------------------------
CREATE TABLE tblMathang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    maMathang VARCHAR(50) NOT NULL UNIQUE,
    tenMathang VARCHAR(255) NOT NULL,
    hangSanxuat VARCHAR(255),
    giaBan DOUBLE NOT NULL,
    soLuongTon INT NOT NULL DEFAULT 0,
    moTa VARCHAR(255),
    tblLoaimathangid INT NOT NULL,
    CONSTRAINT fk_mathang_loai FOREIGN KEY (tblLoaimathangid) 
        REFERENCES tblLoaimathang(id)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 10. Bảng tblNhacungcap
-- --------------------------------------------------------------------
CREATE TABLE tblNhacungcap (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ten VARCHAR(255) NOT NULL,
    diaChi VARCHAR(255),
    soDienthoai VARCHAR(50),
    email VARCHAR(255),
    moTa VARCHAR(255)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 11. Bảng tblPhieunhaphang
-- --------------------------------------------------------------------
CREATE TABLE tblPhieunhaphang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ngayNhap DATE NOT NULL,
    ghiChu VARCHAR(255),
    tblNVKhoid INT NOT NULL,
    tblNhacungcapid INT NOT NULL,
    CONSTRAINT fk_phieunhap_nvkho FOREIGN KEY (tblNVKhoid) 
        REFERENCES tblNVKho(tblNhanvienid),
    CONSTRAINT fk_phieunhap_ncc FOREIGN KEY (tblNhacungcapid) 
        REFERENCES tblNhacungcap(id)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 12. Bảng tblChitietphieunhap (Đã loại bỏ thanhTien dẫn xuất)
-- --------------------------------------------------------------------
CREATE TABLE tblChitietphieunhap (
    id INT AUTO_INCREMENT PRIMARY KEY,
    soLuongNhap INT NOT NULL,
    giaNhap DOUBLE NOT NULL,
    tblPhieunhaphangid INT NOT NULL,
    tblMathangid INT NOT NULL,
    CONSTRAINT fk_ctphieunhap_phieu FOREIGN KEY (tblPhieunhaphangid) 
        REFERENCES tblPhieunhaphang(id) ON DELETE CASCADE,
    CONSTRAINT fk_ctphieunhap_mathang FOREIGN KEY (tblMathangid) 
        REFERENCES tblMathang(id)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 13. Bảng tblGiohang (1-1 với tblKhachhang)
-- --------------------------------------------------------------------
CREATE TABLE tblGiohang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tblKhachhangid INT NOT NULL UNIQUE,
    CONSTRAINT fk_giohang_khachhang FOREIGN KEY (tblKhachhangid) 
        REFERENCES tblKhachhang(tblThanhvienid) ON DELETE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 14. Bảng tblChitietgiohang
-- --------------------------------------------------------------------
CREATE TABLE tblChitietgiohang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    soLuong INT NOT NULL,
    tblGiohangid INT NOT NULL,
    tblMathangid INT NOT NULL,
    CONSTRAINT fk_ctgiohang_giohang FOREIGN KEY (tblGiohangid) 
        REFERENCES tblGiohang(id) ON DELETE CASCADE,
    CONSTRAINT fk_ctgiohang_mathang FOREIGN KEY (tblMathangid) 
        REFERENCES tblMathang(id)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 15. Bảng tblDondathang (Đơn trực tuyến; đã loại bỏ tongTien dẫn xuất)
-- --------------------------------------------------------------------
CREATE TABLE tblDondathang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    maDonhang VARCHAR(50) NOT NULL UNIQUE,
    ngayDat DATE NOT NULL,
    diaChiNhan VARCHAR(255) NOT NULL,
    trangThai VARCHAR(50) NOT NULL DEFAULT 'cho_duyet', -- 'cho_duyet', 'da_duyet', 'da_xuat', 'tu_choi'
    ngayXuat DATE NULL,
    tblKhachhangid INT NOT NULL,
    tblNVKhoid INT NULL,
    tblNVGiaohangid INT NULL,
    CONSTRAINT fk_dondathang_khachhang FOREIGN KEY (tblKhachhangid) 
        REFERENCES tblKhachhang(tblThanhvienid),
    CONSTRAINT fk_dondathang_nvkho FOREIGN KEY (tblNVKhoid) 
        REFERENCES tblNVKho(tblNhanvienid),
    CONSTRAINT fk_dondathang_nvgiaohang FOREIGN KEY (tblNVGiaohangid) 
        REFERENCES tblNVGiaohang(id)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 16. Bảng tblChitietdondathang (Đã loại bỏ thanhTien dẫn xuất)
-- --------------------------------------------------------------------
CREATE TABLE tblChitietdondathang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    soLuongDat INT NOT NULL,
    donGia DOUBLE NOT NULL,
    tblDondathangid INT NOT NULL,
    tblMathangid INT NOT NULL,
    CONSTRAINT fk_ctdondathang_donhang FOREIGN KEY (tblDondathangid) 
        REFERENCES tblDondathang(id) ON DELETE CASCADE,
    CONSTRAINT fk_ctdondathang_mathang FOREIGN KEY (tblMathangid) 
        REFERENCES tblMathang(id)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 17. Bảng tblHoadonbanhang (Hóa đơn tại quầy; đã loại bỏ tongTien dẫn xuất)
-- --------------------------------------------------------------------
CREATE TABLE tblHoadonbanhang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    maHoadon VARCHAR(50) NOT NULL UNIQUE,
    ngayBan DATE NOT NULL,
    ghiChu VARCHAR(255),
    tblNVBanhangid INT NOT NULL,
    tblKhachhangid INT NULL, -- Cho phép NULL đối với khách vãng lai
    CONSTRAINT fk_hoadon_nvbanhang FOREIGN KEY (tblNVBanhangid) 
        REFERENCES tblNVBanhang(tblNhanvienid),
    CONSTRAINT fk_hoadon_khachhang FOREIGN KEY (tblKhachhangid) 
        REFERENCES tblKhachhang(tblThanhvienid)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 18. Bảng tblChitiethoadon (Đã loại bỏ thanhTien dẫn xuất)
-- --------------------------------------------------------------------
CREATE TABLE tblChitiethoadon (
    id INT AUTO_INCREMENT PRIMARY KEY,
    soLuongMua INT NOT NULL,
    donGia DOUBLE NOT NULL,
    tblHoadonbanhangid INT NOT NULL,
    tblMathangid INT NOT NULL,
    CONSTRAINT fk_cthoadon_hoadon FOREIGN KEY (tblHoadonbanhangid) 
        REFERENCES tblHoadonbanhang(id) ON DELETE CASCADE,
    CONSTRAINT fk_cthoadon_mathang FOREIGN KEY (tblMathangid) 
        REFERENCES tblMathang(id)
) ENGINE=InnoDB;
