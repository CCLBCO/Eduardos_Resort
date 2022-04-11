package controller;

import static controller.FilterRecordsServlet.userDB;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author admin
 */

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.BookingRecord;

public class testFilter {
    public static void main (String args[]){
        Connection con = null;
        String jdbcClassName = "org.apache.derby.jdbc.ClientDriver";
        String dbUserName = "app";
        String dbPassword = "app";
        String jdbcDriverURL = "jdbc:derby";
        String dbHostName = "localhost";
        String dbPort = "1527";
        String databaseName = "EduardosResort";
        try {
            // Getting the Parameters for the Connection
            Class.forName(jdbcClassName);
            String userDB = dbUserName;
            String passDB = dbPassword;

            //StringBuffer is used to make the string changeable
            StringBuffer url = new StringBuffer(jdbcDriverURL)
                    .append("://")
                    .append(dbHostName)
                    .append(":")
                    .append(dbPort)
                    .append("/")
                    .append(databaseName);
            con = DriverManager.getConnection(url.toString(),userDB,passDB);  
        } 
        catch (SQLException sqle){ } 
        catch (ClassNotFoundException nfe){ }
        
        //WORKS!!
        //String filterquery = "SELECT * FROM BOOKING_INFO WHERE STATUS_ID = ? AND DATE_BOOKED >= '2022-01-01 00:00:00'";
        
        String filterquery = "SELECT * FROM BOOKING_INFO WHERE STATUS_ID = ? AND DATE_BOOKED >= ?";

        //String filterquery = "SELECT * FROM BOOKING_INFO WHERE STATUS_ID = ? AND ROOM_ID = ?";
            try {
                //Timestamp dateOnwardsFilter = Timestamp.valueOf("2022-03-13");
                String dateOnwardsFilter = "2022-01-01 00:00:00";
                PreparedStatement filterRecordStmt = con.prepareStatement(filterquery);
                filterRecordStmt.setInt(1, 1);
                filterRecordStmt.setString(2, dateOnwardsFilter);
                //filterRecordStmt.setInt(2, 1);  //1 is deluxe
                ResultSet filteredRS = filterRecordStmt.executeQuery();
                
                while(filteredRS.next()) {
                    System.out.println("ID: " + filteredRS.getInt("booking_id"));
                    System.out.println("Date Booked: " + filteredRS.getTimestamp("date_booked"));
                    System.out.println("Name: " + filteredRS.getString("name"));
                    System.out.println("Status ID: " + filteredRS.getInt("status_id"));
                }
            } catch (Exception e) {
            
            }
    }
}
