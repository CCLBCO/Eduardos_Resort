/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

import controller.Security;

/**
 *
 * @author admin
 */
public class Account {
    // 5 properties
    private int user_id;
    private String username;
    private String email;
    private String password;
    private String role;
    
    //constructors
    public Account(){}
    
    //setter constructor
    public Account(
        int user_id,
        String username, 
        String email,
        String password,
        String role)
    {
        this.user_id = user_id;
        this.username = username;
        this.email = email;
        this.password = password;
        this.role = role;
    }

    

    //setters
    public void setUsername(String username){
        this.username = username;  
    }
    public void setPassword(String password){
        String encryptedPass = Security.encrypt(password);
        this.password = encryptedPass; 
    }
    
    
    //getters
    public int getUserID(){
        return user_id;
    }
    public String getUsername(){
        return username;   
    }
    public String getEmail(){
        return email;
    }
    public String getPassword(){
        String decryptedPass = Security.decrypt(password);
        return decryptedPass;
    }
    public String getRole(){
        return role; 
    }
}
