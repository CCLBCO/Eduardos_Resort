package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class loginServlet extends HttpServlet {
    
    Connection con;
    static StringBuffer url;
    static String userDB, passDB;                                                       // Username and Password from web.xml
    static String userArg, passArg, query, tempU, tempP, u, p, r, n, decryptedPass;   
    HttpSession session; // userArg & passArg from Input
    RequestDispatcher rd;
                                      
    public void init(ServletConfig config) throws ServletException 
    {
        super.init(config);
        try                                                                     
        {
            System.out.println("driver: " + config.getInitParameter("jdbcClassName"));
            System.out.println(config.getInitParameter("dbUserName"));
            System.out.println(config.getInitParameter("dbPassword"));
            
            
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
            System.out.println(config.getInitParameter("url"));
           
        } 
        catch (SQLException sqle){ } 
        catch (ClassNotFoundException nfe){ }
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException
    {
        try 
        {   // We need to not add PASS=? because the program cannot continue if the password is already wrong
            query = "SELECT * FROM account WHERE USERNAME = ?";                  
            PreparedStatement ps = con.prepareStatement(query);                    
            
            // Inputs from Login Page
            userArg = request.getParameter("username");
            passArg = request.getParameter("password");
            String gRecaptchaResponse = request.getParameter("g-recaptcha-response");
           
//		boolean verify = VerifyCaptcha.verify(gRecaptchaResponse);
                boolean verify = true;
                System.out.println("Response: " + verify);
  
            // Checks for Blank Username and Password
            if (userArg.equals("") || passArg.equals(""))
            {
                request.setAttribute("error","Username or Password is Blank!");
                rd = request.getRequestDispatcher("/login.jsp");            
                rd.include(request, response);
            }
            
            if (con != null) {            
                //DB Wrapper Object
                ps.setString(1, userArg);                                       // puts the inputted username
                ResultSet res = ps.executeQuery();                              // executes the given query and its arguments

                // Stores Data from the Database
                while(res.next())                                              
                {
                    u = res.getString("USERNAME");
                    p = res.getString("PASSWORD");
                    r = res.getString("ROLE");
                }
                
                ps.close();
                res.close();
                decryptedPass = Security.decrypt(p); //decrypted password from database
      
                if(userArg.equals(u) && passArg.equals(decryptedPass)){
                    if(!verify){
                       request.setAttribute("error", "reCaptcha is Mandatory!");
                       rd = request.getRequestDispatcher("/login.jsp");            
                       rd.include(request, response);
                   }
                    else {
                        // Session Attribute to Destroy Later after Logout
                        session = request.getSession();
                        //session.setAttribute("uname", userArg); // no need to show name of who logged in

                        session.setAttribute("sessionUser", userArg);
                        session.setAttribute("role", r);
                        session.setAttribute("user", u);
                        response.sendRedirect("bookingManagement");
                    }
                }
                
                 // Errors 1-3 throws user-defined AuthenticationException
                else if (userArg.equals(u))                                           
                {
                    if(passArg.equals(""))
                    {
                        request.setAttribute("error","Password is Blank!");
                        rd = request.getRequestDispatcher("/login.jsp");            
                        rd.include(request, response);
                    }
                    else if(!passArg.equals(decryptedPass))
                    {
                        request.setAttribute("error", "Incorrect Password!");
                        rd = request.getRequestDispatcher("/login.jsp");            
                        rd.include(request, response);
                    }
                }
                
                else {
                    request.setAttribute("error", "Username does not exist!");
                    rd = request.getRequestDispatcher("/login.jsp");            
                    rd.include(request, response);
                }
            }
            con.close();
        } 
        catch (SQLException sqle){ 
        } finally {
            con.close();
        } 
    }

 @Override
 public void doGet(HttpServletRequest request, HttpServletResponse response)
 throws IOException, ServletException{
     doPost(request, response);
     
 }

@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(loginServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}