/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import model.BookingRecord;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


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

    private static boolean isInteger(String str) {
        if (str == null) {
            return false;
        }
        int length = str.length();
        if (length == 0) {
            return false;
        }
        int i = 0;
        if (str.charAt(0) == '-') {
            if (length == 1) {
                return false;
            }
            i = 1;
        }
        for (; i < length; i++) {
            char c = str.charAt(i);
            if (c < '0' || c > '9') {
                return false;
            }
        }
        return true;
    }

    //Update queries
    public void moveRecords(int[] bookingIDs, String status){
        
        String statusToBeSwitchedTo = "";
        System.out.print("inside moveRecords() function");
        switch(status){
            //if it was an unconfirmed record, it will be updated to confirmed
            case "unconfirmed": statusToBeSwitchedTo = "1";       //1 means confirmed
                break;
            //if it was an confirmed record, it will be updated to unconfirmed, probably means that the handler made a mistake in confirming
            case "confirmed": statusToBeSwitchedTo = "0";         //0 means unconfirmed
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