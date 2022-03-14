package controller;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import static org.apache.commons.text.CharacterPredicates.DIGITS;
import static org.apache.commons.text.CharacterPredicates.LETTERS;
import org.apache.commons.text.RandomStringGenerator;

public class ReservationServlet extends HttpServlet {
    
    Connection con;
    static StringBuffer url;
    static String userDB, passDB;                                                       // Username and Password from web.xml
    static String query, tempU, tempP, u, p, r, n, pckupDate,
            drpDate, cstmName, email, country, phnNumber, randomizedCode, dateString; 
    LocalDate parsedPckDate, parsedDropDate;
    long days, cost;
    int status_id = 0;
    int roomType, convCost, convDays;
    Date convPckDate, convDropDate;
    Timestamp currentDate;
    HttpSession session; // userArg & passArg from Input
                                      
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
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        try 
        {     
            if (con != null) 
            {   
                // Inputs from Reservation Page
                currentDate = Timestamp.valueOf(LocalDateTime.now());
                System.out.println(currentDate);
                roomType = Integer.parseInt(request.getParameter("rooms"));
                System.out.println(roomType);
                pckupDate = request.getParameter("pckupDate");
                System.out.println(pckupDate);
                drpDate = request.getParameter("drpDate");
                System.out.println(drpDate);
                cstmName = request.getParameter("cstmName");
                System.out.println(cstmName);
                email = request.getParameter("email");
                System.out.println(email);
                phnNumber = request.getParameter("phnNumber");
                System.out.println(phnNumber);
                country = request.getParameter("country");
                System.out.println(country);

                parsedPckDate = LocalDate.parse(pckupDate);
                parsedDropDate = LocalDate.parse(drpDate);
                
                convPckDate = convertToDateViaSqlDate(parsedPckDate);
                convDropDate = convertToDateViaSqlDate(parsedDropDate);

                convDays = getDaysInBetween(parsedPckDate, parsedDropDate);
                System.out.println("Days in between: " + convDays);
                convCost = getCost(convDays);
                System.out.println(convCost);
                
                randomizedCode = generateCode(7);
                System.out.println(randomizedCode);

                PreparedStatement ps; 
                // We need to not add PASS=? because the program cannot continue if the password is already wrong
                query = "INSERT INTO APP.BOOKING_INFO (DATE_BOOKED, NAME, EMAIL, PHONE_NUMBER, COUNTRY, "
                        + "ROOM_ID, START_BOOKING, END_BOOKING, NUMBER_OF_DAYS, COST, BOOKING_CODE,"
                        + "STATUS_ID) "
                        + "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";    
                
                ps = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
                ps.setTimestamp(1, currentDate);
                ps.setString(2, cstmName);
                ps.setString(3, email);
                ps.setString(4, phnNumber);
                ps.setString(5, country);
                ps.setInt(6, roomType);
                ps.setDate(7, convPckDate);
                ps.setDate(8, convDropDate);
                ps.setInt(9, convDays);
                ps.setInt(10, convCost);
                ps.setString(11, randomizedCode);
                ps.setInt(12, status_id);
                ps.executeUpdate();
                con.commit();
                ps.close();

            }
        } 
        catch (SQLException sqle){ }
    }

 @Override
 public void doGet(HttpServletRequest request, HttpServletResponse response)
 throws IOException, ServletException{
     doPost(request, response);
     
 }

@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    public Date convertToDateViaSqlDate(LocalDate dateToConvert) {
    return java.sql.Date.valueOf(dateToConvert);
    }
    
    public int getCost(int days) {
        if(roomType == 1){
                    convCost = days * 2500;
                }
                else {
                    convCost = days * 3500;
                }
    return convCost;
    }
    
    public int getDaysInBetween(LocalDate pPD, LocalDate dDD) {  
        days = ChronoUnit.DAYS.between(pPD, dDD);
    return convDays = Math.toIntExact(days);
    }
    
    public String generateCode(int digits) {
        RandomStringGenerator generator = new RandomStringGenerator.Builder()
                    .withinRange('0', 'Z')
                    .filteredBy(LETTERS, DIGITS)
                    .build();
                
    randomizedCode = generator.generate(digits);        
    return randomizedCode;
    }
    
}
