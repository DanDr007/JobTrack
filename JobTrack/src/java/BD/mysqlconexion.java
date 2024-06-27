/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package BD;
import java.sql.*;
import java.sql.DriverManager;
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 *
 * @author Daniel Diaz
 */
public class mysqlconexion {
    private String url,usuario,pass;
    Connection con = null;
    Statement set = null;
    ResultSet rs = null;
    String driver = "com.mysql.jdbc.Driver";
    public mysqlconexion(String url,String usuario, String pass){
    this.url=url;
    this.pass=pass;
    this.usuario=usuario;
    System.out.println("mysql constructor");
    }
    
    public Connection getConexion(){
        System.out.println("getConexion");
        try{
            Class.forName(driver);
            con = DriverManager.getConnection(url, usuario, pass);
            System.out.println("Conexion relizada");
        }catch( ClassNotFoundException | SQLException e){
            System.out.println("Error: " + e.getMessage());
        }
        return con;
    }
    public void CerrarCon(){
        try {
            con.close();
            System.out.println("Conexion cerrada");
        } catch (SQLException ex) {
            System.out.println("no se cerro la conexion");
            Logger.getLogger(mysqlconexion.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    public ResultSet consulta(String q){
        try {
            set = con.createStatement();
            rs=set.executeQuery(q);
            System.out.println("Consulta hecha");
        } catch (SQLException ex) {
            System.out.println("No se pudo hacer la consulta");
        }
        return rs;
    }
    public void update(String q){
    try {
            set = con.createStatement();
            set.executeUpdate(q);
            set.close();
            System.out.println("UPDATE hecha");
        } catch (SQLException ex) {
            try {
                Logger.getLogger(mysqlconexion.class.getName()).log(Level.SEVERE, null, ex);
                System.out.println("No se realizo la actualizacion");
                set.close();
            } catch (SQLException ex1) {
                Logger.getLogger(mysqlconexion.class.getName()).log(Level.SEVERE, null, ex1);
            }
        }
    }
    public void cerrarSet(){
        try {
            set.close();
            System.out.println("Cerrando set");
        } catch (SQLException ex) {
            Logger.getLogger(mysqlconexion.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
