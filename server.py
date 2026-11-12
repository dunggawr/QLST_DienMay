import sys
import os
import sqlite3
import urllib.parse
from http.server import HTTPServer, BaseHTTPRequestHandler
from datetime import datetime

PORT = 8088
DB_FILE = os.path.join(os.path.dirname(__file__), "demo_db.sqlite")

def init_db():
    conn = sqlite3.connect(DB_FILE)
    c = conn.cursor()
    c.executescript('''
    DROP TABLE IF EXISTS tblChitiethoadon;
    DROP TABLE IF EXISTS tblHoadonbanhang;
    DROP TABLE IF EXISTS tblChitietdondathang;
    DROP TABLE IF EXISTS tblDondathang;
    DROP TABLE IF EXISTS tblMathang;
    DROP TABLE IF EXISTS tblLoaimathang;
    DROP TABLE IF EXISTS tblKhachhang;
    DROP TABLE IF EXISTS tblThanhvien;

    CREATE TABLE tblThanhvien (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tenDangnhap TEXT UNIQUE NOT NULL,
        matKhau TEXT NOT NULL,
        hoTen TEXT NOT NULL,
        ngaySinh TEXT NOT NULL,
        diaChi TEXT NOT NULL,
        email TEXT,
        soDienthoai TEXT,
        vaiTro TEXT NOT NULL,
        ghiChu TEXT
    );

    CREATE TABLE tblKhachhang (
        tblThanhvienid INTEGER PRIMARY KEY,
        maKhachhang TEXT UNIQUE NOT NULL,
        FOREIGN KEY(tblThanhvienid) REFERENCES tblThanhvien(id)
    );

    CREATE TABLE tblLoaimathang (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tenLoai TEXT NOT NULL,
        moTa TEXT
    );

    CREATE TABLE tblMathang (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        maMathang TEXT UNIQUE NOT NULL,
        tenMathang TEXT NOT NULL,
        hangSanxuat TEXT,
        giaBan REAL NOT NULL,
        soLuongTon INTEGER DEFAULT 0,
        moTa TEXT,
        tblLoaimathangid INTEGER
    );

    CREATE TABLE tblHoadonbanhang (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        maHoadon TEXT UNIQUE NOT NULL,
        ngayBan TEXT NOT NULL,
        ghiChu TEXT,
        tblNVBanhangid INTEGER,
        tblKhachhangid INTEGER
    );

    CREATE TABLE tblChitiethoadon (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        soLuongMua INTEGER NOT NULL,
        donGia REAL NOT NULL,
        tblHoadonbanhangid INTEGER,
        tblMathangid INTEGER
    );

    CREATE TABLE tblDondathang (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        maDonhang TEXT UNIQUE NOT NULL,
        ngayDat TEXT NOT NULL,
        diaChiNhan TEXT NOT NULL,
        trangThai TEXT NOT NULL,
        ngayXuat TEXT,
        tblKhachhangid INTEGER
    );

    CREATE TABLE tblChitietdondathang (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        soLuongDat INTEGER NOT NULL,
        donGia REAL NOT NULL,
        tblDondathangid INTEGER,
        tblMathangid INTEGER
    );

    -- Dữ liệu mẫu
    INSERT INTO tblThanhvien VALUES (1, 'quanli1', '123456', 'Trần Quản Lý', '1985-03-15', '123 Cầu Giấy, Hà Nội', 'quanli1@dienmay.vn', '0911222333', 'nvquanli', 'Quản lý');
    INSERT INTO tblThanhvien VALUES (2, 'kho1', '123456', 'Lê Văn Kho', '1991-07-22', '45 Giải Phóng, Hà Nội', 'kho1@dienmay.vn', '0922333444', 'nvkho', 'Thủ kho');
    INSERT INTO tblThanhvien VALUES (3, 'banhang1', '123456', 'Phạm Bán Hàng', '1995-10-05', '88 Kim Mã, Hà Nội', 'banhang1@dienmay.vn', '0933444555', 'nvbanhang', 'Thu ngân');

    INSERT INTO tblThanhvien VALUES (4, 'nguyenvanan', '123456', 'Nguyễn Văn An', '1990-05-12', '12 Phố Huế, Hai Bà Trưng, Hà Nội', 'an.nguyen@email.com', '0912345678', 'khachhang', 'Khách VIP');
    INSERT INTO tblKhachhang VALUES (4, 'KH001');

    INSERT INTO tblThanhvien VALUES (5, 'tranthibinh', '123456', 'Trần Thị Bình', '1993-08-20', '56 Nguyễn Tri Phương, Đà Nẵng', 'binh.tran@email.com', '0987654321', 'khachhang', 'Khách thân thiết');
    INSERT INTO tblKhachhang VALUES (5, 'KH002');

    INSERT INTO tblThanhvien VALUES (6, 'lehoangnam', '123456', 'Lê Hoàng Nam', '1988-11-15', '78 Lê Lợi, Quận 1, TP.HCM', 'nam.le@email.com', '0905123456', 'khachhang', 'Khách mua sỉ');
    INSERT INTO tblKhachhang VALUES (6, 'KH003');

    INSERT INTO tblLoaimathang VALUES (1, 'Tivi', 'Tivi Smart, OLED');
    INSERT INTO tblLoaimathang VALUES (2, 'Tủ lạnh', 'Tủ lạnh Inverter');
    INSERT INTO tblLoaimathang VALUES (3, 'Máy giặt', 'Máy giặt cửa trước');
    INSERT INTO tblLoaimathang VALUES (4, 'Điều hòa', 'Điều hòa Inverter');

    INSERT INTO tblMathang VALUES (1, 'MH001', 'Smart Tivi Sony 55 inch 4K', 'Sony', 15000000, 20, '4K HDR', 1);
    INSERT INTO tblMathang VALUES (2, 'MH002', 'Smart Tivi Samsung 65 inch QLED', 'Samsung', 18000000, 15, 'QLED 4K', 1);
    INSERT INTO tblMathang VALUES (3, 'MH003', 'Tủ lạnh Panasonic Inverter 300L', 'Panasonic', 9500000, 25, 'Ag Clean', 2);
    INSERT INTO tblMathang VALUES (4, 'MH004', 'Máy giặt LG Inverter 9kg', 'LG', 8000000, 30, 'AI DD', 3);
    INSERT INTO tblMathang VALUES (5, 'MH005', 'Điều hòa Daikin Inverter 9000 BTU', 'Daikin', 10500000, 18, 'Coanda', 4);

    -- Hóa đơn quầy HD001 - KH001 (Nguyễn Văn An)
    INSERT INTO tblHoadonbanhang VALUES (1, 'HD001', '2026-10-12', 'Khách quẹt thẻ', 3, 4);
    INSERT INTO tblChitiethoadon VALUES (1, 1, 15000000, 1, 1);
    INSERT INTO tblChitiethoadon VALUES (2, 1, 8000000, 1, 4);

    -- Đơn hàng trực tuyến ĐÃ XUẤT DH001 - KH001 (Nguyễn Văn An)
    INSERT INTO tblDondathang VALUES (1, 'DH001', '2026-10-15', '12 Phố Huế, Hà Nội', 'da_xuat', '2026-10-16', 4);
    INSERT INTO tblChitietdondathang VALUES (1, 1, 9500000, 1, 3);

    -- Hóa đơn quầy HD002 - KH002 (Trần Thị Bình)
    INSERT INTO tblHoadonbanhang VALUES (2, 'HD002', '2026-10-18', 'Khách chuyển khoản', 3, 5);
    INSERT INTO tblChitiethoadon VALUES (3, 1, 18000000, 2, 2);

    -- Đơn hàng trực tuyến ĐÃ XUẤT DH002 - KH003 (Lê Hoàng Nam)
    INSERT INTO tblDondathang VALUES (2, 'DH002', '2026-10-20', '78 Lê Lợi, TP.HCM', 'da_xuat', '2026-10-22', 6);
    INSERT INTO tblChitietdondathang VALUES (2, 2, 10500000, 2, 5);

    -- Hóa đơn khách vãng lai
    INSERT INTO tblHoadonbanhang VALUES (3, 'HD003', '2026-10-25', 'Khách vãng lai', 3, NULL);
    INSERT INTO tblChitiethoadon VALUES (4, 1, 8000000, 3, 4);
    ''')
    conn.commit()
    conn.close()

init_db()

current_user = None
session_data = {}

class QLSTHandler(BaseHTTPRequestHandler):
    def send_html(self, content):
        self.send_response(200)
        self.send_header('Content-Type', 'text/html; charset=utf-8')
        self.end_headers()
        self.wfile.write(content.encode('utf-8'))

    def redirect(self, path):
        self.send_response(302)
        self.send_header('Location', path)
        self.end_headers()

    def do_GET(self):
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path
        qs = urllib.parse.parse_qs(parsed.query)

        if path in ['', '/', '/index.html']:
            self.redirect('/view/thanhvien/gdDangnhap.jsp')
            return

        # 1. gdDangnhap.jsp
        if path.endswith('gdDangnhap.jsp'):
            error = qs.get('error', [''])[0]
            err_html = f'<div style="color:#dc3545;background:#f8d7da;padding:10px;border-radius:4px;margin-bottom:15px;text-align:center;">{error}</div>' if error else ''
            html = f'''<!DOCTYPE html>
<html><head><meta charset="UTF-8"><title>Đăng nhập - Siêu thị Điện máy</title>
<style>
body {{ font-family: Arial, sans-serif; margin: 40px; background-color: #f4f6f9; }}
.login-box {{ max-width: 400px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}
h2 {{ text-align: center; color: #007bff; margin-bottom: 25px; }}
.form-group {{ margin-bottom: 15px; }}
label {{ display: block; margin-bottom: 5px; font-weight: bold; }}
input[type="text"], input[type="password"] {{ width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; font-size: 14px; }}
.btn-submit {{ width: 100%; padding: 12px; background-color: #007bff; color: white; border: none; border-radius: 4px; font-size: 16px; font-weight: bold; cursor: pointer; }}
.btn-submit:hover {{ background-color: #0056b3; }}
.demo-accounts {{ background: #e9ecef; padding: 12px; border-radius: 5px; font-size: 13px; margin-top: 15px; }}
</style></head>
<body>
<div class="login-box">
    <h2>ĐĂNG NHẬP HỆ THỐNG</h2>
    {err_html}
    <form action="/view/thanhvien/doDangnhap.jsp" method="POST">
        <div class="form-group">
            <label>Tên đăng nhập:</label>
            <input type="text" name="username" value="quanli1" required>
        </div>
        <div class="form-group">
            <label>Mật khẩu:</label>
            <input type="password" name="password" value="123456" required>
        </div>
        <button type="submit" class="btn-submit">Đăng nhập</button>
    </form>
    <div style="text-align: center; margin-top: 15px; font-size: 14px;">
        Chưa có tài khoản? <a href="/view/khachhang/gdDangki.jsp" style="color: #28a745; font-weight: bold; text-decoration: none;">Đăng ký thành viên ngay</a>
    </div>
    <div class="demo-accounts">
        <strong>Tài khoản thử nghiệm:</strong><br>
        • Quản lý: <code>quanli1</code> / <code>123456</code><br>
        • Khách hàng: <code>nguyenvanan</code> / <code>123456</code>
    </div>
</div></body></html>'''
            self.send_html(html)

        # 2. gdChinhKH.jsp
        elif path.endswith('gdChinhKH.jsp'):
            html = '''<!DOCTYPE html>
<html><head><meta charset="UTF-8"><title>Trang chủ Khách hàng</title>
<style>
body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f6f9; }
.container { max-width: 800px; margin: auto; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
h2 { color: #0056b3; border-bottom: 2px solid #0056b3; padding-bottom: 10px; }
.menu-bar { display: flex; gap: 15px; margin: 20px 0; }
.btn { padding: 10px 18px; text-decoration: none; color: white; background-color: #007bff; border-radius: 4px; font-weight: bold; }
.btn-register { background-color: #28a745; }
</style></head>
<body>
<div class="container">
    <h2>HỆ THỐNG SIÊU THỊ ĐIỆN MÁY</h2>
    <p>Chào mừng quý khách đến với siêu thị điện máy!</p>
    <div class="menu-bar">
        <a href="/view/khachhang/gdChinhKH.jsp" class="btn">Trang chủ</a>
        <a href="/view/khachhang/gdDangki.jsp" class="btn btn-register">Đăng ký thành viên</a>
        <a href="/view/thanhvien/gdDangnhap.jsp" class="btn" style="background-color: #17a2b8;">Đăng nhập</a>
    </div>
    <div style="background: #e9ecef; padding: 15px; border-radius: 5px;">
        <h3>Các tính năng dành cho khách hàng:</h3>
        <ul>
            <li><strong>Đăng ký thành viên:</strong> Tạo tài khoản thành viên để được tích điểm và đặt mua trực tuyến.</li>
            <li><strong>Tìm kiếm mặt hàng:</strong> Tra cứu nhanh chóng các thiết bị điện máy chính hãng.</li>
            <li><strong>Đặt hàng trực tuyến:</strong> Đặt mua giao hàng tận nhà nhanh chóng, an toàn.</li>
        </ul>
    </div>
</div></body></html>'''
            self.send_html(html)

        # 3. gdDangki.jsp
        elif path.endswith('gdDangki.jsp'):
            error = qs.get('error', [''])[0]
            err_html = f'<div style="color:#dc3545;background:#f8d7da;padding:10px;border-radius:4px;margin-bottom:15px;">{error}</div>' if error else ''
            html = f'''<!DOCTYPE html>
<html><head><meta charset="UTF-8"><title>Đăng ký thành viên</title>
<style>
body {{ font-family: Arial, sans-serif; margin: 20px; background-color: #f4f6f9; }}
.container {{ max-width: 600px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}
h2 {{ color: #28a745; text-align: center; margin-bottom: 25px; }}
.form-group {{ margin-bottom: 15px; }}
label {{ display: block; margin-bottom: 5px; font-weight: bold; }}
input[type="text"], input[type="password"], input[type="date"], input[type="email"] {{ width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }}
.btn-group {{ display: flex; justify-content: space-between; margin-top: 25px; }}
.btn {{ padding: 10px 20px; font-size: 15px; border-radius: 4px; cursor: pointer; border: none; font-weight: bold; text-decoration: none; }}
.btn-submit {{ background-color: #28a745; color: white; }}
.btn-back {{ background-color: #6c757d; color: white; line-height: 20px; }}
.required {{ color: red; }}
</style>
<script>
function validateForm() {{
    var hoTen = document.getElementById("hoTen").value.trim();
    var ngaySinh = document.getElementById("ngaySinh").value;
    var diaChi = document.getElementById("diaChi").value.trim();
    var soDienthoai = document.getElementById("soDienthoai").value.trim();
    var email = document.getElementById("email").value.trim();
    var tenDangnhap = document.getElementById("tenDangnhap").value.trim();
    var matKhau = document.getElementById("matKhau").value;
    var xacNhanMatKhau = document.getElementById("xacNhanMatKhau").value;

    if (!hoTen || !ngaySinh || !diaChi || !soDienthoai || !tenDangnhap || !matKhau) {{
        alert("Vui lòng nhập đầy đủ các trường thông tin bắt buộc (*).");
        return false;
    }}
    if (!/^[0-9]{{9,11}}$/.test(soDienthoai)) {{
        alert("Số điện thoại không hợp lệ (phải là 9-11 chữ số).");
        return false;
    }}
    if (matKhau !== xacNhanMatKhau) {{
        alert("Mật khẩu và xác nhận mật khẩu không trùng khớp.");
        return false;
    }}
    return true;
}}
</script>
</head>
<body>
<div class="container">
    <h2>ĐĂNG KÝ THÀNH VIÊN KHÁCH HÀNG</h2>
    {err_html}
    <form action="/view/khachhang/doDangki.jsp" method="POST" onsubmit="return validateForm();">
        <div class="form-group"><label>Họ và tên <span class="required">*</span>:</label><input type="text" id="hoTen" name="hoTen" value="Vũ Đức Đam" required></div>
        <div class="form-group"><label>Ngày sinh <span class="required">*</span>:</label><input type="date" id="ngaySinh" name="ngaySinh" value="1994-06-15" required></div>
        <div class="form-group"><label>Địa chỉ <span class="required">*</span>:</label><input type="text" id="diaChi" name="diaChi" value="99 Bà Triệu, Hà Nội" required></div>
        <div class="form-group"><label>Số điện thoại <span class="required">*</span>:</label><input type="text" id="soDienthoai" name="soDienthoai" value="0977888999" required></div>
        <div class="form-group"><label>Email:</label><input type="email" id="email" name="email" value="dam.vu@email.com"></div>
        <div class="form-group"><label>Tên đăng nhập <span class="required">*</span>:</label><input type="text" id="tenDangnhap" name="tenDangnhap" value="vudam94" required></div>
        <div class="form-group"><label>Mật khẩu <span class="required">*</span>:</label><input type="password" id="matKhau" name="matKhau" value="123456" required></div>
        <div class="form-group"><label>Xác nhận mật khẩu <span class="required">*</span>:</label><input type="password" id="xacNhanMatKhau" name="xacNhanMatKhau" value="123456" required></div>
        <div class="form-group"><label>Ghi chú:</label><input type="text" id="ghiChu" name="ghiChu" value="Đăng ký mới"></div>
        <div class="btn-group">
            <a href="/view/khachhang/gdChinhKH.jsp" class="btn btn-back">Quay lại</a>
            <button type="submit" class="btn btn-submit">Đăng ký thành viên</button>
        </div>
    </form>
</div></body></html>'''
            self.send_html(html)

        # 4. gdChinhQL.jsp
        elif path.endswith('gdChinhQL.jsp'):
            html = '''<!DOCTYPE html>
<html><head><meta charset="UTF-8"><title>Trang chủ Quản lý</title>
<style>
body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f6f9; }
.container { max-width: 850px; margin: auto; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
.header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #0056b3; padding-bottom: 10px; }
h2 { color: #0056b3; margin: 0; }
.menu-bar { display: flex; gap: 15px; margin: 25px 0; }
.btn { padding: 12px 20px; text-decoration: none; color: white; background-color: #007bff; border-radius: 4px; font-weight: bold; }
.btn-report { background-color: #28a745; }
</style></head>
<body>
<div class="container">
    <div class="header">
        <h2>BÀN LÀM VIỆC NHÂN VIÊN QUẢN LÝ</h2>
        <div>Xin chào, <strong>Trần Quản Lý</strong> | <a href="/view/thanhvien/gdDangnhap.jsp" style="color: #dc3545; text-decoration: none;">Đăng xuất</a></div>
    </div>
    <div class="menu-bar">
        <a href="/view/nvquanli/gdChinhQL.jsp" class="btn">Trang chủ</a>
        <a href="/view/nvquanli/gdChonBaocao.jsp" class="btn btn-report">📊 Xem báo cáo thống kê</a>
    </div>
    <div style="background: #e9ecef; padding: 20px; border-radius: 5px;">
        <h3>Chức năng của Nhân viên Quản lý:</h3>
        <ul>
            <li><strong>Thống kê khách hàng theo doanh thu:</strong> Xem danh sách khách hàng có doanh thu cao nhất và chi tiết từng lần giao dịch.</li>
            <li><strong>Thống kê doanh thu:</strong> Báo cáo doanh thu toàn siêu thị.</li>
            <li><strong>Thống kê mặt hàng & nhà cung cấp.</strong></li>
        </ul>
    </div>
</div></body></html>'''
            self.send_html(html)

        # 5. gdChonBaocao.jsp
        elif path.endswith('gdChonBaocao.jsp'):
            html = '''<!DOCTYPE html>
<html><head><meta charset="UTF-8"><title>Chọn loại báo cáo</title>
<style>
body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f6f9; }
.container { max-width: 650px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
h2 { color: #0056b3; text-align: center; margin-bottom: 25px; border-bottom: 2px solid #0056b3; padding-bottom: 10px; }
.report-list { display: flex; flex-direction: column; gap: 15px; margin: 25px 0; }
.report-item { display: block; padding: 15px 20px; background-color: #f8f9fa; border: 1px solid #dee2e6; border-left: 5px solid #007bff; border-radius: 4px; text-decoration: none; color: #333; font-size: 16px; font-weight: bold; }
.report-featured { border-left-color: #28a745; background-color: #f4fff4; }
.btn-back { display: inline-block; padding: 10px 20px; background-color: #6c757d; color: white; text-decoration: none; border-radius: 4px; font-weight: bold; }
</style></head>
<body>
<div class="container">
    <h2>CHỌN LOẠI BÁO CÁO THỐNG KÊ</h2>
    <div class="report-list">
        <a href="/view/nvquanli/gdTKKhachhang.jsp" class="report-item report-featured">
            📊 Thống kê khách hàng theo doanh thu (Khả dụng)
        </a>
        <a href="#" class="report-item" onclick="alert('Đang nâng cấp'); return false;">📦 Thống kê mặt hàng</a>
        <a href="#" class="report-item" onclick="alert('Đang nâng cấp'); return false;">🏢 Thống kê nhà cung cấp</a>
        <a href="#" class="report-item" onclick="alert('Đang nâng cấp'); return false;">💰 Thống kê doanh thu chung</a>
    </div>
    <div style="text-align: center; margin-top: 25px;">
        <a href="/view/nvquanli/gdChinhQL.jsp" class="btn-back">⬅ Quay lại Trang chủ</a>
    </div>
</div></body></html>'''
            self.send_html(html)

        # 6. gdTKKhachhang.jsp
        elif path.endswith('gdTKKhachhang.jsp'):
            ngayBD = qs.get('ngayBD', ['2026-10-01'])[0]
            ngayKT = qs.get('ngayKT', ['2026-10-31'])[0]
            session_data['ngayBD'] = ngayBD
            session_data['ngayKT'] = ngayKT

            error_msg = ''
            rows_html = ''
            has_searched = 'ngayBD' in qs

            if has_searched:
                if not ngayBD or not ngayKT:
                    error_msg = '<div style="color:#721c24;background:#f8d7da;padding:12px;border-radius:4px;margin-bottom:20px;text-align:center;">Vui lòng chọn đầy đủ cả Ngày bắt đầu và Ngày kết thúc!</div>'
                elif ngayKT < ngayBD:
                    error_msg = '<div style="color:#721c24;background:#f8d7da;padding:12px;border-radius:4px;margin-bottom:20px;text-align:center;">Ngày kết thúc không được trước Ngày bắt đầu!</div>'
                else:
                    conn = sqlite3.connect(DB_FILE)
                    c = conn.cursor()
                    query = '''
                    SELECT 
                        kh.tblThanhvienid, kh.maKhachhang, tv.hoTen, tv.ngaySinh, tv.soDienthoai,
                        COUNT(DISTINCT gd.maGiaoDich) AS tongSoGiaodich,
                        SUM(gd.thanhTien) AS tongDoanhthu
                    FROM tblKhachhang kh
                    JOIN tblThanhvien tv ON kh.tblThanhvienid = tv.id
                    JOIN (
                        SELECT hd.tblKhachhangid, ('HD_' || hd.id) as maGiaoDich, (ct.soLuongMua * ct.donGia) as thanhTien
                        FROM tblHoadonbanhang hd
                        JOIN tblChitiethoadon ct ON hd.id = ct.tblHoadonbanhangid
                        WHERE hd.tblKhachhangid IS NOT NULL AND hd.ngayBan >= ? AND hd.ngayBan <= ?

                        UNION ALL

                        SELECT ddh.tblKhachhangid, ('DH_' || ddh.id) as maGiaoDich, (ct.soLuongDat * ct.donGia) as thanhTien
                        FROM tblDondathang ddh
                        JOIN tblChitietdondathang ct ON ddh.id = ct.tblDondathangid
                        WHERE ddh.trangThai = 'da_xuat' AND ddh.ngayXuat >= ? AND ddh.ngayXuat <= ?
                    ) gd ON kh.tblThanhvienid = gd.tblKhachhangid
                    GROUP BY kh.tblThanhvienid, kh.maKhachhang, tv.hoTen, tv.ngaySinh, tv.soDienthoai
                    ORDER BY tongDoanhthu DESC;
                    '''
                    c.execute(query, (ngayBD, ngayKT, ngayBD, ngayKT))
                    rows = c.fetchall()
                    conn.close()

                    if not rows:
                        error_msg = '<div style="color:#856404;background:#fff3cd;padding:15px;border-radius:4px;text-align:center;font-weight:bold;">Không có dữ liệu thống kê trong khoảng thời gian này!</div>'
                    else:
                        for idx, r in enumerate(rows, 1):
                            dt_fmt = f"{r[6]:,.0f} đ".replace(',', '.')
                            encoded_name = urllib.parse.quote(r[2])
                            rows_html += f'''
                            <tr onclick="window.location.href='/view/nvquanli/gdChitietGiaodich.jsp?idKH={r[0]}&maKH={r[1]}&hoTen={encoded_name}';">
                                <td>{idx}</td>
                                <td><a style="color:#007bff;font-weight:bold;text-decoration:none;" href="/view/nvquanli/gdChitietGiaodich.jsp?idKH={r[0]}&maKH={r[1]}&hoTen={encoded_name}">{r[1]}</a></td>
                                <td style="text-align:left;"><a style="color:#007bff;font-weight:bold;text-decoration:none;" href="/view/nvquanli/gdChitietGiaodich.jsp?idKH={r[0]}&maKH={r[1]}&hoTen={encoded_name}">{r[2]}</a></td>
                                <td>{r[3]}</td>
                                <td>{r[4]}</td>
                                <td><strong>{r[5]}</strong></td>
                                <td style="text-align:right;color:#d9534f;font-weight:bold;">{dt_fmt}</td>
                            </tr>
                            '''

            html = f'''<!DOCTYPE html>
<html><head><meta charset="UTF-8"><title>Thống kê khách hàng theo doanh thu</title>
<style>
body {{ font-family: Arial, sans-serif; margin: 20px; background-color: #f4f6f9; }}
.container {{ max-width: 1000px; margin: auto; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}
h2 {{ color: #0056b3; text-align: center; margin-bottom: 20px; }}
.filter-box {{ background: #e9ecef; padding: 20px; border-radius: 6px; margin-bottom: 25px; }}
.form-row {{ display: flex; gap: 20px; align-items: center; justify-content: center; flex-wrap: wrap; }}
input[type="date"] {{ padding: 8px 12px; border: 1px solid #ccc; border-radius: 4px; }}
.btn {{ padding: 9px 18px; border-radius: 4px; font-weight: bold; cursor: pointer; border: none; text-decoration: none; }}
.btn-submit {{ background-color: #007bff; color: white; }}
.btn-back {{ background-color: #6c757d; color: white; }}
table {{ width: 100%; border-collapse: collapse; margin-top: 15px; }}
th, td {{ border: 1px solid #dee2e6; padding: 12px 10px; text-align: center; font-size: 14px; }}
th {{ background-color: #007bff; color: white; }}
tr:nth-child(even) {{ background-color: #f8f9fa; }}
tr:hover {{ background-color: #e3f2fd; cursor: pointer; }}
</style></head>
<body>
<div class="container">
    <h2>THỐNG KÊ KHÁCH HÀNG THEO DOANH THU</h2>
    <div class="filter-box">
        <form action="/view/nvquanli/gdTKKhachhang.jsp" method="GET">
            <div class="form-row">
                <div><label>Từ ngày:</label> <input type="date" name="ngayBD" value="{ngayBD}" required></div>
                <div><label>Đến ngày:</label> <input type="date" name="ngayKT" value="{ngayKT}" required></div>
                <button type="submit" class="btn btn-submit">🔍 Xem thống kê</button>
                <a href="/view/nvquanli/gdChonBaocao.jsp" class="btn btn-back">⬅ Quay lại</a>
            </div>
        </form>
    </div>
    {error_msg}
    {f"""<p><strong>Khoảng thời gian:</strong> từ {ngayBD} đến {ngayKT}</p>
    <p style="font-size: 13px; color: #555;"><i>* Bấm vào mã hoặc họ tên khách hàng để xem chi tiết giao dịch.</i></p>
    <table>
        <thead><tr><th>TT</th><th>Mã KH</th><th>Họ và tên</th><th>Ngày sinh</th><th>Điện thoại</th><th>Số lần GD</th><th>Tổng doanh thu</th></tr></thead>
        <tbody>{rows_html}</tbody>
    </table>""" if rows_html else ""}
</div></body></html>'''
            self.send_html(html)

        # 7. gdChitietGiaodich.jsp
        elif path.endswith('gdChitietGiaodich.jsp'):
            idKH = qs.get('idKH', ['4'])[0]
            maKH = qs.get('maKH', ['KH001'])[0]
            hoTen = qs.get('hoTen', ['Nguyễn Văn An'])[0]
            ngayBD = session_data.get('ngayBD', '2026-10-01')
            ngayKT = session_data.get('ngayKT', '2026-10-31')

            conn = sqlite3.connect(DB_FILE)
            c = conn.cursor()

            # Lấy hóa đơn
            c.execute('''
            SELECT hd.id, hd.maHoadon, hd.ngayBan, ct.soLuongMua, ct.donGia, (ct.soLuongMua * ct.donGia),
                   mh.maMathang, mh.tenMathang, mh.hangSanxuat
            FROM tblHoadonbanhang hd
            JOIN tblChitiethoadon ct ON hd.id = ct.tblHoadonbanhangid
            JOIN tblMathang mh ON ct.tblMathangid = mh.id
            WHERE hd.tblKhachhangid = ? AND hd.ngayBan >= ? AND hd.ngayBan <= ?
            ORDER BY hd.ngayBan, hd.id
            ''', (idKH, ngayBD, ngayKT))
            hd_rows = c.fetchall()

            # Lấy đơn đặt hàng đã xuất
            c.execute('''
            SELECT ddh.id, ddh.maDonhang, ddh.ngayXuat, ct.soLuongDat, ct.donGia, (ct.soLuongDat * ct.donGia),
                   mh.maMathang, mh.tenMathang, mh.hangSanxuat
            FROM tblDondathang ddh
            JOIN tblChitietdondathang ct ON ddh.id = ct.tblDondathangid
            JOIN tblMathang mh ON ct.tblMathangid = mh.id
            WHERE ddh.tblKhachhangid = ? AND ddh.trangThai = 'da_xuat' AND ddh.ngayXuat >= ? AND ddh.ngayXuat <= ?
            ORDER BY ddh.ngayXuat, ddh.id
            ''', (idKH, ngayBD, ngayKT))
            dh_rows = c.fetchall()
            conn.close()

            cards_html = ''
            trans_count = 0
            tong_tat_ca = 0

            # Gom hóa đơn
            hd_dict = {}
            for r in hd_rows:
                hd_id = r[0]
                if hd_id not in hd_dict:
                    hd_dict[hd_id] = {'ma': r[1], 'ngay': r[2], 'items': []}
                hd_dict[hd_id]['items'].append(r)

            for hd_id, data in hd_dict.items():
                trans_count += 1
                tong_hd = sum(it[5] for it in data['items'])
                tong_tat_ca += tong_hd
                items_tr = ''
                for i_idx, it in enumerate(data['items'], 1):
                    items_tr += f"<tr><td>{i_idx}</td><td>{it[6]}</td><td style='text-align:left;'>{it[7]}</td><td>{it[8]}</td><td>{it[3]}</td><td style='text-align:right;'>{it[4]:,.0f} đ</td><td style='text-align:right;'><strong>{it[5]:,.0f} đ</strong></td></tr>".replace(',', '.')
                cards_html += f'''
                <div style="border:1px solid #ced4da;border-radius:6px;margin-bottom:20px;overflow:hidden;background:white;">
                    <div style="background:#007bff;color:white;padding:12px 20px;display:flex;justify-content:space-between;font-weight:bold;">
                        <div>Giao dịch #{trans_count}: Hóa đơn {data['ma']} <span style="background:#ffc107;color:#212529;padding:2px 8px;border-radius:4px;font-size:12px;">Mua tại quầy</span></div>
                        <div>Ngày bán: {data['ngay']}</div>
                    </div>
                    <table style="width:100%;border-collapse:collapse;">
                        <thead><tr style="background:#f1f3f5;"><th>STT</th><th>Mã MH</th><th>Tên mặt hàng</th><th>Hãng</th><th>Số lượng</th><th>Đơn giá</th><th>Thành tiền</th></tr></thead>
                        <tbody>{items_tr}</tbody>
                    </table>
                    <div style="background:#f8f9fa;padding:10px 20px;text-align:right;font-weight:bold;color:#d9534f;border-top:1px solid #dee2e6;">Tổng giá trị hóa đơn: {tong_hd:,.0f} đ</div>
                </div>'''.replace(',', '.')

            # Gom đơn hàng
            dh_dict = {}
            for r in dh_rows:
                dh_id = r[0]
                if dh_id not in dh_dict:
                    dh_dict[dh_id] = {'ma': r[1], 'ngay': r[2], 'items': []}
                dh_dict[dh_id]['items'].append(r)

            for dh_id, data in dh_dict.items():
                trans_count += 1
                tong_dh = sum(it[5] for it in data['items'])
                tong_tat_ca += tong_dh
                items_tr = ''
                for i_idx, it in enumerate(data['items'], 1):
                    items_tr += f"<tr><td>{i_idx}</td><td>{it[6]}</td><td style='text-align:left;'>{it[7]}</td><td>{it[8]}</td><td>{it[3]}</td><td style='text-align:right;'>{it[4]:,.0f} đ</td><td style='text-align:right;'><strong>{it[5]:,.0f} đ</strong></td></tr>".replace(',', '.')
                cards_html += f'''
                <div style="border:1px solid #ced4da;border-radius:6px;margin-bottom:20px;overflow:hidden;background:white;">
                    <div style="background:#20c997;color:white;padding:12px 20px;display:flex;justify-content:space-between;font-weight:bold;">
                        <div>Giao dịch #{trans_count}: Đơn hàng {data['ma']} <span style="background:#28a745;color:white;padding:2px 8px;border-radius:4px;font-size:12px;">Đặt trực tuyến đã xuất</span></div>
                        <div>Ngày xuất kho: {data['ngay']}</div>
                    </div>
                    <table style="width:100%;border-collapse:collapse;">
                        <thead><tr style="background:#f1f3f5;"><th>STT</th><th>Mã MH</th><th>Tên mặt hàng</th><th>Hãng</th><th>Số lượng</th><th>Đơn giá</th><th>Thành tiền</th></tr></thead>
                        <tbody>{items_tr}</tbody>
                    </table>
                    <div style="background:#f8f9fa;padding:10px 20px;text-align:right;font-weight:bold;color:#d9534f;border-top:1px solid #dee2e6;">Tổng giá trị đơn hàng: {tong_dh:,.0f} đ</div>
                </div>'''.replace(',', '.')

            tong_fmt = f"{tong_tat_ca:,.0f} đ".replace(',', '.')
            html = f'''<!DOCTYPE html>
<html><head><meta charset="UTF-8"><title>Chi tiết giao dịch khách hàng</title>
<style>
body {{ font-family: Arial, sans-serif; margin: 20px; background-color: #f4f6f9; }}
.container {{ max-width: 1050px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}
h2 {{ color: #0056b3; text-align: center; }}
.kh-info {{ background: #e9ecef; padding: 15px 20px; border-radius: 6px; margin: 20px 0; }}
table th, table td {{ border: 1px solid #dee2e6; padding: 10px; text-align: center; font-size: 14px; }}
.btn-back {{ display: inline-block; padding: 10px 22px; background-color: #6c757d; color: white; text-decoration: none; border-radius: 4px; font-weight: bold; margin-top: 20px; }}
</style></head>
<body>
<div class="container">
    <h2>CHI TIẾT CÁC LẦN GIAO DỊCH CỦA KHÁCH HÀNG</h2>
    <div class="kh-info">
        <p><strong>Mã khách hàng:</strong> <span style="color:#0056b3;font-size:16px;font-weight:bold;">{maKH}</span> &nbsp;|&nbsp; <strong>Họ tên:</strong> <span style="font-weight:bold;">{hoTen}</span></p>
        <p><strong>Kỳ thống kê:</strong> Từ {ngayBD} đến {ngayKT}</p>
    </div>
    {cards_html if cards_html else "<p>Không có giao dịch nào.</p>"}
    <div style="background:#d4edda;border:1px solid #c3e6cb;color:#155724;padding:18px;border-radius:6px;font-size:18px;text-align:right;font-weight:bold;margin-top:20px;">
        Tổng số lần giao dịch: {trans_count} &nbsp;|&nbsp; TỔNG DOANH THU: {tong_fmt}
    </div>
    <div><a href="/view/nvquanli/gdTKKhachhang.jsp?ngayBD={ngayBD}&ngayKT={ngayKT}" class="btn-back">⬅ Quay lại danh sách thống kê</a></div>
</div></body></html>'''
            self.send_html(html)

    def do_POST(self):
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path
        length = int(self.headers.get('Content-Length', 0))
        post_data = self.rfile.read(length).decode('utf-8')
        form = urllib.parse.parse_qs(post_data)

        # Login POST
        if path.endswith('doDangnhap.jsp'):
            u = form.get('username', [''])[0]
            p = form.get('password', [''])[0]
            conn = sqlite3.connect(DB_FILE)
            c = conn.cursor()
            c.execute("SELECT id, tenDangnhap, hoTen, vaiTro FROM tblThanhvien WHERE tenDangnhap=? AND matKhau=?", (u, p))
            row = c.fetchone()
            conn.close()
            if row:
                if row[3] == 'nvquanli':
                    self.redirect('/view/nvquanli/gdChinhQL.jsp')
                elif row[3] == 'khachhang':
                    self.redirect('/view/khachhang/gdChinhKH.jsp')
                else:
                    self.redirect('/view/thanhvien/gdDangnhap.jsp')
            else:
                self.redirect('/view/thanhvien/gdDangnhap.jsp?error=' + urllib.parse.quote('Sai tên đăng nhập hoặc mật khẩu!'))

        # Register POST
        elif path.endswith('doDangki.jsp'):
            hoTen = form.get('hoTen', [''])[0]
            ngaySinh = form.get('ngaySinh', [''])[0]
            diaChi = form.get('diaChi', [''])[0]
            soDienthoai = form.get('soDienthoai', [''])[0]
            email = form.get('email', [''])[0]
            tenDangnhap = form.get('tenDangnhap', [''])[0]
            matKhau = form.get('matKhau', [''])[0]
            ghiChu = form.get('ghiChu', [''])[0]

            conn = sqlite3.connect(DB_FILE)
            c = conn.cursor()
            c.execute("SELECT COUNT(*) FROM tblThanhvien WHERE tenDangnhap=?", (tenDangnhap,))
            if c.fetchone()[0] > 0:
                conn.close()
                self.redirect(f'/view/khachhang/gdDangki.jsp?error=' + urllib.parse.quote(f"Tên đăng nhập '{tenDangnhap}' đã được sử dụng!"))
                return

            c.execute("INSERT INTO tblThanhvien (tenDangnhap, matKhau, hoTen, ngaySinh, diaChi, email, soDienthoai, vaiTro, ghiChu) VALUES (?, ?, ?, ?, ?, ?, ?, 'khachhang', ?)",
                      (tenDangnhap, matKhau, hoTen, ngaySinh, diaChi, email, soDienthoai, ghiChu))
            new_id = c.lastrowid
            new_makh = f"KH{new_id:03d}"
            c.execute("INSERT INTO tblKhachhang (tblThanhvienid, maKhachhang) VALUES (?, ?)", (new_id, new_makh))
            conn.commit()
            conn.close()

            html = f'''<!DOCTYPE html>
<html><head><meta charset="UTF-8"><title>Đăng ký thành công</title>
<style>
body {{ font-family: Arial, sans-serif; margin: 40px; background-color: #f4f6f9; text-align: center; }}
.box {{ max-width: 500px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}
.success {{ color: #28a745; }}
.btn {{ padding: 10px 25px; font-size: 16px; border-radius: 4px; text-decoration: none; color: white; background-color: #007bff; display: inline-block; font-weight: bold; }}
</style></head>
<body>
<div class="box">
    <h2 class="success">ĐĂNG KÝ THÀNH VIÊN THÀNH CÔNG!</h2>
    <div style="background-color: #e9ecef; padding: 15px; border-radius: 5px; margin: 20px 0; text-align: left;">
        <p><strong>Mã khách hàng:</strong> <span style="color:#28a745; font-size:18px; font-weight:bold;">{new_makh}</span></p>
        <p><strong>Họ và tên:</strong> {hoTen}</p>
        <p><strong>Tên đăng nhập:</strong> {tenDangnhap}</p>
        <p><strong>Số điện thoại:</strong> {soDienthoai}</p>
        <p><strong>Địa chỉ:</strong> {diaChi}</p>
    </div>
    <p>Quý khách có thể dùng tài khoản này để đăng nhập và mua sắm.</p>
    <a href="/view/khachhang/gdChinhKH.jsp" class="btn">OK (Về trang chủ)</a>
</div></body></html>'''
            self.send_html(html)

if __name__ == '__main__':
    server = HTTPServer(('127.0.0.1', PORT), QLSTHandler)
    print(f"Server running at http://localhost:{PORT}")
    sys.stdout.flush()
    server.serve_forever()
