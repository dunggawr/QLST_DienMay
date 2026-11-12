-- ====================================================================
-- HỆ THỐNG QUẢN LÝ SIÊU THỊ ĐIỆN MÁY (QLST ĐIỆN MÁY)
-- CÁC STORED PROCEDURES
-- Theo chuẩn giáo trình PTIT (gọi qua CallableStatement trong DAO)
-- ====================================================================

USE qldst_dienmay;

DELIMITER $$

-- --------------------------------------------------------------------
-- SP 1: kiemtraTrungTDN
-- Mục đích: Kiểm tra tên đăng nhập đã tồn tại trong tblThanhvien chưa
-- Tham số: 
--   IN  p_username VARCHAR(255)
--   OUT p_result   INT (1: Đã tồn tại/trùng; 0: Chưa tồn tại/hợp lệ)
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS kiemtraTrungTDN$$
CREATE PROCEDURE kiemtraTrungTDN(
    IN  p_username VARCHAR(255),
    OUT p_result   INT
)
BEGIN
    DECLARE v_count INT DEFAULT 0;
    SELECT COUNT(*) INTO v_count 
    FROM tblThanhvien 
    WHERE tenDangnhap = p_username;
    
    IF v_count > 0 THEN
        SET p_result = 1;
    ELSE
        SET p_result = 0;
    END IF;
END$$

-- --------------------------------------------------------------------
-- SP 2: luuKhachhang
-- Mục đích: Lưu thông tin khách hàng mới vào tblThanhvien, tblKhachhang và khởi tạo tblGiohang
-- Tham số:
--   IN  p_username  VARCHAR(255)
--   IN  p_password  VARCHAR(255)
--   IN  p_hoten     VARCHAR(255)
--   IN  p_ngaysinh  DATE
--   IN  p_diachi    VARCHAR(255)
--   IN  p_email     VARCHAR(255)
--   IN  p_sdt       VARCHAR(50)
--   IN  p_ghichu    VARCHAR(255)
--   OUT p_new_id    INT
--   OUT p_new_makh  VARCHAR(50)
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS luuKhachhang$$
CREATE PROCEDURE luuKhachhang(
    IN  p_username  VARCHAR(255),
    IN  p_password  VARCHAR(255),
    IN  p_hoten     VARCHAR(255),
    IN  p_ngaysinh  DATE,
    IN  p_diachi    VARCHAR(255),
    IN  p_email     VARCHAR(255),
    IN  p_sdt       VARCHAR(50),
    IN  p_ghichu    VARCHAR(255),
    OUT p_new_id    INT,
    OUT p_new_makh  VARCHAR(50)
)
BEGIN
    -- 1. Thêm vào bảng cha tblThanhvien
    INSERT INTO tblThanhvien(tenDangnhap, matKhau, hoTen, ngaySinh, diaChi, email, soDienthoai, vaiTro, ghiChu)
    VALUES(p_username, p_password, p_hoten, p_ngaysinh, p_diachi, p_email, p_sdt, 'khachhang', p_ghichu);
    
    SET p_new_id = LAST_INSERT_ID();
    
    -- 2. Tự động sinh mã khách hàng theo định dạng KHxxx (ví dụ: KH003)
    SET p_new_makh = CONCAT('KH', LPAD(p_new_id, 3, '0'));
    
    -- 3. Thêm vào bảng con tblKhachhang
    INSERT INTO tblKhachhang(tblThanhvienid, maKhachhang)
    VALUES(p_new_id, p_new_makh);
    
    -- 4. Khởi tạo giỏ hàng trống cho khách hàng
    INSERT INTO tblGiohang(tblKhachhangid)
    VALUES(p_new_id);
END$$

-- --------------------------------------------------------------------
-- SP 3: tkKhachhangTheoDoanhthu
-- Mục đích: Thống kê khách hàng theo doanh thu từ ngày p_ngayBD đến p_ngayKT
-- Doanh thu = Tổng (hóa đơn bán tại quầy của KH) + Tổng (đơn hàng trực tuyến đã xuất của KH)
-- Khách vãng lai (tblKhachhangid IS NULL) KHÔNG xuất hiện trong danh sách này.
-- Sắp xếp theo tổng doanh thu giảm dần (DESC).
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS tkKhachhangTheoDoanhthu$$
CREATE PROCEDURE tkKhachhangTheoDoanhthu(
    IN p_ngayBD DATE,
    IN p_ngayKT DATE
)
BEGIN
    SELECT 
        kh.tblThanhvienid,
        kh.maKhachhang,
        tv.hoTen,
        tv.ngaySinh,
        tv.diaChi,
        tv.soDienthoai,
        tv.email,
        COUNT(DISTINCT gd.maGiaoDich) AS tongSoGiaodich,
        COALESCE(SUM(gd.thanhTien), 0) AS tongDoanhthu
    FROM tblKhachhang kh
    INNER JOIN tblThanhvien tv ON kh.tblThanhvienid = tv.id
    INNER JOIN (
        -- 1. Giao dịch từ Hóa đơn bán hàng tại quầy
        SELECT 
            hd.tblKhachhangid,
            CONCAT('HD_', hd.id) AS maGiaoDich,
            cthd.soLuongMua * cthd.donGia AS thanhTien
        FROM tblHoadonbanhang hd
        INNER JOIN tblChitiethoadon cthd ON hd.id = cthd.tblHoadonbanhangid
        WHERE hd.tblKhachhangid IS NOT NULL 
          AND hd.ngayBan >= p_ngayBD 
          AND hd.ngayBan <= p_ngayKT

        UNION ALL

        -- 2. Giao dịch từ Đơn đặt hàng trực tuyến ĐÃ XUẤT (ngày giao dịch tính là ngayXuat)
        SELECT 
            ddh.tblKhachhangid,
            CONCAT('DH_', ddh.id) AS maGiaoDich,
            ctdh.soLuongDat * ctdh.donGia AS thanhTien
        FROM tblDondathang ddh
        INNER JOIN tblChitietdondathang ctdh ON ddh.id = ctdh.tblDondathangid
        WHERE ddh.trangThai = 'da_xuat'
          AND ddh.ngayXuat >= p_ngayBD 
          AND ddh.ngayXuat <= p_ngayKT
    ) gd ON kh.tblThanhvienid = gd.tblKhachhangid
    GROUP BY kh.tblThanhvienid, kh.maKhachhang, tv.hoTen, tv.ngaySinh, tv.diaChi, tv.soDienthoai, tv.email
    ORDER BY tongDoanhthu DESC;
END$$

-- --------------------------------------------------------------------
-- SP 4: dsHoadonCuaKH
-- Mục đích: Lấy danh sách hóa đơn tại quầy và các dòng chi tiết của 1 KH trong khoảng ngày
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS dsHoadonCuaKH$$
CREATE PROCEDURE dsHoadonCuaKH(
    IN p_idKH INT,
    IN p_ngayBD DATE,
    IN p_ngayKT DATE
)
BEGIN
    SELECT 
        hd.id AS hoadonId,
        hd.maHoadon,
        hd.ngayBan,
        hd.ghiChu,
        ct.id AS cthdId,
        ct.soLuongMua,
        ct.donGia,
        (ct.soLuongMua * ct.donGia) AS thanhTien,
        mh.id AS mathangId,
        mh.maMathang,
        mh.tenMathang,
        mh.hangSanxuat,
        mh.giaBan
    FROM tblHoadonbanhang hd
    INNER JOIN tblChitiethoadon ct ON hd.id = ct.tblHoadonbanhangid
    INNER JOIN tblMathang mh ON ct.tblMathangid = mh.id
    WHERE hd.tblKhachhangid = p_idKH
      AND hd.ngayBan >= p_ngayBD 
      AND hd.ngayBan <= p_ngayKT
    ORDER BY hd.ngayBan ASC, hd.id ASC, ct.id ASC;
END$$

-- --------------------------------------------------------------------
-- SP 5: dsDonhangCuaKH
-- Mục đích: Lấy danh sách đơn đặt hàng trực tuyến ĐÃ XUẤT và các dòng chi tiết của 1 KH
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS dsDonhangCuaKH$$
CREATE PROCEDURE dsDonhangCuaKH(
    IN p_idKH INT,
    IN p_ngayBD DATE,
    IN p_ngayKT DATE
)
BEGIN
    SELECT 
        ddh.id AS donhangId,
        ddh.maDonhang,
        ddh.ngayDat,
        ddh.diaChiNhan,
        ddh.trangThai,
        ddh.ngayXuat,
        ct.id AS ctdhId,
        ct.soLuongDat,
        ct.donGia,
        (ct.soLuongDat * ct.donGia) AS thanhTien,
        mh.id AS mathangId,
        mh.maMathang,
        mh.tenMathang,
        mh.hangSanxuat,
        mh.giaBan
    FROM tblDondathang ddh
    INNER JOIN tblChitietdondathang ct ON ddh.id = ct.tblDondathangid
    INNER JOIN tblMathang mh ON ct.tblMathangid = mh.id
    WHERE ddh.tblKhachhangid = p_idKH
      AND ddh.trangThai = 'da_xuat'
      AND ddh.ngayXuat >= p_ngayBD 
      AND ddh.ngayXuat <= p_ngayKT
    ORDER BY ddh.ngayXuat ASC, ddh.id ASC, ct.id ASC;
END$$

DELIMITER ;
