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
                <img src="../image/ER_logo_noBG(cropped).png">
            </div>

            <p class="h4 font-weight-bold dashboard">DASHBOARD</p>
            <ul class="list-unstyled components">
                <li class="active">
                    <a href="#homeSubmenu" data-toggle="collapse" aria-expanded="true"
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
                    <ul class="collapse list-unstyled show" id="pageSubmenu">
                        <li>
                            <form method="POST" action="<%= request.getContextPath()%>/ManageUsersServlet"
                                 class="pl-5 font-weight-light submenu-form sub-active" id="manageUsersForm">
                                <button class="submenu" id="manageUsers" name="status" value="manageUsers">Manage Users</button>
                            </form>
                        </li>
                        <li>
                            <form method="POST" action="<%= request.getContextPath()%>/ManageLogsServlet" 
                                  class="pl-5 font-weight-light submenu-form" id="manageLogsForm">
<!--                                <p class="submenu" id="manageUsers">Manage Users</p>-->
                                <button class="submenu" id="manageLogs" value="manageLogs">Handler Logs</button>
                            </form>
                        </li>
                    </ul>
                </li>
                <%  }%>
                <li class="logout-action">
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

                            <div class="row justify-content-between mt-3 w-100 ml-0 centeritems">
                                <div class="row col-sm-12 col-lg-10 pt-2 filterflex centeritems">
                                    <form method="POST" id="EditAccountsServlet" action="<%= request.getContextPath()%>/EditAccountsServlet"></form>
                                    <!--form class="w-100 filterflex"-->
                                        <!--button class="col-sm-12 col-lg-2 mt-sm-2 mt-lg-0 btn btn-actions">View</button-->
                                        <button id="removeButton" name="editAccountType" value="remove" class="col-sm-12 col-lg-3 mt-sm-2 mt-lg-0 btn btn-actions ml-0 ml-lg-2 marginleft marginbottom" 
                                                form="EditAccountsServlet">Remove Account
                                        </button>
                                    <!--/form-->
                                    
                                        <button onclick="togglePopup()" class="col-sm-12 col-lg-3 mt-sm-2 mt-lg-0 btn btn-actions ml-0 ml-lg-2 marginleft marginbottom">Change 
                                        Password</button>
                                        
                                        <button onclick="togglePopup1()" class="col-sm-12 col-lg-3 mt-sm-2 mt-lg-0 btn btn-actions ml-0 ml-lg-2 marginleft marginbottom">Add
                                        Account</button>
                                </div>
                            </div>

                            <%
                                String manageUserMsg = (String)session.getAttribute("error");  
                                if(manageUserMsg != null) { %>
                                    <div class="row justify-content-between mt-3 w-100 ml-0 centeritems">
                                        <div class="row col-sm-12 col-lg-10 pt-2 filterflex centeritems">
                                            <font color=red size=3px><%=manageUserMsg%></font>
                                        </div>
                                    </div>
                            <%  } %>
                               
                            <div class="content-block bg-light min-vh-100 w-100 mt-4">
                                <!-- Start of Accounts body -->
                                <section class="confirmed">
                                    <!--<form method="POST" id="item-form" action="<!--%= request.getContextPath()%>/ManageUsersServlet">-->
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
                                                    
                                                    ArrayList<Account> accounts = (ArrayList)session.getAttribute("accountsList");
                                                    int pageLimit = currentPage * 10;
                                                    int start = pageLimit - MAX_RECORDS_PER_PAGE;
                                                   
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
                                                            <td>
                                                                <input type="checkbox" name="userID" value="<%=id%>" form="EditAccountsServlet">
                                                            </td>
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
                                    <!--/form-->
                                <!-- End of Accounts Body -->
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Start of Change Password Pop Up -->
    <div class="popup" id="popup">
        <div class="overlay"></div>
        <div class="content">
            <div class="close-btn" onclick="togglePopup()">&times;</div>
            <div class="center">
                <!--form method="POST" action="<!--%= request.getContextPath()%>/EditAccountsServlet"-->
                    <label for="username">New Password</label>
                    <input type="password" id="cpNewPass" name="cpNewPass" title="Please input a strong password." 
                           onkeyup='cpCheck();' form="EditAccountsServlet" required>

                    <label for="psw">Confirm Password</label>
                    <input type="password" id="cpNewPassConf" name="cpNewPassConf" title="Must match with the given password above." 
                           onkeyup='cpCheck();' form="EditAccountsServlet" required>

                    <div>
                        <span id='cpMessage'></span>
                    </div>
                    
                    <button type="submit" id="changePassButton" class="action-button" 
                            name="editAccountType" value="change" form="EditAccountsServlet">CHANGE</button>
                <!--/form-->
            </div>
        </div>
    </div>
    <!-- End of Change Password Pop Up -->
    
    <!-- Start of Add Account Pop Up -->
    <div class="popup" id="popup-1">
        <div class="overlay"></div>
        <div class="content">
            <div class="close-btn" onclick="togglePopup1()">&times;</div>
            <div class="center">
                <form method="POST" id="AddAccountServlet" action="<%= request.getContextPath()%>/AddAccountServlet">
                    <label for="username">Username</label>
                    <input type="text"  id="username" name="username" required>

                    <label for="email">Email</label>
                    <input type="text"  id="email" name="email" required>
                    
                    <label for="password">Password</label>
                    <input type="password" id="addNewPass" name="addNewPass" title="Please input a strong password." onkeyup='aaCheck();' required>

                    <label for="confirmpassword1">Confirm Password</label>
                    <input type="password" id="addNewPassConf" name="addNewPassConf" title="Must match with the given password above." onkeyup='aaCheck();' required>
                    
                    <span id='aaMessage'></span>
                    
                    <div>
                        <button type="submit" id="addAccButton" class="action-button">ADD</button>
                    <div>
                <!--</form>-->
            </div>
        </div>
    </div>
    <!-- End of Add Account Pop Up -->
    
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

            document.getElementById("removeButton").addEventListener("click", function (event) {
                var numberOfChecked = $('input:checkbox:checked').length;
            
                console.log("YOU PRESSED REMOVE BUTTON");
                if(numberOfChecked === 0) {
                    alert("At least one checkbox has to be checked!"); 
                    event.preventDefault();
                } else {
                    console.log("one or more has been checked!");
                    document.forms["EditAccountsServlet"].submit();
                }
            });
            //onclick="atLeastOne()"
            document.getElementById("changePassButton").addEventListener("click", function (event) {
                if(document.getElementById("cpNewPass").value === document.getElementById('cpNewPassConf').value) {
                    console.log("YOU PRESSED CHANGE PASS BUTTON");
                    document.forms["EditAccountsServlet"].submit();
                } else {
                    event.preventDefault();
                }
            });
            
            document.getElementById("addAccButton").addEventListener("click", function (event) {
                if(document.getElementById("addNewPass").value === document.getElementById('addNewPassConf').value) {
                    console.log("YOU PRESSED ADD ACCOUNT BUTTON");
                    document.forms["AddAccountServlet"].submit();
                } else {
                    event.preventDefault();
                }
            });
        })();
    </script>
    
    <!-- Pop up -->
    <script>
        
        function cpCheck() {
            console.log("you're inside cpCheck");
            if (document.getElementById("cpNewPass").value === document.getElementById('cpNewPassConf').value) {
              document.getElementById('cpMessage').style.color = 'green';
              document.getElementById('cpMessage').innerHTML = 'Passwords match!';
            } else {
              document.getElementById('cpMessage').style.color = 'red';
              document.getElementById('cpMessage').innerHTML = 'Passwords don\'t match!';
            }
        }
        
        function aaCheck() {
            console.log("you're inside aaCheck");
            if (document.getElementById("addNewPass").value === document.getElementById('addNewPassConf').value) {
              document.getElementById('aaMessage').style.color = 'green';
              document.getElementById('aaMessage').innerHTML = 'Passwords match!';
            } else {
              document.getElementById('aaMessage').style.color = 'red';
              document.getElementById('aaMessage').innerHTML = 'Passwords don\'t match!';
            }
        }
        
        
        
        function atLeastOne() {
            var numberOfChecked = $('input:checkbox:checked').length;
            if (numberOfChecked === 0) {
               alert("At least one checkbox has to be checked!"); 
            } else {
                console.log("one or more has been checked!");
//                console.log("editButtonType is " + document.getElementsByName("editAccountType").value);
//                document.getElementsByName("editAccountType").value = "remove";
//                
//                console.log("editButtonType is " + document.getElementsByName("editAccountType").value);
                const form  = document.getElementById("EditAccountsServlet");

                form.submit();                
//                document.forms["EditAccountsServlet].submit();
            }
        }
        
        function togglePopup(){
            var numberOfChecked = $('input:checkbox:checked').length;
            console.log("total checked is: " + numberOfChecked);
            if(numberOfChecked > 1) {
                console.log("more than one was checked");
                alert("Only one checkbox should be checked!");                
            } else if(numberOfChecked === 0) { 
                console.log("less than one was checked");
                alert("One checkbox has to be checked!"); 
            } else {
                document.getElementById("popup").classList.toggle("active");
            }
        }
        
        function togglePopup1(){
            document.getElementById("popup-1").classList.toggle("active");
        }
    </script>
</body>

</html>