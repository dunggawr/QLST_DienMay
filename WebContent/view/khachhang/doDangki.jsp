<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Khachhang" %>
<%@ page import="dao.KhachhangDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    request.setCharacterEncoding("UTF-8");

    String hoTen = request.getParameter("hoTen");
    String ngaySinhStr = request.getParameter("ngaySinh");
    String diaChi = request.getParameter("diaChi");
    String soDienthoai = request.getParameter("soDienthoai");
    String email = request.getParameter("email");
    String tenDangnhap = request.getParameter("tenDangnhap");
    String matKhau = request.getParameter("matKhau");
    String ghiChu = request.getParameter("ghiChu");

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date ngaySinh = null;
    try {
        if (ngaySinhStr != null && !ngaySinhStr.isEmpty()) {
            ngaySinh = sdf.parse(ngaySinhStr);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Đóng gói thông tin thực thể Khachhang
    Khachhang kh = new Khachhang();
    kh.setHoTen(hoTen);
    kh.setNgaySinh(ngaySinh);
    kh.setDiaChi(diaChi);
    kh.setSoDienthoai(soDienthoai);
    kh.setEmail(email);
    kh.setTenDangnhap(tenDangnhap);
    kh.setMatKhau(matKhau);
    kh.setGhiChu(ghiChu);

    KhachhangDAO khDAO = new KhachhangDAO();

    // 1. Kiểm tra trùng tên đăng nhập (Ngoại lệ 4b)
    boolean isTrung = khDAO.kiemTraTrungTendangnhap(tenDangnhap);
    if (isTrung) {
        request.setAttribute("errorMsg", "Tên đăng nhập '" + tenDangnhap + "' đã được sử dụng. Vui lòng chọn tên đăng nhập khác!");
        request.getRequestDispatcher("gdDangki.jsp").forward(request, response);
        return;
    }

    // 2. Lưu khách hàng vào CSDL và cấp mã khách hàng
    boolean success = khDAO.luuKhachhang(kh);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kết quả Đăng ký - Siêu thị Điện máy</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f4f6f9; text-align: center; }
        .box { max-width: 500px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .success { color: #28a745; }
        .error { color: #dc3545; }
        .info { background-color: #e9ecef; padding: 15px; border-radius: 5px; margin: 20px 0; text-align: left; }
        .btn { padding: 10px 25px; font-size: 16px; border-radius: 4px; text-decoration: none; color: white; background-color: #007bff; display: inline-block; font-weight: bold; }
        .btn:hover { background-color: #0056b3; }
    </style>
</head>
<body>
<div class="box">
    <% if (success) { %>
        <h2 class="success">ĐĂNG KÝ THÀNH VIÊN THÀNH CÔNG!</h2>
        <div class="info">
            <p><strong>Mã khách hàng:</strong> <span style="color:#28a745; font-size:18px; font-weight:bold;"><%= kh.getMaKhachhang() %></span></p>
            <p><strong>Họ và tên:</strong> <%= kh.getHoTen() %></p>
            <p><strong>Tên đăng nhập:</strong> <%= kh.getTenDangnhap() %></p>
            <p><strong>Số điện thoại:</strong> <%= kh.getSoDienthoai() %></p>
            <p><strong>Địa chỉ:</strong> <%= kh.getDiaChi() %></p>
        </div>
        <p>Quý khách có thể dùng tài khoản này để đăng nhập và đặt mua hàng trực tuyến.</p>
        <a href="gdChinhKH.jsp" class="btn">OK (Về trang chủ)</a>
    <% } else { %>
        <h2 class="error">ĐĂNG KÝ THẤT BẠI!</h2>
        <p>Đã xảy ra lỗi trong quá trình lưu dữ liệu vào hệ thống. Vui lòng thử lại sau.</p>
        <a href="gdDangki.jsp" class="btn" style="background-color: #dc3545;">Quay lại đăng ký</a>
    <% } %>
</div>
</body>
</html>
