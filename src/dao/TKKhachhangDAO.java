package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import model.TKKhachhang;

/**
 * Lớp TKKhachhangDAO thực hiện nghiệp vụ thống kê khách hàng theo doanh thu
 * Module ViewCustomerRevenueStatistics8.
 */
public class TKKhachhangDAO extends DAO {

    public TKKhachhangDAO() {
        super();
    }

    /**
     * Lấy danh sách thống kê khách hàng theo doanh thu trong khoảng thời gian từ ngày ngayBD đến ngayKT
     * @param ngayBD ngày bắt đầu kỳ thống kê
     * @param ngayKT ngày kết thúc kỳ thống kê
     * @return danh sách các đối tượng TKKhachhang sắp xếp theo tổng doanh thu giảm dần
     */
    public ArrayList<TKKhachhang> getTKKhachhang(Date ngayBD, Date ngayKT) {
        ArrayList<TKKhachhang> result = new ArrayList<TKKhachhang>();
        if (ngayBD == null || ngayKT == null || ngayKT.before(ngayBD)) {
            return result;
        }

        String sql = "{call tkKhachhangTheoDoanhthu(?, ?)}";
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setDate(1, new java.sql.Date(ngayBD.getTime()));
            cs.setDate(2, new java.sql.Date(ngayKT.getTime()));
            ResultSet rs = cs.executeQuery();

            while (rs.next()) {
                TKKhachhang tk = new TKKhachhang();
                tk.setId(rs.getInt("tblThanhvienid"));
                tk.setMaKhachhang(rs.getString("maKhachhang"));
                tk.setHoTen(rs.getString("hoTen"));
                tk.setNgaySinh(rs.getDate("ngaySinh"));
                tk.setDiaChi(rs.getString("diaChi"));
                tk.setSoDienthoai(rs.getString("soDienthoai"));
                tk.setEmail(rs.getString("email"));
                tk.setTongSoGiaodich(rs.getInt("tongSoGiaodich"));
                tk.setTongDoanhthu(rs.getDouble("tongDoanhthu"));

                result.add(tk);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
}
