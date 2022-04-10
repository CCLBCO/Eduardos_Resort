/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.MessagingException;
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
public class ForgotPasswordServlet extends HttpServlet {
    
    Connection con;
    static StringBuffer url;
    static String userDB, passDB;                                               // Username and Password from web.xml
    static String email, dbEmail, query;
    static int otp;
    RequestDispatcher rd;
    private HttpSession session;
    
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
                    .append(config.getInitParameter("databaseName"));
            con = DriverManager.getConnection(url.toString(),userDB,passDB);  
        } 
        catch (SQLException sqle){ } 
        catch (ClassNotFoundException nfe){ }
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, MessagingException {
        try{
            if(con != null){
                query = "SELECT * FROM ACCOUNTS WHERE EMAIL = ?";
                PreparedStatement ps = con.prepareStatement(query, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                // Inputs from Login Page
                email = request.getParameter("email");
                
                if (email.equals("")) {
                request.setAttribute("error","Please enter an email!");
                rd = request.getRequestDispatcher("forgotpassword.jsp");            
                rd.forward(request, response);
                }   
                
                ps.setString(1, email);                                       // puts the inputted username
                ResultSet res = ps.executeQuery();
                
                if(!res.next()){
                    System.out.println("Email does not exist!!");
                    request.setAttribute("error", "Your booking has already been cancelled or Booking Code no longer exists!");
                    res.close();
                    
                    request.setAttribute("error", "Email does not exist!");
                    rd = request.getRequestDispatcher("forgotpassword.jsp");            
                    rd.forward(request, response);
                }
                else{
                    System.out.println("Email exist!!");
                    
                    
                    otp = getOTP();
                    System.out.println(otp);
                    String forOTP = "<html> Dear Handler, <br> <br>"
                    + "Your OTP is: " + otp;
                    emailOTP(email, forOTP);
                    
                    session = request.getSession();
                    session.setAttribute("otpvalue", otp);
                    session.setAttribute("email", email);
                    
                    rd = request.getRequestDispatcher("/onetimepin.jsp");            
                    rd.forward(request, response);
                }
            }
        } catch (SQLException sqle){ }
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
        } catch (SQLException ex) {
            Logger.getLogger(ForgotPasswordServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (MessagingException ex) {
            Logger.getLogger(ForgotPasswordServlet.class.getName()).log(Level.SEVERE, null, ex);
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
        } catch (SQLException ex) {
            Logger.getLogger(ForgotPasswordServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (MessagingException ex) {
            Logger.getLogger(ForgotPasswordServlet.class.getName()).log(Level.SEVERE, null, ex);
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
    
    public void emailOTP(String email, String msg) throws MessagingException {
        EmailForgotPasswordUtil.sendMail(email, msg);
    }
    
    public int getOTP(){
        int otpvalue;
        // HttpSession mySession = request.getSession();]
        
        Random rand = new Random();
        otpvalue = rand.nextInt(1255650);
        return otpvalue;
    }

}
