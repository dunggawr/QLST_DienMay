package test;

import static org.junit.Assert.*;

import dao.DAO;
import dao.KhachhangDAO;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import model.Khachhang;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

/**
 * Kiểm thử đơn vị cho lớp KhachhangDAO (JUnit 4)
 * Thiết kế ca kiểm thử phủ nhánh cấp 2 (Branch Coverage)
 * Có cơ chế rollback transaction để không làm bẩn CSDL kiểm thử.
 */
public class TestKhachhangDAO {

    private KhachhangDAO khachhangDAO;
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    @Before
    public void setUp() throws Exception {
        khachhangDAO = new KhachhangDAO();
        // Đảm bảo kết nối không tự động commit trong test để có thể rollback
        if (DAO.con != null) {
            DAO.con.setAutoCommit(false);
        }
    }

    @After
    public void tearDown() throws Exception {
        // Rollback toàn bộ các thay đổi phát sinh trong test
        if (DAO.con != null) {
            try {
                DAO.con.rollback();
                DAO.con.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Test case 1: Kiểm tra trùng tên đăng nhập - Tên đăng nhập ĐÃ TỒN TẠI
     * Nhánh: v_count > 0 -> return true
     */
    @Test
    public void testKiemTraTrungTendangnhap_DaTonTai() {
        String username = "nguyenvanan"; // Đã có trong CSDL mẫu
        boolean isDuplicate = khachhangDAO.kiemTraTrungTendangnhap(username);
        assertTrue("Tên đăng nhập đã tồn tại phải trả về true", isDuplicate);
    }

    /**
     * Test case 2: Kiểm tra trùng tên đăng nhập - Tên đăng nhập CHƯA TỒN TẠI
     * Nhánh: v_count == 0 -> return false
     */
    @Test
    public void testKiemTraTrungTendangnhap_ChuaTonTai() {
        String username = "user_chua_tung_co_99999";
        boolean isDuplicate = khachhangDAO.kiemTraTrungTendangnhap(username);
        assertFalse("Tên đăng nhập chưa tồn tại phải trả về false", isDuplicate);
    }

    /**
     * Test case 3: Lưu khách hàng mới thành công (Đầy đủ và hợp lệ)
     * Nhánh: execute thành công, cấp mã KH và trả về true
     */
    @Test
    public void testLuuKhachhang_ThanhCong() throws Exception {
        Khachhang kh = new Khachhang();
        kh.setTenDangnhap("testuser_moi_123");
        kh.setMatKhau("matkhau123");
        kh.setHoTen("Vũ Đức Đam");
        kh.setNgaySinh(sdf.parse("1994-06-15"));
        kh.setDiaChi("99 Bà Triệu, Hoàn Kiếm, Hà Nội");
        kh.setEmail("dam.vu@email.com");
        kh.setSoDienthoai("0977888999");
        kh.setGhiChu("Khách đăng ký mới từ web");

        boolean result = khachhangDAO.luuKhachhang(kh);
        assertTrue("Lưu khách hàng hợp lệ phải trả về true", result);
        assertTrue("Mã khách hàng phải được tự động sinh (ID > 0)", kh.getId() > 0);
        assertNotNull("Mã khách hàng không được null", kh.getMaKhachhang());
        assertTrue("Mã khách hàng phải bắt đầu bằng KH", kh.getMaKhachhang().startsWith("KH"));
    }

    /**
     * Test case 4: Lưu khách hàng thất bại do trùng tên đăng nhập
     * Nhánh: Lỗi UNIQUE constraint -> exception / rollback -> return false
     */
    @Test
    public void testLuuKhachhang_ThatBai_TrungUsername() throws Exception {
        Khachhang kh = new Khachhang();
        kh.setTenDangnhap("nguyenvanan"); // Trùng tên đăng nhập của KH001
        kh.setMatKhau("matkhau123");
        kh.setHoTen("Nguyễn Văn Trùng");
        kh.setNgaySinh(sdf.parse("1992-01-01"));
        kh.setDiaChi("Hà Nội");
        kh.setEmail("trung@email.com");
        kh.setSoDienthoai("0911111111");

        boolean result = khachhangDAO.luuKhachhang(kh);
        assertFalse("Lưu khách hàng trùng tên đăng nhập phải trả về false", result);
    }
}
