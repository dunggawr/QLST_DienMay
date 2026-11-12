<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="model.TKKhachhang" %>
<%@ page import="model.Thanhvien" %>
<%@ page import="dao.TKKhachhangDAO" %>

<%
    Thanhvien user = (Thanhvien) session.getAttribute("user");
    if (user == null || !"nvquanli".equalsIgnoreCase(user.getVaiTro())) {
        response.sendRedirect("../thanhvien/gdDangnhap.jsp");
        return;
    }

    request.setCharacterEncoding("UTF-8");
    String ngayBDStr = request.getParameter("ngayBD");
    String ngayKTStr = request.getParameter("ngayKT");

    SimpleDateFormat sdfInput = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat sdfDisplay = new SimpleDateFormat("dd/MM/yyyy");
    DecimalFormat df = new DecimalFormat("#,### đ");

    ArrayList<TKKhachhang> listTK = null;
    String errorMsg = null;
    boolean isSearched = false;

    if (ngayBDStr != null && ngayKTStr != null) {
        isSearched = true;
        // Kiểm tra chưa chọn đủ 2 ngày (Ngoại lệ 5b)
        if (ngayBDStr.trim().isEmpty() || ngayKTStr.trim().isEmpty()) {
            errorMsg = "Vui lòng chọn đầy đủ cả Ngày bắt đầu và Ngày kết thúc!";
        } else {
            try {
                Date ngayBD = sdfInput.parse(ngayBDStr);
                Date ngayKT = sdfInput.parse(ngayKTStr);

                // Kiểm tra ngày kết thúc trước ngày bắt đầu (Ngoại lệ 5a)
                if (ngayKT.before(ngayBD)) {
                    errorMsg = "Ngày kết thúc không được trước Ngày bắt đầu. Vui lòng chọn lại khoảng ngày!";
                } else {
                    // Lưu khoảng ngày vào session để tái sử dụng ở trang chi tiết giao dịch
                    session.setAttribute("ngayBD", ngayBD);
                    session.setAttribute("ngayKT", ngayKT);
                    session.setAttribute("ngayBDStr", ngayBDStr);
                    session.setAttribute("ngayKTStr", ngayKTStr);

                    TKKhachhangDAO dao = new TKKhachhangDAO();
                    listTK = dao.getTKKhachhang(ngayBD, ngayKT);
                }
            } catch (Exception e) {
                errorMsg = "Định dạng ngày tháng không hợp lệ!";
                e.printStackTrace();
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thống kê khách hàng theo doanh thu - Siêu thị Điện máy</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f6f9; }
        .container { max-width: 1000px; margin: auto; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { color: #0056b3; text-align: center; margin-bottom: 20px; }
        .filter-box { background: #e9ecef; padding: 20px; border-radius: 6px; margin-bottom: 25px; }
        .form-row { display: flex; gap: 20px; align-items: center; justify-content: center; flex-wrap: wrap; }
        .form-group { display: flex; align-items: center; gap: 10px; }
        label { font-weight: bold; color: #333; }
        input[type="date"] { padding: 8px 12px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; }
        .btn { padding: 9px 18px; border-radius: 4px; font-weight: bold; cursor: pointer; border: none; font-size: 14px; text-decoration: none; }
        .btn-submit { background-color: #007bff; color: white; }
        .btn-submit:hover { background-color: #0056b3; }
        .btn-back { background-color: #6c757d; color: white; }
        .btn-back:hover { background-color: #5a6268; }
        .alert-error { color: #721c24; background-color: #f8d7da; border: 1px solid #f5c6cb; padding: 12px; border-radius: 4px; margin-bottom: 20px; text-align: center; font-weight: bold; }
        .alert-empty { color: #856404; background-color: #fff3cd; border: 1px solid #ffeeba; padding: 15px; border-radius: 4px; text-align: center; font-weight: bold; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #dee2e6; padding: 12px 10px; text-align: center; font-size: 14px; }
        th { background-color: #007bff; color: white; }
        tr:nth-child(even) { background-color: #f8f9fa; }
        tr:hover { background-color: #e3f2fd; cursor: pointer; }
        .td-left { text-align: left; }
        .td-right { text-align: right; }
        .revenue { font-weight: bold; color: #d9534f; }
        .link-detail { color: #007bff; text-decoration: none; font-weight: bold; }
        .link-detail:hover { text-decoration: underline; color: #0056b3; }
    </style>
    <script>
        function validateDate() {
            var bd = document.getElementById("ngayBD").value;
            var kt = document.getElementById("ngayKT").value;
            if (!bd || !kt) {
                alert("Vui lòng chọn đầy đủ cả Ngày bắt đầu và Ngày kết thúc!");
                return false;
            }
            if (kt < bd) {
                alert("Lỗi: Ngày kết thúc không được trước Ngày bắt đầu!");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
<div class="container">
    <h2>THỐNG KÊ KHÁCH HÀNG THEO DOANH THU</h2>

    <div class="filter-box">
        <form action="gdTKKhachhang.jsp" method="GET" onsubmit="return validateDate();">
            <div class="form-row">
                <div class="form-group">
                    <label for="ngayBD">Từ ngày:</label>
                    <input type="date" id="ngayBD" name="ngayBD" value="<%= ngayBDStr != null ? ngayBDStr : "2026-10-01" %>" required>
                </div>
                <div class="form-group">
                    <label for="ngayKT">Đến ngày:</label>
                    <input type="date" id="ngayKT" name="ngayKT" value="<%= ngayKTStr != null ? ngayKTStr : "2026-10-31" %>" required>
                </div>
                <button type="submit" class="btn btn-submit">🔍 Xem thống kê</button>
                <a href="gdChonBaocao.jsp" class="btn btn-back">⬅ Quay lại</a>
            </div>
        </form>
    </div>

    <%-- Thông báo lỗi kiểm tra ngày --%>
    <% if (errorMsg != null) { %>
        <div class="alert-error"><%= errorMsg %></div>
    <% } %>

    <%-- Bảng kết quả thống kê --%>
    <% if (isSearched && errorMsg == null) { %>
        <% if (listTK == null || listTK.isEmpty()) { %>
            <%-- Ngoại lệ 6a: Không có dữ liệu --%>
            <div class="alert-empty">Không có dữ liệu thống kê trong khoảng thời gian này!</div>
        <% } else { %>
            <p><strong>Khoảng thời gian:</strong> từ <%= sdfDisplay.format((Date)session.getAttribute("ngayBD")) %> đến <%= sdfDisplay.format((Date)session.getAttribute("ngayKT")) %></p>
            <p style="font-size: 13px; color: #555;"><i>* Bấm vào tên hoặc mã khách hàng để xem chi tiết các lần giao dịch.</i></p>
            
            <table>
                <thead>
                    <tr>
                        <th style="width: 50px;">TT</th>
                        <th style="width: 100px;">Mã KH</th>
                        <th>Họ và tên</th>
                        <th style="width: 110px;">Ngày sinh</th>
                        <th style="width: 120px;">Điện thoại</th>
                        <th style="width: 130px;">Số lần giao dịch</th>
                        <th style="width: 160px;">Tổng doanh thu</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        int index = 1;
                        for (TKKhachhang tk : listTK) { 
                    %>
                    <tr onclick="window.location.href='gdChitietGiaodich.jsp?idKH=<%= tk.getId() %>&maKH=<%= tk.getMaKhachhang() %>&hoTen=<%= java.net.URLEncoder.encode(tk.getHoTen(), "UTF-8") %>';">
                        <td><%= index++ %></td>
                        <td><a class="link-detail" href="gdChitietGiaodich.jsp?idKH=<%= tk.getId() %>&maKH=<%= tk.getMaKhachhang() %>&hoTen=<%= java.net.URLEncoder.encode(tk.getHoTen(), "UTF-8") %>"><%= tk.getMaKhachhang() %></a></td>
                        <td class="td-left"><a class="link-detail" href="gdChitietGiaodich.jsp?idKH=<%= tk.getId() %>&maKH=<%= tk.getMaKhachhang() %>&hoTen=<%= java.net.URLEncoder.encode(tk.getHoTen(), "UTF-8") %>"><%= tk.getHoTen() %></a></td>
                        <td><%= tk.getNgaySinh() != null ? sdfDisplay.format(tk.getNgaySinh()) : "" %></td>
                        <td><%= tk.getSoDienthoai() != null ? tk.getSoDienthoai() : "" %></td>
                        <td><strong><%= tk.getTongSoGiaodich() %></strong></td>
                        <td class="td-right revenue"><%= df.format(tk.getTongDoanhthu()) %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    <% } %>
</div>
</body>
</html>
