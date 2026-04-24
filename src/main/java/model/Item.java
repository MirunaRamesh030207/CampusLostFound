package model;

public class Item {
    private int    itemId;
    private int    userId;
    private String itemName;
    private String type;
    private String category;
    private String description;
    private String location;
    private String datePost;
    private String status;
    private String imageName;

    public int    getItemId()      { return itemId; }
    public int    getUserId()      { return userId; }
    public String getItemName()    { return itemName; }
    public String getType()        { return type; }
    public String getCategory()    { return category; }
    public String getDescription() { return description; }
    public String getLocation()    { return location; }
    public String getDatePost()    { return datePost; }
    public String getStatus()      { return status; }
    public String getImageName()   { return imageName; }

    public void setItemId(int itemId)          { this.itemId = itemId; }
    public void setUserId(int userId)          { this.userId = userId; }
    public void setItemName(String itemName)   { this.itemName = itemName; }
    public void setType(String type)           { this.type = type; }
    public void setCategory(String category)   { this.category = category; }
    public void setDescription(String desc)    { this.description = desc; }
    public void setLocation(String location)   { this.location = location; }
    public void setDatePost(String datePost)   { this.datePost = datePost; }
    public void setStatus(String status)       { this.status = status; }
    public void setImageName(String imageName) { this.imageName = imageName; }

//Reporter info (not stored in DB — only used for display)
private String reporterName;
private String reporterContact;
private String reporterRoll;

public String getReporterName()    { return reporterName; }
public String getReporterContact() { return reporterContact; }
public String getReporterRoll()    { return reporterRoll; }

public void setReporterName(String n)    { this.reporterName = n; }
public void setReporterContact(String c) { this.reporterContact = c; }
public void setReporterRoll(String r)    { this.reporterRoll = r; }
}