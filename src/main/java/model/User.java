package model;

public class User {
    private int    userId;
    private String name, rollNumber, contact, department, password;

    public User(String name, String rollNumber, String contact,
                String department, String password) {
        this.name       = name;
        this.rollNumber = rollNumber;
        this.contact    = contact;
        this.department = department;
        this.password   = password;
    }

    public User(String name, String rollNumber, String contact, String department) {
        this(name, rollNumber, contact, department, null);
    }

    public int    getUserId()       { return userId; }
    public String getName()         { return name; }
    public String getRollNumber()   { return rollNumber; }
    public String getContact()      { return contact; }
    public String getDepartment()   { return department; }
    public String getPassword()     { return password; }

    public void setUserId(int userId) { this.userId = userId; }
}