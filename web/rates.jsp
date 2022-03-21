<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rates and Promos</title>

    <!-- font awesome cdn link  -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

    <!-- custom css file link  -->
    <link rel="stylesheet" href="css/rates.css">

</head>

<body>

    <!-- header section starts  -->
    <header class="header">
        <div class="container1">
            <nav class="navbar flex1">
              <ul class="nav-menu">
                <li> <a href="index.jsp">Home</a></li>
                <!--li> <a href="#room">Accomodations</a></li-->
                <!--li> <a href="rates.jsp">Rates and Promos</a></li-->
                <!--li> <a href="#restaurant">Event Packages</a></li-->
                <li> <a href="reservation.jsp">Reservation</a></li>
              </ul>
            </nav>
        </div>
    </header>  
    <!-- header section ends -->

    <!-- speciality section starts  -->

    <section class="speciality" id="speciality">

        <div class="box-container">

            <div class="box">
                <img class="image" src="image/e-1.jpg" alt="">
                <div class="content">
                    <img src="image/ic-1.png" alt="">
                    <h3>Entrance Fee</h3>
                    <div class="col">
                        <div class="col-70">
                            <p class="text-left">Child/Teens/Adults</p>
                            <p class="text-left">Senior Citizens</p>
                            <p class="text-left">Person with Disability</p>
                            <p class="text-left">Infant (1yr old & above)</p>
                        </div>
                        <div class="col-30">
                            <p class="text-right">P 120.00</p>
                            <p class="text-right">P 100.00</p>
                            <p class="text-right">P 100.00</p>
                            <p class="text-right">Free</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="box">
                <img class="image" src="image/e-2.jpg" alt="">
                <div class="content">
                    <img src="image/ic-2.png" alt="">
                    <h3>Function Hall</h3>
                    <p>P 8,000.00</p>

                </div>
            </div>

            <div class="box">
                <img class="image" src="image/e-3.jpg" alt="">
                <div class="content">
                    <img src="image/ic-3.png" alt="">
                    <h3>VIP Room with Videoke</h3>
                    <p>P 2,000.00</p>
                    <p>Free Entrance of 6 persons inclusive of:</p>
                    <p>2 buckets of SanMig Light</p>
                    <p>1 whole Grilled Chicken</p>
                </div>
            </div>

            <div class="box">
                <img class="image" src="image/e-4.jpg" alt="">
                <div class="content">
                    <img src="image/ic-4.png" alt="">
                    <h3>Room Rates</h3>
                    <div class="col">
                        <div class="col-70">
                            <p class="text-left">Family Room (4 persons)</p>
                            <p class="text-left">Deluxe Room (3 persons)</p>
                            <p class="text-left">Deluxe Room (1 person)</p>
                            <p class="text-left">Additional 1 person with Free Breakfast</p>
                        </div>
                        <div class="col-30">
                            <p class="text-right">P 3 500.00</p>
                            <p class="text-right">P 2 500.00</p>
                            <p class="text-right">P 2 000.00</p>
                            <p class="text-right">P 400.00</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="box">
                <img class="image" src="image/e-5.jpg" alt="">
                <div class="content">
                    <img src="image/ic-5.png" alt="">
                    <h3>Cottages</h3>
                    <div class="col">
                        <div class="col-70">
                            <p class="text-left">Front View</p>
                            <p class="text-left">Fountain View</p>
                            <p class="text-left">Top View</p>
                            <p class="text-left">Pool Side Big Tent</p>
                            <p class="text-left">Pool Side Tent</p>
                            <p class="text-left">Videoke</p>
                        </div>
                        <div class="col-30">
                            <p class="text-right">P 400.00</p>
                            <p class="text-right">P 400.00</p>
                            <p class="text-right">P 500.00</p>
                            <p class="text-right">P 800.00</p>
                            <p class="text-right">P 400.00</p>
                            <p class="text-right">P 700.00</p>
                        </div>
                    </div>
                </div>
            </div>

        </div>

    </section>

    <!-- speciality section ends -->


    <!-- custom js file link  -->
    <script>
        let menu = document.querySelector('#menu-bar');
        let navbar = document.querySelector('.navbar');

        menu.onclick = () =>{

        menu.classList.toggle('fa-times');
        navbar.classList.toggle('active');

        }

        window.onscroll = () =>{

        menu.classList.remove('fa-times');
        navbar.classList.remove('active');

        if(window.scrollY > 60){
            document.querySelector('#scroll-top').classList.add('active');
        }else{
            document.querySelector('#scroll-top').classList.remove('active');
        }

        }

        function loader(){
        document.querySelector('.loader-container').classList.add('fade-out');
        }

        function fadeOut(){
        setInterval(loader, 3000);
        }

        window.onload = fadeOut();
    </script>
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