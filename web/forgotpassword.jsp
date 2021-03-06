<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Forgot Password</title>
        <link rel="stylesheet" type="text/css" href="css/forgotpassword.css" />
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
        <script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
    </head>
    <body>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
 <div class="form-gap"></div>
<div class="container">
	<div class="row">
		<div class="col-md-4 col-md-offset-4">
            <div class="panel panel-default">
              <div class="panel-body">
                <div class="text-center">
                  <h3><i class="fa fa-lock fa-4x"></i></h3>
                  <h2 class="text-center">Forgot Password?</h2>
                  <p>You can reset your password here.</p>
                  <%
                    String login_msg=(String)request.getAttribute("error");  
                    if(login_msg!=null)
                    out.println("<font color=red size=3px>"+login_msg+"</font>");
                  %>
                  <div class="panel-body">
    
                    <form id="register-form" role="form" autocomplete="off" class="form" method="post" action="ForgotPasswordServlet">
                      <div class="form-group">
                        <div class="input-group">
                          <span class="input-group-addon"><i class="glyphicon glyphicon-envelope color-green"></i></span>
                          <input id="email" name="email" placeholder="Email Address" class="form-control"  type="email" required>
                        </div>
                      </div>
                      <div class="form-group">
                        <input name="recover-submit" class="action-button btn btn-lg btn-primary btn-block" value="Reset Password" type="submit">
                      </div>
          
                    </form>
    
                  </div>
                </div>
              </div>
            </div>
          </div>
	</div>
        </div>
    </body>
</html>