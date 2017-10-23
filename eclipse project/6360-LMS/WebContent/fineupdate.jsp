<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page errorPage="error.jsp" %>
<%@ page import="java.io.*,java.util.*, javax.servlet.*, java.text.*" %>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="dbHostApp.dataProcess"%>

<!DOCTYPE html>
<html>
  <head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="description" content="Fine Update Page"/>
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
            <li><a href="cardapply.jsp">Card Apply</a></li>
            <li class="active"><a href="fine.jsp">Fine</a></li>
            <li><a href="about.jsp">About</a></li>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </nav>
    </div>
    
	
    <!-- FINE
	================================================== -->
	<div class="container">
	<div class="page-header text-primary"><h4 class="text-center">Update/Show/Pay Fine:</h4></div>
	  <div class="row">
	    <form id="fineupdateform" class="form-search" action="fineupdate.jsp" method="post">
          <span class="col-xs-3"></span>
          <span class="col-xs-3 input-sm"><input id="fupdate" class="btn btn-lg btn-primary btn-block" type="submit" value="Update Fine Table"></input></span>
        </form>
      </div>
      <br/><br/>
      <div class="row">
        <form id="fineshowform" class="form-search" action="fineshow.jsp" method="post">
          <span class="col-xs-3">Card Number<input type="text" name="fnshowcardno" class="form-control" pattern="[I][D]\d{6}" title="Use the format: IDxxxxxx"></input></span>      
          <span class="col-xs-3 input-sm"><input id="fnshow" class="btn btn-lg btn-primary btn-block" type="submit" value="Show Fine Table"></input></span>
        </form>
      </div>
      <br/>
      <div class="row">
        <form id="finepayform" class="form-search" action="finepay.jsp" method="post"  data-ng-app="">
          <span class="col-xs-3">Card Number<input type="text" name="fnpaycardno" class="form-control" data-ng-model="in1" pattern="[I][D]\d{6}" title="Use the format: IDxxxxxx"></input></span>      
          <span class="col-xs-3 input-sm"><input id="fnpay" class="btn btn-lg btn-primary btn-block" type="submit" value="Pay Fine of This Borrower" data-ng-disabled="!in1"></input></span>
        </form>
      </div>
      <br/><br/>
	</div>
	
	<%-- PROCESS FINE UPDATE --%>
	<%! String mysqlpassword = "123"; %>
	<%
		// use the Library_Management_System library
		String sqlcmd0="USE Library_Management_System;";
		// select relate table
		String sqlcmd1 = "SELECT BL.Loan_id, BL.Due_date, BL.Date_in, F.fine_amt, F.paid FROM BOOK_LOANS AS BL LEFT OUTER JOIN FINES AS F ON BL.Loan_id=F.Loan_id;";
		// update the fine table
		String sqlcmd2 = null;	
		// connect to database
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/", "root", mysqlpassword);
		Statement stmt1 = conn.createStatement();
		Statement stmt2 = conn.createStatement();
		
		stmt1.executeQuery(sqlcmd0);	// use the database
		ResultSet result1 = stmt1.executeQuery(sqlcmd1);
		String loanId = null;
		String dueDate = null;
		String dateIn = null;
		String fineAmt = null;
		String paid = null;
		DecimalFormat df = new DecimalFormat("0.00");
		double fineamount = 0.0;
		while (result1.next()) {
			loanId = result1.getString("Loan_id");
			dueDate = result1.getString("Due_date");
			dateIn = result1.getString("Date_in");
			fineAmt = result1.getString("fine_amt");
			paid = result1.getString("paid");
			
			//!dateIn.equalsIgnoreCase("NULL")
			if (dateIn != null) {	// the book has been returned
				long diffDay = dataProcess.dayDifference(dueDate, dateIn);
            	if (diffDay > 0) {	// the book wasn't returned in time, so there should be a corresponding tuple in the fine table
            		fineamount= diffDay * 0.25;
            		if (fineAmt == null) {	// the tuple has not been created
            			sqlcmd2 = "INSERT INTO FINES VALUES ('" + loanId + "','" + df.format(fineamount) + "','0');" ;
            			stmt2.executeUpdate(sqlcmd2);
            		} else {	// the tuple has been created
            			if (paid.equals("0")) {	// if it's unpaid, process; otherwise, do nothing
                			sqlcmd2 = "UPDATE FINES SET fine_amt='" + df.format(fineamount) + "' WHERE Loan_id ='" + loanId + "';";
                			stmt2.executeUpdate(sqlcmd2);
                		}
            		}
            	}	
			} else {	// the book has not been returned
				long diffDay = dataProcess.dayDifference(dueDate);
				if (diffDay > 0) {	// the due date of this book has passed, so there should be a corresponding tuple in the fine table
					fineamount= diffDay * 0.25;
					if (fineAmt == null) {	// the tuple has not been created
						sqlcmd2 = "INSERT INTO FINES VALUES ('" + loanId + "','" + df.format(fineamount) + "','0');" ;
						stmt2.executeUpdate(sqlcmd2);
					} else {	// the tuple has been created
						sqlcmd2 = "UPDATE FINES SET fine_amt='" + df.format(fineamount) + "' WHERE Loan_id ='" + loanId + "';";
            			stmt2.executeUpdate(sqlcmd2);
					}
				}
			}
		}	
		result1.close();
		conn.close();
	%>
		<br/>
		<div class="alert alert-success container" role="alert">
    		<strong>SUCCESS!</strong> The Fines table is updated.
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