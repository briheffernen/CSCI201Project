<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<%@page import="java.util.ArrayList,java.io.IOException,java.sql.Connection,java.sql.DriverManager,java.sql.PreparedStatement,java.sql.ResultSet,java.sql.SQLException,java.sql.Statement" %>
<%
	Connection conn = null;
	Statement st = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	ArrayList<String> users = new ArrayList<String>();
	Class.forName("com.mysql.jdbc.Driver"); // anything done after this line will be using this driver
	conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/Final?user=root&password=root&useSSL=false");
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
	function moreMembers()
	{
		var c = document.getElementById("members").children;
		var orig = c[c.length-1];
		var child = orig.cloneNode(true);	
		child.value="";
		document.getElementById("members").append(child);
	}
</script>

</head>
<body>
<div >
	<form id="meeting" action="Meeting_Validation">
	Choose Meeting Name:<br>
	<input name="name"><br>
	Choose Meeting Deadline:<br>
	<input name="date" type="date"><input name = "time" type="time"><br>
	Choose Meeting Duration in minutes<br>
	<input name = "duration" ><br>
	<br>Add Members: <br>
		<div id="members">
			  <input name="membername" id="friends" list="names">	 
	</div>
	 <datalist id="names">
	  	<% for(int i = 0; i < users.size(); i++){ %>
	  		<option value="<%= users.get(i) %>">
	  	<%} %>
	  </datalist> 
	 <input type="submit" value="Submit"> 
	</form>
</div>
<button type="button" onclick="moreMembers()"> More members </button>
<div id="place"></div>
</body>
</html>