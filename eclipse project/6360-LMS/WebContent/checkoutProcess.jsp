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
    <meta name="description" content="Check Out Process Page"/>
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
            <li class="active"><a href="checkout.jsp">Check Out</a></li>
            <li><a href="checkin.jsp">Check In</a></li>
            <li><a href="cardapply.jsp">Card Apply</a></li>
            <li><a href="fine.jsp">Fine</a></li>
            <li><a href="about.jsp">About</a></li>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </nav>
    </div>
    
	<!-- CHECK OUT
	================================================== -->
	<div class="container">
	<div class="page-header text-primary"><h4 class="text-center">Check Out the Book:</h4></div>
	  <form id="coform" class="form-search" action="checkoutProcess.jsp" method="post"  data-ng-app="">
        <span class="col-xs-3">ISBN<input type="text" name="coisbn" class="form-control" data-ng-model="in1"></input></span>
        <span class="col-xs-2">Branch ID<input type="text" name="cobranchid" class="form-control" data-ng-model="in2"></input></span>
        <span class="col-xs-3">Card Number<input type="text" name="cocardno" class="form-control" data-ng-model="in3" pattern="[I][D]\d{6}" title="Use the format: IDxxxxxx"></input></span>
        <span class="col-xs-2 input-sm"><input id="co" class="btn btn-lg btn-primary btn-block" type="submit" value="Check Out" data-ng-disabled="!(in1 && in2 && in3)"></input></span>
      </form>
	</div>
    
	
	<%-- PROCESS CHECK OUT --%>
	<%! String mysqlpassword = "123"; %>
	<%
		String isbn=request.getParameter("coisbn");
		String branchId=request.getParameter("cobranchid");
		String cardNo=request.getParameter("cocardno");
		
		// use the Library_Management_System library
		String sqlcmd0 = "USE Library_Management_System;";
		String sqlcmd1 = "SELECT COUNT(*) AS OutNum FROM BOOK_LOANS AS BL WHERE BL.Card_no='" + cardNo + "' AND (BL.Date_in IS NULL);";
		String sqlcmd2_1 = "SELECT No_of_copies FROM BOOK_COPIES AS BC WHERE BC.Book_id='" + isbn + "' AND BC.Branch_id='" + branchId + "';";
		String sqlcmd2_2 = "SELECT COUNT(*) AS thisOutNum FROM BOOK_LOANS AS BL WHERE (BL.Date_in IS NULL) AND BL.Isbn='" + isbn + "' AND BL.Branch_id='" + branchId + "';";
		// connect to database
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/", "root", mysqlpassword);
		Statement stmt1 = conn.createStatement();
		Statement stmt2 = conn.createStatement();
		Statement stmt3 = conn.createStatement();
		
		stmt1.executeQuery(sqlcmd0);
		ResultSet result1 = stmt1.executeQuery(sqlcmd1);	// check how many books the borrower hasn't returned
		result1.next();
		String outNum = result1.getString("OutNum");
		
		// check whether this book still has available copies at this branch
		ResultSet result2_1 = stmt2.executeQuery(sqlcmd2_1);
		result2_1.next();
		String totalNum = result2_1.getString("No_of_copies");
		ResultSet result2_2 = stmt2.executeQuery(sqlcmd2_2);
		result2_2.next();
		String notAvailableNum = result2_2.getString("thisOutNum");
		int tNum = Integer.parseInt(totalNum);
		int availableNum = tNum - Integer.parseInt(notAvailableNum);
		if ( Integer.parseInt(outNum) >= 3) {	// the borrower has at least 3 books not returned
	%>	<br/>
		<div class="alert alert-alert" role="alert">
	        <strong>SORRY!</strong> The borrower is not allowed to borrow the book, since he/she already has 3 booked borrowed.
	    </div>
	<%
		} else if (tNum <= 0 || availableNum <= 0) {	// all copies of this book at this branch has been checked out
	%>
		<br/>
		<div class="alert alert-alert" role="alert">
	        <strong>SORRY!</strong> This book at this branch is not available.
	    </div>
	<%		
		} else {	// the borrower can borrow this book
			String sqlcmd3 = "SELECT MAX(Loan_id) AS Maxloanid FROM BOOK_LOANS;";
			ResultSet result3 = stmt3.executeQuery(sqlcmd3);	// query the maximum loan_id at this moment
			result3.next();
			String maxloanid = result3.getString("Maxloanid");
			int newId = Integer.parseInt(maxloanid) + 1;	// new Loan_id
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			String dateOut = format.format(new Date());
			Calendar c = Calendar.getInstance();
			c.setTime(new Date());
			c.add(Calendar.DATE, 14); // Adding 14 days
			String dueDate = format.format(c.getTime());
			String sqlcmd4 = "INSERT INTO BOOK_LOANS VALUES ('" + newId + "','" + isbn + "','" + branchId + "','" + cardNo + "','" + dateOut + "','" + dueDate + "',NULL);";
			stmt3.executeUpdate(sqlcmd4);
			result3.close();
		}
		result1.close();
		result2_1.close();
		result2_2.close();
		conn.close();
	%>
		<br/>
		<div class="alert alert-success container" role="alert">
	        <strong>SUCCESS!</strong> This book is successfully checked out.
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