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

    <div class="container">
    <div class="book">
      <div class="description">
        <h1><strong>Book</strong> reservations</h1>
        <p>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
        </p>
        <div class="quote">
          <p>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.
          </p>
        </div>
        <ul>
          <li>Super reliable service</li>
          <li>24/7 customer srvice</li>
          <li>GPS tracking and help</li>
          <li>Wide range vehicle</li>
        </ul>
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

          <!--div-- class="inpbox full">
            <div class="inrbox">
              <span class="flaticon-taxi"> Regular</span>
              <input type="radio" name="plan">
              <h2>$50</h2>
              <span>1 Passenger</span>
            </div>
            <div class="inrbox">
              <span class="flaticon-taxi"> Pro</span>
              <input type="radio" name="plan">
              <h2>$120</h2>
              <span>2 Passenger</span>
            </div>
            <div class="inrbox">
              <span class="flaticon-taxi"> Advance</span>
              <input type="radio" name="plan">
              <h2>$180</h2>
              <span>4 Passenger</span>
            </div>
          </!--div-->
          <button class="subt">Submit</button>
          <button class="rst">Reset</button>
        </form>
      </div>
    </div>
    </div>
      
      
<footer>
    <div class="waves">
    <div class="wave" id="wave1"></div>
    
    <div class="wave" id="wave2"></div>
    <div class="wave" id="wave3"></div>
    <div class="wave" id="wave4"></div>
    </div>
</footer>

  <!--Wave Animation-->
  <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
  <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

<!--Typing Animation-->
<script>
  !function(a){"use strict";a.fn.typer=function(b){function c(a,b){k<b.length?(g=b[k].split(""),h=g.length,setTimeout(function(){a.append(g[j]),j++,j<h?c(a,b):(j=0,k++,setTimeout(function(){e(a,function(){c(a,b)})},i.backspaceDelay))},i.typeSpeed)):i.repeat&&d(a,b)}function d(a,b){k=0,setTimeout(function(){c(a,b)},i.repeatDelay)}function e(a,b){setTimeout(function(){a.text(a.text().slice(0,-1)),0<a.text().length?e(a,b):"function"==typeof b&&b()},i.backspaceSpeed)}function f(a){setInterval(function(){a.fadeOut(400).fadeIn(400)},900)}var g,h,i=a.extend({typeSpeed:60,backspaceSpeed:20,backspaceDelay:800,repeatDelay:1e3,repeat:!0,autoStart:!0,startDelay:100,useCursor:!0,strings:["Typer.js plugin"]},b),j=0,k=0;return this.each(function(){var b,d,e=a(this);i.autoStart&&(e.append('<span class="typed"></span>'),i.useCursor&&(e.append('<span class="typed_cursor">&#x7c;</span>'),d=e.children(".typed_cursor"),f(d)),b=e.children(".typed"),setTimeout(function(){c(b,i.strings)},i.startDelay))})}}(jQuery);

  $(document).ready(function(){
      //Typing Animation
      var typed = new Typed('.animate-1', {
          strings: ["CAPTIVATING VIEWS", "BREATHTAKING SUNSETS", "PERFECT VACATIONS"],
      typeSpeed: 100,
      backSpeed: 60,
      loop: true
      });

      var typed = new Typed('.animate-2', {
          strings: ["A HAVEN OF LUXURY", "COMFORT", "THAT EVERYONE DESERVES"],
      typeSpeed: 100,
      backSpeed: 60,
      loop: true
      });

      var typed = new Typed('.animate-3', {
      strings: ["LET THE JOURNEY BEGIN", "A WORLD OF ADVENTURES", "RELAXATION", "MEMORIES AWAIT!"],
      typeSpeed: 100,
      backSpeed: 60,
      loop: true
      });
  });
</script>
  </body>
</html>