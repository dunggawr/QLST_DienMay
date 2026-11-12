package model;

import java.io.Serializable;
import java.util.Date;

/**
 * Lớp thực thể Nhanvien kế thừa từ Thanhvien
 * Đại diện cho bảng tblNhanvien.
 */
public class Nhanvien extends Thanhvien implements Serializable {
    private static final long serialVersionUID = 1L;

    private String viTri;

    public Nhanvien() {
        super();
    }

    public Nhanvien(int id, String tenDangnhap, String matKhau, String hoTen, Date ngaySinh, 
                    String diaChi, String email, String soDienthoai, String vaiTro, String ghiChu, String viTri) {
        super(id, tenDangnhap, matKhau, hoTen, ngaySinh, diaChi, email, soDienthoai, vaiTro, ghiChu);
        this.viTri = viTri;
    }

    public String getViTri() {
        return viTri;
    }

    public void setViTri(String viTri) {
        this.viTri = viTri;
    }
}
