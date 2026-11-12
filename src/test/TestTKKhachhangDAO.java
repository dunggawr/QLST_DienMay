package test;

import static org.junit.Assert.*;

import dao.TKKhachhangDAO;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import model.TKKhachhang;
import org.junit.Before;
import org.junit.Test;

/**
 * Kiểm thử đơn vị cho lớp TKKhachhangDAO (JUnit 4)
 * Bao phủ các nhánh luồng chính và các trường hợp ngoại lệ.
 */
public class TestTKKhachhangDAO {

    private TKKhachhangDAO tkKhachhangDAO;
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    @Before
    public void setUp() throws Exception {
        tkKhachhangDAO = new TKKhachhangDAO();
    }

    /**
     * Test case 1: Khoảng ngày chuẩn, có dữ liệu giao dịch trong CSDL
     * Tháng 10/2026 (2026-10-01 đến 2026-10-31)
     * Kỳ vọng: 
     * - Trả về danh sách 3 khách hàng có tài khoản: KH001, KH003, KH002
     * - Không chứa khách vãng lai
     * - Doanh thu sắp xếp giảm dần: KH001 (32.500.000) > KH003 (21.000.000) > KH002 (18.000.000)
     */
    @Test
    public void testGetTKKhachhang_CoDuLieu() throws Exception {
        Date ngayBD = sdf.parse("2026-10-01");
        Date ngayKT = sdf.parse("2026-10-31");

        ArrayList<TKKhachhang> list = tkKhachhangDAO.getTKKhachhang(ngayBD, ngayKT);

        assertNotNull("Danh sách kết quả không được null", list);
        assertEquals("Số lượng khách hàng phát sinh giao dịch phải là 3", 3, list.size());

        // Kiểm tra thứ tự sắp xếp giảm dần theo tổng doanh thu
        TKKhachhang top1 = list.get(0);
        assertEquals("Khách hàng doanh thu cao nhất phải là KH001", "KH001", top1.getMaKhachhang());
        assertEquals("Tổng số giao dịch của KH001 phải là 2 (1 quầy + 1 online đã xuất)", 2, top1.getTongSoGiaodich());
        assertEquals("Tổng doanh thu của KH001 phải là 32.500.000", 32500000.0, top1.getTongDoanhthu(), 0.001);

        TKKhachhang top2 = list.get(1);
        assertEquals("Khách hàng thứ hai phải là KH003", "KH003", top2.getMaKhachhang());
        assertEquals("Tổng doanh thu của KH003 phải là 21.000.000", 21000000.0, top2.getTongDoanhthu(), 0.001);

        TKKhachhang top3 = list.get(2);
        assertEquals("Khách hàng thứ ba phải là KH002", "KH002", top3.getMaKhachhang());
        assertEquals("Tổng doanh thu của KH002 phải là 18.000.000", 18000000.0, top3.getTongDoanhthu(), 0.001);
    }

    /**
     * Test case 2: Khoảng ngày không phát sinh giao dịch nào trong CSDL (Ngoại lệ 6a)
     * Kỳ vọng: Trả về danh sách rỗng (size == 0)
     */
    @Test
    public void testGetTKKhachhang_KhongCoDuLieu() throws Exception {
        Date ngayBD = sdf.parse("2015-01-01");
        Date ngayKT = sdf.parse("2015-01-31");

        ArrayList<TKKhachhang> list = tkKhachhangDAO.getTKKhachhang(ngayBD, ngayKT);

        assertNotNull("Danh sách kết quả không được null", list);
        assertEquals("Khoảng thời gian không có giao dịch phải trả về rỗng", 0, list.size());
    }

    /**
     * Test case 3: Ngày kết thúc trước ngày bắt đầu (Ngoại lệ 5a)
     * Kỳ vọng: Không gọi CSDL, trả về danh sách rỗng
     */
    @Test
    public void testGetTKKhachhang_NgayKTTruocNgayBD() throws Exception {
        Date ngayBD = sdf.parse("2026-10-31");
        Date ngayKT = sdf.parse("2026-10-01"); // ngayKT < ngayBD

        ArrayList<TKKhachhang> list = tkKhachhangDAO.getTKKhachhang(ngayBD, ngayKT);

        assertNotNull("Danh sách kết quả không được null", list);
        assertEquals("Ngày kết thúc trước ngày bắt đầu phải trả về danh sách rỗng", 0, list.size());
    }

    /**
     * Test case 4: Tham số null (Ngoại lệ 5b)
     * Kỳ vọng: Trả về danh sách rỗng
     */
    @Test
    public void testGetTKKhachhang_ThamSoNull() {
        ArrayList<TKKhachhang> list = tkKhachhangDAO.getTKKhachhang(null, null);

        assertNotNull("Danh sách kết quả không được null", list);
        assertEquals("Tham số null phải trả về danh sách rỗng", 0, list.size());
    }
}
