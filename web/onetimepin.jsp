<!DOCTYPE html>
<html lang="en" >
<head>
  <meta charset="UTF-8">
  <title>OTP Page</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css">
  
  <link rel="stylesheet" href="css/onetimepin.css">

</head>
<body>
    <form id="msform" method="post" action="validateOTP">
        <fieldset>
            <h2 class="h2">Email Verification</h2>
            <h3 class="h3">We sent your code</h3>
            <h3 class="h3">Enter the confirmation code below</h3>
            
            <%
                    String login_msg=(String)request.getAttribute("error");  
                    if(login_msg!=null)
                    out.println("<font color=red size=3px>"+login_msg+"</font> <br> <br>");
            %>  
            
            <input type="text" name="otpfield" placeholder="Enter OTP" pattern="[0-9]+" title="Please only input numbers." required />
            <input name="next" class="next action-button" value="Send" type="submit" />
        </fieldset>
    </form>
</body>
</html>
