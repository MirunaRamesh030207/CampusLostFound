package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.User;

public class UserDAO {

    // ── REGISTER ──────────────────────────────────────────
    public boolean registerUser(User user) {
        try {
            Connection con = DBConnection.getConnection();
            if (con == null) {
                System.out.println("❌ Connection is null!");
                return false;
            }
            String sql = "INSERT INTO users(name, roll_number, contact, department, password) "
                       + "VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, user.getName());
            ps.setString(2, user.getRollNumber());
            ps.setString(3, user.getContact());
            ps.setString(4, user.getDepartment());
            ps.setString(5, user.getPassword());
            int rows = ps.executeUpdate();
            System.out.println("Rows inserted: " + rows);
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── LOGIN ─────────────────────────────────────────────
    public User loginUser(String rollNumber, String password) {
        try {
            Connection con = DBConnection.getConnection();
            if (con == null) {
                System.out.println("❌ Connection is null!");
                return null;
            }
            String sql = "SELECT * FROM users WHERE roll_number = ? AND password = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, rollNumber);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User(
                    rs.getString("name"),
                    rs.getString("roll_number"),
                    rs.getString("contact"),
                    rs.getString("department"),
                    rs.getString("password")
                );
                u.setUserId(rs.getInt("user_id"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ── CHECK IF ROLL NUMBER ALREADY EXISTS ───────────────
    public boolean isRollNumberExists(String rollNumber) {
        try {
            Connection con = DBConnection.getConnection();
            if (con == null) return false;
            String sql = "SELECT COUNT(*) FROM users WHERE roll_number = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, rollNumber);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}