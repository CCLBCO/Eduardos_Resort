<!DOCTYPE html>
<html lang="en" >
<head>
  <meta charset="UTF-8">
  <title>Booking</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css">
  <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
  <link rel="stylesheet" href="css/booking.css">

</head>

<header class="header">
    <div class="container1">
        <nav class="navbar flex1">
          <ul class="nav-menu">
            <li> <a href="index.jsp">Back</a></li>
            <!--li> <a href="#room">Accomodations</a></li-->
            <!--li> <a href="rates.jsp">Rates and Promos</a></li-->
            <!--li> <a href="#restaurant">Event Packages</a></li-->
            <!--li> <a href="rooms.jsp">Room Bookings</a></li-->
            <!--li> <a href="reservation.jsp">Reservation</a></li-->
            <!--li> <a href="login.jsp">Admin Login</a></li-->
          </ul>
        </nav>
    </div>
</header>  

<body>
    <form id="msform" method="post" action="ViewBookingServlet">
        <fieldset>
            <h2 class="h2">Booking</h2>
            <h3 class="h3">Enter the booking code below</h3>
            
            <%
                    String login_msg=(String)request.getAttribute("error");  
                    if(login_msg!=null)
                    out.println("<font color=red size=3px>"+login_msg+"</font> <br> <br>");
            %>  
            
            <input type="text" name="code" placeholder="Enter Booking Code" required />
            <input name="next" class="next action-button" value="Send" type="submit" />
        </fieldset>
    </form>
            
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
    function togglePopup(){
        document.getElementById("popup-1").classList.toggle("active");
    }
</script>

</html>
