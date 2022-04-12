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
import model.BookingRecord;

/**
 *
 * @author admin
 */
public class EditAccountsServlet extends HttpServlet {

    Connection con;
    static StringBuffer url;
    static String userDB, passDB;                                               // Username and Password from web.xml
    static String userArg, passArg, query;        
    
    private String path;
    private ArrayList<Account> accountsList;
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
            if(con != null){
                try {
                    AccessAccounts account = new AccessAccounts(con);
                    session = request.getSession();
                    
                    String editAccountType = request.getParameter("editType");
                    
                    System.out.println("the edit type you're trying to do is: " + editAccountType);
                    
                    String accIDs[] = request.getParameterValues("bookingID"); //array of booking IDs that had their boxes checked
                    int[] accountIDs = null;
                    
                    
                    System.out.println("the number of records that have been checked: "+ accountIDs.length);
                    accountIDs = new int[accIDs.length];

                    try {
                        System.out.println("the number of records that have been checked: "+ accountIDs.length);
                        accountIDs = new int[accIDs.length];
                    
                        for(int i = 0; accIDs.length > i; i++){
                            System.out.println("inside loop");
                            System.out.println("the number of IDs being converted: "+ (i + 1));
                            accountIDs[i] = Integer.parseInt(accIDs[i]);
                        }
                    } catch (NullPointerException npe) {
                        System.out.println("the add account function must have been pressed so no checkboxes are required to be checked");
                        //Account account = new Account(request.getParameter("user_id"), 
                        //                  request.getParameter("username"), 
                        //                  request.getParameter("email"),  
                        //                  request.getParameter("password"), 
                        //                  "handler");
                        //account.addAccount(account);
                        checkboxesNull = true;
                    }
                    
                    
                    //if the above did not catch NullPointerException, the following code will continue to run since there were checkboxes clicked
                    //and even if there were checkboxes clicked and the DELETE ALL button was pressed, there is still a switch case for that
                    if(accountIDs.length == 0) {
                        //pop alert something in front end
                        System.out.println("there is no account that has been checked");
                    } else if(accountIDs.length >= 1) {
                        System.out.println("accountIDNums length is greater than or equal to one!");
                        
                        if (editAccountType.equals("remove")) {
                            account.removeAccount(accountIDs);
                        } else if (editAccountType.equals("changePassword")) {
                            if(accountIDs.length == 1) {
                                if(request.getParameter("newPass").equals(request.getParameter("confirmNewPass"))){
                                    account.changePassword(accountIDs[0], request.getParameter("confirmNewPass"));
                                } 
                            } else {
                                //tell user to check only one checkbox
                            }
                        } else {
                            //Account account = new Account(request.getParameter("user_id"), 
                                //                  request.getParameter("username"), 
                                //                  request.getParameter("email"),  
                                //                  request.getParameter("password"), 
                                //                  "handler");
                            //account.addAccount(account);
                        }
                       
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

                } catch(SQLException e)
                {
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
