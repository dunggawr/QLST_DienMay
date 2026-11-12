package model;

import java.io.Serializable;

/**
 * Lớp thực thể Mathang đại diện cho bảng tblMathang
 */
public class Mathang implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String maMathang;
    private String tenMathang;
    private String hangSanxuat;
    private double giaBan;
    private int soLuongTon;
    private String moTa;
    private Loaimathang loaimathang;

    public Mathang() {
        super();
    }

    public Mathang(int id, String maMathang, String tenMathang, String hangSanxuat, 
                   double giaBan, int soLuongTon, String moTa, Loaimathang loaimathang) {
        this.id = id;
        this.maMathang = maMathang;
        this.tenMathang = tenMathang;
        this.hangSanxuat = hangSanxuat;
        this.giaBan = giaBan;
        this.soLuongTon = soLuongTon;
        this.moTa = moTa;
        this.loaimathang = loaimathang;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMaMathang() {
        return maMathang;
    }

    public void setMaMathang(String maMathang) {
        this.maMathang = maMathang;
    }

    public String getTenMathang() {
        return tenMathang;
    }

    public void setTenMathang(String tenMathang) {
        this.tenMathang = tenMathang;
    }

    public String getHangSanxuat() {
        return hangSanxuat;
    }

    public void setHangSanxuat(String hangSanxuat) {
        this.hangSanxuat = hangSanxuat;
    }

    public double getGiaBan() {
        return giaBan;
    }

    public void setGiaBan(double giaBan) {
        this.giaBan = giaBan;
    }

    public int getSoLuongTon() {
        return soLuongTon;
    }

    public void setSoLuongTon(int soLuongTon) {
        this.soLuongTon = soLuongTon;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public Loaimathang getLoaimathang() {
        return loaimathang;
    }

    public void setLoaimathang(Loaimathang loaimathang) {
        this.loaimathang = loaimathang;
    }
}
