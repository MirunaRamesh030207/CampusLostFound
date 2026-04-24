package dao;
import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:xe",
                "system",
                "root123"   // ← Did you change this?
            );
            System.out.println("Connected ✅");
        } catch (Exception e) {
            System.out.println("❌ DB Connection Failed!");
            System.out.println("Reason: " + e.getMessage()); // ← ADD THIS
            e.printStackTrace();
        }
        return con;
    }
}