/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import static controller.ManageRecordsServlet.userDB;
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
import model.BookingRecord;

/**
 *
 * @author admin
 */
public class EditRecordsServlet extends HttpServlet {

    Connection con;
    static StringBuffer url;
    static String userDB, passDB;                                               // Username and Password from web.xml
    static String userArg, passArg, query;        
    
    private ArrayList<BookingRecord> brList;
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
        
            if(con != null){
                try{
                    AccessRecords record = new AccessRecords(con);
                    session = request.getSession();
                    
                    String editButtonType = request.getParameter("editType");
                    String statusRecords = request.getParameter("status");
                    
                    System.out.println("the edit type you're trying to do is: " + editButtonType);
                    System.out.println("the status of the records you're trying to get is: " + statusRecords);
                    
                    String bookIDs[] = request.getParameterValues("bookingID"); //array of booking IDs that had their boxes checked
                    System.out.println("the number of records that have been checked: "+ bookIDs.length);
                    int[] bookingIDs = new int[bookIDs.length];
                    
                    for(int i = 0; bookIDs.length > i; i++){
                        System.out.println("inside loop");
                        System.out.println("the number of IDs being converted: "+ (i + 1));
                        bookingIDs[i] = Integer.parseInt(bookIDs[i]);
                    }
                    
                    if(bookingIDs.length == 0) {
                        //pop alert something in front end
                        System.out.println("there is no record that has been checked");
                    } else if(bookingIDs.length >= 1) {
                        System.out.println("bookingIDs length is greater than or equal to one!");
                        switch(editButtonType){
                            case "delete": record.deleteRecords(bookingIDs);
                                break;
                            case "move":  record.moveRecords(bookingIDs, statusRecords);
                                break;
                        }
                    }
                    
                    session.setAttribute("statusFromEdit", statusRecords);
                    response.sendRedirect("ManageRecordsServlet");
                    //allRecordsFromDB.close();
                    //record.close();  
                } catch(IOException e) {
                    e.printStackTrace();
                }
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

    

    

