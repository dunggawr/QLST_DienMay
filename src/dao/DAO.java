package dao;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * Lớp cơ sở DAO (Data Access Object) quản lý kết nối JDBC
 * Theo chuẩn giáo trình PTIT.
 */
public class DAO {
    public static Connection con;

    public DAO() {
        if (con == null) {
            String dbUrl = "jdbc:mysql://localhost:3306/qldst_dienmay?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
            String dbClass = "com.mysql.cj.jdbc.Driver";
            try {
                try {
                    Class.forName(dbClass);
                } catch (ClassNotFoundException e) {
                    Class.forName("com.mysql.jdbc.Driver");
                }
                con = DriverManager.getConnection(dbUrl, "root", "");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
