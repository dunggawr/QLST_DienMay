package model;

import java.io.Serializable;

/**
 * Lớp thực thể Loaimathang đại diện cho bảng tblLoaimathang
 */
public class Loaimathang implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String tenLoai;
    private String moTa;

    public Loaimathang() {
        super();
    }

    public Loaimathang(int id, String tenLoai, String moTa) {
        this.id = id;
        this.tenLoai = tenLoai;
        this.moTa = moTa;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTenLoai() {
        return tenLoai;
    }

    public void setTenLoai(String tenLoai) {
        this.tenLoai = tenLoai;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }
}
