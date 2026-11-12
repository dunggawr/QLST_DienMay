<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="dao.DAO" %>
<%@ page import="model.Thanhvien" %>

<%
    request.setCharacterEncoding("UTF-8");
    String u = request.getParameter("username");
    String p = request.getParameter("password");

    DAO dao = new DAO();
    String sql = "SELECT * FROM tblThanhvien WHERE tenDangnhap = ? AND matKhau = ?";
    Thanhvien tv = null;
    try {
        PreparedStatement ps = DAO.con.prepareStatement(sql);
        ps.setString(1, u);
        ps.setString(2, p);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            tv = new Thanhvien();
            tv.setId(rs.getInt("id"));
            tv.setTenDangnhap(rs.getString("tenDangnhap"));
            tv.setHoTen(rs.getString("hoTen"));
            tv.setVaiTro(rs.getString("vaiTro"));
            session.setAttribute("user", tv);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (tv != null) {
        if ("nvquanli".equalsIgnoreCase(tv.getVaiTro())) {
            response.sendRedirect("../nvquanli/gdChinhQL.jsp");
        } else if ("khachhang".equalsIgnoreCase(tv.getVaiTro())) {
            response.sendRedirect("../khachhang/gdChinhKH.jsp");
        } else {
            response.sendRedirect("gdDangnhap.jsp");
        }
    } else {
        request.setAttribute("errorMsg", "Sai tên đăng nhập hoặc mật khẩu!");
        request.getRequestDispatcher("gdDangnhap.jsp").forward(request, response);
    }
%>
