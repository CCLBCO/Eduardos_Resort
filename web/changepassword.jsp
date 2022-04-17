<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Change Password</title>
        
        <link rel="stylesheet" href="css/changepassword.css">
    </head>
    <body>
        <form id="msform" action="ChangePasswordServlet" method="post">
            <div class="form-gap"></div>
            <div class="container">
              <div class="center">
              <h2 class="h2">Change Password</h2>
              <%
                            String login_msg=(String)request.getAttribute("error");  
                            if(login_msg!=null)
                            out.println("<font color=red size=3px>"+login_msg+"</font>");
              %>
              <form>
                <label for="usrname">New Password</label>
                <input type="password" id="password" name="password" title="Please input a strong password." onkeyup="check()"required>

                <label for="psw">Confirm Password</label>
                <input type="password" id="passConf" name="passConf" title="Must match with the given password above." onkeyup="check()" required>

                <label id='message'></label>
                
                <input type="submit" id="changePassSumbitButton" class="action-button" value="Submit">
              </form>
              </div>
            </div>
        </form>
    </body>
    <script type="text/javascript">
        document.getElementById("changePassSumbitButton").addEventListener("click", function (event) {
                if(document.getElementById("password").value === document.getElementById('passConf').value) {
                    console.log("YOU PRESSED CHANGE PASS BUTTON");
                    document.forms["EditAccountsServlet"].submit();
                } else {
                    event.preventDefault();
                }
        });
            
        function check() {
            console.log("you're inside check()");
            if (document.getElementById("password").value === document.getElementById('passConf').value) {
              document.getElementById('message').style.color = 'green';
              document.getElementById('message').innerHTML = 'Passwords match!';
            } else {
              document.getElementById('message').style.color = 'red';
              document.getElementById('message').innerHTML = 'Passwords don\'t match!';
            }
        }
    </script>
</html>
