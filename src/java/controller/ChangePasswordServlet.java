/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Gil Cruzada
 */
public class ChangePasswordServlet extends HttpServlet {
   Connection con;
   static StringBuffer url;
   static String userDB, passDB, passArg, passConfArg, u, p, decryptPass, updatePassQuery, email, encryptPass;  
   RequestDispatcher rd;
   HttpSession session; 

   @Override
    public void init(ServletConfig config) throws ServletException 
    {
        super.init(config);
        try                                                                     
        {
            // Getting the Parameters for the Connection
            Class.forName(config.getInitParameter("jdbcClassName"));
            userDB = config.getInitParameter("dbUserName");
            passDB = config.getInitParameter("dbPassword");

            //StringBuffer is used to make the string changeable
            url = new StringBuffer(config.getInitParameter("jdbcDriverURL"))
                    .append("://")
                    .append(config.getInitParameter("dbHostName"))
                    .append(":")
                    .append(config.getInitParameter("dbPort"))
                    .append("/")
                    .append(config.getInitParameter("databaseName"))
                    .append(config.getInitParameter("ssl"));
            con = DriverManager.getConnection(url.toString(),userDB,passDB);  
        } 
        catch (SQLException | ClassNotFoundException sqle){ }
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
         try{
               if(con != null){

                   passArg = request.getParameter("password");
                   passConfArg = request.getParameter("passConf");
                   session = request.getSession();
                   
                   email = (String) session.getAttribute("email");
                   System.out.println("email is: " + email);
                   PreparedStatement ps;
                   
                   // For Updating Password
                   updatePassQuery = "UPDATE ACCOUNT SET PASSWORD = ? WHERE EMAIL = ?";
                   
                   // if new password and confirm password does not match
                   if(!passConfArg.equals(passArg)){
                       request.setAttribute("error", "Password Does not Match!!");
                       rd = request.getServletContext().getRequestDispatcher("/changepassword.jsp");            
                       rd.include(request, response);
                   }
                   else{
                      
                       encryptPass = Security.encrypt(passArg);
                       ps = con.prepareStatement(updatePassQuery);
                       ps.setString(1, encryptPass);
                       ps.setString(2, email);
                       ps.executeUpdate();
                       System.out.println("Password has been updated with: " + passArg);
                       session.removeAttribute("email");
                       session.removeAttribute("otpvalue");
                       session.invalidate();
                       rd = request.getServletContext().getRequestDispatcher("/login.jsp");
                       rd.forward(request, response);
                   }
 
                }
               
            }
            catch(SQLException sqle){}
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
