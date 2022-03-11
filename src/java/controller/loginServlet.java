package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
        {   // We need to not add PASS=? because the program cannot continue if the password is already wrong
            query = "SELECT * FROM ACCOUNTS WHERE USERNAME = ?";                  
            PreparedStatement ps = con.prepareStatement(query, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);                    
            
            // Inputs from Login Page
            userArg = request.getParameter("username");
            passArg = request.getParameter("password");
            String gRecaptchaResponse = request.getParameter("g-recaptcha-response");
		System.out.println("Response: " + gRecaptchaResponse);
		// boolean verify = VerifyCaptcha.verify(gRecaptchaResponse);
  
            // Checks for Blank Username and Password
//            if (userArg.equals("") && passArg.equals(""))
//            {
//                // throw new NullValueException();
//            }
            if (con != null) 
            {            
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
                
                decryptedPass = Security.decrypt(p); //decrypted password from database
      
                 // Errors 1-3 throws user-defined AuthenticationException
                if (!userArg.equals(u))                                           
                {
                    if(passArg.equals(""))
                    {
                        request.setAttribute("msg", " Username is Incorrect and Password is Blank!");
                        // throw new AuthenticationException();
                    }
                    else if(!passArg.equals(decryptedPass))
                    {
                        request.setAttribute("msg", "Username and Password are Both Incorrect!");
                        // throw new AuthenticationException();
                    }
                }
                else if (userArg.equals(u) && !passArg.equals(decryptedPass))
                {
                    request.setAttribute("msg", "Username is Correct but Incorrect Password!");
                    // throw new AuthenticationException();
                }
                else
                {
                   // Session Attribute to Destroy Later after Logout
                   session = request.getSession();
                   res = ps.executeQuery();
                   //session.setAttribute("uname", userArg); // no need to show name of who logged in
         
                        session.setAttribute("sessionUser", userArg);
                        session.setAttribute("role", r);
                        response.sendRedirect("bookingManagement");
                }
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
}
