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
    <div class="main_content">
        <div class="header1">BOOKINGS</div>
        <div class="header2 flex">
            <p>&nbsp&nbspUNCONFIRMED RECORDS</p><button class="btn">Generate Excel</button>
        </div>
        <div class="container">
            <div>
                <div class="flex dropdown-list">
                    <form action="/action_page.php">
                        <!-- original code, I'm not sure what the java equiv is -->
                        <select class="header3" name="Date Recorded" id="Date Recorded">
                            <option class="header3" value="Date Recorded">Date Recorded</option>
                            <option class="header3" value="saab">Saab</option>
                            <option class="header3" value="opel">Opel</option>
                            <option class="header3" value="audi">Audi</option>
                        </select>
                    </form>
                    <form action="/action_page.php">

                        <select class="header3" name="Start Date" id="Start Date">
                            <option class="header3" value="Start Date">Start Date</option>
                            <option class="header3" value="saab">Saab</option>
                            <option class="header3" value="opel">Opel</option>
                            <option class="header3" value="audi">Audi</option>
                        </select>
                    </form>
                    <form action="/action_page.php">

                        <select class="header3" name="End Date" id="End Date">
                            <option class="header3" value="End Date">End Date</option>
                            <option class="header3" value="saab">Saab</option>
                            <option class="header3" value="opel">Opel</option>
                            <option class="header3" value="audi">Audi</option>
                        </select>
                    </form>
                    <form action="/action_page.php">

                        <select class="header3" name="Country" id="Country">
                            <option class="header3" value="Country">Country</option>
                            <option class="header3" value="saab">Saab</option>
                            <option class="header3" value="opel">Opel</option>
                            <option class="header3" value="audi">Audi</option>
                        </select>
                    </form>
                    <form action="/action_page.php">
                        <select class="header3" name="Room" id="Room">
                            <option class="header3" value="Room">Room</option>
                            <option class="header3" value="saab">Saab</option>
                            <option class="header3" value="opel">Opel</option>
                            <option class="header3" value="audi">Audi</option>
                        </select>
                    </form>
                </div>
                <div class="flex flex-between mt-5">
                    <div class="flex">
                        <button class="btn-actions">Filter</button>
                        <button class="btn-actions">Edit</button>
                        <button class="btn-actions">Delete</button>
                        <button class="btn-actions">Move to Confirmed</button>
                    </div>
                    <div class="flex pr-24">
                        <button class="btn-actions">Reset Filter</button>
                        <button class="btn-actions">Reset Order</button>
                    </div>
                </div>
            </div>
            <!-- JS for DropDown Button -->
            <script>
                let click = document.querySelector('.click1');
                let list = document.querySelector('.list1');
                click.addEventListener("click", () => {
                    list.classList.toggle('newlist');
                });
            </script>
        </div>
        <div class="box">
            <svg class="box w-100 h-500">
                <rect width="2000" height="650" style="fill:rgb(255, 255, 255);stroke-width:3;stroke:rgb(0,0,0)" />
            </svg>
            <!-- Start of Records body -->
                <form method = "POST" id="fetchItem"></form>
                <section class="unconfirmed">
                    <form method="POST" id="item-form" action="ManageRecordsServlet">
                        <table data-toggle="table" data-search="true" data-filter-control="true" data-show-export="true" data-click-to-select="true" data-toolbar="#toolbar">
                            <thead>
                                <tr>
                                    <th></th>
                                    <th class="booking-id">ID</th>
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
                                        System.out.print("this is the name: " + name);
                            %>
                                        <tr class="details">
                                            <td class="item-id"><%=id%></td>
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
                </form>
            </section>
            <!-- End of Records body -->
        </div>
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