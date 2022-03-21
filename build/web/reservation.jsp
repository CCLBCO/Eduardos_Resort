<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Reservation Form</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <script src="https://kit.fontawesome.com/2237df38d7.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" type="text/css" href="font/flaticon.css">
    <link rel="stylesheet" type="text/css" href="css/reservation.css" />
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
    

    <!-- Middle Container -->
    <div class="container">
        <div class="book">
            <div class="description">
              <h1><strong>Book</strong> reservations</h1>

            </div>
            
            <div class="form">
              <form method="post" action="ReservationServlet">
                <div class="inpbox full">
                  <!--span class="flaticon-taxi"></span-->

                  <select id="rooms" name="rooms" required>
                    <option value="">Select Room Type</option>
                    <option value="1">Family Room</option>
                    <option value="2">Deluxe Room</option>
                  </select>
                </div>
                <div class="inpbox">
                  <span class="flaticon-calendar"></span>
                  <input type="date" placeholder="Pickup Date" name="pckupDate" required>
                </div>
                <div class="inpbox">
                  <span class="flaticon-calendar"></span>
                  <input type="date" placeholder="Drop Date" name="drpDate" required>
                </div>
                <div class="inpbox">
                  <span class="flaticon-user"></span>
                  <input type="text" placeholder="Full Name" name="cstmName" required>
                </div>
                <div class="inpbox">
                  <span class="flaticon-email"></span>
                  <input type="email" placeholder="Email" name="email" required>
                </div>
                <div class="inpbox">
                  <span class="flaticon-location"></span>
                  <input type="text" placeholder="Phone Number" name="phnNumber" required>
                </div>
                <div class="inpbox">
                  <span class="flaticon-globe"></span>
                  <input type="text" placeholder="Country" name="country" required>
                </div>
                <button class="subt">Submit</button>
                <button class="rst">Reset</button>
              </form>
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
    </div>
    <ul class="social_icon">
      <li><a href='#'><ion-icon name="logo-facebook"></ion-icon></a></li>
      <li><a href='#'><ion-icon name="logo-twitter"></ion-icon></a></li>
      <li><a href='#'><ion-icon name="logo-linkedin"></ion-icon></a></li>
      <li><a href='#'><ion-icon name="logo-instagram"></ion-icon></a></li>
    </ul>
    <ul class="menu">
        <li><p>Message us at eduardosresort@gmail.com</p></li>
         <li><p>Call us at <strong>(043) 288-7153</strong> or <strong>09183227201</strong></p></li>
    </ul>
</footer>

<!--Wave Animation-->
<script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

</html>