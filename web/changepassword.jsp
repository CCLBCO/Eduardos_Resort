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
        <input type="password" id="usrname" name="password" title="Please input a strong password."required>

        <label for="psw">Confirm Password</label>
        <input type="password" id="psw" name="passConf" title="Must match with the given password above." required>

        <input type="submit" value="Submit">
      </form>
      </div>
    </div>
</form>
    </body>
</html>
