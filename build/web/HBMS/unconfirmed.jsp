<%@page import="exceptions.SessionDestroyedException"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.sql.Date"%>
<%@page import="javax.mail.FetchProfile.Item"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.BookingRecord"%>
<%@page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // New HTTP
    response.setHeader("Pragma", "no-cache"); // Older HTTP
    response.setHeader("Expires", "0"); // Proxy Servers

    if(session.getAttribute("sessionUser") == null){
       throw new SessionDestroyedException();
    }
    // If a user that's not an admin logins and tries to access the admin.jsp it will throw an exception
    if(!session.getAttribute("role").equals("handler") && !session.getAttribute("role").equals("owner")){
        //throw new WrongAdminException();
     }
        

    final int MAX_RECORDS_PER_PAGE = 10;
    int currentPage = 1;    //TEMP VALUES
    String maxPage = "10";  //TEMP VALUES

    // Maintaining the search parameter.
    //String searchParameter = (String) session.getAttribute("searchView");
    //if (searchParameter == null) searchParameter = "";
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
                                class="pl-5 font-weight-light submenu-form sub-active" id="unconfirmedForm">
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
                            <form action="manageUsers.html" class="pl-5 font-weight-light submenu-form" id="manageUsersForm">
<!--                                <p class="submenu" id="manageUsers">Manage Users</p>-->
                                <button class="submenu" id="manageUsers" value="manageUsers">Manage Users</button>
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
                                <p class="h2 text-light font-weight-bold align-text-bottom">UNCONFIRMED RECORDS</p>
                                <form>
                                    <button id="generateExcel" class="btn btn-base ml-1 ml-lg-3">Generate Excel</button>
                                </form>
                            </div>
                            <div class="row mt-2 w-100 ml-0">
                                <select class="col-sm-12 mt-sm-2 mt-lg-0 col-lg-2 custom-select mr-sm-0 mr-lg-1">
                                    <option selected>Date Recorded</option>
                                    <option value="saab">Saab</option>
                                    <option value="opel">Opel</option>
                                    <option value="audi">Audi</option>
                                </select>
                                
                                <span class="flaticon-calendar"></span> <!--Check in date-->
                                <input class="inpbox" type="date" placeholder="Check-in Date" name="checkindate" required>
                                
                                <span class="flaticon-calendar"></span> <!--Check out date-->
                                <input class="inpbox" type="date" placeholder="Check-out Date" name="checkoutdate" required>
                                
                                <select class="col-sm-12 mt-sm-2 mt-lg-0 col-lg-2 custom-select">
                                    <option selected>Room</option>
                                    <option name="roomType" value="deluxe">Deluxe</option>
                                    <option name="roomType" value="family">Family</option>
                                </select>
                            </div>
                            <div class="row justify-content-between mt-3 w-100 ml-0">
                                <div class="row col-sm-12 col-lg-7 pt-2">
                                    <form class="w-100" method="POST" id="FilterRecordsServlet" action="<%= request.getContextPath()%>/FilterRecordsServlet">
                                        <button class="btn btn-base ml-1 ml-lg-3">Filter</button>
                                        <button class="btn btn-base ml-1 ml-lg-3">Reset</button>
                                    </form>
                                    <form class="w-100" method="POST" id="EditRecordsServlet" action="<%= request.getContextPath()%>/EditRecordsServlet">
                                        <!--button id="editButton" class="col-sm-12 col-lg-2 mt-sm-2 mt-lg-0 btn btn-actions ml-0 ml-lg-2" onclick="show_hide()">Edit</button-->
                                        <button type="submit" id="deleteButton" name="editType" value="delete"
                                            class="col-sm-12 col-lg-2 mt-sm-2 mt-lg-0 btn btn-actions ml-0 ml-lg-2">Delete</button>
                                        <button type="submit" id="moveButton" name="editType" value="move" 
                                            class="col-sm-12 col-lg-4 mt-sm-2 mt-lg-0 btn btn-actions ml-0 ml-lg-2">Move to Unconfirmed</button>
                                        <input type="hidden" name="status" value="confirmed" form="EditRecordsServlet">
                                    </form>
                                    <!--form method="POST" id="EditRecordsServlet" action="<%= request.getContextPath()%>/EditRecordsServlet" class="w-100 display-flex">
                                        <button class="filter-button">Filter</button>
                                        
                                        <div class="dropdown-edit">
                                            <button class="dropbtn" type="button" data-toggle="dropdown">Edit</button>
                                            <ul class="dropdown-edit-content">
                                                <li><a href="#">Delete</a></li>
                                                <li><a href="#">Move to Confirmed</a></li>
                                            </ul>
                                        </div>
                                    </form-->
                                </div>
                                <!--div class="row col-sm-12 col-lg-5 pt-2 justify-content-end">
                                    <form method="POST" action="" class="w-100 d-flex justify-content-end">
                                        <button class="col-sm-12 col-lg-5 btn btn-actions ml-0">Reset Filter</button>
                                        <button class="col-sm-12 col-lg-5 btn btn-actions ml-0 ml-md-3 mt-sm-2 mt-lg-0">Reset Order</button>
                                    </form>
                                </div-->
                            </div>
                            <div class="content-block bg-light min-vh-100 w-100 mt-4">
                                <!-- Start of Records body -->
                                <section class="unconfirmed">
                                    <!--form method="POST" id="edit-unconfirmed" action="<%= request.getContextPath()%>/EditRecordsServlet"-->
                                        <table id="unconfirmed-records" class="table table-responsive" data-toggle="table" data-search="true"
                                            data-filter-control="true" data-show-export="true"
                                            data-click-to-select="true" data-toolbar="#toolbar">
                                            <thead>
                                                <tr>
                                                    <th data-visible="true"></th><!-- will make the true or false a variable that toggle visibility when EDIT button is pressed-->
                                                    <!--th class="booking-id">ID</th-->
                                                    <th>Date Booked</th>
                                                    <th>Name</th>
                                                    <th>Email</th>
                                                    <th>Phone Number</th>
                                                    <th>Country</th>
                                                    <th>Room Type</th>
                                                    <th>Check In</th>
                                                    <th>Check Out</th>
                                                    <th>Cost</th>
                                                    <th>Booking Code</th>
                                                    <th></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                    //for double values like price
                                                    DecimalFormat df = new DecimalFormat("###,##0.00");
                                                    int pageLimit = currentPage * 10;
                                                    int start = pageLimit - MAX_RECORDS_PER_PAGE;
                                                    System.out.print("this is before the arraylist");
                                                    ArrayList<BookingRecord> records = (ArrayList)session.getAttribute("brList");
                                                    System.out.print("this is after the arraylist");
                                                    if(records.isEmpty()){
                                                        System.out.println("brList has nothing :((");
                                                    }
                                                    for (int i = start; i < pageLimit; i++)
                                                    {
                                                        if (i != records.size())
                                                        {
                                                            
                                                            BookingRecord record = records.get(i);
                                                            int id = record.getBookingId();
                                                            Timestamp date_booked = record.getDateBooked();
                                                            String name = record.getName();
                                                            String email = record.getEmail();
                                                            String phone_number = record.getPhoneNumber();
                                                            String country = record.getCountry();
                                                            String room_type = record.getRoomType();
                                                            Date start_booking = record.getStartBookingDate();
                                                            Date end_booking = record.getEndBookingDate();
                                                            double cost = record.getCost();
                                                            String booking_code = record.getBookingCode();        
                                                            System.out.println("this is the name: " + name);
                                                %>
                                                <tr class="details">
                                                    <td><input type="checkbox" name="bookingID" id="checkBox" value="<%=id%>" form="EditRecordsServlet"></td>
                                                    <!--td class="item-id"><%=id%></td-->
                                                    <td><%=date_booked%></td>
                                                    <td><%=name%></td>
                                                    <td><%=email%></td>
                                                    <td><%=phone_number%></td>
                                                    <td><%=country%></td>
                                                    <td><%=room_type%></td>
                                                    <td><%=start_booking%></td>
                                                    <td><%=end_booking%></td>
                                                    <td><%=df.format(cost)%></td>
                                                    <td><%=booking_code%></td>
                                                </tr>
                                                <%} else {
                                                        break;
                                                    }
                                                }%>
                                            </tbody>
                                        </table>
                                    <!--/form-->
                                <!-- End of Records Body -->
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

    <!-- Table2Excel JS -->
    <script src="table2excel.js"></script>
    
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

            document.getElementById("generateExcel").addEventListener("click", function () {
                console.log("YOU ARE INSIDE GENERATE EXCEL");
                var table2excel = new Table2Excel();
                table2excel.export(document.querySelectorAll("#unconfirmed-records"), "EduardosResort-Unconfirmed-Bookings");
            });
        })();
    </script>
</body>

</html>