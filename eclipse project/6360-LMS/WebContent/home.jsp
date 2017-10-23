<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page errorPage="error.jsp" %>
<%@ page import="java.io.*,java.util.*, javax.servlet.*, java.text.*" %>

<!DOCTYPE html>
<html>
  <head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="description" content="Search Page"/>
    <!-- <link rel="icon" href="./img/xxx.ico"> -->
    <title>Library Management System</title>
    
    <!-- Bootstrap core CSS -->
    <link href="http://getbootstrap.com/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <link href="http://getbootstrap.com/assets/css/ie10-viewport-bug-workaround.css" rel="stylesheet">
    
    <script src="http://getbootstrap.com/assets/js/ie-emulation-modes-warning.js"></script>
    
    <!-- MY CSS -->
    <link href="css/lms.css" rel="stylesheet">
  </head>
  
  <body>
    <!-- HEADER
	================================================== -->
    <div class="container">
      <span class="h1 text-primary">Library Management System</span>
      <img src="images/header.jpg" alt="header" class="pull-right text-bottom"/>
    </div>
    
    <!-- NAVBAR
	================================================== -->
	<div class="container">
	<nav class="navbar navbar-default">
	  <div class="container">
	    <div class="navbar-header">
	      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse">
	        <span class="sr-only">Toggle navigation</span>
	        <span class="icon-bar"></span>
	        <span class="icon-bar"></span>
	        <span class="icon-bar"></span>
	      </button>
	      <a class="navbar-brand" href="#">LMS</a>
        </div>
        <div class="navbar-collapse collapse">
          <ul class="nav navbar-nav">
            <li  class="active"><a href="home.jsp">Home</a></li>
            <li><a href="search.jsp">Search</a></li>
            <li><a href="checkout.jsp">Check Out</a></li>
            <li><a href="checkin.jsp">Check In</a></li>
            <li><a href="cardapply.jsp">Card Apply</a></li>
            <li><a href="fine.jsp">Fine</a></li>
            <li><a href="about.jsp">About</a></li>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </nav>
    </div>
    
	<!-- WELCOME
	================================================== -->
	<div class="container">
      <div>
        <p class="h3 text-primary text-center"><span class="h1">Welcome</span> to the Library Management System!</p>
      </div>
	</div>
	
    
	
	<!-- FOOTER
	================================================== -->
	<div class="container">
      <hr class="featurette-divider"/>
      <footer class="footer">
        <p class="pull-right"><a href="#">Back to top</a></p>
        <span>Library Management System</span>
        <span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
		<em>Design by Fenglan Yang</em>
        <span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
        <%SimpleDateFormat ft = new SimpleDateFormat ("E yyyy.MM.dd"); %>
		<span>Today is <%=ft.format( new Date() )%></span>
      </footer>
    </div> <!-- /.container -->
    
    
  </body>
</html>