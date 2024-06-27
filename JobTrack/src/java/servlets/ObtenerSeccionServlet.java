/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SeccionesCurriculumServlet")
public class ObtenerSeccionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // JDBC URL, username and password of MySQL server
    private static final String url = "jdbc:mysql://localhost:3306/jobtrack";
    private static final String user = "root";
    private static final String password = "root";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Obtenemos el curriculumId de los parámetros de la solicitud
        String curriculumId = request.getParameter("curriculumId");

        // Preparamos la lista para almacenar las secciones
        List<Map<String, String>> sections = new ArrayList<>();

        // Establecemos la conexión con la base de datos
        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            // Consulta para obtener las secciones del currículum
            String query = "SELECT id_sec, titulo FROM secciones WHERE id_cur = ? ORDER BY prioridad DESC";
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, curriculumId);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> section = new HashMap<>();
                        section.put("id_sec", rs.getString("id_sec"));
                        section.put("titulo", rs.getString("titulo"));
                        sections.add(section);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Manejo de errores: puedes implementar una respuesta de error adecuada aquí
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return;
        }

        // Convertimos la lista de secciones a JSON
        String jsonSections = toJson(sections);

        // Configuramos la respuesta HTTP
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Enviamos la respuesta JSON
        try (PrintWriter out = response.getWriter()) {
            out.print(jsonSections);
            out.flush();
        }
    }

    // Método para convertir lista de secciones a JSON
    private String toJson(List<Map<String, String>> sections) {
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        for (int i = 0; i < sections.size(); i++) {
            Map<String, String> section = sections.get(i);
            sb.append("{");
            sb.append("\"id_sec\": \"").append(section.get("id_sec")).append("\",");
            sb.append("\"titulo\": \"").append(section.get("titulo")).append("\"");
            sb.append("}");
            if (i < sections.size() - 1) {
                sb.append(",");
            }
        }
        sb.append("]");
        return sb.toString();
    }
}
