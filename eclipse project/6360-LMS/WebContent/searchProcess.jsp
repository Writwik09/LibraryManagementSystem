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
    <meta name="description" content="Search Process Page"/>
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
            <li class="active"><a href="search.jsp">Search</a></li>
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
    
	
    <!-- SEARCH
	================================================== -->
	<div class="container">
	<div class="page-header text-primary"><h4 class="text-center">Please search the book you want:</h4></div>
	  <form id="bsform" class="form-search" action="searchProcess.jsp" method="post"  data-ng-app="">
        <span class="col-xs-3">ISBN<input type="text" name="bkisbn" class="form-control" data-ng-model="in1"></input></span>
        <span class="col-xs-4">TITLE<input type="text" name="bktitle" class="form-control" data-ng-model="in2"></input></span>
        <span class="col-xs-3">AUTHOR<input type="text" name="bkauthor" class="form-control" data-ng-model="in3"></input></span>
        <span class="col-xs-2 input-sm"><input id="bs" class="btn btn-lg btn-primary btn-block" type="submit" value="Search" data-ng-disabled="!(in1 || in2 || in3)"></input></span>
      </form>
	</div>
	
	<%-- PROCESS SEARCH --%>
	<%! String mysqlpassword = "123"; %>
	<%
		String isbn=request.getParameter("bkisbn");
		String title=request.getParameter("bktitle");
		String author=request.getParameter("bkauthor");
		if (isbn == null || isbn.equals("")) {
			isbn = "%";
		}
		if (title == null || title.equals("")) {
			title = "%";
		} else {
			title = "%" + title + "%";
		}
		if (author == null || author.equals("")) {
			author = "%";
		} else {
			author = "%" + author + "%";
		}
		
		// use the Library_Management_System library
		String sqlcmd0="USE Library_Management_System;";

		// query isbn, title, author names, branch id, branch name, # book copy
		String sqlcmd1 = "SELECT * FROM (";
		sqlcmd1 += "SELECT B.Isbn, B.Title, GROUP_CONCAT(DISTINCT A.Fullname ORDER BY A.Author_id SEPARATOR ', ') AS Fullnames, BC.Branch_id, Branch_name, No_of_copies ";
		sqlcmd1 += "FROM BOOK AS B, AUTHORS AS A, BOOK_AUTHORS AS BA, LIBRARY_BRANCH AS LB, BOOK_COPIES AS BC ";
		sqlcmd1 += "WHERE B.Isbn=BA.Isbn AND BA.Author_id=A.Author_id AND BC.Book_id=BA.Isbn AND LB.Branch_id=BC.Branch_id AND B.Isbn LIKE '" + isbn + "' AND B.Title LIKE '" + title + "' ";
		sqlcmd1 += "GROUP BY BA.Isbn, BC.Book_id, BC.Branch_id) AS TEMPTABLE ";
		sqlcmd1 += "WHERE Fullnames LIKE '" + author + "';";
		
		// connect to database
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/", "root", mysqlpassword);
		Statement stmt1 = conn.createStatement();
		Statement stmt2 = conn.createStatement();
		
		stmt1.executeQuery(sqlcmd0);
		ResultSet result1 = stmt1.executeQuery(sqlcmd1);
	  %>
	
	
	<!-- SEARCH RESULT
	================================================== -->
	<div class="container">
	  <div class="page-header text-primary"><h4 class="text-center">Search Result:</h4></div>
	  
	  <table class="table table-striped">
	    <thead>
		  <tr>
		    <th>ISBN</th>
		    <th>Title</th>
		    <th>Author</th>
		    <th>Branch ID</th>
		    <th>Branch Name</th>
		    <th># Book Copy</th>
		    <th># Copy Available</th>
		  </tr>
		</thead>
		<tbody>
		<%
			while (result1.next()) {%>
		  <tr>
		  
		    <td><%=result1.getString("Isbn") %></td>
		    <td><%=result1.getString("Title") %></td>
		    <td><%=result1.getString("Fullnames") %></td>
		    <td><%=result1.getString("Branch_id") %></td>
		    <td><%=result1.getString("Branch_name") %></td>
		    <td><%=result1.getString("No_of_copies") %></td>
		    <%  String sqlcmd2 = "SELECT COUNT(*) AS Copynotavailable FROM BOOK_LOANS AS BL WHERE BL.Isbn='" + result1.getString("Isbn") + "' AND BL.Branch_id='" + result1.getString("Branch_id") + "' AND BL.Date_in IS NULL;"; 
		    	ResultSet result2 = stmt2.executeQuery(sqlcmd2);
		    	result2.next();
		    	int Copyavailable = Integer.parseInt(result1.getString("No_of_copies")) - result2.getInt("Copynotavailable");
		    	result2.close();
		    %>
		    <td><%=Copyavailable %></td>
		  </tr>
			<% } 
			result1.close();
			conn.close();
		%>
			
		</tbody>
	  </table>
	  
	</div> <!-- /.container -->
	
	
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