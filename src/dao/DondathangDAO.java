package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import model.Chitietdondathang;
import model.Dondathang;
import model.Khachhang;
import model.Mathang;

/**
 * Lớp DondathangDAO lấy danh sách đơn đặt hàng trực tuyến ĐÃ XUẤT của khách hàng
 */
public class DondathangDAO extends DAO {

    public DondathangDAO() {
        super();
    }

    /**
     * Lấy danh sách các đơn đặt hàng trực tuyến đã xuất của một khách hàng trong khoảng ngày
     * @param kh đối tượng khách hàng
     * @param ngayBD ngày bắt đầu
     * @param ngayKT ngày kết thúc
     * @return danh sách các đối tượng Dondathang kèm chi tiết đơn hàng
     */
    public ArrayList<Dondathang> getDonhangCuaKH(Khachhang kh, Date ngayBD, Date ngayKT) {
        ArrayList<Dondathang> list = new ArrayList<Dondathang>();
        if (kh == null || ngayBD == null || ngayKT == null) {
            return list;
        }

        String sql = "{call dsDonhangCuaKH(?, ?, ?)}";
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setInt(1, kh.getId());
            cs.setDate(2, new java.sql.Date(ngayBD.getTime()));
            cs.setDate(3, new java.sql.Date(ngayKT.getTime()));
            ResultSet rs = cs.executeQuery();

            Map<Integer, Dondathang> mapDh = new HashMap<Integer, Dondathang>();

            while (rs.next()) {
                int dhId = rs.getInt("donhangId");
                Dondathang dh = mapDh.get(dhId);
                if (dh == null) {
                    dh = new Dondathang();
                    dh.setId(dhId);
                    dh.setMaDonhang(rs.getString("maDonhang"));
                    dh.setNgayDat(rs.getDate("ngayDat"));
                    dh.setDiaChiNhan(rs.getString("diaChiNhan"));
                    dh.setTrangThai(rs.getString("trangThai"));
                    dh.setNgayXuat(rs.getDate("ngayXuat"));
                    dh.setKhachhang(kh);
                    dh.setDsChitietdondathang(new ArrayList<Chitietdondathang>());

                    mapDh.put(dhId, dh);
                    list.add(dh);
                }

                // Đóng gói chi tiết đơn đặt hàng
                Chitietdondathang ct = new Chitietdondathang();
                ct.setId(rs.getInt("ctdhId"));
                ct.setSoLuongDat(rs.getInt("soLuongDat"));
                ct.setDonGia(rs.getDouble("donGia"));
                ct.setThanhTien(rs.getDouble("thanhTien"));

                Mathang mh = new Mathang();
                mh.setId(rs.getInt("mathangId"));
                mh.setMaMathang(rs.getString("maMathang"));
                mh.setTenMathang(rs.getString("tenMathang"));
                mh.setHangSanxuat(rs.getString("hangSanxuat"));
                mh.setGiaBan(rs.getDouble("giaBan"));

                ct.setMathang(mh);
                dh.getDsChitietdondathang().add(ct);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
