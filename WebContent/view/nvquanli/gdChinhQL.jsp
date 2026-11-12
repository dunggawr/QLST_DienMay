<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Thanhvien" %>
<%
    Thanhvien user = (Thanhvien) session.getAttribute("user");
    if (user == null || !"nvquanli".equalsIgnoreCase(user.getVaiTro())) {
        response.sendRedirect("../thanhvien/gdDangnhap.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang chủ Quản lý - Siêu thị Điện máy</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f6f9; }
        .container { max-width: 850px; margin: auto; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #0056b3; padding-bottom: 10px; }
        h2 { color: #0056b3; margin: 0; }
        .user-info { font-size: 14px; color: #555; }
        .menu-bar { display: flex; gap: 15px; margin: 25px 0; }
        .btn { padding: 12px 20px; text-decoration: none; color: white; background-color: #007bff; border-radius: 4px; font-weight: bold; }
        .btn:hover { background-color: #0056b3; }
        .btn-report { background-color: #28a745; }
        .btn-report:hover { background-color: #218838; }
        .btn-logout { background-color: #dc3545; }
        .btn-logout:hover { background-color: #c82333; }
        .content-box { background: #e9ecef; padding: 20px; border-radius: 5px; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>BÀN LÀM VIỆC NHÂN VIÊN QUẢN LÝ</h2>
        <div class="user-info">
            Xin chào, <strong><%= user.getHoTen() %></strong> (<%= user.getVaiTro() %>) |
            <a href="../thanhvien/gdDangnhap.jsp" style="color: #dc3545; text-decoration: none;">Đăng xuất</a>
        </div>
    </div>

    <div class="menu-bar">
        <a href="gdChinhQL.jsp" class="btn">Trang chủ</a>
        <a href="gdChonBaocao.jsp" class="btn btn-report">Xem báo cáo thống kê</a>
    </div>

    <div class="content-box">
        <h3>Chức năng của Nhân viên Quản lý:</h3>
        <p>Hệ thống hỗ trợ nhân viên quản lý theo dõi, phân tích tình hình kinh doanh của toàn bộ siêu thị thông qua các báo cáo:</p>
        <ul>
            <li><strong>Thống kê khách hàng theo doanh thu:</strong> Xem danh sách khách hàng mang lại doanh thu cao nhất và chi tiết từng lần giao dịch.</li>
            <li><strong>Thống kê doanh thu:</strong> Báo cáo tổng hợp doanh thu bán lẻ tại quầy và bán hàng trực tuyến.</li>
            <li><strong>Thống kê mặt hàng:</strong> Theo dõi các mặt hàng bán chạy, tồn kho.</li>
            <li><strong>Thống kê nhà cung cấp:</strong> Đánh giá khối lượng và giá trị hàng hóa nhập từ các đối tác.</li>
        </ul>
    </div>
</div>
</body>
</html>
