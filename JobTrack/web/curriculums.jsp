<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/Styles.css">
    <title>JobTrack</title>
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
                    // Establecer conexión con la base de datos
                    String url = "jdbc:mysql://localhost:3306/jobtrack";
                    String user = "root";
                    String password = "root";
                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(url, user, password);
                        stmt = conn.createStatement();
                        String query = "SELECT curriculum.id_cur, curriculum.titulo, usuarios.nombre " +
                                       "FROM curriculum " +
                                       "JOIN usuarios ON curriculum.id_usu = usuarios.id_usu";
                        rs = stmt.executeQuery(query);

                        while (rs.next()) {
                            int idCur = rs.getInt("id_cur");
                            String titulo = rs.getString("titulo");
                            String nombreCreador = rs.getString("nombre");
                %>
                            <div class="card">
                                <span>Currículum de <%= titulo %> (Creador: <%= nombreCreador %>)</span>
                                <div class="profile-circle"></div>
                                <button class="action-button" onclick="location.href='detalleCurriculum.jsp?id=<%= idCur %>'">➔</button>
                                <% 
                // Verificar nivel de permisos
                Integer permisos = (Integer) session.getAttribute("permisos");
                System.out.println(permisos);
                if (permisos == 2) { // Si los permisos son 2, mostrar botón para borrar currículums
            %>
                <button class="action-button" onclick="location.href='borrarcurriculum?delete-curriculum=<%= idCur %>'" enctype="multipart/form-data">Borrar</button>
                               
            <% } %>
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
