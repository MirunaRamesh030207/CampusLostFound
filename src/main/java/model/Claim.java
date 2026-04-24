package model;

import java.sql.Date;

public class Claim {
    private int claimId;
    private int itemId;
    private int claimedBy;
    private Date claimDate;
    private boolean verified;

    // Constructor
    public Claim(int itemId, int claimedBy) {
        this.itemId = itemId;
        this.claimedBy = claimedBy;
        this.claimDate = new Date(System.currentTimeMillis());
        this.verified = false;
    }

    // Getters
    public int getClaimId() { return claimId; }
    public int getItemId() { return itemId; }
    public int getClaimedBy() { return claimedBy; }
    public Date getClaimDate() { return claimDate; }
    public boolean isVerified() { return verified; }

    // Setters
    public void setClaimId(int claimId) { this.claimId = claimId; }
    public void setVerified(boolean verified) { this.verified = verified; }
}