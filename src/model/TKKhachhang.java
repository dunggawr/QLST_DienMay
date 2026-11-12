package model;

import java.io.Serializable;
import java.util.Date;

/**
 * Lớp thực thể thống kê TKKhachhang kế thừa từ Khachhang
 * Đại diện cho kết quả báo cáo thống kê khách hàng theo doanh thu
 * Không có bảng vật lý trong CSDL (loại bỏ theo Bước 5 giáo trình).
 */
public class TKKhachhang extends Khachhang implements Serializable {
    private static final long serialVersionUID = 1L;

    private int tongSoGiaodich;
    private double tongDoanhthu;

    public TKKhachhang() {
        super();
    }

    public TKKhachhang(int id, String tenDangnhap, String matKhau, String hoTen, Date ngaySinh, 
                       String diaChi, String email, String soDienthoai, String ghiChu, 
                       String maKhachhang, int tongSoGiaodich, double tongDoanhthu) {
        super(id, tenDangnhap, matKhau, hoTen, ngaySinh, diaChi, email, soDienthoai, ghiChu, maKhachhang);
        this.tongSoGiaodich = tongSoGiaodich;
        this.tongDoanhthu = tongDoanhthu;
    }

    public int getTongSoGiaodich() {
        return tongSoGiaodich;
    }

    public void setTongSoGiaodich(int tongSoGiaodich) {
        this.tongSoGiaodich = tongSoGiaodich;
    }

    public double getTongDoanhthu() {
        return tongDoanhthu;
    }

    public void setTongDoanhthu(double tongDoanhthu) {
        this.tongDoanhthu = tongDoanhthu;
    }
}
