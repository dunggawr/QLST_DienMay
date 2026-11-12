package model;

import java.io.Serializable;

/**
 * Lớp thực thể Nhacungcap đại diện cho bảng tblNhacungcap
 */
public class Nhacungcap implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String ten;
    private String diaChi;
    private String soDienthoai;
    private String email;
    private String moTa;

    public Nhacungcap() {
        super();
    }

    public Nhacungcap(int id, String ten, String diaChi, String soDienthoai, String email, String moTa) {
        this.id = id;
        this.ten = ten;
        this.diaChi = diaChi;
        this.soDienthoai = soDienthoai;
        this.email = email;
        this.moTa = moTa;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTen() {
        return ten;
    }

    public void setTen(String ten) {
        this.ten = ten;
    }

    public String getDiaChi() {
        return diaChi;
    }

    public void setDiaChi(String diaChi) {
        this.diaChi = diaChi;
    }

    public String getSoDienthoai() {
        return soDienthoai;
    }

    public void setSoDienthoai(String soDienthoai) {
        this.soDienthoai = soDienthoai;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }
}
