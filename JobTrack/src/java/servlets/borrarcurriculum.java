package servlets;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/eliminarcurriculum")
public class borrarcurriculum extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private String dbURL = "jdbc:mysql://localhost:3306/jobtrack";
    private String dbUser = "root";
    private String dbPass = "root";
    private String uploadDir = "uploads"; // Directorio donde se guardarán las imágenes

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String curriculumId = request.getParameter("delete-curriculum");

        Connection conn = null;
        PreparedStatement statementDeleteSections = null;
        PreparedStatement statementDeleteCurriculum = null;

        try {
            DriverManager.registerDriver(new com.mysql.cj.jdbc.Driver());
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // Eliminar todas las secciones del currículum seleccionado
            String sqlDeleteSections = "DELETE FROM secciones WHERE id_cur = ?";
            statementDeleteSections = conn.prepareStatement(sqlDeleteSections);
            statementDeleteSections.setInt(1, Integer.parseInt(curriculumId));
            statementDeleteSections.executeUpdate();

            // Eliminar el currículum seleccionado
            String sqlDeleteCurriculum = "DELETE FROM curriculum WHERE id_cur = ?";
            statementDeleteCurriculum = conn.prepareStatement(sqlDeleteCurriculum);
            statementDeleteCurriculum.setInt(1, Integer.parseInt(curriculumId));
            statementDeleteCurriculum.executeUpdate();

            request.setAttribute("Message", "Currículum eliminado exitosamente.");
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("Message", "Error: " + ex.getMessage());
        } finally {
            if (statementDeleteSections != null) try { statementDeleteSections.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (statementDeleteCurriculum != null) try { statementDeleteCurriculum.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        getServletContext().getRequestDispatcher("/modificar.jsp").forward(request, response);
    }
       protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       String curriculumId = request.getParameter("delete-curriculum");

        Connection conn = null;
        PreparedStatement statementDeleteSections = null;
        PreparedStatement statementDeleteCurriculum = null;

        try {
            DriverManager.registerDriver(new com.mysql.cj.jdbc.Driver());
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // Eliminar todas las secciones del currículum seleccionado
            String sqlDeleteSections = "DELETE FROM secciones WHERE id_cur = ?";
            statementDeleteSections = conn.prepareStatement(sqlDeleteSections);
            statementDeleteSections.setInt(1, Integer.parseInt(curriculumId));
            statementDeleteSections.executeUpdate();

            // Eliminar el currículum seleccionado
            String sqlDeleteCurriculum = "DELETE FROM curriculum WHERE id_cur = ?";
            statementDeleteCurriculum = conn.prepareStatement(sqlDeleteCurriculum);
            statementDeleteCurriculum.setInt(1, Integer.parseInt(curriculumId));
            statementDeleteCurriculum.executeUpdate();

            request.setAttribute("Message", "Currículum eliminado exitosamente.");
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("Message", "Error: " + ex.getMessage());
        } finally {
            if (statementDeleteSections != null) try { statementDeleteSections.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (statementDeleteCurriculum != null) try { statementDeleteCurriculum.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        response.sendRedirect("curriculums.jsp");
       }
}
