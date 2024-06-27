<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Aquí debes obtener el ID del usuario logueado. Puede variar según tu lógica de autenticación.
    int userId = (Integer) session.getAttribute("id");// Por ejemplo, el ID de usuario logueado es 1. Esto debe ser dinámico.

    // Establecer conexión con la base de datos
    String url = "jdbc:mysql://localhost:3306/jobtrack";
    String user = "root";
    String password = "root";
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    List<Map<String, String>> curriculums = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, password);
        stmt = conn.createStatement();
        String query = "SELECT id_cur, titulo FROM curriculum WHERE id_usu = " + userId;
        rs = stmt.executeQuery(query);

        while (rs.next()) {
            Map<String, String> curriculum = new HashMap<>();
            curriculum.put("id_cur", rs.getString("id_cur"));
            curriculum.put("titulo", rs.getString("titulo"));
            curriculums.add(curriculum);
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
    <title>Agregar Sección al Currículum</title>
    <link rel="stylesheet" href="css/Stylescr.css">
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
                <h2>Agregar Sección al Currículum</h2>
                <div class="profile-circle"></div>
            </div>
            <div class="content">
                <form id="add-section-form" action="nuevaseccion" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="curriculum-select">Seleccionar Currículum:</label>
                        <select id="curriculum-select" name="curriculum">
                            <option value="">Seleccionar Currículum</option>
                            <%
                                for (Map<String, String> curriculum : curriculums) {
                            %>
                                <option value="<%= curriculum.get("id_cur") %>"><%= curriculum.get("titulo") %></option>
                            <%
                                }
                            %>
                            <option value="new">Nuevo Currículum</option>
                        </select>
                    </div>
                    <div class="form-group" id="new-curriculum-title" style="display: none;">
                        <label for="new-curriculum-input">Título del Nuevo Currículum:</label>
                        <input type="text" id="new-curriculum-input" name="new-curriculum-title" placeholder="Ingrese el título del nuevo currículum">
                    </div>
                    <div class="form-group">
                        <label for="section-title">Título de la Sección:</label>
                        <input type="text" id="section-title" name="section-title" placeholder="Ingrese el título de la sección">
                    </div>
                    <div class="form-group">
                        <label for="section-content">Contenido:</label>
                        <textarea id="section-content" name="section-content" rows="5" placeholder="Ingrese el contenido de la sección"></textarea>
                    </div>
                    <div class="form-group">
                        <label for="section-image">Subir Imagen:</label>
                        <input type="file" id="section-image" name="section-image">
                    </div>
                    <div class="form-group">
                        <label for="section-priority">Prioridad:</label>
                        <input type="number" id="section-priority" name="section-priority" min="0" max="99" placeholder="Ingrese un número de 2 dígitos">
                        <small>Entre más alto sea el número, mayor será la prioridad.</small>
                    </div>
                    <button type="submit" class="action-button">Agregar Sección</button>
                </form>
            </div>
        </div>
    </div>
    <script>
        const curriculumSelect = document.getElementById('curriculum-select');
        const newCurriculumTitle = document.getElementById('new-curriculum-title');

        curriculumSelect.addEventListener('change', function() {
            if (this.value === 'new') {
                newCurriculumTitle.style.display = 'block';
            } else {
                newCurriculumTitle.style.display = 'none';
            }
        });
        document.getElementById('add-section-form').addEventListener('submit', function(event) {
            event.preventDefault();
            this.submit();
        });
    </script>
</body>
</html>
