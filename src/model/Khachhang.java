package model;

import java.io.Serializable;
import java.util.Date;

/**
 * Lớp thực thể Khachhang kế thừa từ Thanhvien
 * Đại diện cho bảng tblKhachhang (dùng tblThanhvienid làm khóa chính & ngoại).
 */
public class Khachhang extends Thanhvien implements Serializable {
    private static final long serialVersionUID = 1L;

    private String maKhachhang;

    public Khachhang() {
        super();
        this.setVaiTro("khachhang");
    }

    public Khachhang(String maKhachhang) {
        super();
        this.maKhachhang = maKhachhang;
        this.setVaiTro("khachhang");
    }

    public Khachhang(int id, String tenDangnhap, String matKhau, String hoTen, Date ngaySinh, 
                     String diaChi, String email, String soDienthoai, String ghiChu, String maKhachhang) {
        super(id, tenDangnhap, matKhau, hoTen, ngaySinh, diaChi, email, soDienthoai, "khachhang", ghiChu);
        this.maKhachhang = maKhachhang;
    }

    public Khachhang(String tenDangnhap, String matKhau, String hoTen, Date ngaySinh, 
                     String diaChi, String email, String soDienthoai, String ghiChu) {
        super(tenDangnhap, matKhau, hoTen, ngaySinh, diaChi, email, soDienthoai, "khachhang", ghiChu);
    }

    public String getMaKhachhang() {
        return maKhachhang;
    }

    public void setMaKhachhang(String maKhachhang) {
        this.maKhachhang = maKhachhang;
    }
}
