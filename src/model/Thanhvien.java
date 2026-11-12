package model;

import java.io.Serializable;
import java.util.Date;

/**
 * Lớp thực thể Thanhvien đại diện cho bảng tblThanhvien
 * Chứa thông tin đăng nhập và thông tin cá nhân của người dùng hệ thống.
 */
public class Thanhvien implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String tenDangnhap;
    private String matKhau;
    private String hoTen;
    private Date ngaySinh;
    private String diaChi;
    private String email;
    private String soDienthoai;
    private String vaiTro;
    private String ghiChu;

    public Thanhvien() {
        super();
    }

    public Thanhvien(int id, String tenDangnhap, String matKhau, String hoTen, Date ngaySinh, 
                     String diaChi, String email, String soDienthoai, String vaiTro, String ghiChu) {
        this.id = id;
        this.tenDangnhap = tenDangnhap;
        this.matKhau = matKhau;
        this.hoTen = hoTen;
        this.ngaySinh = ngaySinh;
        this.diaChi = diaChi;
        this.email = email;
        this.soDienthoai = soDienthoai;
        this.vaiTro = vaiTro;
        this.ghiChu = ghiChu;
    }

    public Thanhvien(String tenDangnhap, String matKhau, String hoTen, Date ngaySinh, 
                     String diaChi, String email, String soDienthoai, String vaiTro, String ghiChu) {
        this.tenDangnhap = tenDangnhap;
        this.matKhau = matKhau;
        this.hoTen = hoTen;
        this.ngaySinh = ngaySinh;
        this.diaChi = diaChi;
        this.email = email;
        this.soDienthoai = soDienthoai;
        this.vaiTro = vaiTro;
        this.ghiChu = ghiChu;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTenDangnhap() {
        return tenDangnhap;
    }

    public void setTenDangnhap(String tenDangnhap) {
        this.tenDangnhap = tenDangnhap;
    }

    public String getMatKhau() {
        return matKhau;
    }

    public void setMatKhau(String matKhau) {
        this.matKhau = matKhau;
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

    public String getVaiTro() {
        return vaiTro;
    }

    public void setVaiTro(String vaiTro) {
        this.vaiTro = vaiTro;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }
}
