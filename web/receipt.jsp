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
    
<!-- header section starts  -->

<!--header>

    <a href="#" class="logo"><i class="fas fa-utensils"></i>food</a>

    <div id="menu-bar" class="fas fa-bars"></div>

    <nav class="navbar">
        <a href="#home">home</a>
        <a href="#speciality">speciality</a>
        <a href="#popular">popular</a>
        <a href="#gallery">gallery</a>
        <a href="#review">review</a>
        <a href="#order">order</a>
    </nav>

</header-->
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

<section class="footer">

    <div class="share">
        <a href="#" class="btn">facebook</a>
        <a href="#" class="btn">twitter</a>
        <a href="#" class="btn">instagram</a>
        <a href="#" class="btn">pinterest</a>
        <a href="#" class="btn">linkedin</a>
    </div>

</section>

<!-- scroll top button  -->
<a href="#home" class="fas fa-angle-up" id="scroll-top"></a>


<!-- custom js file link  -->
<script src="js/script.js"></script>


</body>
</html>