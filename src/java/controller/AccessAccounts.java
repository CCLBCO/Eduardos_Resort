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
        String query = "SELECT * FROM ACCOUNT";
        try{
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            ps.close();
            rs.close();
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

    
    public void changePassword(int accountIDToBeEdited, String newPassword){

        String updatequery = "UPDATE ACCOUNT SET PASSWORD = ? WHERE USER_ID = ?";
       
        try(PreparedStatement updateAccountStmt = con.prepareStatement(updatequery)){
            
            String encryptedPass = Security.encrypt(newPassword);
            updateAccountStmt.setString(1, encryptedPass);
            updateAccountStmt.setInt(2, accountIDToBeEdited);
            
            int updated = updateAccountStmt.executeUpdate();
            con.commit();
            
        } catch (SQLException ex) 
        {ex.printStackTrace();}
    }
    
    // delete function - done
    public void removeAccount(int[] accountsToBeDeleted){
        String deletequery = "DELETE FROM ACCOUNT WHERE USER_ID = ?";
        
        try(PreparedStatement deleteRecordStmt = con.prepareStatement(deletequery)){
            for(int i = 0; accountsToBeDeleted.length > i; i++){
                
                deleteRecordStmt.setInt(1, accountsToBeDeleted[i]);

                int deleted = deleteRecordStmt.executeUpdate();
                con.commit();
                System.out.println("Number of records deleted are: " + deleted);
            }
            
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    
    public void addAccount(String uname, String email, String addNewPass){
        String insertquery = "INSERT INTO APP.ACCOUNT (USERNAME, EMAIL, PASSWORD, ROLE) VALUES(?, ?, ?, ?)";    
        
        try(PreparedStatement insertRecordStmt = con.prepareStatement(insertquery)){
            
            String encryptedPass = Security.encrypt(addNewPass);
            insertRecordStmt.setString(1, uname);
            insertRecordStmt.setString(2, email);
            insertRecordStmt.setString(3, encryptedPass);
            insertRecordStmt.setString(4, "handler");
            
            int inserted = insertRecordStmt.executeUpdate();
            con.commit();
            System.out.println("Number of records deleted are: " + inserted);
            
            
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
}
