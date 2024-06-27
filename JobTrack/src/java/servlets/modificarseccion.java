package servlets;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/modificarseccionnn")
@MultipartConfig
public class modificarseccion extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private String dbURL = "jdbc:mysql://localhost:3306/jobtrack";
    private String dbUser = "root";
    private String dbPass = "root";
    private String uploadDir = "uploads"; // Directorio donde se guardarán las imágenes

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String curriculumId = request.getParameter("curriculum");
        String sectionId = request.getParameter("section");
        String sectionTitle = request.getParameter("section-title");
        String sectionContent = request.getParameter("section-content");
        String sectionPriority = request.getParameter("section-priority");
        Part filePart = request.getPart("section-image");

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
        PreparedStatement statementDelete = null;
        PreparedStatement statementInsert = null;

        try {
            DriverManager.registerDriver(new com.mysql.cj.jdbc.Driver());
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // Iniciar transacción
            conn.setAutoCommit(false);

            // Eliminar la sección siempre que exista un id de sección
            if (sectionId != null && !sectionId.isEmpty()) {
                String sqlDelete = "DELETE FROM secciones WHERE id_sec = ? AND id_cur = ?";
                statementDelete = conn.prepareStatement(sqlDelete);
                statementDelete.setInt(1, Integer.parseInt(sectionId));
                statementDelete.setInt(2, Integer.parseInt(curriculumId));
                statementDelete.executeUpdate();
            }

            // Insertar una nueva sección con los datos proporcionados
            if (!sectionTitle.isEmpty() || !sectionContent.isEmpty() || (filePart != null && filePart.getSize() > 0)) {
                String sqlInsert = "INSERT INTO secciones (id_cur, titulo, contenido, prioridad, imagen) VALUES (?, ?, ?, ?, ?)";
                statementInsert = conn.prepareStatement(sqlInsert);
                statementInsert.setInt(1, Integer.parseInt(curriculumId));
                statementInsert.setString(2, sectionTitle);
                statementInsert.setString(3, sectionContent);
                statementInsert.setInt(4, Integer.parseInt(sectionPriority));
                statementInsert.setString(5, fileName != null ? uploadDir + "/" + fileName : null);
                statementInsert.executeUpdate();
            }

            // Confirmar la transacción
            conn.commit();
            
            request.setAttribute("Message", "Sección modificada exitosamente.");

        } catch (SQLException ex) {
            // En caso de error, hacer rollback
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            ex.printStackTrace();
            request.setAttribute("Message", "Error: " + ex.getMessage());
        } finally {
            // Restaurar el comportamiento de auto commit y cerrar conexiones
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
            if (statementDelete != null) try { statementDelete.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (statementInsert != null) try { statementInsert.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        getServletContext().getRequestDispatcher("/modificar.jsp").forward(request, response);
    }
}
