/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import model.BookingRecord;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import javax.mail.MessagingException;


public class AccessRecords {
    private final Connection con;


    
    // requires connection
    // In order for this class to work. It needs to have a connection.
    public AccessRecords(Connection con) {
        this.con = con;
    }
    
    public void close() {   
        try {
            con.close();
        } catch (SQLException e) 
        { 
            e.printStackTrace();
        }
    }
    
    // Select all inventory
    public ResultSet showRecords(String statusOfRecords) {
        String query = "";
        switch(statusOfRecords){
            case "unconfirmed": query = "SELECT * FROM BOOKING_INFO WHERE STATUS_ID = 0";
                                break;
            case "confirmed": query = "SELECT * FROM BOOKING_INFO WHERE STATUS_ID = 1";
                                break;
            case "cancelled": query = "SELECT * FROM BOOKING_INFO WHERE STATUS_ID = 2";
                                break;
        }
        try{
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            return rs;
        } catch (SQLException ex) 
        {ex.printStackTrace();}
        return null;
    }
    
    // get all details of one item
    public BookingRecord getBookingRecord(int booking_id){
        String query = "SELECT * FROM BOOKING_INFO WHERE BOOKING_ID = ?";
        String room_type = "";
        String status_type = "";
        try(PreparedStatement ps = con.prepareStatement(
                query, 
                ResultSet.TYPE_SCROLL_INSENSITIVE, 
                ResultSet.CONCUR_UPDATABLE)
           ){
            ps.setInt(1, booking_id);
            
            try(ResultSet rs = ps.executeQuery();){
                rs.next();
                switch(rs.getInt("room_id"))
                {
                    case 1: room_type = "deluxe";
                            break;                         
                    case 2: room_type = "family";
                            break;    
                }
                switch(rs.getInt("status_id")) 
                {
                    case 0: status_type = "unconfirmed";
                            break;                         
                    case 1: status_type = "confirmed";
                            break;    
                    case 2: status_type = "cancelled";
                            break;  
                }
                return new BookingRecord(
                        booking_id,         
                        rs.getTimestamp("date_booked"),                   
                        rs.getString("name"),             
                        rs.getString("email"),              
                        rs.getString("phone_number"),              
                        rs.getString("country"),                  
                        room_type,
                        rs.getDate("start_booking"),
                        rs.getDate("end_booking"),
                        rs.getInt("number_of_days"),
                        rs.getDouble("cost"),
                        rs.getString("booking_code"),
                        status_type
                );
            }
        } catch (SQLException ex) 
        {ex.printStackTrace();}
        return null;
    }

//    private static boolean isInteger(String str) {
//        if (str == null) {
//            return false;
//        }
//        int length = str.length();
//        if (length == 0) {
//            return false;
//        }
//        int i = 0;
//        if (str.charAt(0) == '-') {
//            if (length == 1) {
//                return false;
//            }
//            i = 1;
//        }
//        for (; i < length; i++) {
//            char c = str.charAt(i);
//            if (c < '0' || c > '9') {
//                return false;
//            }
//        }
//        return true;
//    }

    //Update queries
    public void moveRecords(int[] bookingIDs, String status) throws SQLException, MessagingException{
        
        String statusToBeSwitchedTo = "";
        System.out.print("inside moveRecords() function");
        switch(status){
            //if it was an unconfirmed record, it will be updated to confirmed
            case "unconfirmed": statusToBeSwitchedTo = "1"; //1 means confirmed
                                loopThroughSuccessEmail(bookingIDs);
                break;
            //if it was an confirmed record, it will be updated to unconfirmed, probably means that the handler made a mistake in confirming
            case "confirmed": statusToBeSwitchedTo = "0";         //0 means unconfirmed
                              loopThroughHandlerErrorEmail(bookingIDs);
                break;
            case "cancelled": statusToBeSwitchedTo = "0";         //0 means unconfirmed
                break;
        }
        System.out.print("Status to be switched to is: " + statusToBeSwitchedTo);
        
        String updatequery = "UPDATE BOOKING_INFO SET STATUS_ID = ? WHERE BOOKING_ID = ?";
       
        try(PreparedStatement updateRecordStmt = con.prepareStatement(updatequery)){
            for(int i = 0; bookingIDs.length > i; i++){
                System.out.print("the bookingID being updated right now is: " + bookingIDs[i]);
                updateRecordStmt.setInt(1, Integer.parseInt(statusToBeSwitchedTo));
                updateRecordStmt.setInt(2, bookingIDs[i]);

                int updated = updateRecordStmt.executeUpdate();
                con.commit();
                System.out.println("Number of records updated are: " + updated);
            }
            
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    
    // uses a query to get the email of a customer based on booking_id
    public String getEmail (int bookingID) throws SQLException{
        String email = null;
        String getEmailQuery = "SELECT EMAIL FROM BOOKING_INFO WHERE BOOKING_ID = ?";
        System.out.println("Successfully emailed booking id:" + bookingID);
        PreparedStatement ps;
        ResultSet res;
        ps = con.prepareStatement(getEmailQuery);
        ps .setInt(1, bookingID);
        res = ps.executeQuery();
                    
        while(res.next())                                              
        {
          email = res.getString("EMAIL");
        }
         
        return email;
    }
     
    // iterates through the array of bookingIDs so we can email each customer
    public void loopThroughSuccessEmail(int[] bookingIDs) throws SQLException, MessagingException{
        String email;
        for(int i = 0; bookingIDs.length > i; i++){
           email = getEmail(bookingIDs[i]);
//         successEmail(email);  // Will be used in deployment
           successEmail("gilcruzada16@gmail.com"); // Placeholder onleh
        }
    }
    
    // iterates through the array of bookingIDs so we can email each customer about errors
    public void loopThroughHandlerErrorEmail(int[] bookingIDs) throws SQLException, MessagingException{
        String email;
        for(int i = 0; bookingIDs.length > i; i++){
           email = getEmail(bookingIDs[i]);
//         handlerErrorEmail(email);  // Will be used in deployment
           handlerErrorEmail("gilcruzada16@gmail.com"); // Placeholder onleh
        }
    }
    
    // emails the customer for a successful booking
    public void successEmail(String email) throws MessagingException{
        EmailSuccessBookingUtil.sendMail(email);
    }
    
     // emails the customer about potentialhandler error
    public void handlerErrorEmail(String email) throws MessagingException{
        EmailHandlerErrorUtil.sendMail(email);
    }
    
    //changing status to 'cancelled'
    public void deleteRecords(int[] bookingIDs){
        String updatequery = "UPDATE BOOKING_INFO SET STATUS_ID = ? WHERE BOOKING_ID = ?";
       
        try(PreparedStatement updateRecordStmt = con.prepareStatement(updatequery)){
            for(int i = 0; bookingIDs.length > i; i++){
                updateRecordStmt.setInt(1, 2);                                      //2 in status means "cancelled"
                updateRecordStmt.setInt(2, bookingIDs[i]);

                int updated = updateRecordStmt.executeUpdate();
                con.commit();
                System.out.println("Number of records updated are: " + updated);
            }
            
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    
    //truly deleting the 'cancelled' recordsrecords
    public void finalDeleteRecords(int[] bookingIDs){
        String deletequery = "DELETE FROM BOOKING_INFO WHERE STATUS_ID = ? AND BOOKING_ID = ?";
       
        try(PreparedStatement deleteRecordStmt = con.prepareStatement(deletequery)){
            for(int i = 0; bookingIDs.length > i; i++){
                deleteRecordStmt.setInt(1, 2);                                      //2 in status means "cancelled"
                deleteRecordStmt.setInt(2, bookingIDs[i]);

                int deleted = deleteRecordStmt.executeUpdate();
                con.commit();
                System.out.println("Number of records deleted are: " + deleted);
            }
            
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    
    //truly deleting all the 'cancelled' records
    public void finalDeleteAllRecords() {
        String deletequery = "DELETE FROM BOOKING_INFO WHERE STATUS_ID = ?";
       
        try(PreparedStatement deleteRecordStmt = con.prepareStatement(deletequery)) {
            deleteRecordStmt.setInt(1, 2);                                      //2 in status means "cancelled"

            int deleted = deleteRecordStmt.executeUpdate();
            con.commit();
            System.out.println("Number of records deleted are: " + deleted);
            
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    
    public ResultSet searchRecords(String status, String searchValue) {
        String searchquery = "";
        String statusToBeFiltered = "";
        int rtNum = 0;
        
        System.out.println("YOU'RE INSIDE searchRecords()!");
        System.out.println("status passed inside searchRecords() is " + status);
        
        switch(status){
            case "unconfirmed": statusToBeFiltered = "0";       //0 means unconfirmed
                break;
            case "confirmed": statusToBeFiltered = "1";         //1 means confirmed
                break;
            case "cancelled": statusToBeFiltered = "2";         //2 means cancelled
                break;
        }
        
        if(searchValue.equals("")) {
            System.out.println("SEARCH HAS NO INPUT");
            searchquery = "SELECT * FROM BOOKING_INFO WHERE STATUS_ID = ?";
            
            try {
                PreparedStatement searchRecordStmt = con.prepareStatement(searchquery);
                searchRecordStmt.setInt(1, Integer.parseInt(statusToBeFiltered));   
                
                ResultSet searched = searchRecordStmt.executeQuery();
                return searched;
            } catch (SQLException ex) {}
        } else {
            System.out.println("SEARCH HAS INPUT");
            searchquery = "SELECT * FROM BOOKING_INFO WHERE STATUS_ID = ? AND (NAME = ? OR EMAIL = ? OR PHONE_NUMBER = ? OR BOOKING_CODE = ?)";
            
            try {
                PreparedStatement searchRecordStmt = con.prepareStatement(searchquery);
                searchRecordStmt.setInt(1, Integer.parseInt(statusToBeFiltered));   
                searchRecordStmt.setString(2, searchValue);
                searchRecordStmt.setString(3, searchValue);
                searchRecordStmt.setString(4, searchValue);
                searchRecordStmt.setString(5, searchValue);
                ResultSet searched = searchRecordStmt.executeQuery();
                return searched;
            } catch (SQLException ex) {}
        }
        return null;
    }
    
    public ResultSet filterRecords(String status, String drFilter, String rtFilter) { 
        String filterquery = "";
        String statusToBeFiltered = "";
        int rtNum = 0;
        
        System.out.println("YOU'RE INSIDE filterRecords()!");
        switch(status){
            case "unconfirmed": statusToBeFiltered = "0";       //0 means unconfirmed
                break;
            case "confirmed": statusToBeFiltered = "1";         //1 means confirmed
                break;
        }
        switch(rtFilter){
            case "deluxe": rtNum = 1;                            //1 means deluxe
                break;
            case "family": rtNum = 2;                            //2 means family
                break;
        }
        
        if(rtFilter.equals("Select Room Type") && drFilter.equals("")) {
            System.out.println("FILTER HAS NO INPUT");
            filterquery = "SELECT * FROM BOOKING_INFO WHERE STATUS_ID = ?";
            try {
                PreparedStatement filterRecordStmt = con.prepareStatement(filterquery);
                filterRecordStmt.setInt(1, Integer.parseInt(statusToBeFiltered));   
                
                ResultSet filtered = filterRecordStmt.executeQuery();
                return filtered;
            } catch (SQLException ex) {}
        } else if(rtFilter.equals("Select Room Type")) {
            System.out.println("FILTER HAS NO ROOM TYPE INPUT");
            filterquery = "SELECT * FROM BOOKING_INFO WHERE STATUS_ID = ? AND DATE_BOOKED >= ?";
            try {
                PreparedStatement filterRecordStmt = con.prepareStatement(filterquery);
                filterRecordStmt.setInt(1, Integer.parseInt(statusToBeFiltered));   
                filterRecordStmt.setString(2, drFilter);
                
                ResultSet filtered = filterRecordStmt.executeQuery();
                return filtered;
            } catch (SQLException ex) {}
        } else if (drFilter.equals("")) {
            System.out.println("FILTER HAS NO DATE RECORDED INPUT");
            filterquery = "SELECT * FROM BOOKING_INFO WHERE STATUS_ID = ? AND ROOM_ID = ?";
            try {
                PreparedStatement filterRecordStmt = con.prepareStatement(filterquery);
                filterRecordStmt.setInt(1, Integer.parseInt(statusToBeFiltered));  
                filterRecordStmt.setInt(2, rtNum);
                ResultSet filtered = filterRecordStmt.executeQuery();
                return filtered;
            } catch (SQLException ex) {}
        } else {
            System.out.println("FILTER HAS BOTH FILTER INPUTS");
            filterquery = "SELECT * FROM BOOKING_INFO WHERE STATUS_ID = ? AND DATE_BOOKED >= ? AND ROOM_ID = ?";
            try {
                PreparedStatement filterRecordStmt = con.prepareStatement(filterquery);
                filterRecordStmt.setInt(1, Integer.parseInt(statusToBeFiltered));   
                filterRecordStmt.setString(2, drFilter);
                filterRecordStmt.setInt(3, rtNum);
                ResultSet filtered = filterRecordStmt.executeQuery();
                return filtered;
            } catch (SQLException ex) {}
        }
        
        return null;
    }
    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">    
    // 
    /* public void deleteRecord(int[] recordsToBeDeleted){
        String query = "DELETE FROM ITEM WHERE ITEM_ID IN"; 
        StringBuilder sb = new StringBuilder(query);
        
        // makes placing the "?" dynamic in query depending on items to be deleted
        sb.append("(");
        for(int i = 0; i < recordsToBeDeleted.length; i++){
            if(i+1 != recordsToBeDeleted.length)
                sb.append("?, ");
            else
                sb.append("?");   
        }
        sb.append(")");
        
        query = sb.toString();
        
        try(PreparedStatement ps = con.prepareStatement(query)){
            for(int i = 0; i < recordsToBeDeleted.length; i++){
                int id = recordsToBeDeleted[i];
                ps.setInt(i+1, id);
            }
            int result = ps.executeUpdate();
            System.out.print("NUMBER OF ROWS AFFECTED BY DELETION ["+result+"]");
        } catch (SQLException ex) 
        {ex.printStackTrace();}
    }*/ 
    //</editor-fold>
}