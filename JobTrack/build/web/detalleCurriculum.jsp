<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Obtener el id del curriculum desde la URL
    String curriculumId = request.getParameter("id");
    if (curriculumId == null || curriculumId.isEmpty()) {
        // Manejar el error cuando el id no está presente en la URL
        out.println("No se ha proporcionado un id de currículum válido.");
        return;
    }

    // Establecer conexión con la base de datos
    String url = "jdbc:mysql://localhost:3306/jobtrack";
    String user = "root";
    String password = "root";
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    List<Map<String, String>> sections = new ArrayList<>();
    Map<String, String> curriculum = new HashMap<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, password);

        // Obtener los datos del curriculum
        String curriculumQuery = "SELECT titulo FROM curriculum WHERE id_cur = ?";
        stmt = conn.prepareStatement(curriculumQuery);
        stmt.setInt(1, Integer.parseInt(curriculumId));
        rs = stmt.executeQuery();
        if (rs.next()) {
            curriculum.put("titulo", rs.getString("titulo"));
        }

        // Obtener las secciones del curriculum
        String sectionQuery = "SELECT titulo, contenido, prioridad, imagen FROM secciones WHERE id_cur = ? ORDER BY prioridad DESC";
        stmt = conn.prepareStatement(sectionQuery);
        stmt.setInt(1, Integer.parseInt(curriculumId));
        rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, String> section = new HashMap<>();
            section.put("titulo", rs.getString("titulo"));
            section.put("contenido", rs.getString("contenido"));
            section.put("prioridad", rs.getString("prioridad"));
            section.put("imagen", rs.getString("imagen"));
            sections.add(section);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= curriculum.get("titulo") %> - Currículum</title>
    <link rel="stylesheet" href="css/Stylesc.css">
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <% for (Map<String, String> section : sections) { %>
                <a href="#<%= section.get("titulo").toLowerCase().replaceAll(" ", "-") %>" class="sidebar-button"><%= section.get("titulo") %></a>
            <% } %>
            <button class="sidebar-button" onclick="location.href='miscurriculums.jsp'">Regresar</button>
        </div>
        <div class="main">
            <div class="header">
                <h1>Currículum - <%= curriculum.get("titulo") %></h1>
                <div class="profile-circle"></div>
            </div>
            <div class="content">
                <% for (Map<String, String> section : sections) { %>
                    <section id="<%= section.get("titulo").toLowerCase().replaceAll(" ", "-") %>">
                        <h2><%= section.get("titulo") %></h2>
                        <div class="form-group">
                            <p><%= section.get("contenido") %></p>
                        </div>
                    </section>
                    <% if (section.get("imagen") != null && !section.get("imagen").isEmpty()) { %>
                        <section id="fotografias">
                            <div class="form-group">
                                <img src="<%= section.get("imagen") %>" width="200">
                            </div>
                        </section>
                    <% } %>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>
