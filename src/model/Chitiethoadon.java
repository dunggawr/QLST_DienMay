package model;

import java.io.Serializable;

/**
 * Lớp thực thể Chitiethoadon đại diện cho bảng tblChitiethoadon
 */
public class Chitiethoadon implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int soLuongMua;
    private double donGia;
    private double thanhTien; // Thuộc tính dẫn xuất trên tầng hướng đối tượng: soLuongMua * donGia
    private Mathang mathang;

    public Chitiethoadon() {
        super();
    }

    public Chitiethoadon(int id, int soLuongMua, double donGia, Mathang mathang) {
        this.id = id;
        this.soLuongMua = soLuongMua;
        this.donGia = donGia;
        this.thanhTien = soLuongMua * donGia;
        this.mathang = mathang;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSoLuongMua() {
        return soLuongMua;
    }

    public void setSoLuongMua(int soLuongMua) {
        this.soLuongMua = soLuongMua;
        this.thanhTien = this.soLuongMua * this.donGia;
    }

    public double getDonGia() {
        return donGia;
    }

    public void setDonGia(double donGia) {
        this.donGia = donGia;
        this.thanhTien = this.soLuongMua * this.donGia;
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
