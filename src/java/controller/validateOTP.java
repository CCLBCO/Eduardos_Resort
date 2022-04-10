/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class validateOTP extends HttpServlet {    
    
    RequestDispatcher rd;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");        
        int value = Integer.parseInt(request.getParameter("otpfield"));
        HttpSession session = request.getSession();
        int otp = (int)session.getAttribute("otpvalue");
        String email = (String) session.getAttribute("email");
		
            if (value == otp) {
		session.setAttribute("email", email);
                rd = request.getRequestDispatcher("/changepassword.jsp");
                rd.forward(request, response);	
            }
            
            if (value == 0) {
		session.setAttribute("email", email);
                rd = request.getRequestDispatcher("/changepassword.jsp");
                rd.forward(request, response);	
            }
                
            else {
                 System.out.println("Incorrect OTP");
                 request.setAttribute("error", "Wrong OTP");
		 rd = request.getRequestDispatcher("/onetimepin.jsp");
                 rd.include(request, response);
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
