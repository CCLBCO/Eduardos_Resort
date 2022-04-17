<%@page import="exceptions.SessionDestroyedException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.sql.Date"%>
<%@page import="javax.mail.FetchProfile.Item"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.BookingRecord"%>
<%@page import="java.text.DecimalFormat"%>

<!DOCTYPE html>

<%  // Gets session object and throws user-defined SessionDestroyedException when the Session Attribute is not Created 
        System.out.println("user: "+session.getAttribute("sessionUser"));
        System.out.println("role: "+session.getAttribute("role"));
           
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
                                class="pl-5 font-weight-light submenu-form sub-active" id="cancelledbookings">
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
                                <button class="submenu" id="manageUsers">Manage Users</button>
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
                                <p class="h2 text-light font-weight-bold align-text-bottom">CANCELLED RECORDS</p>
                            </div>
                            <div class="row justify-content-between mt-3 w-100 ml-0 centeritems">
                                <div class="row col-sm-12 col-lg-7 pt-2 filterflex1">
                                    <form class="w-100 filterflex1" method="POST" id="EditRecordsServlet" action="<%= request.getContextPath()%>/EditRecordsServlet"></form>
                                        <!--button id="editButton" class="col-sm-12 col-lg-2 mt-sm-2 mt-lg-0 btn btn-actions ml-0 ml-lg-2" onclick="show_hide()">Edit</button-->
                                        <button onclick="toggleRestoreWarning()" class="col-sm-12 col-lg-2 mt-sm-2 mt-lg-0 btn btn-actions ml-0 ml-lg-2 marginleft marginbottom1">Restore</button>
                                        <button onclick="toggleFinalDeleteWarning()" class="col-sm-12 col-lg-2 mt-sm-2 mt-lg-0 btn btn-actions ml-0 ml-lg-2 marginleft marginbottom1">Delete</button>
                                        <button onclick="toggleFinalDeleteAllWarning()" class="col-sm-12 col-lg-4 mt-sm-2 mt-lg-0 btn btn-actions ml-0 ml-lg-2 marginleft marginbottom1">Delete All</button>
                                        <input type="hidden" name="status" value="cancelled" form="EditRecordsServlet">
                                    
                                </div>
                                        
                                <div class="topnav">
                                    <div class="search-container">
                                        <form method="POST" action="<%= request.getContextPath()%>/FilterRecordsServlet">
                                            <input type="text" placeholder="Search" name="searchValue">
                                            <input type="hidden" name="status" value="cancelled">
                                            <button type="submit" name="filterType" value="search"><i class="fa-solid fa-magnifying-glass"></i></button>
                                        </form>
                                    </div>
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
    
    <!-- Start of Restore Warning Pop Up -->
    <div class="popup" id="restorepopup">
        <div class="overlay"></div>
        <div class="content">
            <div class="close-btn" onclick="toggleRestoreWarning()">&times;</div>
            <div class="center">
                <img src="../image/warning-orange.png" style="max-height: 180px; max-width: 180px;">
                <label>Are you sure about restoring these records back to unconfirmed? If you delete or confirm them again, this will notify the booker.</label>
                <!--<button onclick="toggleMoveWarning()" class="action-button">CHECK AGAIN</button>-->  
                <label style="color: red; font-size:10px;">(exit if you want to check again)</label>
                <button type="submit" id="moveButton" class="action-button" name="editType" value="move" form="EditRecordsServlet">YES</button>
            </div>
        </div>
    </div>
    <!-- End of Restore Warning Password Pop Up -->
    
    <!-- Start of Final Delete Warning Pop Up -->
    <div class="popup" id="finaldeletepopup">
        <div class="overlay"></div>
        <div class="content">
            <div class="close-btn" onclick="toggleFinalDeleteWarning()">&times;</div>
            <div class="center">
                <img src="../image/warning-orange.png" style="max-height: 180px; max-width: 180px;">
                <label>Are you sure about deleting the following records? After this there is no way to restore them again.</label>
                <!--<button onclick="toggleDeleteWarning()" class="action-button">CHECK AGAIN</button>-->    
                <label style="color: red; font-size:10px;">(exit if you want to check again)</label>
                <button type="submit" id="finalDeleteButton" name="editType" value="trueDelete" class="action-button" form="EditRecordsServlet">YES</button>
            </div>
        </div>
    </div>
    <!-- End of Final Delete ALL Warning Pop Up -->
    
    <!-- Start of Final Delete Warning Pop Up -->
    <div class="popup" id="finaldeleteallpopup">
        <div class="overlay"></div>
        <div class="content">
            <div class="close-btn" onclick="toggleFinalDeleteAllWarning()">&times;</div>
            <div class="center">
                <img src="../image/warning-orange.png" style="max-height: 180px; max-width: 180px;">
                <label>Are you sure about deleting all the records? After this there is no way to restore them again.</label>
                <!--<button onclick="toggleDeleteWarning()" class="action-button">CHECK AGAIN</button>-->    
                <label style="color: red; font-size:10px;">(exit if you want to check again)</label>
                <button type="submit" id="finalDeleteAllButton" name="editType" value="trueDeleteAll" class="action-button" form="EditRecordsServlet">YES</button>
            </div>
        </div>
    </div>
    <!-- End of Final Delete ALL Warning Pop Up -->
    
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

            
        })();
    </script>
        <script>        
        function toggleFinalDeleteWarning(){
            var numberOfChecked = $('input:checkbox:checked').length;
            console.log("total checked is: " + numberOfChecked);
            if(numberOfChecked < 1) {
                alert("At least one should be checked!");                
            } else {
                document.getElementById("finaldeletepopup").classList.toggle("active");
            }
        }
        
        function toggleFinalDeleteAllWarning(){
            document.getElementById("finaldeleteallpopup").classList.toggle("active");
        }
        
        function toggleRestoreWarning(){
            var numberOfChecked = $('input:checkbox:checked').length;
            console.log("total checked is: " + numberOfChecked);
            if(numberOfChecked < 1) {
                alert("At least one should be checked!");                
            } else {
                document.getElementById("restorepopup").classList.toggle("active");
            }
        }
    </script>
</body>
</html>
