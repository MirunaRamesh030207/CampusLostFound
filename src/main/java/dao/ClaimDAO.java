package dao;

import model.Claim;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ClaimDAO {

    // Claim an item
    public boolean claimItem(Claim claim) {
        String sql = "INSERT INTO claims (item_id, claimed_by, claim_date, verified) VALUES (?, ?, ?, ?)";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setInt(1, claim.getItemId());
            stmt.setInt(2, claim.getClaimedBy());
            stmt.setDate(3, claim.getClaimDate());
            stmt.setInt(4, 0);

            stmt.executeUpdate();
            System.out.println("Item claimed successfully!");
            return true;

        } catch (SQLException e) {
            System.out.println("Claim failed: " + e.getMessage());
            return false;
        }
    }

    // Mark item as resolved
    public boolean resolveItem(int itemId) {
        String sql = "UPDATE items SET status = 'resolved' WHERE item_id = ?";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, itemId);

            stmt.executeUpdate();
            System.out.println("Item marked as resolved!");
            return true;

        } catch (SQLException e) {
            System.out.println("Resolve failed: " + e.getMessage());
            return false;
        }
    }
}