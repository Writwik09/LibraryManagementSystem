<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page errorPage="error.jsp" %>
<%@ page import="java.io.*,java.util.*, javax.servlet.*, java.text.*" %>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>

<!DOCTYPE html>
<html>
  <head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="description" content="Card Apply Process Page"/>
    <!-- <link rel="icon" href="./img/xxx.ico"> -->
    <title>Library Management System</title>
    
    <!-- Bootstrap core CSS -->
    <link href="http://getbootstrap.com/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <link href="http://getbootstrap.com/assets/css/ie10-viewport-bug-workaround.css" rel="stylesheet">
    
    <script src="http://getbootstrap.com/assets/js/ie-emulation-modes-warning.js"></script>
    <!-- AngularJS -->
    <script src="http://apps.bdimg.com/libs/angular.js/1.4.6/angular.min.js"></script>
    
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
            <li><a href="home.jsp">Home</a></li>
            <li><a href="search.jsp">Search</a></li>
            <li><a href="checkout.jsp">Check Out</a></li>
            <li><a href="checkin.jsp">Check In</a></li>
            <li class="active"><a href="cardapply.jsp">Card Apply</a></li>
            <li><a href="fine.jsp">Fine</a></li>
            <li><a href="about.jsp">About</a></li>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </nav>
    </div>
    
	
    <!-- CARD APPLY
	================================================== -->
	<div class="container">
	<div class="page-header text-primary"><h4 class="text-center">Please enter your information to apply new card:</h4></div>
	  <form id="brform" class="form-search" action="cardapplyProcess.jsp" method="post"  data-ng-app="">
        <span class="col-xs-3">SSN<input type="text" name="brssn" class="form-control" data-ng-model="in1" pattern="\d{3}[\-]\d{2}[\-]\d{4}" title="Use the format: xxx-xx-xxxx"></input></span>
        <span class="col-xs-3">FIRST NAME<input type="text" name="brfname" class="form-control" data-ng-model="in2"></input></span>
        <span class="col-xs-3">LAST NAME<input type="text" name="brlname" class="form-control" data-ng-model="in3"></input></span>
        <span class="col-xs-4">ADDRESS<input type="text" name="braddress" class="form-control" data-ng-model="in4"></input></span>
        <span class="col-xs-3">PHONE<input type="text" name="brphone" class="form-control" data-ng-model="in5" pattern="[\(]\d{3}[\)] \d{3}[\-]\d{4}" title="Use the format: (xxx) xxx-xxxx"></input></span>
        <span class="col-xs-2 input-sm"><input id="br" class="btn btn-lg btn-primary btn-block" type="submit" value="Apply" data-ng-disabled="!(in1 && in2 && in3 && in4 && in5)"></input></span>
      </form>
	</div>
	
	<%-- PROCESS CARD APPLY --%>
	<%! String mysqlpassword = "123"; %>
	<%
		String ssn=request.getParameter("brssn");
		String fname=request.getParameter("brfname");
		String lname=request.getParameter("brlname");
		String address=request.getParameter("braddress");
		String phone=request.getParameter("brphone");
		
		// use the Library_Management_System library
		String sqlcmd0="USE Library_Management_System;";
		// check if the borrower already has a card
		String sqlcmd1 = "SELECT Ssn, Card_no FROM BORROWER WHERE Ssn='" + ssn + "';";
		
		// connect to database
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/", "root", mysqlpassword);
		Statement stmt1 = conn.createStatement();
	
		stmt1.executeQuery(sqlcmd0);	// use the database
		ResultSet result1 = stmt1.executeQuery(sqlcmd1);
		
		if (result1.next()) {%>
			<br/>
			<div class="alert alert-warning container" role="alert">
	        	<strong>REQUEST REJECTED!</strong> The borrower already has a card and the card number is <%=result1.getString("Card_no")%>
	      	</div>
		<% 
		} else {
			String sqlcmd2 = "SELECT Max_borrower_no FROM LIBRARY_INFO;";
			Statement stmt2 = conn.createStatement();
			Statement stmt3 = conn.createStatement();
			ResultSet result2 = stmt2.executeQuery(sqlcmd2);
			result2.next();
			int no = Integer.parseInt(result2.getString("Max_borrower_no")) + 1;
			String CardNo = "ID";
			for (int i = 0; i < 6 - Integer.toString(no).length(); i++) {
				CardNo = CardNo + "0";
			}
			CardNo = CardNo + Integer.toString(no);
			String sqlcmd3 = "INSERT INTO BORROWER VALUES ('" + CardNo + "','" + ssn + "','" + fname + "','" + lname + "','" + address + "','" + phone + "');";
			if(stmt2.executeUpdate(sqlcmd3) == 1) {
		%>
			<br/>
			<div class="alert alert-success container" role="alert">
        		<strong>SUCCESS!</strong> The new card number is <%=CardNo %>
      		</div>
		<%
			String sqlcmd4 = "UPDATE LIBRARY_INFO SET Max_borrower_no='" + no + "';";
			stmt3.executeUpdate(sqlcmd4);
			}
			result2.close();
		}	
		result1.close();
		conn.close();
	%>

	
	
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