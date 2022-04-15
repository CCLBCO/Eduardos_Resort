/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import static controller.EditAccountsServlet.userDB;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Account;

/**
 *
 * @author admin
 */
public class AddAccountServlet extends HttpServlet {
    
    Connection con;
    static StringBuffer url;
    static String userDB, passDB;                                               // Username and Password from web.xml
    static String userArg, passArg, query;        
    
    private String path;
    private ArrayList<Account> accountsList; 
    private String username, email, addNewPass, addNewPassConf;
    private HttpSession session;
    
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
                    .append(config.getInitParameter("databaseName"));
            con = DriverManager.getConnection(url.toString(),userDB,passDB);  
        } 
        catch (SQLException sqle){ } 
        catch (ClassNotFoundException nfe){ }
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        session = request.getSession();
            boolean checkboxesNull = false;
            System.out.println("YOU ARE INSIDE ADD ACCOUNTS SERVLET");
            if(con != null){
                try {
                    AccessAccounts account = new AccessAccounts(con);
                    session = request.getSession();
                    
                    
                    username = request.getParameter("username");
                    email = request.getParameter("email");
                    addNewPass = request.getParameter("addNewPass");
                    addNewPassConf = request.getParameter("addNewPassConf");                  
                        
                    if(request.getParameter("addNewPass").equals(request.getParameter("addNewPassConf"))){
                        account.addAccount(username, email, addNewPassConf);
                    } 
                            
                    //The following code is to reload the page with the (probably) updated set of records
                    session = request.getSession();
                    
                    ResultSet rs = account.showAccounts();
                    accountsList = new ArrayList<>();
                    
                    int numberOfAccounts = 0;
                    while(rs.next()){                        
                        accountsList.add(
                            new Account(
                            rs.getInt("user_id"),                     
                            rs.getString("username"),             
                            rs.getString("email"),              
                            rs.getString("password"),              
                            rs.getString("role")
                            )
                        );
                        numberOfAccounts++;
                        System.out.println("the name of this account is " + rs.getString("username"));
                    }

                    session.setAttribute("accountsList", accountsList);

                    System.out.println(numberOfAccounts);

                    session.setAttribute("accountsList", accountsList);

                    //redirect 
                    path = request.getContextPath() + "/HBMS/manageUsers.jsp";

                    //allRecordsFromDB.close();
                    //record.close();  

                    response.sendRedirect(path);

            } catch(SQLException e) {
                e.printStackTrace();
            }
        }
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
