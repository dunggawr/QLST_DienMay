package model;

import java.io.Serializable;

/**
 * Lớp thực thể Chitietdondathang đại diện cho bảng tblChitietdondathang
 */
public class Chitietdondathang implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int soLuongDat;
    private double donGia;
    private double thanhTien; // Thuộc tính dẫn xuất trên tầng hướng đối tượng
    private Mathang mathang;

    public Chitietdondathang() {
        super();
    }

    public Chitietdondathang(int id, int soLuongDat, double donGia, Mathang mathang) {
        this.id = id;
        this.soLuongDat = soLuongDat;
        this.donGia = donGia;
        this.thanhTien = soLuongDat * donGia;
        this.mathang = mathang;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSoLuongDat() {
        return soLuongDat;
    }

    public void setSoLuongDat(int soLuongDat) {
        this.soLuongDat = soLuongDat;
        this.thanhTien = this.soLuongDat * this.donGia;
    }

    public double getDonGia() {
        return donGia;
    }

    public void setDonGia(double donGia) {
        this.donGia = donGia;
        this.thanhTien = this.soLuongDat * this.donGia;
    }

    public double getThanhTien() {
        return thanhTien;
    }

    public void setThanhTien(double thanhTien) {
        this.thanhTien = thanhTien;
    }

    public Mathang getMathang() {
        return mathang;
    }

    public void setMathang(Mathang mathang) {
        this.mathang = mathang;
    }
}
