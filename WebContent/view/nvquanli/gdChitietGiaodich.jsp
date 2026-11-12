<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="model.Khachhang" %>
<%@ page import="model.Hoadonbanhang" %>
<%@ page import="model.Chitiethoadon" %>
<%@ page import="model.Dondathang" %>
<%@ page import="model.Chitietdondathang" %>
<%@ page import="model.Thanhvien" %>
<%@ page import="dao.HoadonbanhangDAO" %>
<%@ page import="dao.DondathangDAO" %>

<%
    Thanhvien user = (Thanhvien) session.getAttribute("user");
    if (user == null || !"nvquanli".equalsIgnoreCase(user.getVaiTro())) {
        response.sendRedirect("../thanhvien/gdDangnhap.jsp");
        return;
    }

    request.setCharacterEncoding("UTF-8");
    String idKHStr = request.getParameter("idKH");
    String maKH = request.getParameter("maKH");
    String hoTen = request.getParameter("hoTen");

    Date ngayBD = (Date) session.getAttribute("ngayBD");
    Date ngayKT = (Date) session.getAttribute("ngayKT");
    String ngayBDStr = (String) session.getAttribute("ngayBDStr");
    String ngayKTStr = (String) session.getAttribute("ngayKTStr");

    if (idKHStr == null || ngayBD == null || ngayKT == null) {
        response.sendRedirect("gdTKKhachhang.jsp");
        return;
    }

    int idKH = Integer.parseInt(idKHStr);
    Khachhang kh = new Khachhang();
    kh.setId(idKH);
    kh.setMaKhachhang(maKH);
    kh.setHoTen(hoTen);

    HoadonbanhangDAO hdDAO = new HoadonbanhangDAO();
    DondathangDAO dhDAO = new DondathangDAO();

    // Lấy danh sách hóa đơn mua tại quầy
    ArrayList<Hoadonbanhang> dsHoadon = hdDAO.getHoadonCuaKH(kh, ngayBD, ngayKT);

    // Lấy danh sách đơn hàng trực tuyến đã xuất
    ArrayList<Dondathang> dsDonhang = dhDAO.getDonhangCuaKH(kh, ngayBD, ngayKT);

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    DecimalFormat df = new DecimalFormat("#,### đ");

    double tongTatCaDoanhThu = 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết giao dịch khách hàng - Siêu thị Điện máy</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f6f9; }
        .container { max-width: 1050px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { color: #0056b3; text-align: center; margin-bottom: 10px; }
        .kh-info { background: #e9ecef; padding: 15px 20px; border-radius: 6px; margin: 20px 0; font-size: 15px; }
        .kh-info p { margin: 6px 0; }
        .trans-card { border: 1px solid #ced4da; border-radius: 6px; margin-bottom: 25px; overflow: hidden; background: white; box-shadow: 0 1px 4px rgba(0,0,0,0.05); }
        .trans-header { background-color: #007bff; color: white; padding: 12px 20px; font-weight: bold; display: flex; justify-content: space-between; font-size: 15px; }
        .badge-type { background: #ffc107; color: #212529; padding: 3px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; }
        .badge-online { background: #28a745; color: white; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #e9ecef; padding: 10px 12px; font-size: 14px; text-align: center; }
        th { background-color: #f1f3f5; color: #495057; }
        .td-left { text-align: left; }
        .td-right { text-align: right; }
        .trans-footer { background-color: #f8f9fa; padding: 12px 20px; text-align: right; font-size: 16px; font-weight: bold; border-top: 1px solid #dee2e6; color: #d9534f; }
        .total-box { background: #d4edda; border: 1px solid #c3e6cb; color: #155724; padding: 18px; border-radius: 6px; font-size: 18px; text-align: right; margin-top: 25px; font-weight: bold; }
        .btn-back { display: inline-block; padding: 10px 22px; background-color: #6c757d; color: white; text-decoration: none; border-radius: 4px; font-weight: bold; margin-top: 20px; font-size: 15px; }
        .btn-back:hover { background-color: #5a6268; }
    </style>
</head>
<body>
<div class="container">
    <h2>CHI TIẾT CÁC LẦN GIAO DỊCH CỦA KHÁCH HÀNG</h2>

    <div class="kh-info">
        <p><strong>Mã khách hàng:</strong> <span style="color:#0056b3; font-size:16px; font-weight:bold;"><%= maKH %></span></p>
        <p><strong>Họ và tên khách hàng:</strong> <span style="font-size:16px; font-weight:bold;"><%= hoTen != null ? hoTen : "" %></span></p>
        <p><strong>Khoảng thời gian thống kê:</strong> Từ <strong><%= sdf.format(ngayBD) %></strong> đến <strong><%= sdf.format(ngayKT) %></strong></p>
    </div>

    <% 
        int transCount = 0;
        
        // 1. Hiển thị các Hóa đơn bán hàng tại quầy
        if (dsHoadon != null && !dsHoadon.isEmpty()) {
            for (Hoadonbanhang hd : dsHoadon) {
                transCount++;
                double tongHd = hd.getTongTien();
                tongTatCaDoanhThu += tongHd;
    %>
        <div class="trans-card">
            <div class="trans-header">
                <div>
                    Giao dịch #<%= transCount %>: <strong>Hóa đơn <%= hd.getMaHoadon() %></strong>
                    <span class="badge-type">Mua trực tiếp tại quầy</span>
                </div>
                <div>Ngày giao dịch: <%= sdf.format(hd.getNgayBan()) %></div>
            </div>
            <table>
                <thead>
                    <tr>
                        <th style="width: 40px;">STT</th>
                        <th style="width: 100px;">Mã mặt hàng</th>
                        <th>Tên mặt hàng</th>
                        <th style="width: 120px;">Hãng sản xuất</th>
                        <th style="width: 80px;">Số lượng</th>
                        <th style="width: 130px;">Đơn giá</th>
                        <th style="width: 150px;">Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        int itemIdx = 1;
                        for (Chitiethoadon ct : hd.getDsChitiethoadon()) { 
                    %>
                    <tr>
                        <td><%= itemIdx++ %></td>
                        <td><%= ct.getMathang().getMaMathang() %></td>
                        <td class="td-left"><%= ct.getMathang().getTenMathang() %></td>
                        <td><%= ct.getMathang().getHangSanxuat() %></td>
                        <td><%= ct.getSoLuongMua() %></td>
                        <td class="td-right"><%= df.format(ct.getDonGia()) %></td>
                        <td class="td-right"><strong><%= df.format(ct.getThanhTien()) %></strong></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <div class="trans-footer">
                Tổng giá trị hóa đơn: <%= df.format(tongHd) %>
            </div>
        </div>
    <% 
            }
        } 
    %>

    <% 
        // 2. Hiển thị các Đơn đặt hàng trực tuyến ĐÃ XUẤT
        if (dsDonhang != null && !dsDonhang.isEmpty()) {
            for (Dondathang dh : dsDonhang) {
                transCount++;
                double tongDh = dh.getTongTien();
                tongTatCaDoanhThu += tongDh;
    %>
        <div class="trans-card">
            <div class="trans-header" style="background-color: #20c997;">
                <div>
                    Giao dịch #<%= transCount %>: <strong>Đơn đặt hàng <%= dh.getMaDonhang() %></strong>
                    <span class="badge-type badge-online">Đặt hàng trực tuyến</span>
                </div>
                <div>Ngày xuất kho: <%= dh.getNgayXuat() != null ? sdf.format(dh.getNgayXuat()) : "" %></div>
            </div>
            <table>
                <thead>
                    <tr>
                        <th style="width: 40px;">STT</th>
                        <th style="width: 100px;">Mã mặt hàng</th>
                        <th>Tên mặt hàng</th>
                        <th style="width: 120px;">Hãng sản xuất</th>
                        <th style="width: 80px;">Số lượng</th>
                        <th style="width: 130px;">Đơn giá</th>
                        <th style="width: 150px;">Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        int itemIdx = 1;
                        for (Chitietdondathang ct : dh.getDsChitietdondathang()) { 
                    %>
                    <tr>
                        <td><%= itemIdx++ %></td>
                        <td><%= ct.getMathang().getMaMathang() %></td>
                        <td class="td-left"><%= ct.getMathang().getTenMathang() %></td>
                        <td><%= ct.getMathang().getHangSanxuat() %></td>
                        <td><%= ct.getSoLuongDat() %></td>
                        <td class="td-right"><%= df.format(ct.getDonGia()) %></td>
                        <td class="td-right"><strong><%= df.format(ct.getThanhTien()) %></strong></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <div class="trans-footer">
                Tổng giá trị đơn hàng: <%= df.format(tongDh) %>
            </div>
        </div>
    <% 
            }
        } 
    %>

    <% if (transCount == 0) { %>
        <p style="text-align: center; color: #888;">Khách hàng này không có giao dịch nào trong khoảng thời gian đã chọn.</p>
    <% } %>

    <div class="total-box">
        Tổng số lần giao dịch: <%= transCount %> &nbsp;|&nbsp; 
        TỔNG DOANH THU CỦA KHÁCH HÀNG: <%= df.format(tongTatCaDoanhThu) %>
    </div>

    <div>
        <a href="gdTKKhachhang.jsp?ngayBD=<%= ngayBDStr %>&ngayKT=<%= ngayKTStr %>" class="btn-back">⬅ Quay lại danh sách thống kê</a>
    </div>
</div>
</body>
</html>
