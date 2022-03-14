/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import model.Account;
import controller.Security;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class AccessAccounts {
    private final Connection con;


    
    // requires connection
    // In order for this class to work. It needs to have a connection.
    public AccessAccounts(Connection con) {
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
    public ResultSet showAccounts() {
        String query = "SELECT * FROM ACCOUNTS";
        try{
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            return rs;
        } catch (SQLException ex) 
        {ex.printStackTrace();}
        return null;
    }
    
    // get all details of one item
    public Account getAccount(int user_id){
        String query = "SELECT * FROM ACCOUNTS WHERE USER_ID = ?";
       
        try(PreparedStatement ps = con.prepareStatement(
                query, 
                ResultSet.TYPE_SCROLL_INSENSITIVE, 
                ResultSet.CONCUR_UPDATABLE)
           ){
            ps.setInt(1, user_id);
            
            try(ResultSet rs = ps.executeQuery();){
                rs.next();
                
                return new Account(
                        user_id,         
                        rs.getString("username"),                   
                        rs.getString("email"),             
                        rs.getString("password"),              
                        rs.getString("role")
                );
            }
        } catch (SQLException ex) 
        {ex.printStackTrace();}
        return null;
    }

    
    public void editAccount(Account accountToBeEdited, String newPassword){

        String updatequery = "UPDATE ACCOUNTS SET PASSWORD = ? WHERE USER_ID = ?";
       
        try(PreparedStatement updateAccountStmt = con.prepareStatement(updatequery)){
            
            String encryptedPass = Security.encrypt(newPassword);
            updateAccountStmt.setString(1, encryptedPass);
            
            int updated = updateAccountStmt.executeUpdate();
            con.commit();
            
        } catch (SQLException ex) 
        {ex.printStackTrace();}
    }
    
    // delete function - done
    public void deleteAccount(int[] accountsToBeDeleted){
        
    }
    
    public void addAccount(int stockAdded){
    
    }
}
