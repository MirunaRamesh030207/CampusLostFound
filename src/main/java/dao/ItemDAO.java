package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Item;

public class ItemDAO {

    // ── POST ITEM ─────────────────────────────────────────
    public boolean postItem(Item item) {
        try {
            Connection con = DBConnection.getConnection();
            if (con == null) {
                System.out.println("❌ Connection is null!");
                return false;
            }

            String sql = "INSERT INTO items "
                       + "(user_id, type, category, description, location, "
                       + "date_posted, status, image_name, item_name) "
                       + "VALUES (?, ?, ?, ?, ?, TO_DATE(?, 'YYYY-MM-DD'), ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,    item.getUserId());
            ps.setString(2, item.getType());
            ps.setString(3, item.getCategory());
            ps.setString(4, item.getDescription());
            ps.setString(5, item.getLocation());
            ps.setString(6, item.getDatePost());
            ps.setString(7, item.getStatus());
            ps.setString(8, item.getImageName());
            ps.setString(9, item.getItemName());

            int rows = ps.executeUpdate();
            System.out.println("✅ Item inserted. Rows: " + rows);
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── GET ALL ITEMS ─────────────────────────────────────
    public List<Item> getAllItems() {
        List<Item> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            if (con == null) return list;

            String sql = "SELECT * FROM items ORDER BY date_posted DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Item item = new Item();
                item.setItemId(rs.getInt("item_id"));
                item.setUserId(rs.getInt("user_id"));
                item.setItemName(rs.getString("item_name"));
                item.setType(rs.getString("type"));
                item.setCategory(rs.getString("category"));
                item.setDescription(rs.getString("description"));
                item.setLocation(rs.getString("location"));
                item.setDatePost(rs.getString("date_posted"));
                item.setStatus(rs.getString("status"));
                item.setImageName(rs.getString("image_name"));
                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── GET ITEMS BY TYPE ─────────────────────────────────
    public List<Item> getItemsByType(String type) {
        List<Item> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            if (con == null) return list;

            String sql = "SELECT * FROM items WHERE type = ? AND status = 'open' "
                       + "ORDER BY date_posted DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, type);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Item item = new Item();
                item.setItemId(rs.getInt("item_id"));
                item.setUserId(rs.getInt("user_id"));
                item.setItemName(rs.getString("item_name"));
                item.setType(rs.getString("type"));
                item.setCategory(rs.getString("category"));
                item.setDescription(rs.getString("description"));
                item.setLocation(rs.getString("location"));
                item.setDatePost(rs.getString("date_posted"));
                item.setStatus(rs.getString("status"));
                item.setImageName(rs.getString("image_name"));
                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── RESOLVE ITEM ──────────────────────────────────────
    public boolean resolveItem(int itemId) {
        try {
            Connection con = DBConnection.getConnection();
            if (con == null) return false;
            String sql = "UPDATE items SET status = 'resolved' WHERE item_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, itemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public Item getItemById(int itemId) {
        try {
            Connection con = DBConnection.getConnection();
            if (con == null) return null;

            String sql = "SELECT i.*, u.name as reporter_name, "
                       + "u.contact as reporter_contact, u.roll_number "
                       + "FROM items i JOIN users u ON i.user_id = u.user_id "
                       + "WHERE i.item_id = ?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, itemId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Item item = new Item();
                item.setItemId(rs.getInt("item_id"));
                item.setUserId(rs.getInt("user_id"));
                item.setItemName(rs.getString("item_name"));
                item.setType(rs.getString("type"));
                item.setCategory(rs.getString("category"));
                item.setDescription(rs.getString("description"));
                item.setLocation(rs.getString("location"));
                java.sql.Date d = rs.getDate("date_posted");
                item.setDatePost(d != null ? d.toString() : "");
                item.setStatus(rs.getString("status"));
                item.setImageName(rs.getString("image_name"));
                // Reporter info stored temporarily using existing fields
                item.setReporterName(rs.getString("reporter_name"));
                item.setReporterContact(rs.getString("reporter_contact"));
                item.setReporterRoll(rs.getString("roll_number"));
                return item;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public boolean deleteItem(int itemId) {
        try {
            Connection con = DBConnection.getConnection();
            if (con == null) return false;

            String sql = "DELETE FROM items WHERE item_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, itemId);
            int rows = ps.executeUpdate();
            System.out.println("✅ Item deleted. Rows: " + rows);
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public List<Item> getItemsByUserId(int userId) {
        List<Item> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            if (con == null) return list;

            String sql = "SELECT * FROM items WHERE user_id = ? ORDER BY date_posted DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Item item = new Item();
                item.setItemId(rs.getInt("item_id"));
                item.setUserId(rs.getInt("user_id"));
                item.setItemName(rs.getString("item_name"));
                item.setType(rs.getString("type"));
                item.setCategory(rs.getString("category"));
                item.setDescription(rs.getString("description"));
                item.setLocation(rs.getString("location"));
                java.sql.Date d = rs.getDate("date_posted");
                item.setDatePost(d != null ? d.toString() : "");
                item.setStatus(rs.getString("status"));
                item.setImageName(rs.getString("image_name"));
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}