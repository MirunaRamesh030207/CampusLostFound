![Java](https://img.shields.io/badge/Java-21-orange)
![JSP](https://img.shields.io/badge/JSP-Web_App-blue)
![Servlet](https://img.shields.io/badge/Servlet-Jakarta-red)
![MySQL](https://img.shields.io/badge/MySQL-Database-blue)
![Maven](https://img.shields.io/badge/Maven-Build-red)
![License](https://img.shields.io/badge/License-Educational-green)

🎒 Campus Lost & Found System

A **Java-based Full Stack Web Application** developed to simplify the process of reporting, tracking, and reclaiming lost items within a college campus. The application enables students to post lost or found items, search for belongings, submit claims, and manage reports through a simple and user-friendly interface.

This project was built to strengthen my understanding of **Java Web Development**, **Database Management**, and the **MVC architecture** using JSP, Servlets, JDBC, and MySQL.

---
🚀 Project Overview

Losing personal belongings on campus is a common problem. Traditional notice boards and social media groups are often inefficient for tracking lost and found items.

The **Campus Lost & Found System** provides a centralized platform where students can:

- Report lost items
- Post found items
- Search available items
- Claim recovered belongings
- Contact item owners
- Manage reports efficiently

---

✨ Features

- 👤 User Registration & Login
- 📦 Report Lost Items
- 🎒 Post Found Items
- 🔍 Search & Browse Items
- ✅ Claim Lost/Found Items
- 🗑️ Delete Your Own Posts
- 📊 Dashboard with Statistics
- 📱 Responsive User Interface
- 🔒 Secure Database Connectivity

---

🏗️ System Architecture

```
Presentation Layer
(JSP + HTML + CSS + JavaScript)
            │
            ▼
Business Logic
(Java Servlets)
            │
            ▼
Data Access Layer
(JDBC + DAO Classes)
            │
            ▼
MySQL Database
```

---

🛠️ Tech Stack

| Layer | Technology |
|--------|------------|
| Frontend | JSP, HTML, CSS, JavaScript |
| Backend | Java Servlets |
| Database | MySQL |
| Database Connectivity | JDBC |
| Build Tool | Maven |
| Server | Apache Tomcat 10.1 |
| IDE | Eclipse IDE |

---

📂 Project Structure

```
CampusLostFound
│
├── src
│   └── main
│       ├── java
│       │   ├── dao
│       │   ├── model
│       │   └── servlet
│       │
│       ├── webapp
│       │   ├── css
│       │   ├── images
│       │   ├── js
│       │   ├── WEB-INF
│       │   └── *.jsp
│
├── screenshots
├── pom.xml
├── .gitignore
└── README.md
```

---

🗄️ Database Design

| Table | Description |
|--------|-------------|
| users | Stores registered student information |
| items | Stores lost and found item details |
| claims | Stores claim requests submitted by students |
| users1 | Stores additional user records |

---

⚙️ Installation Guide

Prerequisites

- Java 21
- Eclipse IDE
- Apache Tomcat 10.1
- MySQL Server
- Maven

---

Step 1 - Clone the Repository

```bash
git clone https://github.com/MirunaRamesh030207/CampusLostFound.git
```

---

Step 2 - Import into Eclipse

```
File
   ↓
Import
   ↓
Existing Maven Project
```

Select the cloned project.

---

Step 3 - Configure Database

Open

```
src/main/java/dao/DBConnection.java
```

Update the database connection:

```java
DriverManager.getConnection(
    "jdbc:mysql://YOUR_HOST:3306/YOUR_DATABASE",
    "USERNAME",
    "PASSWORD"
);
```

---

Step 4 - Create Database

Create a MySQL database and execute the SQL script included in this repository (or create the required tables manually).

Required tables:

- users
- items
- claims
- users1

---

Step 5 - Run the Project

Right Click Project

```
Run As
      ↓
Run on Server
```

Select

```
Apache Tomcat 10.1
```

Open

```
http://localhost:8081/CampusLostFoundWebproject/index.jsp
```

---

📸 Application Screenshots

## 🏠 Home Page

<img src="screenshots/home.png" width="800">

---

## 🔐 Login Page

<img src="screenshots/login.png" width="800">

---

## 📝 Create Account

<img src="screenshots/create-account.png" width="800">

---

## 📦 Post Found Item

<img src="screenshots/post-found.png" width="800">

---

## ❗ Report Lost Item

<img src="screenshots/report-lost.png" width="800">

---

## 📤 Report Submission

<img src="screenshots/report-submission.png" width="800">

---

## 📞 Contact Owner

<img src="screenshots/contact-owner.png" width="800">

---

🎯 Learning Outcomes

Through this project, I gained hands-on experience in:

- Java Web Development
- MVC Architecture
- JSP & Servlets
- JDBC Database Connectivity
- MySQL Database Design
- CRUD Operations
- Session Management
- Maven Project Structure
- Git & GitHub Version Control

---

🚀 Future Enhancements

- 📧 Email Notifications
- 🔔 Real-time Claim Updates
- 📱 Mobile Responsive Improvements
- ☁️ Cloud Deployment
- 🔍 Advanced Search Filters
- 🤖 AI-based Lost Item Recommendation

---

👩‍💻 Developer

Miruna Ramesh

Aspiring Full Stack Java Developer

GitHub:
https://github.com/MirunaRamesh030207

LinkedIn:
https://www.linkedin.com/in/miruna-ramesh-780902326/

---

# 📄 License

This project has been developed for educational and portfolio purposes.

Feel free to explore the source code and use it for learning.

---

If you found this project helpful, consider giving this repository a Star⭐ .
