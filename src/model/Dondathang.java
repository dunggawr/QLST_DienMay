package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;

/**
 * Lớp thực thể Dondathang đại diện cho bảng tblDondathang
 */
public class Dondathang implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String maDonhang;
    private Date ngayDat;
    private String diaChiNhan;
    private String trangThai; // 'cho_duyet', 'da_duyet', 'da_xuat', 'tu_choi'
    private Date ngayXuat;
    private double tongTien; // Thuộc tính dẫn xuất trên tầng hướng đối tượng
    private Khachhang khachhang;
    private NVKho nvKho;
    private NVGiaohang nvGiaohang;
    private ArrayList<Chitietdondathang> dsChitietdondathang;

    public Dondathang() {
        super();
        this.dsChitietdondathang = new ArrayList<Chitietdondathang>();
    }

    public Dondathang(int id, String maDonhang, Date ngayDat, String diaChiNhan, 
                      String trangThai, Date ngayXuat, Khachhang khachhang) {
        this.id = id;
        this.maDonhang = maDonhang;
        this.ngayDat = ngayDat;
        this.diaChiNhan = diaChiNhan;
        this.trangThai = trangThai;
        this.ngayXuat = ngayXuat;
        this.khachhang = khachhang;
        this.dsChitietdondathang = new ArrayList<Chitietdondathang>();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMaDonhang() {
        return maDonhang;
    }

    public void setMaDonhang(String maDonhang) {
        this.maDonhang = maDonhang;
    }

    public Date getNgayDat() {
        return ngayDat;
    }

    public void setNgayDat(Date ngayDat) {
        this.ngayDat = ngayDat;
    }

    public String getDiaChiNhan() {
        return diaChiNhan;
    }

    public void setDiaChiNhan(String diaChiNhan) {
        this.diaChiNhan = diaChiNhan;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public Date getNgayXuat() {
        return ngayXuat;
    }

    public void setNgayXuat(Date ngayXuat) {
        this.ngayXuat = ngayXuat;
    }

    public double getTongTien() {
        double tong = 0;
        if (dsChitietdondathang != null) {
            for (Chitietdondathang ct : dsChitietdondathang) {
                tong += ct.getThanhTien();
            }
        }
        this.tongTien = tong;
        return tongTien;
    }

    public void setTongTien(double tongTien) {
        this.tongTien = tongTien;
    }

    public Khachhang getKhachhang() {
        return khachhang;
    }

    public void setKhachhang(Khachhang khachhang) {
        this.khachhang = khachhang;
    }

    public NVKho getNvKho() {
        return nvKho;
    }

    public void setNvKho(NVKho nvKho) {
        this.nvKho = nvKho;
    }

    public NVGiaohang getNvGiaohang() {
        return nvGiaohang;
    }

    public void setNvGiaohang(NVGiaohang nvGiaohang) {
        this.nvGiaohang = nvGiaohang;
    }

    public ArrayList<Chitietdondathang> getDsChitietdondathang() {
        return dsChitietdondathang;
    }

    public void setDsChitietdondathang(ArrayList<Chitietdondathang> dsChitietdondathang) {
        this.dsChitietdondathang = dsChitietdondathang;
    }
}
