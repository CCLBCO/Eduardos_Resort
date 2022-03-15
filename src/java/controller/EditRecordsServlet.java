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
    private String path;
    
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
                    
                    String bookingIDs[] = request.getParameterValues("bookingID");
                    
                    if(bookingIDs.length == 0) {
                        
                    }
//                    ResultSet rs = record.showRecords(statusRecords);
//                    brList = new ArrayList<>();
//                    String status_type = "";
//                    int numberOfRecords = 0;
//                    while(rs.next()){
//                        switch(rs.getInt("status_id")) 
//                        {
//                            case 0: status_type = "unconfirmed";
//                                    break;                         
//                            case 1: status_type = "confirmed";
//                                    break;    
//                            case 2: status_type = "cancelled";
//                                    break;  
//                        }
//                        
//                        numberOfRecords++;
//                        System.out.println("the name of this record is " + rs.getString("name"));
//                    }
//
//                    session.setAttribute("brList", brList);
//
//                    System.out.println(numberOfRecords);

                    

                    
                    

                    //allRecordsFromDB.close();
                    //record.close();  

                    response.sendRedirect(path);

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