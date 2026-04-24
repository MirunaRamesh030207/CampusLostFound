package servlet;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import dao.ItemDAO;
import model.Item;

@WebServlet("/PostItemServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize       = 5 * 1024 * 1024,
    maxRequestSize    = 20 * 1024 * 1024
)
public class PostItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Session check ──
        HttpSession session = request.getSession();
        if (session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // ── Get form fields ──
        String itemName    = request.getParameter("itemName");
        String type        = request.getParameter("type");
        String category    = request.getParameter("category");
        String location    = request.getParameter("location");
        String description = request.getParameter("description");
        String datePost    = request.getParameter("datePost");

        // ── Get userId from session ──
        Object userIdObj = session.getAttribute("userId");
        int userId = 1; // default fallback
        if (userIdObj != null) {
            userId = Integer.parseInt(userIdObj.toString());
        }

        // ── Validation ──
        if (itemName == null || itemName.trim().isEmpty() ||
            type == null     || type.trim().isEmpty()     ||
            category == null || category.trim().isEmpty() ||
            location == null || location.trim().isEmpty() ||
            description == null || description.trim().isEmpty()) {

            request.setAttribute("error", "Please fill in all required fields.");
            request.getRequestDispatcher("postItem.jsp").forward(request, response);
            return;
        }

        // ── Handle image upload ──
        String imageName = null;
        try {
            Part filePart = request.getPart("itemImage");
            if (filePart != null && filePart.getSize() > 0) {
                String originalFileName = Paths.get(
                    filePart.getSubmittedFileName()).getFileName().toString();
                String extension = originalFileName.contains(".")
                    ? originalFileName.substring(originalFileName.lastIndexOf("."))
                    : ".jpg";

                imageName = "item_" + System.currentTimeMillis() + "_" + userId + extension;

                String uploadPath = getServletContext().getRealPath("")
                    + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input,
                        Paths.get(uploadPath + File.separator + imageName),
                        StandardCopyOption.REPLACE_EXISTING);
                    System.out.println("✅ Image saved: " + imageName);
                }
            }
        } catch (Exception e) {
            System.out.println("Image upload skipped: " + e.getMessage());
            imageName = null;
        }

        // ── Build Item object ──
        Item item = new Item();
        item.setUserId(userId);
        item.setItemName(itemName);
        item.setType(type);
        item.setCategory(category);
        item.setLocation(location);
        item.setDescription(description);
        item.setDatePost(datePost);
        item.setImageName(imageName);
        item.setStatus("open");

        // ── Save to DB ──
        ItemDAO dao = new ItemDAO();
        boolean result = dao.postItem(item);

        if (result) {
            String msg = "lost".equals(type)
                ? "Lost report submitted successfully!"
                : "Found report submitted successfully!";
            request.setAttribute("success", msg);
        } else {
            request.setAttribute("error", "Failed to submit. Please try again.");
        }

        request.getRequestDispatcher("postItem.jsp").forward(request, response);
    }
}