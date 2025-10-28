package com.utp.nmtelecom.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DatabaseConnection {

    private static final Logger LOGGER = Logger.getLogger(DatabaseConnection.class.getName());

    // private static final String JDBC_URL = "jdbc:mysql://localhost:3306/NMTELECOM_DB_SIMPLE?useSSL=false&serverTimezone=UTC";
    // private static final String JDBC_USER = "root";
    private static final String JDBC_URL = "jdbc:mysql://uhd80gscdqu87nah:sIFnftvOPVMmxMb5tluE@bljjeyberlumcz5grkpk-mysql.services.clever-cloud.com:3306/bljjeyberlumcz5grkpk";
    private static final String JDBC_USER = "uhd80gscdqu87nah";
    private static final String JDBC_PASSWORD = "sIFnftvOPVMmxMb5tluE";


    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            LOGGER.log(Level.INFO, "Intentando conectar a la BD...");
            return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Driver de MySQL no encontrado. Asegúrate de que mysql-connector-java esté en tu pom.xml.", e);
            throw new SQLException("Error: Driver de la base de datos no encontrado. Verifica tu archivo pom.xml.", e);
        }
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error al cerrar la conexión a la BD.", e);
            }
        }
    }
}