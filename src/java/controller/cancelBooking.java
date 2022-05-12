/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import static controller.loginServlet.u;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.MessagingException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Gil Cruzada
 */
public class cancelBooking extends HttpServlet {

    Connection con;
    static StringBuffer url;
    static String userDB, passDB;                                                       // Username and Password from web.xml
    static String query, dtbsCode, inputCode, updateQuery, getEmail, name, email;
    RequestDispatcher rd;
    
    public void init(ServletConfig config) throws ServletException 
    {
        super.init(config);
        try                                                                     
        {
            System.out.println("driver: " + config.getInitParameter("jdbcClassName"));
            System.out.println(config.getInitParameter("dbUserName"));
            
            
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
                    .append(config.getInitParameter("databaseName"));
            con = DriverManager.getConnection(url.toString(),userDB,passDB);  
        } 
        catch (SQLException sqle){ } 
        catch (ClassNotFoundException nfe){ }
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, MessagingException {

        try {
        if (con != null) {
   
                inputCode = request.getParameter("code");
                System.out.println("Code: " + inputCode);
                
                query = "SELECT * FROM BOOKING_INFO WHERE STATUS_ID = 0 AND BOOKING_CODE = ? ";    
                updateQuery = "UPDATE BOOKING_INFO SET STATUS_ID = 2 WHERE BOOKING_CODE = ? AND STATUS_ID = 0";
                getEmail = "SELECT NAME, EMAIL FROM BOOKING_INFO WHERE BOOKING_CODE = ?";
                
                PreparedStatement ps, uc, ge;
                ps = con.prepareStatement(query, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);   
                
                ps.setString(1, inputCode); 
                
                ResultSet res = ps.executeQuery();  
                
                //Gets stored data from the Database
                if(!res.next()){
                    System.out.println("No such booking code");
                    request.setAttribute("error", "Your booking has already been cancelled or Booking Code no longer exists!");
                    rd = request.getRequestDispatcher("/reservation.jsp");            
                    rd.include(request, response);
                    res.close();
                }
                
                else{
                    
                    System.out.println("Booking Code: " + inputCode + " exists!!");
                    uc = con.prepareStatement(updateQuery);
                    uc.setString(1, inputCode);
                    uc.executeUpdate();
                    
                    System.out.println("Booking Cancelled");
                    
                    ge = con.prepareStatement(getEmail);
                    ge.setString(1, inputCode);
                    res = ge.executeQuery();
                    
                    while(res.next())                                              
                    {
                        email = res.getString("EMAIL");
                        name = res.getString("NAME");
                    }
                    
                    System.out.println(email);
                    String forHandler = "<html> Dear Handler, <br> <br>"
                    + "The following customer , "+ name +", issue for cancellation has been processed. <br> <br>";
                    emailNotif("xoulx16@gmail.com", forHandler); // For test only
                    // emailNotif(email, forHandler); // This is for deployment
                    
                    String forCustomer = "<html> Hi "+ name +", <br> <br>"
                    + "We are sorry to hear from you about your booking cancellation. <br> <br>"
                    + "May you soon considder us again for all your resort needs. <br><br>"
                    + "Best Wishes, Eduardo's Resort "
                    + "</html>";
                    emailNotif("xoulx16@gmail.com", forCustomer);
                    
                    rd = request.getRequestDispatcher("/index.jsp");            
                    rd.include(request, response);
                }
             
            }
        }
        catch (SQLException sqle){ }
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
        try {
            processRequest(request, response);
        } catch (MessagingException ex) {
            Logger.getLogger(cancelBooking.class.getName()).log(Level.SEVERE, null, ex);
        }
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
        try {
            processRequest(request, response);
        } catch (MessagingException ex) {
            Logger.getLogger(cancelBooking.class.getName()).log(Level.SEVERE, null, ex);
        }
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
    
    public void emailNotif(String email, String ctnt) throws MessagingException {
        EmailCancellationUtil.sendMail(email, ctnt);
    }

}
