/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
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
public class FilterRecordsServlet extends HttpServlet {

    Connection con;
    static StringBuffer url;
    static String userDB, passDB;                                               // Username and Password from web.xml
    static String userArg, passArg, query;        
    
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
            throws ServletException, IOException {
        if(con != null){
                try {
                    AccessRecords record = new AccessRecords(con);
                    session = request.getSession();
                    String dateRecordedFilter = "";
                    String roomTypeFilter = "";
                    System.out.println("the date recorded from getParameter: " + request.getParameter("dateRecorded"));
//                    try {
//                        dateRecordedFilter = request.getParameter("dateRecorded").concat(" 00:00:00.00");
//                    } catch (IllegalArgumentException e) {
//                        e.printStackTrace();
//                        dateRecordedFilter = null;
//                        //dateRecordedFilter = "2022-01-01 00:00:00.00";
//                    }
                    
                    
                    try {
                        if(request.getParameter("dateRecorded").equals("")) {
                            System.out.println("dateRecorded is null");
                            dateRecordedFilter = "";
                        } else {
                            System.out.println("dateRecorded is not null");
                            dateRecordedFilter = request.getParameter("dateRecorded").concat(" 00:00:00.00");
                        }
                    } catch (NullPointerException npe) {
                        dateRecordedFilter = "";
                    }
                    System.out.println("dateRecordedFilter: " + dateRecordedFilter);
                    
                    
                    try {
                        if(request.getParameter("roomType").equals(null)) {
                            roomTypeFilter = "";
                        } else {
                            roomTypeFilter = request.getParameter("roomType");
                        }
                    } catch (NullPointerException npe) {
                        roomTypeFilter = "";
                    }
                    String statusRecords = request.getParameter("status");
                    
                    System.out.println("date recorded: " + dateRecordedFilter);
                    //System.out.println("check-in: " + checkInFilter);
                    //System.out.println("check-out: " + checkOutFilter);
                    System.out.println("room type: " + roomTypeFilter);
                    System.out.println("the status of the records you're trying to get is: " + statusRecords);
                    
                    
                    ResultSet rsFromFilter = record.filterRecords(statusRecords, dateRecordedFilter, roomTypeFilter);

                    session.setAttribute("rsFromFilter", rsFromFilter);
                    session.setAttribute("statusFromFilter", statusRecords);
                    response.sendRedirect("ManageRecordsServlet");
                    //allRecordsFromDB.close();
                    //record.close();  
                } catch(IOException e) {
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
