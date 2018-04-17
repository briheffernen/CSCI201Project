<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css">
	<title>Create A Team</title>
		<style>
#searchoptions {
    margin-top: 60px;
    text-align: center;
    font-size: 50px;
}


</style>
<%

ArrayList<String> users= new ArrayList<String>();
HashMap<String, String> userNametoID = new HashMap<String, String>();
// code for populating array list of users
Connection conn = null;
Statement st = null;
PreparedStatement ps = null;
ResultSet rs = null;
try {
	Class.forName("com.mysql.jdbc.Driver");
	// anything done after this line will be using this driver
	conn = DriverManager.getConnection("jdbc:mysql://localhost/Final?user=root&password=Chalked1512!&useSSL=false");
	st = conn.createStatement();
	ps = conn.prepareStatement("SELECT u.userName, u.userID FROM users u;");
	rs = ps.executeQuery();

	
	while (rs.next()) {
		String userName = rs.getString("userName");
		String userID = rs.getString("userID");
		users.add(userID);
		userNametoID.put(userName, userID);
		
	}
	
	HttpSession s = request.getSession();
	s.setAttribute("users", users);
	s.setAttribute("currentUser", "chochola");
	
} catch (SQLException sqle) {
	System.out.println("sqle: " + sqle.getMessage());
} catch (ClassNotFoundException cnfe) {
	System.out.println("cnfe: " + cnfe.getMessage());
} finally {
	try {
		if (rs != null) {
			rs.close();
		}
		if (st != null) {
			st.close();
		}
		if (ps != null) {
			ps.close();
		}
		if (conn != null) {
			conn.close();
		}
	} catch (SQLException sqle) {
		System.out.println("sqle closing streams: " + sqle.getMessage());
	}
	String outputUsers = "";
	for (int i=1; i<users.size(); i++)
	{
		outputUsers += "<option value=" + users.get(i) + ">" + users.get(i) + "</option>";
	}
}

%>
<script>
	var socket;
	function connectToServer() {
		socket = new WebSocket("ws://localhost:8080/CSCI_201FinalProject/ws");
		socket.onopen = function(event) {
			
		}
		socket.onmessage = function(event) {
			document.getElementById("notification").innerHTML += event.data
					+ "<br />";
		}
		socket.onclose = function(event) {
			
		}
	}
	function sendMessage() {
		var message = "";
		for (var i=0; i<countBox-1; i++)
			{
				var num = i+1;
				var id = 'teamMember' + num;
				message += document.getElementById(id).value + ',';
			}
		message += 'You have been added to a new team!';
		socket.send(message);
		return false;
	}
	function validate() {
		var xhttp = new XMLHttpRequest();
		var requeststr = "CreateTeam?";
		requeststr += "teamName=" + document.createTeam_form.teamName.value;
		for (i = 0; i < countBox - 1; i++) {
			requeststr += '&teamMember' + i
			'=' + document.createTeam_form.teamMember.value;
		}
		requeststr += "&memberCount=" + countBox;

		xhttp.open("GET", requeststr, false);
		xhttp.send();
		return true;
	}
</script>
</head>
	<body onload="connectToServer()">
	<div id="navBar">
	<nav class="navbar navbar-light bg-light navbar-expand-sm fixed-top">
        <a href="homepage.jsp" class="navbar-brand">When and Where</a>
        <button class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarCollapse">
            <ul class="navbar-nav ml-auto">
                <li class="navbar-item">
                    <a href="#" class="nav-link">Profile</a>
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
    <div class="container-fluid">
	<form id = "myForm" name = "createTeam_form"  method="GET" action ="CreateTeam" onsubmit="sendMessage()">
		<h4>Create A Team</h4>
		Team Name: <input name="teamName"><%String nameError = (String)request.getAttribute("nameError");
			if (nameError != null && nameError != "")
			{
				%> Error: Team name cannot be blank.<%
			}
		
		%><br>
	Add Team Members 
		<br>
		
		Team Member 1 
						<input id="teamMember1" name="teamMember1" list="users">
						<datalist id="users"> 
						<%
							for (int i=0; i<users.size(); i++)
							{
								%> <option value="<%=users.get(i)%>"></option> <%
							}
						%>
  						</datalist>
			
		
<input type="button" value="Add More Team Members" onclick="addInput()">
	<%String memberError = (String)request.getAttribute("memberError");
		if (memberError != null && memberError != "")
		{
			%> Error: Team members cannot be empty or duplicates <% 
		}
		
		%>
		

<span id="response"></span>
<input type = "hidden" id="numMembers" name = "memberCount">
<script>
var countBox =2;
var boxName = 0;
document.getElementById('numMembers').value = 1;
function addInput()
{
 
document.getElementById('response').innerHTML+='<br/> Team Member ' + countBox + '<input id="teamMember' + countBox +'" name="teamMember' + countBox+'" list="users">';

     countBox += 1;
     document.getElementById('numMembers').value = countBox-1;
}
</script>
	
		<br>
		<input type="submit" value="Create Team">
		
		</form>
		</div>
		<div id="notification"></div>
	</body>
</html>