package model;

import java.io.Serializable;

/**
 * Lớp thực thể NVQuanli kế thừa Nhanvien
 */
public class NVQuanli extends Nhanvien implements Serializable {
    private static final long serialVersionUID = 1L;

    public NVQuanli() {
        super();
        this.setVaiTro("nvquanli");
    }
}
