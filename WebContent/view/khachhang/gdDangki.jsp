<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng ký thành viên - Siêu thị Điện máy</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f6f9; }
        .container { max-width: 600px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { color: #28a745; text-align: center; margin-bottom: 25px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; color: #333; }
        input[type="text"], input[type="password"], input[type="date"], input[type="email"] {
            width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; font-size: 14px;
        }
        .btn-group { display: flex; justify-content: space-between; margin-top: 25px; }
        .btn { padding: 10px 20px; font-size: 15px; border-radius: 4px; cursor: pointer; border: none; font-weight: bold; }
        .btn-submit { background-color: #28a745; color: white; }
        .btn-submit:hover { background-color: #218838; }
        .btn-back { background-color: #6c757d; color: white; text-decoration: none; display: inline-block; text-align: center; line-height: 20px; }
        .btn-back:hover { background-color: #5a6268; }
        .error-msg { color: #dc3545; background-color: #f8d7da; padding: 10px; border-radius: 4px; margin-bottom: 15px; }
        .required { color: red; }
    </style>
    <script>
        function validateForm() {
            var hoTen = document.getElementById("hoTen").value.trim();
            var ngaySinh = document.getElementById("ngaySinh").value;
            var diaChi = document.getElementById("diaChi").value.trim();
            var soDienthoai = document.getElementById("soDienthoai").value.trim();
            var email = document.getElementById("email").value.trim();
            var tenDangnhap = document.getElementById("tenDangnhap").value.trim();
            var matKhau = document.getElementById("matKhau").value;
            var xacNhanMatKhau = document.getElementById("xacNhanMatKhau").value;

            // Kiểm tra thiếu thông tin bắt buộc (Ngoại lệ 4a)
            if (hoTen === "" || ngaySinh === "" || diaChi === "" || soDienthoai === "" || tenDangnhap === "" || matKhau === "") {
                alert("Vui lòng nhập đầy đủ các trường thông tin bắt buộc (*).");
                return false;
            }

            // Kiểm tra số điện thoại (chỉ chứa chữ số)
            var phoneRegex = /^[0-9]{9,11}$/;
            if (!phoneRegex.test(soDienthoai)) {
                alert("Số điện thoại không hợp lệ (phải là dãy số từ 9 đến 11 chữ số).");
                return false;
            }

            // Kiểm tra định dạng email nếu có nhập
            if (email !== "") {
                var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    alert("Địa chỉ email không đúng định dạng (ví dụ: ten@email.com).");
                    return false;
                }
            }

            // Kiểm tra mật khẩu khớp xác nhận mật khẩu
            if (matKhau !== xacNhanMatKhau) {
                alert("Mật khẩu và xác nhận mật khẩu không trùng khớp.");
                return false;
            }

            return true;
        }
    </script>
</head>
<body>
<div class="container">
    <h2>ĐĂNG KÝ THÀNH VIÊN KHÁCH HÀNG</h2>

    <%-- Hiển thị thông báo lỗi nếu có trả về từ doDangki.jsp --%>
    <%
        String errorMsg = (String) request.getAttribute("errorMsg");
        if (errorMsg != null && !errorMsg.isEmpty()) {
    %>
        <div class="error-msg"><%= errorMsg %></div>
    <%
        }
        // Giữ lại các giá trị đã nhập khi xảy ra ngoại lệ
        String hoTenVal = request.getParameter("hoTen") != null ? request.getParameter("hoTen") : "";
        String ngaySinhVal = request.getParameter("ngaySinh") != null ? request.getParameter("ngaySinh") : "";
        String diaChiVal = request.getParameter("diaChi") != null ? request.getParameter("diaChi") : "";
        String soDienthoaiVal = request.getParameter("soDienthoai") != null ? request.getParameter("soDienthoai") : "";
        String emailVal = request.getParameter("email") != null ? request.getParameter("email") : "";
        String tenDangnhapVal = request.getParameter("tenDangnhap") != null ? request.getParameter("tenDangnhap") : "";
        String ghiChuVal = request.getParameter("ghiChu") != null ? request.getParameter("ghiChu") : "";
    %>

    <form action="doDangki.jsp" method="POST" onsubmit="return validateForm();">
        <div class="form-group">
            <label for="hoTen">Họ và tên <span class="required">*</span>:</label>
            <input type="text" id="hoTen" name="hoTen" value="<%= hoTenVal %>" placeholder="Ví dụ: Nguyễn Văn An" required>
        </div>

        <div class="form-group">
            <label for="ngaySinh">Ngày sinh <span class="required">*</span>:</label>
            <input type="date" id="ngaySinh" name="ngaySinh" value="<%= ngaySinhVal %>" required>
        </div>

        <div class="form-group">
            <label for="diaChi">Địa chỉ <span class="required">*</span>:</label>
            <input type="text" id="diaChi" name="diaChi" value="<%= diaChiVal %>" placeholder="Ví dụ: 12 Phố Huế, Hai Bà Trưng, Hà Nội" required>
        </div>

        <div class="form-group">
            <label for="soDienthoai">Số điện thoại <span class="required">*</span>:</label>
            <input type="text" id="soDienthoai" name="soDienthoai" value="<%= soDienthoaiVal %>" placeholder="Ví dụ: 0912345678" required>
        </div>

        <div class="form-group">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" value="<%= emailVal %>" placeholder="Ví dụ: an.nguyen@email.com">
        </div>

        <div class="form-group">
            <label for="tenDangnhap">Tên đăng nhập <span class="required">*</span>:</label>
            <input type="text" id="tenDangnhap" name="tenDangnhap" value="<%= tenDangnhapVal %>" placeholder="Ví dụ: annv90" required>
        </div>

        <div class="form-group">
            <label for="matKhau">Mật khẩu <span class="required">*</span>:</label>
            <input type="password" id="matKhau" name="matKhau" placeholder="Nhập mật khẩu" required>
        </div>

        <div class="form-group">
            <label for="xacNhanMatKhau">Xác nhận mật khẩu <span class="required">*</span>:</label>
            <input type="password" id="xacNhanMatKhau" name="xacNhanMatKhau" placeholder="Nhập lại mật khẩu" required>
        </div>

        <div class="form-group">
            <label for="ghiChu">Ghi chú:</label>
            <input type="text" id="ghiChu" name="ghiChu" value="<%= ghiChuVal %>" placeholder="Thông tin bổ sung (nếu có)">
        </div>

        <div class="btn-group">
            <a href="gdChinhKH.jsp" class="btn btn-back">Quay lại</a>
            <button type="submit" class="btn btn-submit">Đăng ký thành viên</button>
        </div>
    </form>
</div>
</body>
</html>
