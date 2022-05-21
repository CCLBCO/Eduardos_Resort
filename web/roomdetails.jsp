<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>Reservation Form</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
        <script src="https://kit.fontawesome.com/2237df38d7.js" crossorigin="anonymous"></script>
        <link rel="stylesheet" type="text/css" href="font/flaticon.css">
        <link rel="stylesheet" type="text/css" href="css/roomdetails.css">
    </head>

    <header class="header">
        <div class="container1">
            <nav class="navbar flex1">
                <form method ="post" action="invalidateViewBookingServlet"> 
                <ul class="nav-menu">
                    <li> <a href="${pageContext.request.contextPath}/index.jsp">Back</a></li>
                    <!--li> <a href="#room">Accomodations</a></li-->
                    <!--li> <a href="rates.jsp">Rates and Promos</a></li-->
                    <!--li> <a href="#restaurant">Event Packages</a></li-->
                    <!--li> <a href="rooms.jsp">Room Bookings</a></li-->
                    <!--li> <a href="reservation.jsp">Reservation</a></li-->
                    <!--li> <a href="login.jsp">Admin Login</a></li-->
                </ul>
                </form>
            </nav>
        </div>
    </header>  

    <body>
        <%
            String room = (String) request.getAttribute("room");
            String name = (String) request.getAttribute("name");
            String arvDate = (String) request.getAttribute("arrivalDate");
            String deptDate = (String) request.getAttribute("departDate");
            String email = (String) request.getAttribute("email");
            String phone = (String) request.getAttribute("phone");
            String cost = (String) request.getAttribute("cost");
            String code = (String) request.getAttribute("code");
            String country = (String) request.getAttribute("country");
        %>
        
        <center>
        <%
            String login_msg = (String) request.getAttribute("error");
            if (login_msg != null) {
                out.println("<font color=red size=3px>" + login_msg + "</font>");
            } else {
                out.println("<font color=white size=3px>" + login_msg + "</font>");
            }
        %>
        </center>
    
        <br>
        <div class="container">
            <div class="book">
                <h1>Your Reservation</h1>
                <ul class="details">
                    <li>Room: <b> <% out.println(room);%> </b> </li>
                    <li>Arrival Date: <b><% out.println(arvDate);%></b> </li>
                    <li>Departure Date: <b><% out.println(deptDate);%></b> </li>
                    <li>Total Amount: <b><% out.println("PHP " + cost);%></b> </li>
                    <li>Name: <b><% out.println(name);%></b> </li>
                    <li>Email: <b><% out.println(email);%></b> </li>
                    <li>Phone: <b><% out.println(phone);%></b> </li>
                    <li>Country: <b><% out.println(country);%></b> </li>
                </ul>
            </div>

            <div class="buttons">
                <button class="bk" onclick="togglePopup()">Cancel Booking</button>

                <form>
                    <button class="bk">Download PDF</button>
                </form>

                <div class="popup" id="popup-1">
                    <div class="overlay"></div>
                    <div class="content">
                        <div class="close-btn" onclick="togglePopup()">&times;</div>
                        <h1>Enter Booking Code</h1>
                        <form class="inputcode" method="post" action="cancelBooking">
                                <input class="cancelbooking" type="text" placeholder="XXXXXXX" name="code" required>
                            <button class="bksubmit">Submit</button>
                        </form>
                    </div>
                </div>    

            </div>

        </div>
    </body>

    <footer>
        <div class="waves">
            <div class="wave" id="wave1"></div>
            <div class="wave" id="wave2"></div>
            <div class="wave" id="wave3"></div>
            <div class="wave" id="wave4"></div>
    </footer>

    <!--Wave Animation-->
    <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

    <!--Pop-up Animation -->
    <script>
                            function togglePopup() {
                                document.getElementById("popup-1").classList.toggle("active");
                            }
    </script>

</html>