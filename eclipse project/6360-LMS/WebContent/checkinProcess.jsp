<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.io.*,java.util.*, javax.servlet.*, java.text.*" %>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>

<!DOCTYPE html>
<html>
  <head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="description" content="Check In Process Page"/>
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
            <li class="active"><a href="checkin.jsp">Check In</a></li>
            <li><a href="cardapply.jsp">Card Apply</a></li>
            <li><a href="fine.jsp">Fine</a></li>
            <li><a href="about.jsp">About</a></li>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </nav>
    </div>
    
	<!-- CHECK IN SEARCH
	================================================== -->
	<div class="container">
	<div class="page-header text-primary"><h4 class="text-center">Check In the Book:</h4></div>
	  <form id="ciform" class="form-search" action="checkinSearch.jsp" method="post"  data-ng-app="">
        <span class="col-xs-2">ISBN<input type="text" name="ciisbn" class="form-control" data-ng-model="in1"></input></span>
        <span class="col-xs-2">Card Number<input type="text" name="cicardno" class="form-control" data-ng-model="in2" pattern="[I][D]\d{6}" title="Use the format: IDxxxxxx"></input></span>
        <span class="col-xs-2">Borrower First Name<input type="text" name="cifname" class="form-control" data-ng-model="in3"></input></span>
        <span class="col-xs-2">Borrower Last Name<input type="text" name="cilname" class="form-control" data-ng-model="in4"></input></span>
        <span class="col-xs-2 input-sm"><input id="ci" class="btn btn-lg btn-primary btn-block" type="submit" value="Search" data-ng-disabled="!(in1 || in2 || in3 || in4)"></input></span>
      </form>
	</div>
	
	<!-- CHECK IN 
	================================================== -->
	<div class="container">
	  <br/>
	  <form id="ciform" class="form-search" action="checkinProcess.jsp" method="post"  data-ng-app="">
        <span class="col-xs-2">Loan ID<input type="text" name="ciloanid" class="form-control" data-ng-model="in1"></input></span>
        <span class="col-xs-2 input-sm"><input id="ci" class="btn btn-lg btn-primary btn-block" type="submit" value="Check In" data-ng-disabled="!in1"></input></span>
      </form>
	</div>
    

	<%-- PROCESS CHECK IN --%>
	<%! String mysqlpassword = "123"; %>
	<%
		String loanId=request.getParameter("ciloanid");
	
		// use the Library_Management_System library
		String sqlcmd0 = "USE Library_Management_System;";
		// check whether this book is already checked in
		String sqlcmd1 = "SELECT Date_in FROM BOOK_LOANS WHERE Loan_id='" + loanId + "';";
		
		// connect to database
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/", "root", mysqlpassword);
		Statement stmt1 = conn.createStatement();
		Statement stmt2 = conn.createStatement();
		
		stmt1.executeQuery(sqlcmd0);
		ResultSet result1 = stmt1.executeQuery(sqlcmd1);
		if (!result1.next()) {	// no result: no such loan_id
	%>
		<div class="container">
		  <br/>
		  <div class="alert alert-warning" role="alert">
			<strong>WARNING!</strong> The Loan ID is invalid.
		  </div>
		</div>	<!-- /.container -->
	<%
		} else {
			if (result1.getString("Date_in") != null) {	// the book has already been checked in
	%>
			<div class="container">
			  <br/>
		      <div class="alert alert-warning" role="alert">
				<strong>SORRY!</strong> The book has already been checked in, and the check in date is <%=result1.getString("Date_in") %>.
			  </div>
			</div>	<!-- /.container -->
	<%
			} else {	// check in the book
				SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
				String dayNow = format.format(new Date());
				String sqlcmd2 = "UPDATE BOOK_LOANS SET Date_in='" + dayNow + "' WHERE Loan_id='" + loanId + "';";
				stmt2.executeUpdate(sqlcmd2);
	%>
			<div class="container">
			  <br/>
			  <div class="alert alert-success" role="alert">
				<strong>SUCCESS!</strong> This book is successfully checked in.
			  </div>
			</div>	<!-- /.container -->
	<% 
			}
			result1.close();
			conn.close();			
		}
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