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
    <title>Chọn loại báo cáo thống kê - Siêu thị Điện máy</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f6f9; }
        .container { max-width: 650px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { color: #0056b3; text-align: center; margin-bottom: 25px; border-bottom: 2px solid #0056b3; padding-bottom: 10px; }
        .report-list { display: flex; flex-direction: column; gap: 15px; margin: 25px 0; }
        .report-item {
            display: block; padding: 15px 20px; background-color: #f8f9fa; border: 1px solid #dee2e6;
            border-left: 5px solid #007bff; border-radius: 4px; text-decoration: none; color: #333;
            font-size: 16px; font-weight: bold; transition: all 0.2s ease;
        }
        .report-item:hover { background-color: #e3f2fd; border-left-color: #0056b3; transform: translateX(5px); }
        .report-featured { border-left-color: #28a745; background-color: #f4fff4; }
        .report-featured:hover { background-color: #e8f5e9; border-left-color: #1e7e34; }
        .btn-back { display: inline-block; padding: 10px 20px; background-color: #6c757d; color: white; text-decoration: none; border-radius: 4px; font-weight: bold; }
        .btn-back:hover { background-color: #5a6268; }
    </style>
</head>
<body>
<div class="container">
    <h2>CHỌN LOẠI BÁO CÁO THỐNG KÊ</h2>
    <p style="text-align: center; color: #666;">Vui lòng chọn loại báo cáo thống kê cần xem:</p>

    <div class="report-list">
        <a href="gdTKKhachhang.jsp" class="report-item report-featured">
            📊 Thống kê khách hàng theo doanh thu (Đang hoạt động)
        </a>
        <a href="#" class="report-item" onclick="alert('Chức năng Thống kê mặt hàng đang được nâng cấp.'); return false;">
            📦 Thống kê mặt hàng
        </a>
        <a href="#" class="report-item" onclick="alert('Chức năng Thống kê nhà cung cấp đang được nâng cấp.'); return false;">
            🏢 Thống kê nhà cung cấp
        </a>
        <a href="#" class="report-item" onclick="alert('Chức năng Thống kê doanh thu toàn siêu thị đang được nâng cấp.'); return false;">
            💰 Thống kê doanh thu chung
        </a>
    </div>

    <div style="text-align: center; margin-top: 25px;">
        <a href="gdChinhQL.jsp" class="btn-back">⬅ Quay lại Trang chủ</a>
    </div>
</div>
</body>
</html>
