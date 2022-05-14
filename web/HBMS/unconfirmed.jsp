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
        
    String user = (String)session.getAttribute("user");
        
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
    
    <!-- Icon -->
    <script src="https://kit.fontawesome.com/2237df38d7.js" crossorigin="anonymous"></script>
    
</head>

<body>
    <div class="wrapper">
        <!-- Sidebar  -->
        <nav id="sidebar">
            <div class="sidebar-header">
                <img src="../image/ER_logo_noBG(cropped).png">
            </div>

            <p class="h4 font-weight-bold dashboard">DASHBOARD</p>
            <div>
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
                        <li>
                            <form method="POST" action="<%= request.getContextPath()%>/ManageRecordsServlet"
                                class="pl-5 font-weight-light submenu-form" id="cancelledbookings">
                                  <button class="submenu" id="cancelled" name="status" value="cancelled">Cancelled Records</button>
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
<!--                                <p class="submenu" id="manageUsers">Manage Users</p>-->
                                <button class="submenu" id="manageUsers" value="manageUsers">Manage Users</button>
                            </form>
                        </li>
                    </ul>
                </li>
                <%  }%>
            </ul>
            </div>
            
            <div class="logout-action">
                <form method="POST" action="<%= request.getContextPath()%>/logoutServlet"
                    class="font-weight-light text-center">
                        <button class="btn btn-base logout text-center" id="logout">LOG OUT</button>
                </form>
            </div>
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
                            <div class="row ml-0 centeritems">
                                <p class="h2 text-light font-weight-bold align-text-bottom">UNCONFIRMED RECORDS</p>
                                <form>
                                    <button id="generateExcel" class="btn btn-base ml-1 ml-lg-3">Generate Excel</button>
                                </form>
                            </div>
                            <div class="row mt-2 w-100 ml-0">
                                <!--select class="col-sm-12 mt-sm-2 mt-lg-0 col-lg-2 custom-select mr-sm-0 mr-lg-1">
                                    <option selected>Date Recorded</option>
                                    <option value="saab">Saab</option>
                                    <option value="opel">Opel</option>
                                    <option value="audi">Audi</option>
                                </select-->
                                
                                <label for="bday" class="paddingtopbday">From Date Recorded:</label>
                                <span class="flaticon-calendar"></span> <!--Date Recorded onwards-->
                                <input class="inpbox samplewidth1" type="date" placeholder="Date Recorded" name="dateRecorded" form="FilterRecordsServlet">
                                
<!--                                <label for="bday">Check In:</label>
                                <span class="flaticon-calendar"></span> 
                                <input class="inpbox" type="date" placeholder="Check In Date" name="checkIn" form="FilterRecordsServlet">
                                
                                
                                <label for="bday">Check Out:</label>
                                <span class="flaticon-calendar"></span> 
                                <input class="inpbox" type="date" placeholder="Check Out Date" name="checkOut" form="FilterRecordsServlet">
-->
                            </div>
                            <div class="row mt-2 w-100 ml-0 samplewidth">
                                <label for="room" class="paddingtoproom">Room: </label>
                                <select class="col-sm-12 mt-sm-2 mt-lg-0 col-lg-2 custom-select margintop" name="roomType" form="FilterRecordsServlet">
                                    <option selected form="FilterRecordsServlet">Select Room Type</option>
                                    <option value="deluxe" form="FilterRecordsServlet">Deluxe</option>
                                    <option value="family" form="FilterRecordsServlet">Family</option>
                                </select>
                            </div>
                            <div class="row justify-content-between mt-3 w-100 ml-0 centeritems">
                                <div class="row col-sm-12 col-lg-7 pt-2 filterflex1">
                                    <form class="w-100 filterflex1" method="POST" id="FilterRecordsServlet" action="<%= request.getContextPath()%>/FilterRecordsServlet">
                                        <button class="btn btn-base ml-1 ml-lg-3 marginleft marginbottom" name="filterType" value="filter">Filter</button>
                                        <button class="btn btn-base ml-1 ml-lg-3 marginleft marginbottom" name="filterType" value="reset">Reset</button>
                                        <input type="hidden" name="status" value="unconfirmed" form="FilterRecordsServlet"><!-- IMPORTANT FOR GETTING CONFIRMED RECORDS ONLY -->
                                    </form>
                                    <form class="w-100 filterflex1" method="POST" id="EditRecordsServlet" action="<%= request.getContextPath()%>/EditRecordsServlet"></form>
                                    <!--button id="editButton" class="col-sm-12 col-lg-2 mt-sm-2 mt-lg-0 btn btn-actions ml-0 ml-lg-2" onclick="show_hide()">Edit</button-->
                                    <button onclick="toggleDeleteWarning()" class="col-sm-12 col-lg-2 mt-sm-2 mt-lg-0 btn btn-actions ml-0 ml-lg-2 marginleft marginbottom1">Delete</button>
                                    <button onclick="toggleMoveWarning()" class="col-sm-12 col-lg-4 mt-sm-2 mt-lg-0 btn btn-actions ml-0 ml-lg-2 marginleft marginbottom1">Move to Confirmed</button>
                                    <input type="hidden" name="status" value="unconfirmed" form="EditRecordsServlet">
                                    <input type="hidden" name="username" value="<%=user%>" form="EditRecordsServlet">                                    
                                </div>
                                        
                                <div class="topnav">
                                    <div class="search-container">
                                        <form method="POST" action="<%= request.getContextPath()%>/FilterRecordsServlet">
                                            <input type="text" placeholder="Search" name="searchValue">
                                            <input type="hidden" name="status" value="unconfirmed">
                                            <button type="submit" name="filterType" value="search"><i class="fa-solid fa-magnifying-glass"></i></button>
                                        </form>
                                    </div>
                                </div>
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
                                                    <th>Last Edit By</th>
                                                    <th>Last Edit Time</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                    //for double values like price
                                                    DecimalFormat df = new DecimalFormat("###,##0.00");
                                                    int start = 0;
                                                    System.out.print("this is before the arraylist");
                                                    ArrayList<BookingRecord> records = (ArrayList)session.getAttribute("brList");
                                                    System.out.print("this is after the arraylist");
                                                    if(records.isEmpty()){
                                                        System.out.println("brList has nothing :((");
                                                    }
                                                    for (int i = start; i < records.size(); i++)
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
                                                            String last_edited_by = record.getLastEditedBy();
                                                            Timestamp last_edited_time = record.getLastEditedTime();
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
                                                    <td><%=last_edited_by%></td>
                                                    <td><%=last_edited_time%></td>
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

    <!-- Start of Delete Warning Pop Up -->
    <div class="popup" id="deletepopup">
        <div class="overlay"></div>
        <div class="content">
            <div class="close-btn" onclick="toggleDeleteWarning()">&times;</div>
            <div class="center">
                <img src="../image/warning-orange.png" style="max-height: 180px; max-width: 180px;">
                <label>Are you sure about deleting these records? This will send an email that the customer's booking was discontinued.</label>
                <!--<button onclick="toggleDeleteWarning()" class="action-button">CHECK AGAIN</button>-->    
                <label style="color: red; font-size:10px;">(exit if you want to check again)</label>
                <button type="submit" id="deleteButton" class="action-button" name="editType" value="delete" form="EditRecordsServlet">YES</button>
            </div>
        </div>
    </div>
    <!-- End of Delete Warning Password Pop Up -->
    
    <!-- Start of Move Warning Pop Up -->
    <div class="popup" id="movepopup">
        <div class="overlay"></div>
        <div class="content">
            <div class="close-btn" onclick="toggleMoveWarning()">&times;</div>
            <div class="center">
                <img src="../image/warning-orange.png" style="max-height: 180px; max-width: 180px;">
                <label>Are you sure about confirming these records? This will send an email to whom you confirmed.</label>
                <!--<button onclick="toggleMoveWarning()" class="action-button">CHECK AGAIN</button>-->  
                <label style="color: red; font-size:10px;">(exit if you want to check again)</label>
                <button type="submit" id="moveButton" class="action-button" name="editType" value="move" form="EditRecordsServlet">YES</button>
            </div>
        </div>
    </div>
    <!-- End of Move Warning Password Pop Up -->
    
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
 
            document.getElementById("manageUsersForm").addEventListener("click", function () {
                document.forms["manageUsersForm"].submit();
            });
            
            document.getElementById("generateExcel").addEventListener("click", function () {
                console.log("YOU ARE INSIDE GENERATE EXCEL");
                var table2excel = new Table2Excel();
                table2excel.export(document.querySelectorAll("#unconfirmed-records"), "EduardosResort-Unconfirmed-Bookings");
            });
        })();
    </script>
    
    <script>        
        function toggleDeleteWarning(){
            var numberOfChecked = $('input:checkbox:checked').length;
            console.log("total checked is: " + numberOfChecked);
            if(numberOfChecked < 1) {
                alert("At least one should be checked!");                
            } else {
                document.getElementById("deletepopup").classList.toggle("active");
            }
        }
        
        function toggleMoveWarning(){
            var numberOfChecked = $('input:checkbox:checked').length;
            console.log("total checked is: " + numberOfChecked);
            if(numberOfChecked < 1) {
                alert("At least one should be checked!");                
            } else {
                document.getElementById("movepopup").classList.toggle("active");
            }
        }
    </script>
</body>

</html>