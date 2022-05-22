/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import model.Account;
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


public class ManageUsersServlet extends HttpServlet {

    Connection con;
    static StringBuffer url;
    static String userDB, passDB;                                               // Username and Password from web.xml
    static String userArg, passArg, query;        
    
    private ArrayList<Account> accountsList;
    private HttpSession session;
    private String path;

    private int currentPage;
    private int MAX_RECORDS_PER_PAGE = 10;
    
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
        catch (SQLException sqle){ } 
        catch (ClassNotFoundException nfe){ }
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
                session = request.getSession();
        
        //session handler
        //if(session.getAttribute("userID") != null){
            if(con != null){
                try{
                    AccessAccounts accounts = new AccessAccounts(con);
                    session = request.getSession();
                    
                    ResultSet rs = accounts.showAccounts();
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

                    int maxPage = (int) Math.ceil(numberOfAccounts / Double.valueOf(MAX_RECORDS_PER_PAGE));
                    session.setAttribute("accountsList", accountsList);

                    // Overwrites the search, filter, and sort parameters.
                    /*session.setAttribute("searchView", search);
                    session.setAttribute("filterView", filter);
                    session.setAttribute("sortView", sort);*/
                    session.setAttribute("viewCurrentPageNumber", currentPage + "");
                    session.setAttribute("viewMaxPageNumber", maxPage + "");

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
        /*}else{
            request.setAttribute("msg", "Please login again");
            session.invalidate();
            //throw new SessionException();
        }   */
    }

    private boolean hasValue(String s) {
        if (s == null || s.trim().equals("") || s.isEmpty()) {
            return false;
        } 
        return true;
    }

    private String getValue(String reqParam, String sessParam, HttpServletRequest request, HttpSession session) {
        if (request.getParameter(reqParam) != null) {
            session.removeAttribute("viewCurrentPageNumber");
            return request.getParameter(reqParam);
        }
        else if (session.getAttribute(sessParam) != null) {
            return (String) session.getAttribute(sessParam);
        } else {
            return null;
        }        
    }

    private int getPageNumber(String changePage, String currentPage, HttpServletRequest request, HttpSession session) {
        if (session.getAttribute(currentPage) == null) {
            return 1;
        } else if (session.getAttribute(currentPage) != null && request.getParameter(changePage) != null) {
            int change = Integer.parseInt(request.getParameter(changePage));
            int currentPageNumber = Integer.parseInt((String)session.getAttribute(currentPage));
            return currentPageNumber + change;
        } else {
            return Integer.parseInt((String)session.getAttribute(currentPage));
        }       
    }

 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }


    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
