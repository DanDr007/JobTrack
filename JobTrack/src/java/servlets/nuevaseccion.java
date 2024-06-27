package servlets;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/crearseccion")
@MultipartConfig
public class nuevaseccion extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private String dbURL = "jdbc:mysql://localhost:3306/jobtrack";
    private String dbUser = "root";
    private String dbPass = "root";
    private String uploadDir = "uploads"; // Directorio donde se guardarán las imágenes

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String curriculumId = request.getParameter("curriculum");
        String newCurriculumTitle = request.getParameter("new-curriculum-title");
        String sectionTitle = request.getParameter("section-title");
        String sectionContent = request.getParameter("section-content");
        String sectionPriority = request.getParameter("section-priority");
        Part filePart = request.getPart("section-image");
        HttpSession session = request.getSession();
        String fileName = null;
        if (filePart != null && filePart.getSize() > 0) {
            fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            File uploads = new File(getServletContext().getRealPath("/") + File.separator + uploadDir);
            if (!uploads.exists()) {
                uploads.mkdirs();
            }
            File file = new File(uploads, fileName);
            try (FileOutputStream fos = new FileOutputStream(file);
                 InputStream fileContent = filePart.getInputStream()) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = fileContent.read(buffer)) != -1) {
                    fos.write(buffer, 0, bytesRead);
                }
            }
        }

        Connection conn = null;
        PreparedStatement statement = null;
        ResultSet generatedKeys = null;
        int userId = (Integer) session.getAttribute("id");
        

        try {
            DriverManager.registerDriver(new com.mysql.cj.jdbc.Driver());
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            if ("new".equals(curriculumId)) {
                String insertCurriculumSql = "INSERT INTO curriculum (id_usu, titulo) VALUES (?, ?)";
                PreparedStatement insertCurriculumStatement = conn.prepareStatement(insertCurriculumSql, PreparedStatement.RETURN_GENERATED_KEYS);
                insertCurriculumStatement.setInt(1, userId); // Replace with dynamic user id
                insertCurriculumStatement.setString(2, newCurriculumTitle);
                insertCurriculumStatement.executeUpdate();

                generatedKeys = insertCurriculumStatement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    curriculumId = String.valueOf(generatedKeys.getInt(1));
                }
            }

            String sql = "INSERT INTO secciones (id_cur, titulo, contenido, prioridad, imagen) VALUES (?, ?, ?, ?, ?)";
            statement = conn.prepareStatement(sql);
            statement.setInt(1, Integer.parseInt(curriculumId));
            statement.setString(2, sectionTitle);
            statement.setString(3, sectionContent);
            statement.setInt(4, Integer.parseInt(sectionPriority));
            statement.setString(5, fileName != null ? uploadDir + "/" + fileName : null);

            int row = statement.executeUpdate();
            if (row > 0) {
                request.setAttribute("Message", "Sección añadida exitosamente.");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("Message", "Error: " + ex.getMessage());
        } finally {
            if (generatedKeys != null) try { generatedKeys.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (statement != null) try { statement.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        getServletContext().getRequestDispatcher("/crear.jsp").forward(request, response);
    }
}
