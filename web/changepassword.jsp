<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Change Password</title>
        
        <link rel="stylesheet" href="css/changepassword.css">
    </head>
    <body>
<div class="container">
  <div class="center">
  <form action="/action_page.php">
    <label for="usrname">New Password</label>
    <input type="text" id="usrname" name="usrname" required>

    <label for="psw">Confirm Password</label>
    <input type="password" id="psw" name="psw" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" title="Must contain at least one number and one uppercase and lowercase letter, and at least 8 or more characters" required>

    <input type="submit" value="Submit">
  </form>
  </div>
</div>

<div id="message">
  <h3>Password must contain the following:</h3>
  <p id="letter" class="invalid">A <b>lowercase</b> letter</p>
  <p id="capital" class="invalid">A <b>capital (uppercase)</b> letter</p>
  <p id="number" class="invalid">A <b>number</b></p>
  <p id="length" class="invalid">Minimum <b>8 characters</b></p>
</div>
    </body>
</html>
