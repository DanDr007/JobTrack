<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modificar Sección del Currículum</title>
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
                <h2>Modificar Sección del Currículum</h2>
                <div class="profile-circle"></div>
            </div>
            <div class="content">
                <form id="modify-section-form" action="modificarseccion" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="curriculum-select">Seleccionar Currículum:</label>
                        <select id="curriculum-select" name="curriculum">
                            <option value="">Seleccionar Currículum</option>
                            <% 
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

                                    // Obtener currículums del usuario logueado
                                    int userId = (Integer) session.getAttribute("id");
                                    String queryCurriculums = "SELECT id_cur, titulo FROM curriculum WHERE id_usu = " + userId;
                                    rs = stmt.executeQuery(queryCurriculums);

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

                                // Generar las opciones del select
                                for (Map<String, String> curriculum : curriculums) { 
                            %>
                                <option value="<%= curriculum.get("id_cur") %>"><%= curriculum.get("titulo") %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="section-select">Seleccionar Sección:</label>
                        <select id="section-select" name="section">
                            <option value="">Seleccionar Sección</option>
                        </select>
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
                    <button type="submit" class="action-button">Modificar Sección</button>
                </form>
                <form id="delete-curriculum-form" action="borrarcurriculum" method="post">
                    <div class="form-group">
                        <label for="delete-curriculum-select">Seleccionar Currículum para Eliminar:</label>
                        <select id="delete-curriculum-select" name="delete-curriculum">
                            <option value="">Seleccionar Currículum</option>
                            <% for (Map<String, String> curriculum : curriculums) { %>
                                <option value="<%= curriculum.get("id_cur") %>"><%= curriculum.get("titulo") %></option>
                            <% } %>
                        </select>
                    </div>
                    <button type="submit" class="action-button">Eliminar Currículum</button>
                </form>
            </div>
        </div>
    </div>
    <script>
        // Función para cargar las secciones del currículum seleccionado mediante AJAX
        function loadSections(curriculumId) {
            var xhr = new XMLHttpRequest();
            xhr.open('GET', 'SeccionesCurriculumServlet?curriculumId=' + encodeURIComponent(curriculumId), true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        var sections = JSON.parse(xhr.responseText);
                        var sectionSelect = document.getElementById('section-select');
                        sectionSelect.innerHTML = ''; // Limpiar opciones actuales
                        sections.forEach(function(section) {
                            var option = document.createElement('option');
                            option.value = section.id_sec;
                            option.textContent = section.titulo;
                            sectionSelect.appendChild(option);
                        });
                    } else {
                        console.error('Error al cargar las secciones del currículum');
                    }
                }
            };
            xhr.send();
        }

        // Evento para cargar las secciones cuando se cambia el currículum seleccionado
        document.getElementById('curriculum-select').addEventListener('change', function() {
            var selectedCurriculumId = this.value;
            if (selectedCurriculumId) {
                loadSections(selectedCurriculumId);
            } else {
                // Limpiar las secciones si no se seleccionó ningún currículum
                var sectionSelect = document.getElementById('section-select');
                sectionSelect.innerHTML = '<option value="">Seleccionar Sección</option>';
            }
        });

        // Evitar envío por defecto del formulario (solo para ejemplo, ajustar según necesidades)
        document.getElementById('modify-section-form').addEventListener('submit', function(event) {
            event.preventDefault();
            // Aquí puedes agregar lógica adicional según necesidades
            this.submit();
        });

        // Confirmación antes de eliminar currículum (solo para ejemplo, ajustar según necesidades)
        document.getElementById('delete-curriculum-form').addEventListener('submit', function(event) {
            event.preventDefault();
            if (confirm('¿Estás seguro de que deseas eliminar este currículum?')) {
                this.submit();
            }
        });
    </script>
</body>
</html>
