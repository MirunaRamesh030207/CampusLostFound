package dao;
import java.sql.Connection;
import java.sql.DriverManager;
public class DBConnection {
    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                "jdbc:mysql://sql12.freesqldatabase.com:3306/sql12825007",
                "sql12825007",
                "7dYGDgL1Jb"
            );
            System.out.println("Connected ✅");
        } catch (Exception e) {
            System.out.println("❌ DB Connection Failed!");
            System.out.println("Reason: " + e.getMessage());
            e.printStackTrace();
        }
        return con;
    }
}