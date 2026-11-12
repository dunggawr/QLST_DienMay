package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import model.Chitiethoadon;
import model.Hoadonbanhang;
import model.Khachhang;
import model.Mathang;

/**
 * Lớp HoadonbanhangDAO lấy danh sách hóa đơn mua tại quầy của khách hàng
 */
public class HoadonbanhangDAO extends DAO {

    public HoadonbanhangDAO() {
        super();
    }

    /**
     * Lấy danh sách hóa đơn bán tại quầy của một khách hàng trong khoảng ngày
     * @param kh đối tượng khách hàng
     * @param ngayBD ngày bắt đầu
     * @param ngayKT ngày kết thúc
     * @return danh sách các đối tượng Hoadonbanhang kèm chi tiết hóa đơn
     */
    public ArrayList<Hoadonbanhang> getHoadonCuaKH(Khachhang kh, Date ngayBD, Date ngayKT) {
        ArrayList<Hoadonbanhang> list = new ArrayList<Hoadonbanhang>();
        if (kh == null || ngayBD == null || ngayKT == null) {
            return list;
        }

        String sql = "{call dsHoadonCuaKH(?, ?, ?)}";
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setInt(1, kh.getId());
            cs.setDate(2, new java.sql.Date(ngayBD.getTime()));
            cs.setDate(3, new java.sql.Date(ngayKT.getTime()));
            ResultSet rs = cs.executeQuery();

            Map<Integer, Hoadonbanhang> mapHd = new HashMap<Integer, Hoadonbanhang>();

            while (rs.next()) {
                int hdId = rs.getInt("hoadonId");
                Hoadonbanhang hd = mapHd.get(hdId);
                if (hd == null) {
                    hd = new Hoadonbanhang();
                    hd.setId(hdId);
                    hd.setMaHoadon(rs.getString("maHoadon"));
                    hd.setNgayBan(rs.getDate("ngayBan"));
                    hd.setGhiChu(rs.getString("ghiChu"));
                    hd.setKhachhang(kh);
                    hd.setDsChitiethoadon(new ArrayList<Chitiethoadon>());

                    mapHd.put(hdId, hd);
                    list.add(hd);
                }

                // Đóng gói chi tiết hóa đơn
                Chitiethoadon ct = new Chitiethoadon();
                ct.setId(rs.getInt("cthdId"));
                ct.setSoLuongMua(rs.getInt("soLuongMua"));
                ct.setDonGia(rs.getDouble("donGia"));
                ct.setThanhTien(rs.getDouble("thanhTien"));

                Mathang mh = new Mathang();
                mh.setId(rs.getInt("mathangId"));
                mh.setMaMathang(rs.getString("maMathang"));
                mh.setTenMathang(rs.getString("tenMathang"));
                mh.setHangSanxuat(rs.getString("hangSanxuat"));
                mh.setGiaBan(rs.getDouble("giaBan"));

                ct.setMathang(mh);
                hd.getDsChitiethoadon().add(ct);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
