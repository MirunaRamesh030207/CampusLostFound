package servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.UserDAO;
import model.User;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String rollNumber = request.getParameter("rollNumber");
        String password   = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user   = dao.loginUser(rollNumber, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedUser", user);
            session.setAttribute("userName",   user.getName());
            session.setAttribute("rollNumber", user.getRollNumber());
            session.setAttribute("userId",     user.getUserId()); // ← ADD THIS

            
            response.sendRedirect("index.jsp");
        } else {
            request.setAttribute("error", "Invalid Roll Number or Password!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}