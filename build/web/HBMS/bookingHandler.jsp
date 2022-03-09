<!DOCTYPE html>
<html lang="en">
<%  // Gets session object and throws user-defined SessionDestroyedException when the Session Attribute is not Created 
        if(session.getAttribute("sessionUser") == null)
        {
           //throw new SessionDestroyedException();
        }
       
        // Needed to Disable Back-tracking without Session
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Expires", "0");
%>
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
    <div class="main_content">
        <div class="header1">ACCOUNTS</div>
        <div class="header2">&nbsp&nbspMANAGE USERS</div>
        <div class="button flex">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
            <button class="btn-actions">View</button>
            <button class="btn-actions">Remove Account</button>
            <button class="btn-actions">Change Passsword</button>
            <button class="btn-actions">Add Account</button>
            <br>
            <br>
            <br>
        </div>
        <div class="box">
            <svg class="box w-100 h-500">
                <rect width="2000" height="650" style="fill:rgb(255, 255, 255);stroke-width:3;stroke:rgb(0,0,0)" />
            </svg>
        </div>
    </div>
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