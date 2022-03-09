<%@page import="java.sql.Timestamp"%>
<%@page import="java.sql.Date"%>
<%@page import="javax.mail.FetchProfile.Item"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.BookingRecord"%>
<%@page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
    <%
        /*response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // New HTTP
        response.setHeader("Pragma", "no-cache"); // Older HTTP
        response.setHeader("Expires", "0"); // Proxy Servers
        
        // If no session, then redirect to index.
        if(session.getAttribute("user") == null)
        {
            System.out.println("The session doesn't exist, User " + session.getAttribute("userID"));
            response.sendRedirect(request.getContextPath() +"/index");
        }*/
        
        final int MAX_RECORDS_PER_PAGE = 10;
        //int currentPage = Integer.parseInt((String) session.getAttribute("viewCurrentPageNumber"));
        //String maxPage = (String) session.getAttribute("viewMaxPageNumber");
        int currentPage = 1;    //TEMP VALUES
        String maxPage = "10";  //TEMP VALUES
        
        // Maintaining the search parameter.
        //String searchParameter = (String) session.getAttribute("searchView");
        //if (searchParameter == null) searchParameter = "";
    %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Eduardo's Resort</title>
    <link rel="stylesheet" href="hbms.css">
    <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
    <script src="https://kit.fontawesome.com/b99e675b6e.js"></script>
    
    
</head>

<body>
    <div class="sidebar">
        <nav class="text">
            <p class="center">Eduardo's Resort</p>
            <ul>
                <li>
                    <h3 class="center">Dashboard</h3>
                <li class="active">
                    <a href="#" class="feat-btn"> Bookings
                        <span class="fas fa-caret-down first rotate"></span>
                    </a>
                    <ul class="feat-show show">
                        <!-- need to make this into form tags-->
                        <!--li><a href="unconfirmed.jsp" class="selected">Unconfirmed</a></li>
                        <li><a href="confirmed.jsp">Confirmed</a></li-->
                        <li>
                            <form method="POST" action="<%= request.getContextPath()%>/ManageRecordsServlet">
                                <button class="center" type="submit" name="status" value="unconfirmed">Unconfirmed Records</button>
                            </form>
                        </li>
                        <li>
                            <form method="POST" action="<%= request.getContextPath()%>/ManageRecordsServlet">
                                <button class="center" type="submit" name="status" value="confirmed">Confirmed Records</button>
                            </form>
                        </li>

                    </ul>
                </li>
                <%
                    if(!session.getAttribute("role").equals("admin")) {%>
                        <li>
                            <a href="#" class="serv-btn"> Accounts
                                <span class="fas fa-caret-down second"></span>
                            </a>
                            <ul class="serv-show">
                                <!--li><a href="manageUsers.jsp">Manage Users</a></li-->
                                <li>
                                    <form method="POST" action="<%= request.getContextPath()%>/ManageUsersServlet">
                                        <button class="center" type="submit" >Manage Users</button>
                                    </form>
                                </li>
                            </ul>
                        </li>
                <%  }%>
                <li>
                    <form method="POST" action="<%= request.getContextPath()%>/logoutServlet">
                        <input class="center" type="submit" value="LOG OUT">
                    </form>
                </li>
            </ul>
        </nav>
    </div>
   

    <!-- JS-->
    <script>
        $('.feat-btn').click(function () {
            $('nav ul .feat-show').toggleClass("show");
            $('nav ul .first').toggleClass("rotate");
        });
        $('.serv-btn').click(function () {
            $('nav ul .serv-show').toggleClass("show1");
            $('nav ul .second').toggleClass("rotate");
        });
        $('nav ul li').click(function () {
            $(this).addClass("active").siblings().removeClass("active");
        });
    </script>

</body>

</html>