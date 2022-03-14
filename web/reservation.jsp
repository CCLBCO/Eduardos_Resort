<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Reservation Form</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="font/flaticon.css">
    <link rel="stylesheet" type="text/css" href="css/reservation.css" />
  </head>
  <body>
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
              
              <select id="rooms" name="rooms">
                <option value="">Select Room Type</option>
                <option value="1">Family Room</option>
                <option value="2">Deluxe Room</option>
              </select>
            </div>
            <div class="inpbox">
              <span class="flaticon-calendar"></span>
              <input type="date" placeholder="Pickup Date" name="pckupDate">
            </div>
            <div class="inpbox">
              <span class="flaticon-calendar"></span>
              <input type="date" placeholder="Drop Date" name="drpDate">
            </div>
              
            <div class="inpbox">
              <span class="flaticon-user"></span>
              <input type="text" placeholder="Full Name" name="cstmName">
            </div>
            <div class="inpbox">
              <span class="flaticon-email"></span>
              <input type="email" placeholder="Email" name="email">
            </div>
            <div class="inpbox">
              <span class="flaticon-location"></span>
              <input type="text" placeholder="Phone Number" name="phnNumber">
            </div>
            <div class="inpbox">
              <span class="flaticon-globe"></span>
              <input type="text" placeholder="Country" name="country">
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
  </body>
</html>