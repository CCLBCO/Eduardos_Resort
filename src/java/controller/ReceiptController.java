/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
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
public class ReceiptController extends HttpServlet {

 
    Connection con;
    static StringBuffer url;
    static String userDB, passDB;                                                       // Username and Password from web.xml
    static String query, tempU, tempP, u, p, r, n, pckupDate,
            drpDate, cstmName, email, country, phnNumber, randomizedCode, dateString, convRoom
            ;
    LocalDate parsedPckDate, parsedDropDate;
    long days, cost;
    int status_id = 0;
    int roomType, convCost, convDays;
    Date convPckDate, convDropDate;
    Timestamp currentDate;
    HttpSession session; // userArg & passArg from Input
    RequestDispatcher rd;
    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        try {
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
                    .append(config.getInitParameter("databaseName"))
                    .append(config.getInitParameter("ssl"));
            con = DriverManager.getConnection(url.toString(), userDB, passDB);
        } catch (SQLException sqle) {
        } catch (ClassNotFoundException nfe) {
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, MessagingException {

        try {
            if (con != null) {
                // ask if a session exists
                HttpSession session = request.getSession(false);

                randomizedCode = (String) session.getAttribute("code");
                System.out.println("Code: " + randomizedCode);
                query = "SELECT * FROM ctdd4m5zgklkh9rv.booking_info WHERE BOOKING_CODE = ?";
                PreparedStatement ps, fh;
                
                ps = con.prepareStatement(query);
                ps.setString(1, randomizedCode);

                ResultSet res = ps.executeQuery();
                //Gets stored data from the Database
                while (res.next()) {
                    roomType = res.getInt("ROOM_ID");
                    cstmName = res.getString("NAME");
                    convPckDate = res.getDate("START_BOOKING");
                    convDropDate = res.getDate("END_BOOKING");
                    email = res.getString("EMAIL");
                    phnNumber = res.getString("PHONE_NUMBER");
                    convCost = res.getInt("COST");
                    country = res.getString("COUNTRY");
                }

                convRoom = getRoomType(roomType);
                request.setAttribute("room", convRoom);
                request.setAttribute("name", cstmName);
                request.setAttribute("arrivalDate", dateFormat.format(convPckDate));
                request.setAttribute("departDate", dateFormat.format(convDropDate));
                request.setAttribute("email", email);
                request.setAttribute("code", randomizedCode);
                request.setAttribute("phone", phnNumber);
                request.setAttribute("cost", String.valueOf(convCost));
                request.setAttribute("country", country);
                ps.close();
                res.close();
                
                confirmNotif(email, cstmName);

                String forHandler = "<html> Hi Handler, <br> <br>"
                        + "The following customer has issued a reservation. Details are as follows: <br> <br>"
                        + "Name: " + cstmName + "<br>"
                        + "Email: " + email + "<br>"
                        + "Phone Number: " + phnNumber + "<br>"
                        + "Country: " + country + "<br><br>"
                        + "For further details about check-in and check-out time you may visit the HBMS.";

                String queryForHandler = "SELECT EMAIL FROM account";
                fh = con.prepareStatement(queryForHandler);
                res = fh.executeQuery();
                
                String fhEmail;
                // Stores Data from the Database
                while (res.next()) {
                    fhEmail = res.getString("email");
                    System.out.println("Notif for handler reached!!");
                    handlerConfirmNotif(fhEmail, forHandler);
                }

                rd = request.getServletContext().getRequestDispatcher("/receipt.jsp");
                rd.include(request, response);

            }
        } catch (SQLException sqle) {
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (MessagingException ex) {
            Logger.getLogger(ReceiptController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (MessagingException ex) {
            Logger.getLogger(ReceiptController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public String getRoomType(int roomType) {
        if (roomType == 1) {
            return "Family Room";
        } else {
            return "Deluxe Room";
        }

    }

    public void confirmNotif(String email, String name) throws MessagingException, IOException {
        EmailConfirmationUtil.sendMail(email, name);
    }

    public void handlerConfirmNotif(String email, String msg) throws MessagingException {
        EmailReservationHandlerUtil.sendMail(email, msg);
    }

}
