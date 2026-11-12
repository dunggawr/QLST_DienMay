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
            String dbHost = System.getenv("DB_HOST") != null && !System.getenv("DB_HOST").isEmpty() 
                            ? System.getenv("DB_HOST") : "localhost";
            String dbPort = System.getenv("DB_PORT") != null && !System.getenv("DB_PORT").isEmpty() 
                            ? System.getenv("DB_PORT") : "3306";
            String dbUser = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "root";
            String dbPass = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : "";

            String dbUrl = "jdbc:mysql://" + dbHost + ":" + dbPort + "/qldst_dienmay?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
            String dbClass = "com.mysql.cj.jdbc.Driver";
            try {
                try {
                    Class.forName(dbClass);
                } catch (ClassNotFoundException e) {
                    Class.forName("com.mysql.jdbc.Driver");
                }
                con = DriverManager.getConnection(dbUrl, dbUser, dbPass);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
