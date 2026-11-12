package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;

/**
 * Lớp thực thể Hoadonbanhang đại diện cho bảng tblHoadonbanhang
 */
public class Hoadonbanhang implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String maHoadon;
    private Date ngayBan;
    private double tongTien; // Thuộc tính dẫn xuất trên tầng hướng đối tượng
    private String ghiChu;
    private NVBanhang nvBanhang;
    private Khachhang khachhang; // Có thể null nếu là khách vãng lai
    private ArrayList<Chitiethoadon> dsChitiethoadon;

    public Hoadonbanhang() {
        super();
        this.dsChitiethoadon = new ArrayList<Chitiethoadon>();
    }

    public Hoadonbanhang(int id, String maHoadon, Date ngayBan, String ghiChu, 
                         NVBanhang nvBanhang, Khachhang khachhang) {
        this.id = id;
        this.maHoadon = maHoadon;
        this.ngayBan = ngayBan;
        this.ghiChu = ghiChu;
        this.nvBanhang = nvBanhang;
        this.khachhang = khachhang;
        this.dsChitiethoadon = new ArrayList<Chitiethoadon>();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMaHoadon() {
        return maHoadon;
    }

    public void setMaHoadon(String maHoadon) {
        this.maHoadon = maHoadon;
    }

    public Date getNgayBan() {
        return ngayBan;
    }

    public void setNgayBan(Date ngayBan) {
        this.ngayBan = ngayBan;
    }

    public double getTongTien() {
        double tong = 0;
        if (dsChitiethoadon != null) {
            for (Chitiethoadon ct : dsChitiethoadon) {
                tong += ct.getThanhTien();
            }
        }
        this.tongTien = tong;
        return tongTien;
    }

    public void setTongTien(double tongTien) {
        this.tongTien = tongTien;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }

    public NVBanhang getNvBanhang() {
        return nvBanhang;
    }

    public void setNvBanhang(NVBanhang nvBanhang) {
        this.nvBanhang = nvBanhang;
    }

    public Khachhang getKhachhang() {
        return khachhang;
    }

    public void setKhachhang(Khachhang khachhang) {
        this.khachhang = khachhang;
    }

    public ArrayList<Chitiethoadon> getDsChitiethoadon() {
        return dsChitiethoadon;
    }

    public void setDsChitiethoadon(ArrayList<Chitiethoadon> dsChitiethoadon) {
        this.dsChitiethoadon = dsChitiethoadon;
    }
}
