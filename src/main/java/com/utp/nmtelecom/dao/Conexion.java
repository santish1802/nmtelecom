package com.utp.nmtelecom.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    
    // private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    //private static final String DB_URL = "jdbc:mysql://localhost:3306/nmtelecom_db_simple?serverTimezone=UTC";
    //private static final String DB_USER = "root"; 
    //private static final String DB_PASSWORD = ""; 
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DB_URL = "jdbc:mysql://bljjeyberlumcz5grkpk-mysql.services.clever-cloud.com:3306/bljjeyberlumcz5grkpk?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "uhd80gscdqu87nah";
    private static final String DB_PASSWORD = "sIFnftvOPVMmxMb5tluE";
    // Bloque estático para cargar el driver una sola vez al inicio de la aplicación
    static {
        try {
            Class.forName(DRIVER);
            System.out.println("Driver JDBC de MySQL cargado correctamente.");
        } catch (ClassNotFoundException e) {
            System.err.println("Error: No se encontró el driver JDBC de MySQL. Asegúrate de tener el JAR en el classpath.");
            e.printStackTrace();
            // Lanza una excepción en tiempo de ejecución si el driver no existe
            throw new RuntimeException("Fallo al cargar el driver de la base de datos.", e);
        }
    }

    /**
     * Proporciona una nueva conexión a la base de datos.
     * Esta conexión DEBE ser cerrada por el método que la utiliza.
     * @return Nueva instancia de Connection.
     * @throws SQLException si ocurre un error al establecer la conexión.
     */
    public static Connection getConexion() throws SQLException {
        // En cada llamada, creamos una nueva conexión (o la sacamos del Pool si se usa uno).
        // Esto previene problemas de concurrencia y asegura un cierre rápido de recursos.
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
}