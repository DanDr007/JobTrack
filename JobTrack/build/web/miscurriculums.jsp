<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/Styles.css">
    <title>JobTrack - Mis Currículums</title>
</head>
<body>
    <div class="container">
        <div class="sidebar">
    <br>
    <br>
    <button class="sidebar-button" onclick="location.href='crear.jsp'">Crear</button>
    <button class="sidebar-button" onclick="location.href='miscurriculums.jsp'">Mis Currículums</button>
    <button class="sidebar-button" onclick="location.href='curriculums.jsp'">Currículums</button>
    <button class="sidebar-button" onclick="location.href='modificar.jsp'">Modificar</button>
    <button class="sidebar-button" onclick="location.href='index.html'">Cerrar sesión</button>
</div>
        <div class="main">
            <div class="header">
                <span><%= session.getAttribute("nombre") %></span>
                <div class="profile-circle"></div>
            </div>
            <div class="content">
                <%
                    // Obtener el ID del usuario de la sesión
                    Integer userId = (Integer) session.getAttribute("id");

                    if (userId == null) {
                        // Redirigir al login si el usuario no está logueado
                        response.sendRedirect("index.html");
                        return;
                    }

                    // Establecer conexión con la base de datos
                    String url = "jdbc:mysql://localhost:3306/jobtrack";
                    String dbUser = "root";
                    String dbPassword = "root";
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(url, dbUser, dbPassword);
                        
                        // Consultar los currículums del usuario logueado
                        String query = "SELECT id_cur, titulo FROM curriculum WHERE id_usu = ?";
                        stmt = conn.prepareStatement(query);
                        stmt.setInt(1, userId);
                        rs = stmt.executeQuery();

                        while (rs.next()) {
                            int idCur = rs.getInt("id_cur");
                            String titulo = rs.getString("titulo");
                %>
                            <div class="card">
                                <span>Currículum de <%= titulo %></span>
                                <div class="profile-circle"></div>
                                <button class="action-button" onclick="location.href='detalleCurriculum.jsp?id=<%= idCur %>'">➔</button>
                            </div>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </div>
        </div>
    </div>
</body>
</html>
