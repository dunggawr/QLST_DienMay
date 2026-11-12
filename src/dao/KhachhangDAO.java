package dao;

import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;
import model.Khachhang;

/**
 * Lớp KhachhangDAO xử lý truy cập CSDL cho thực thể Khách hàng
 * Module Register8 (Đăng ký thành viên).
 */
public class KhachhangDAO extends DAO {

    public KhachhangDAO() {
        super();
    }

    /**
     * Kiểm tra tên đăng nhập đã tồn tại trong CSDL chưa
     * @param username tên đăng nhập cần kiểm tra
     * @return true nếu đã tồn tại (bị trùng), false nếu chưa có (hợp lệ)
     */
    public boolean kiemTraTrungTendangnhap(String username) {
        boolean isDuplicate = false;
        String sql = "{call kiemtraTrungTDN(?, ?)}";
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setString(1, username);
            cs.registerOutParameter(2, Types.INTEGER);
            cs.execute();
            int result = cs.getInt(2);
            if (result == 1) {
                isDuplicate = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isDuplicate;
    }

    /**
     * Lưu thông tin khách hàng mới vào CSDL và tự động cấp mã khách hàng
     * Có quản lý Transaction (commit/rollback) theo chuẩn kiểm thử và an toàn dữ liệu.
     * @param kh đối tượng Khachhang cần lưu
     * @return true nếu lưu thành công, false nếu thất bại
     */
    public boolean luuKhachhang(Khachhang kh) {
        boolean success = false;
        String sql = "{call luuKhachhang(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";
        try {
            con.setAutoCommit(false); // Bắt đầu transaction
            CallableStatement cs = con.prepareCall(sql);
            cs.setString(1, kh.getTenDangnhap());
            cs.setString(2, kh.getMatKhau());
            cs.setString(3, kh.getHoTen());
            cs.setDate(4, new java.sql.Date(kh.getNgaySinh().getTime()));
            cs.setString(5, kh.getDiaChi());
            cs.setString(6, kh.getEmail());
            cs.setString(7, kh.getSoDienthoai());
            cs.setString(8, kh.getGhiChu());
            
            // Đăng ký tham số đầu ra
            cs.registerOutParameter(9, Types.INTEGER); // p_new_id
            cs.registerOutParameter(10, Types.VARCHAR); // p_new_makh

            cs.execute();

            int newId = cs.getInt(9);
            String newMaKh = cs.getString(10);

            if (newId > 0 && newMaKh != null) {
                kh.setId(newId);
                kh.setMaKhachhang(newMaKh);
                con.commit(); // Hoàn tất transaction
                success = true;
            } else {
                con.rollback();
            }
        } catch (SQLException e) {
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            success = false;
        } finally {
            try {
                if (con != null) {
                    con.setAutoCommit(true);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return success;
    }
}
