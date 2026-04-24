package servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.ItemDAO;

@WebServlet("/ResolveItemServlet")
public class ResolveItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam  = request.getParameter("id");
        String redirect = request.getParameter("from") != null
                        ? request.getParameter("from") : "myReports.jsp";

        if (idParam != null) {
            try {
                int itemId = Integer.parseInt(idParam);
                ItemDAO dao = new ItemDAO();
                dao.resolveItem(itemId);
                System.out.println("✅ Item resolved: " + itemId);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(redirect);
    }
}