package model;

import java.io.Serializable;
import java.util.Date;

/**
 * Lớp thực thể NVGiaohang đại diện cho bảng tblNVGiaohang
 * Không có tài khoản trong hệ thống nên không kế thừa Thanhvien.
 */
public class NVGiaohang implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String hoTen;
    private Date ngaySinh;
    private String diaChi;
    private String email;
    private String soDienthoai;
    private String viTri;
    private String ghiChu;

    public NVGiaohang() {
        super();
    }

    public NVGiaohang(int id, String hoTen, Date ngaySinh, String diaChi, String email, 
                      String soDienthoai, String viTri, String ghiChu) {
        this.id = id;
        this.hoTen = hoTen;
        this.ngaySinh = ngaySinh;
        this.diaChi = diaChi;
        this.email = email;
        this.soDienthoai = soDienthoai;
        this.viTri = viTri;
        this.ghiChu = ghiChu;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getHoTen() {
        return hoTen;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public Date getNgaySinh() {
        return ngaySinh;
    }

    public void setNgaySinh(Date ngaySinh) {
        this.ngaySinh = ngaySinh;
    }

    public String getDiaChi() {
        return diaChi;
    }

    public void setDiaChi(String diaChi) {
        this.diaChi = diaChi;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSoDienthoai() {
        return soDienthoai;
    }

    public void setSoDienthoai(String soDienthoai) {
        this.soDienthoai = soDienthoai;
    }

    public String getViTri() {
        return viTri;
    }

    public void setViTri(String viTri) {
        this.viTri = viTri;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }
}
