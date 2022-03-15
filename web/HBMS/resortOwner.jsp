<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.sql.Date"%>
<%@page import="javax.mail.FetchProfile.Item"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.BookingRecord"%>
<%@page import="java.text.DecimalFormat"%>

<!DOCTYPE html>

<%  // Gets session object and throws user-defined SessionDestroyedException when the Session Attribute is not Created 
        if(session.getAttribute("sessionUser") == null)
        {
           //throw new SessionDestroyedException();
        }
        
        // If a user that's not an admin logins and tries to access the admin.jsp it will throw an exception
        if(!session.getAttribute("role").equals("owner")){
            //throw new WrongAdminException();
        }
        
        final int MAX_RECORDS_PER_PAGE = 10;
        
        int currentPage = 1;    //TEMP VALUES
        String maxPage = "10";  //TEMP VALUES
        
        // Needed to Disable Back-tracking without Session
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Expires", "0");
     %>

<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Eduardo's Resort</title>

    <!-- Bootstrap CSS CDN -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">

    <!-- Our Custom CSS -->
    <link rel="stylesheet" href="hbms.css">
</head>

<body>
    <div class="wrapper">
        <!-- Sidebar  -->
        <nav id="sidebar">
            <div class="sidebar-header">
                <h3 class="text-center"><span class="text-danger">Eduardo's</span><span class="text-warning"> Resort</span></h3>
            </div>

            <p class="h4 font-weight-bold dashboard">DASHBOARD</p>
            <ul class="list-unstyled components">
                <li class="active">
                    <a href="#homeSubmenu" data-toggle="collapse" aria-expanded="false"
                        class="dropdown-toggle font-weight-bold">BOOKING</a>

                    <ul class="list-unstyled collapse" id="homeSubmenu">
                        <li>
                            <form method="POST" action="<%= request.getContextPath()%>/ManageRecordsServlet"
                                class="pl-5 font-weight-light submenu-form" id="unconfirmedForm">
                                  <button class="submenu" id="unconfirmed" name="status" value="unconfirmed">Unconfirmed Records</button>
                            </form>
                        </li>
                        <li>
                            <form method="POST" action="<%= request.getContextPath()%>/ManageRecordsServlet"
                                class="pl-5 font-weight-light submenu-form" id="confirmedForm">
                                  <button class="submenu" id="confirmed" name="status" value="confirmed">Confirmed Records</button>
                            </form>
                        </li>
                    </ul>
                </li>
                <%
                if(!session.getAttribute("role").equals("handler")) {%>
                <li>
                    <a href="#pageSubmenu" data-toggle="collapse" aria-expanded="false"
                        class="dropdown-toggle font-weight-bold">ACCOUNTS</a>
                    <ul class="collapse list-unstyled" id="pageSubmenu">
                        <li>
                            <form method="POST" action="<%= request.getContextPath()%>/ManageUsersServlet"
                                class="pl-5 font-weight-light submenu-form" id="manageUsersForm">
                                <button class="submenu" id="manageUsersForm" value="manageUsers">Manage Users</button>
                            </form>
                        </li>
                    </ul>
                </li>
                <%  }%>
                <li class="logout-action">
                    <form method="POST" action="<%= request.getContextPath()%>/logoutServlet"
                        class="font-weight-light text-center">
                        <button class="btn btn-base logout text-center" id="logout">LOGOUT</button>
                    </form>
                </li>
            </ul>
        </nav>

        <div id="content">
            <nav class="navbar navbar-expand-lg bg-light">
                <div class="container-fluid">
                    <button type="button" id="sidebarCollapse" class="btn btn-light">
                        <img src="https://img.icons8.com/ios-glyphs/30/000000/menu--v1.png"/>
                    </button>
                </div>
            </nav>

            <!-- welcome logo -->
            <div class="content-body h-100 pt-5">
                <div class="container mt-sm-5 mt-lg-2">
                    <div class="row">
                        <div class="w-100">
                            <img src="../image/welcome.png" class="w-100" alt="welcome">
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- JQUERY -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>

    <!-- Popper.JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"></script>

    <!-- Bootstrap JS -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>

    <!-- JQuery script for sidebar toggle -->
    <script type="text/javascript">
        (function () {
            document.getElementById("sidebarCollapse").addEventListener("click", function () {
                var element = document.getElementById("sidebar").classList.toggle("active");
            });

            document.getElementById("unconfirmed").addEventListener("click", function () {
                document.forms["unconfirmedForm"].submit();
            });

            document.getElementById("confirmed").addEventListener("click", function () {
                document.forms["confirmedForm"].submit();
            });

            document.getElementById("manageUsers").addEventListener("click", function () {
                document.forms["manageUsersForm"].submit();
            });

        })();
    </script>
</body>