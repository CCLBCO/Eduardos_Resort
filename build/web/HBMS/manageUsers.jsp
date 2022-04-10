<%@page import="exceptions.SessionDestroyedException"%>
<%@page import="exceptions.NotOwnerException"%>
<%@page import="javax.mail.FetchProfile.Item"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Account"%>
<!DOCTYPE html>
<html>
<%  // Gets session object and throws user-defined SessionDestroyedException when the Session Attribute is not Created 
        if(session.getAttribute("sessionUser") == null)
        {
           throw new SessionDestroyedException();
        }
        // If a user that's not an owner logins and tries to access the admin.jsp it will throw an exception
        if(!session.getAttribute("role").equals("owner")){
            throw new NotOwnerException();
        }
        
        final int MAX_RECORDS_PER_PAGE = 10;
        int currentPage = 1;    //TEMP VALUES
        String maxPage = "10";  //TEMP VALUES
        
        // Needed to Disable Back-tracking without Session
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Expires", "0");
%>

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
                <img src="../image/ER_logo_noBG.png">
            </div>

            <p class="h4 font-weight-bold dashboard">DASHBOARD</p>
            <ul class="list-unstyled components">
                <li class="active">
                    <a href="#homeSubmenu" data-toggle="collapse" aria-expanded="true"
                        class="dropdown-toggle font-weight-bold">BOOKING</a>

                    <ul class="list-unstyled collapse show" id="homeSubmenu">
                        <li>
                            <form method="POST" action="<%= request.getContextPath()%>/ManageRecordsServlet"
                                class="pl-5 font-weight-light submenu-form" id="unconfirmedForm">
                                <button class="submenu" id="unconfirmed" name="status" value="unconfirmed">Unconfirmed Records</button>
                            </form>
                        </li>
                        <li>
                            <form method="POST" action="<%= request.getContextPath()%>/ManageRecordsServlet"
                                class="pl-5 font-weight-light submenu-form sub-active" id="confirmedForm">
                                <button class="submenu" id="confirmed" name="status" value="confirmed">Confirmed Records</button>
                            </form>
                        </li>
                        <li>
                            <form method="POST" action="<%= request.getContextPath()%>/ManageRecordsServlet"
                                class="pl-5 font-weight-light submenu-form" id="cancelledbookings">
                                  <button class="submenu" id="cancelled" name="status" value="confirmed">Cancelled Records</button>
                            </form>
                        </li>
                    </ul>
                </li>
                <%
                if(!session.getAttribute("role").equals("admin")) {%>
                <li>
                    <a href="#pageSubmenu" data-toggle="collapse" aria-expanded="false"
                        class="dropdown-toggle font-weight-bold">ACCOUNTS</a>
                    <ul class="collapse list-unstyled" id="pageSubmenu">
                        <li>
                            <form method="POST" action="<%= request.getContextPath()%>/ManageUsersServlet"
                                 class="font-weight-light text-center" id="manageUsersForm">
                                <button class="submenu" id="manageUsers" name="status" value="manageUsers">Manage Users</button>
                            </form>
                        </li>
                    </ul>
                </li>
                <%  }%>
                <li class="logout-action1">
                    <form method="POST" action="<%= request.getContextPath()%>/logoutServlet"
                         class="font-weight-light text-center">
                                <button class="btn btn-base logout text-center" id="logout">LOG OUT</button>
                    </form>
                </li>
            </ul>
        </nav>

        <!-- Page Content  -->
        <div id="content">
            <nav class="navbar navbar-expand-lg bg-light">
                <div class="container-fluid">
                    <button type="button" id="sidebarCollapse" class="btn btn-light">
                        <img src="https://img.icons8.com/ios-glyphs/30/000000/menu--v1.png" />
                    </button>
                </div>
            </nav>

            <div class="content-body h-100 pt-5">
                <div class="container mt-sm-5 mt-lg-2">
                    <div class="row p-5">
                        <div class="w-100">
                            <div class="row ml-0">
                                <p class="h2 text-light font-weight-bold align-text-bottom">MANAGE USERS</p>
                            </div>

                            <div class="row justify-content-between mt-3 w-100 ml-0">
                                <div class="row col-sm-12 col-lg-10 pt-2">
                                    <form method="POST" action="" class="w-100">
                                        <!--button class="col-sm-12 col-lg-2 mt-sm-2 mt-lg-0 btn btn-actions">View</button-->
                                        <button
                                            class="col-sm-12 col-lg-3 mt-sm-2 mt-lg-0 btn btn-actions ml-0 ml-lg-2">Remove
                                            Account</button>
                                        <button
                                            class="col-sm-12 col-lg-3 mt-sm-2 mt-lg-0 btn btn-actions ml-0 ml-lg-2">Change
                                            Password</button>
                                        <button
                                            class="col-sm-12 col-lg-3 mt-sm-2 mt-lg-0 btn btn-actions ml-0 ml-lg-2">Add
                                            Account</button>
                                    </form>
                                </div>
                            </div>

                            <div class="content-block bg-light min-vh-100 w-100 mt-4">
                                <!-- Start of Accounts body -->

                                <form method="POST" id="fetchItem"></form>
                                <section class="confirmed">
                                    <form method="POST" id="item-form" action="ManageUsersServlet">
                                        <table class="table table-responsive" data-toggle="table" data-search="true"
                                            data-filter-control="true" data-show-export="true"
                                            data-click-to-select="true" data-toolbar="#toolbar">
                                            <thead>
                                                <tr>
                                                    <th></th>
                                                    <th class="user_id">ID</th>
                                                    <th>Username</th>
                                                    <th>Email</th>
                                                    <th>Password</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                    System.out.print("this is before the arraylist");
                                                    ArrayList<Account> accounts = (ArrayList)session.getAttribute("accountsList");
                                                    int pageLimit = currentPage * 10;
                                                    int start = pageLimit - MAX_RECORDS_PER_PAGE;
                                                    System.out.print("this is after the arraylist");
                                                    if(accounts.isEmpty()){
                                                        System.out.println("accountList has nothing :((");
                                                    }
                                                    
                                                    for (int i = start; i < pageLimit; i++)
                                                    {
                                                        if (i != accounts.size())
                                                        {
                                                            Account account = accounts.get(i);
                                                            int id = account.getUserID();
                                                            String username = account.getUsername();
                                                            String email = account.getEmail();
                                                            String password = account.getPassword();
                                        %>
                                                        <tr class="details">
                                                            <td data-visible="false"><input type="checkbox" name="user_id" value="<%=id%>"</td>
                                                            <td class="accountID"><%=id%></td>
                                                            <td><%=username%></td>
                                                            <td><%=email%></td>
                                                            <td><%=password%></td>
                                                        </tr>
                                            <%         } else {
                                                           break;
                                                       }
                                                    }
                                         %>
                                            </tbody>
                                        </table>
                                    </form>
                                <!-- End of Accounts Body -->
                            </div>
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

</html>