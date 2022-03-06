/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Admin
 */
public class bookingManagement extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            
            // Validates the session object so we can separate the users and admins and organize session management
            
            HttpSession session = request.getSession(false);
            // We set the session to false to stop further the creation of session objects
            
            RequestDispatcher view;
            String roleArg = (String)session.getAttribute("role");
            
            System.out.println("Role: " + roleArg);

            // If there is a session object the user is dispatched to their profile which is based on their role
            if(session.getAttribute("sessionUser") != null){
                if(roleArg.equals("manager")){
//                view = request.getRequestDispatcher("HBMS/manageUsers.jsp");
//                view.forward(request, response); 
                response.sendRedirect("HBMS/resortOwner.jsp");
                }
            
                else if (roleArg.equals("admin")){
//                view = request.getRequestDispatcher("HBMS/confirmed.jsp");
//                view.forward(request, response); 
                response.sendRedirect("HBMS/bookingHandler.jsp");
                }
            }
            
            // If the session object is null the user is forwaded back to the landing page when they accessed it using backtrack
            else{
                response.sendRedirect("Eduardos_Resort/login.jsp");
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