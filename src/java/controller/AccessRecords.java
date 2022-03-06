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

    //DML queries
    
    public void editStatus(BookingRecord recordStatusToBeUpdated){

        String updatequery = "UPDATE ITEM SET STATUS_ID = ? WHERE BOOKING_ID = ?";
       
        try(PreparedStatement updateRecordStmt = con.prepareStatement(updatequery)){
            
            /*switch(rs.getInt("room_id"))
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
            }*/
            updateRecordStmt.setString(1, recordStatusToBeUpdated.getStatus());
            
            
            int updated = updateRecordStmt.executeUpdate();
            con.commit();
            
        } catch (SQLException ex) 
        {ex.printStackTrace();}
    }
    
    // delete function - done
    public void deleteItems(int[] itemsToBeDeleted){
        String query = "DELETE FROM ITEM WHERE ITEM_ID IN"; 
        StringBuilder sb = new StringBuilder(query);
        
        // makes placing the "?" dynamic in query depending on items to be deleted
        sb.append("(");
        for(int i = 0; i < itemsToBeDeleted.length; i++){
            if(i+1 != itemsToBeDeleted.length)
                sb.append("?, ");
            else
                sb.append("?");   
        }
        sb.append(")");
        
        query = sb.toString();
        
        try(PreparedStatement ps = con.prepareStatement(query)){
            for(int i = 0; i < itemsToBeDeleted.length; i++){
                int id = itemsToBeDeleted[i];
                ps.setInt(i+1, id);
            }
            int result = ps.executeUpdate();
            System.out.print("NUMBER OF ROWS AFFECTED BY DELETION ["+result+"]");
        } catch (SQLException ex) 
        {ex.printStackTrace();}
    }
    
    public void addStock(int stockAdded){
    
    }
    
    public void reduceStock(int stockReduced){
    
    }
}
