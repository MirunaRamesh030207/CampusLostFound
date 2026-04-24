package servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.UserDAO;
import model.User;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name       = request.getParameter("name");
        String rollNumber = request.getParameter("rollNumber");
        String contact    = request.getParameter("contact");
        String department = request.getParameter("department");
        String password   = request.getParameter("password");
        String confirmPwd = request.getParameter("confirmPassword");

        // ── Validation ──
        if (name == null || name.trim().isEmpty() ||
            rollNumber == null || rollNumber.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Please fill in all required fields.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPwd)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();

        if (dao.isRollNumberExists(rollNumber)) {
            request.setAttribute("error", "Roll number already registered!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        User user = new User(name, rollNumber, contact, department, password);
        boolean result = dao.registerUser(user);

        if (result) {
            request.setAttribute("success", "Registration successful! You can now login.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}