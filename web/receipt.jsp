<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Eduardos Resort - Receipt</title>

    <!-- font awesome cdn link  -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

    <!-- custom css file link  -->
    <link rel="stylesheet" href="css/receipt.css">

</head>
<body>
    
    <header class="header">
    <div class="container1">
    <nav class="navbar flex1">

      <ul class="nav-menu">
        <li> <a href="index.jsp?#home">Home</a></li>
        <li> <a href="index.jsp?#amenities">Amenities</a></li>
        <li> <a href="index.jsp?#room">Accomodations</a></li>
        <li> <a href="index.jsp?#restaurant">Event Packages</a></li>
        <li> <a href="index.jsp?#gallary">Gallery</a></li>
        <!--li> <a href="rooms.jsp">Room Bookings</a></li-->
        <!--li> <a href="reservation.jsp">Reservation</a></li-->
        <!--li> <a href="login.jsp">Admin Login</a></li-->
      </ul>
    </nav>
    </div>
    </header>
    
<section class="order" id="order">
    <%
        String room = (String)request.getAttribute("room");
        String name = (String)request.getAttribute("name");
        String arvDate = (String)request.getAttribute("arrivalDate");
        String deptDate = (String)request.getAttribute("departDate");
        String email = (String)request.getAttribute("email");
        String phone = (String)request.getAttribute("phone");
        String cost = (String)request.getAttribute("cost");
        String code = (String)request.getAttribute("code");
        String country = (String)request.getAttribute("country");
    %>
    <h1 class="heading"> <span>Your</span> Reservation </h1>

    <div class="row">
        
        <div class="image">
            <img src="image/thumbnail.PNG" alt="">
        </div>

        <form>
            <!--I kept it as a form to preserve the look-->
            <!--Di ko ginalaw "form" and CSS niya-->
            <!--the only CSS I added is details class, in syncing this and cheska's rate's page I
            suggest just adding "details" into her CSS file-->

            <div class="inputBox">
                <h3 class="details">ROOM: </h3>
                <% out.println("<h3 class=" + "details" + ">"+ room + "</h3>"); %>
            </div>
            <div class="inputBox">
                <h3 class="details">NAME: </h3>
                <% out.println("<h3 class=" + "details" + ">"+ name + "</h3>"); %>
            </div>
            <div class="inputBox">
                <h3 class="details">ARRIVAL DATE:</h3>
                <% out.println("<h3 class=" + "details" + ">"+ arvDate + "</h3>"); %>
            </div>
            <div class="inputBox">
                <h3 class="details">EMAIL: </h3>
                <% out.println("<h3 class=" + "details" + ">"+ email + "</h3>"); %>
            </div>
            
            <div class="inputBox">
                <h3 class="details">DEPARTURE DATE: </h3>
                <% out.println("<h3 class=" + "details" + ">"+ deptDate + "</h3>"); %>
            </div>
            <div class="inputBox">
                <h3 class="details">PHONE: </h3>
                <% out.println("<h3 class=" + "details" + ">"+ phone + "</h3>"); %>
            </div>
            
            <div class="inputBox">
                <h3 class="details">TOTAL AMOUNT: </h3>
                <% out.println("<h3 class=" + "details" + ">"+ cost + "</h3>"); %>
            </div>
            
             <div class="inputBox">
                <h3 class="details">CODE: </h3>
                <% out.println("<h3 class=" + "details" + ">"+ code + "</h3>"); %>
            </div>
            
            <div class="inputBox">
                <h3 class="details">COUNTRY:</h3>
                <% out.println("<h3 class=" + "details" + ">"+ country + "</h3>"); %>
            </div>

            <input type="submit" value="DOWNLOAD PDF" class="btn">

        </form>

    </div>

</section>


<!-- footer section  -->

<footer>
    <div class="waves">
    <div class="wave" id="wave1"></div>
    
    <div class="wave" id="wave2"></div>
    <div class="wave" id="wave3"></div>
    <div class="wave" id="wave4"></div>
    </div>
    <ul class="social_icon">
      <li><a href='#'><ion-icon name="logo-facebook"></ion-icon></a></li>
      <li><a href='#'><ion-icon name="logo-twitter"></ion-icon></a></li>
      <li><a href='#'><ion-icon name="logo-linkedin"></ion-icon></a></li>
      <li><a href='#'><ion-icon name="logo-instagram"></ion-icon></a></li>
    </ul>
    <ul class="menu">
        <li><p>Message us at eduardosreseort@gmail.com</p></li>
        <li><p>Call us at (043) 288-7153</p></li>
        <p>@2022 Eduardo's Resort | All Rights Reserved</p>
    </ul>
  </footer>

<!-- scroll top button  -->
<a href="#home" class="fas fa-angle-up" id="scroll-top"></a>


<!-- custom js file link  -->
<script src="js/script.js"></script>


</body>
</html>