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
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.MessagingException;
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
    
    private String path;
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
            throws ServletException, IOException, MessagingException {
            session = request.getSession();
            boolean checkboxesNull = false;
            if(con != null){
                try {
                    AccessRecords record = new AccessRecords(con);
                    session = request.getSession();
                    
                    String editButtonType = request.getParameter("editType");
                    String statusRecords = request.getParameter("status");
                    
                    System.out.println("the edit type you're trying to do is: " + editButtonType);
                    System.out.println("the status of the records you're trying to get is: " + statusRecords);
                    
                    String bookIDs[] = request.getParameterValues("bookingID"); //array of booking IDs that had their boxes checked
                    int[] bookingIDs = null;
                    
                    try {
                        System.out.println("the number of records that have been checked: "+ bookIDs.length);
                        bookingIDs = new int[bookIDs.length];
                    
                        for(int i = 0; bookIDs.length > i; i++){
                            System.out.println("inside loop");
                            System.out.println("the number of IDs being converted: "+ (i + 1));
                            bookingIDs[i] = Integer.parseInt(bookIDs[i]);
                        }
                    } catch (NullPointerException npe) {
                        System.out.println("the delete all function must have been pressed so no checkboxes are required to be checked");
                        record.finalDeleteAllRecords();
                        checkboxesNull = true;
                    }
                    
                    //if the above did not catch NullPointerException, the following code will continue to run since there were checkboxes clicked
                    //and even if there were checkboxes clicked and the DELETE ALL button was pressed, there is still a switch case for that
                    if(!checkboxesNull && bookingIDs.length == 0) {
                        //pop alert something in front end
                        System.out.println("there is no record that has been checked");
                    } else if(!checkboxesNull && bookingIDs.length >= 1) {
                        System.out.println("bookingIDs length is greater than or equal to one!");
                        switch(editButtonType){
                            case "delete": record.deleteRecords(bookingIDs, statusRecords);
                                break;
                            case "move":  record.moveRecords(bookingIDs, statusRecords);
                                break;
                            case "trueDelete":  record.finalDeleteRecords(bookingIDs);
                                break;
                            case "trueDeleteAll":  record.finalDeleteAllRecords();
                                break;
                        }
                    }
                    
                    //The following code is to reload the page with the (probably) updated set of records
                    System.out.println("the status of the records you're trying to get that has been edited: " + statusRecords);
                    
                    ResultSet rs = record.showRecords(statusRecords);
                    
                    brList = new ArrayList<>();
                    String room_type = "";
                    String status_type = "";
                    int numberOfRecords = 0;
                    while(rs.next()){
                        switch(rs.getInt("room_id"))
                        {
                            case 1: room_type = "deluxe";
                                    break;                         
                            case 2: room_type = "family";
                                    break;    
                        }
                        switch(rs.getInt("status_id")) 
                        {
                            case 0: status_type = "unconfirmed";
                                    break;                         
                            case 1: status_type = "confirmed";
                                    break;    
                            case 2: status_type = "cancelled";
                                    break;  
                        }
                        brList.add(
                            new BookingRecord(
                            rs.getInt("booking_id"),         
                            rs.getTimestamp("date_booked"),                   
                            rs.getString("name"),             
                            rs.getString("email"),              
                            rs.getString("phone_number"),              
                            rs.getString("country"),                  
                            room_type,
                            rs.getDate("start_booking"),
                            rs.getDate("end_booking"),
                            rs.getInt("number_of_days"),
                            rs.getDouble("cost"),
                            rs.getString("booking_code"),
                            status_type)
                        );
                        numberOfRecords++;
                        System.out.println("the name of this record is " + rs.getString("name"));
                    }

                    session.setAttribute("brList", brList);

                    System.out.println("The number of records: " + numberOfRecords);

                    //redirect based on status records
                    if(statusRecords.equalsIgnoreCase("unconfirmed")){
                        path = request.getContextPath() + "/HBMS/unconfirmed.jsp";
                    } else if (statusRecords.equalsIgnoreCase("confirmed")) {
                        path = request.getContextPath() + "/HBMS/confirmed.jsp";
                    } else {
                        path = request.getContextPath() + "/HBMS/cancelled.jsp";
                    }

                    //allRecordsFromDB.close();
                    //record.close();  

                    response.sendRedirect(path);
                    
                    //allRecordsFromDB.close();
                    //record.close();  
                } catch(SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    
        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (MessagingException ex) {
            Logger.getLogger(EditRecordsServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        }

        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (MessagingException ex) {
            Logger.getLogger(EditRecordsServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        }

        @Override
        public String getServletInfo() {
            return "Short description";
        }// </editor-fold>
    }

    

    

