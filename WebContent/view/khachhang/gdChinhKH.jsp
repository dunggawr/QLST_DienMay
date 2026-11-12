<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Giao diện chính Khách hàng - Siêu thị Điện máy</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f6f9; }
        .container { max-width: 800px; margin: auto; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        h2 { color: #0056b3; border-bottom: 2px solid #0056b3; padding-bottom: 10px; }
        .menu-bar { display: flex; gap: 15px; margin: 20px 0; }
        .btn { padding: 10px 18px; text-decoration: none; color: white; background-color: #007bff; border-radius: 4px; font-weight: bold; }
        .btn:hover { background-color: #0056b3; }
        .btn-register { background-color: #28a745; }
        .btn-register:hover { background-color: #218838; }
        .welcome-box { background: #e9ecef; padding: 15px; border-radius: 5px; margin-top: 15px; }
    </style>
</head>
<body>
<div class="container">
    <h2>HỆ THỐNG SIÊU THỊ ĐIỆN MÁY</h2>
    <p>Chào mừng quý khách đến với siêu thị điện máy!</p>

    <div class="menu-bar">
        <a href="gdChinhKH.jsp" class="btn">Trang chủ</a>
        <a href="gdDangki.jsp" class="btn btn-register">Đăng ký thành viên</a>
        <a href="../thanhvien/gdDangnhap.jsp" class="btn" style="background-color: #17a2b8;">Đăng nhập</a>
    </div>

    <div class="welcome-box">
        <h3>Các tính năng dành cho khách hàng:</h3>
        <ul>
            <li><strong>Đăng ký thành viên:</strong> Tạo tài khoản thành viên để được tích điểm và đặt mua trực tuyến.</li>
            <li><strong>Tìm kiếm mặt hàng:</strong> Tra cứu nhanh chóng các thiết bị điện máy chính hãng.</li>
            <li><strong>Đặt hàng trực tuyến:</strong> Đặt mua giao hàng tận nhà nhanh chóng, an toàn.</li>
            <li><strong>Mua hàng tại quầy:</strong> Phục vụ trực tiếp tại các chi nhánh siêu thị.</li>
        </ul>
    </div>
</div>
</body>
</html>
