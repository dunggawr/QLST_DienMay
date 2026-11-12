package model;

import java.io.Serializable;

/**
 * Lớp thực thể NVBanhang kế thừa Nhanvien
 */
public class NVBanhang extends Nhanvien implements Serializable {
    private static final long serialVersionUID = 1L;

    public NVBanhang() {
        super();
        this.setVaiTro("nvbanhang");
    }
}
