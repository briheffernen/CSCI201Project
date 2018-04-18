<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css">
<style>
.title {
	margin: auto auto;
	padding: 10px;
	width: 35%;
	background-color: CornflowerBlue;
	text-align: center;
	border-radius: 10px;
	color: white;
}
.centerme {
	margin: auto auto;
	width: 50%;
	text-align: center;
}
</style>
<title>Insert title here</title>
<%@page import="java.util.ArrayList,java.io.IOException,java.sql.Connection,java.sql.DriverManager,java.sql.PreparedStatement,java.sql.ResultSet,java.sql.SQLException,java.sql.Statement" %>
<%
	Connection conn = null;
	Statement st = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	ArrayList<String> users = new ArrayList<String>();
	Class.forName("com.mysql.jdbc.Driver"); // anything done after this line will be using this driver
	conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/Final?user=root&password=Chalked1512!&useSSL=false");
	st = conn.createStatement();
	ps = conn.prepareStatement("SELECT u.userName " +  " FROM Users u;");
	rs = ps.executeQuery();
	//rs = st.executeQuery("SELECT s.fname, s.lname, c.prefix, c.num, g.letterGrade " +  " FROM Student s, Grade g, Class c" + " WHERE fname='" + firstName + "' " + " AND s.studentID=g.studentID AND c.classID = g.classID;"); // query returns a table, update used with insert or update and returns an int for how many rows updated
	// use statment if only going to run once and not taking input from the user
	while (rs.next()) {
		String userName = rs.getString("userName");
		users.add(userName);
	}
	System.out.println("start");
	for(int i = 0; i < users.size(); i++)
		System.out.println(users.get(i));
	ArrayList<String> names = new ArrayList<String>();
	names.add("one");
	names.add("two");
	names.add("three");
	names.add("four");
	names.add("five");
	ArrayList<String> locations = new ArrayList<String>();
	locations.add("aaa");
	locations.add("bbb");
	locations.add("ccc");
	locations.add("ddd");
	locations.add("eee");
%>
<script>
	function submit(){
		document.getElementById("place").innerHTML = "what";
	}
	/*function moreMembers()
	{
		var c = document.getElementById("members").children;
		var orig = c[c.length-1];
		var child = orig.cloneNode(true);	
		child.value="";
		document.getElementById("members").append(child);
	} */
	
</script>

</head>
<body>
<div class="container-fluid">
	<nav class="navbar navbar-light bg-light navbar-expand-sm fixed-top">
        <a href="homepage.jsp" class="navbar-brand">When and Where</a>
        <button class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarCollapse">
            <ul class="navbar-nav ml-auto">
                <li class="navbar-item">
                    <a href="profile.jsp" class="nav-link">Profile</a>
                </li>
                <li class="navbar-item">
                    <a href="#" class="nav-link">Settings</a>
                </li>
                <li class="navbar-item">
                    <a href="#" class="nav-link">Logout</a>
                </li>
            </ul>
        </div>
    </nav>
    </div>
    <br>
    <br>
    <br>
    <h1 class="title">Create A Meeting</h1><br>
<div class="container">
<div class="centerme">
	<form id="meeting" action="Meeting_Validation">
	
	<h5 style="text-align: left;">Meeting Name</h5>
	<div class="input-group">
	
	<input name="name" class="form-control"><br>
	</div><br>
	<h5 style="text-align: left;">Meeting Time</h5>
	<div class="input-group">
	<input name="date" type="date" class="form-control"><input name = "time" type="time" class="form-control">
	</div><br>
	<h5 style="text-align: left;">Meeting Duration in Minutes</h5>
	<div class="input-group">
	<input name = "duration" class="form-control">
	</div>
	<br><h5 style="text-align: left;">Add Members:</h5> 
	<div class="input-group">
	
			
			  <input name="membername" id="friends" list="names" class="form-control" placeholder="Member 1">
			  <span class="input-group-btn">
	<button class="btn btn-primary" type="button" onclick="moreMembers()"> More members </button></span>	 
			  </div>
				<span id="response"></span> 
			 <script>
			 var countBox = 1;
				function moreMembers() {
					var num = countBox + 1;
					document.getElementById('response').innerHTML += '<div class="input-group">'
							+ '<input id="memberName' + countBox +'" class="form-control" name="memberName" list="names" placeholder="Member ' + num + '"> </div>';

					countBox += 1;
					
				}
			 </script>
			
	
	
	 <datalist id="names">
	  	<% for(int i = 0; i < users.size(); i++){ %>
	  		<option value="<%= users.get(i) %>">
	  	<%} %>
	  </datalist> 
	  <br>
	 <input type="submit" class="btn-lg btn-primary" value="Submit"> 
	</form>
	</div>
</div>

<div id="place"></div>
</body>
</html>