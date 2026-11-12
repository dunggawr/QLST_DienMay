<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Mặc định chuyển hướng sang giao diện chính của Khách hàng
    response.sendRedirect(request.getContextPath() + "/view/khachhang/gdChinhKH.jsp");
%>