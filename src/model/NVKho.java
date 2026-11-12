package model;

import java.io.Serializable;

/**
 * Lớp thực thể NVKho kế thừa Nhanvien
 */
public class NVKho extends Nhanvien implements Serializable {
    private static final long serialVersionUID = 1L;

    public NVKho() {
        super();
        this.setVaiTro("nvkho");
    }
}
