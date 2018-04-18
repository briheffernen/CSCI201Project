<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.Connection"%>
<%@ page import ="java.sql.DriverManager"%>
<%@ page import ="java.sql.PreparedStatement"%>
<%@ page import ="java.sql.ResultSet"%>
<%@ page import ="java.sql.SQLException"%>
<%@ page import ="java.sql.Statement"%>
<%@ page import ="java.util.ArrayList"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Profile Page</title>
	<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css">
	<%
	ArrayList<String> meetingNames = new ArrayList<String>();
	ArrayList<String> meetingTimes = new ArrayList<String>();
	ArrayList<String> meetingLocations = new ArrayList<String>();
	
	ArrayList<String> teamNames = new ArrayList<String>();
	
	HttpSession mySession = request.getSession();
	String userName = request.getParameter("name");
	String userID = request.getParameter("email");
	if (userID != null)
	{
		mySession.setAttribute("userID", userID);
	}
	else
	{
		userID = (String)mySession.getAttribute("userID");
	}
	if (userName != null)
	{
		mySession.setAttribute("userName", userName);
	}
	else {
		userName = (String)mySession.getAttribute("userName");
	}
	
	Connection conn = null;
	Statement st = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	try {
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://localhost/Final?user=root&password=qawsqaws&useSSL=false");
		st = conn.createStatement();
		
		System.out.println("called once");
		// rs = st.executeQuery("SELECT * from Student where fname='" + name + "'");
		
		// check if user is in database
		ps = conn.prepareStatement("SELECT * FROM users WHERE userID=?");
		ps.setString(1, userID); // set first variable in prepared statement
		rs = ps.executeQuery();
		
		// add user to database if they are not already there
		if (!rs.next())
		{
			ps = conn.prepareStatement("INSERT INTO USERS (userID, userName) VALUES (?, ?)");
			System.out.println("!!!!" + request.getParameter("email"));
			ps.setString(1, request.getParameter("email"));
			ps.setString(2, request.getParameter("name"));
			ps.execute();
		}
		
		// fill in arraylists with info about user's meetings
		ps = conn.prepareStatement("SELECT * FROM meeting_users WHERE userID=?");
		ps.setString(1, userID);
		rs = ps.executeQuery();
		int [] meetingIDs = new int[20];
		int i=0;
		while(rs.next())
		{
			System.out.println("found meeting");
			int meetingID = rs.getInt("meetingId");
			meetingIDs[i] = meetingID;
			i++;
			System.out.println(i);
		}
		for (int j=0; j<i; j++)
		{
			ps = conn.prepareStatement("SELECT * FROM meeting WHERE meetingId=?");
			ps.setInt(1, meetingIDs[j]);
			rs = ps.executeQuery();
			rs.next();
			String meetingName = rs.getString("meetingName");
			String meetingLocation = rs.getString("meetingLocation");
			String meetingTime = rs.getString("meetingTime");
			meetingNames.add(meetingName);
			meetingLocations.add(meetingLocation);
			meetingTimes.add(meetingTime);
		}
		
		
		// fill in arraylists with info about user teams
		ps = conn.prepareStatement("SELECT * FROM TeamMembers WHERE userID=?");
		ps.setString(1, userName);
		rs = ps.executeQuery();
		System.out.println("we are finding teams");
		while(rs.next())
		{
			int teamId = rs.getInt("teamID");
			System.out.println("TEAM ID " + teamId);
			
			PreparedStatement psT = conn.prepareStatement("SELECT * FROM Team WHERE teamID=?");
			psT.setInt(1, teamId);
			ResultSet rsT = psT.executeQuery();
			rsT.next();
			String teamName = rsT.getString("teamName");
			System.out.println("GETTING TEAM NAME " + teamName);
			teamNames.add(teamName);
		}
		
		
	} catch (SQLException sqle) {
		System.out.println ("SQLException: " + sqle.getMessage());
	} catch (ClassNotFoundException cnfe) {
		System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
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
			System.out.println("sqle: " + sqle.getMessage());
		}
	}
	
	
	//TEST!!
	
	
	
	%>
	<script>
	var socket;
	function connectToServer() {
		socket = new WebSocket("ws://localhost:8080/CSCI_201FinalProject/ws");
		socket.onopen = function(event) {
			
			var message = '<%=userName%>';
			sendMessage(message);
			
		}
		socket.onmessage = function(event) {
			document.getElementById("notification").innerHTML += '<div class="alert alert-warning alert-dismissible" role="alert">' +
			  '<span type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></span>' +
			  event.data + '</div>';
		}
		socket.onclose = function(event) {
			
		}
	}
	function sendMessage(message) {
		socket.send(message);
		return false;
	}
</script>
</head>

<style>
#searchoptions {
	margin-top: 60px;
	font-size: 50px;
}
#map {
	height: 400px;
	width: 90%;
	margin: auto auto;
}
.centerme {
	margin: auto auto;
	width: 80%;
}
#mapsection {
	padding-top: 40px;
	padding-bottom: 30px;
}
#usersection {
	padding-top: 40px;
	display: none;
}
#createmeeting_button {
	margin: 20px auto;
	width: 200px;
}
button:focus {
	outline: none !important;
}
.btn-disabled {
	opacity: 0.5;
}
.fader {
	-webkit-transition: .6s;
	transition: .6s;
}
.btn:hover {
	cursor: pointer;
}
.btn-lg:hover {
	cursor: pointer;
}
.row {
	text-align: center;
}
#userResults {
	margin: auto auto;
	width: 70%;
}

</style>
	<body>
	<nav class="navbar navbar-light bg-light navbar-expand-sm fixed-top">
	<a href="#" class="navbar-brand">When and Where</a>
	<button class="navbar-toggler" data-toggle="collapse"
		data-target="#navbarCollapse">
		<span class="navbar-toggler-icon"></span>
	</button>
	<div class="collapse navbar-collapse" id="navbarCollapse">
		<ul class="navbar-nav ml-auto">
			<li class="navbar-item"><a href="#" class="nav-link">Profile</a>
			</li>
			<li class="navbar-item"><a href="#" class="nav-link">Settings</a>
			</li>
			<li class="navbar-item"><a href="#" class="nav-link">Logout</a>
			</li>
		</ul>
	</div>
	</nav>
	<div class="container-fluid">
	<div>i</div><div>i</div><div>  </div>
	
		<h1><%= (String)mySession.getAttribute("userName") %>'s Profile</h1>
		<h3>Id: <%= (String)mySession.getAttribute("userID") %></h3>
		<div id="searchoptions">
			<form name = "meeting_form" method="GET" action = "CreateMeeting.jsp">
				<input type="submit" name="submit" class="btn btn-primary fader" value="Create a Meeting" />
			</form>
			<h4>  </h4>
			<form name="teamCreate" method="GET" action="CreateATeam.jsp">
				<input type="submit" name="submit" class="btn btn-primary fader" value="Create a Team"/>
			</form>
			<h4>  </h4>
		</div>
		<div id = "meetings">
			<h3>Meetings</h3>
			<table class="table">
			<tr><td>Meeting Name</td>
			<td>Meeting Location</td>
			<td>Meeting Time</td></tr>
				<%
					for (int i = 0; i < meetingNames.size(); i++)
					{
						%><tr>
						<td><form name="meeting_form" method="GET" action = "Meeting.jsp">
							<input type="submit" class="btn btn-outline-primary" name="meetingName" value=<%= meetingNames.get(i) %> />
						</form></td>
						<td><h4><%=meetingLocations.get(i)%></h4></td>
						<td><h4><%=meetingTimes.get(i)%></h4></td>
						
						
						</tr><%
						
					}
				%>
			
			</table>
		</div>
		<div id="teams">
			<h3>Teams</h3>
			<table class="table">
			<tr><td>Team ID</td>
			<td>Team Name</td></tr>
				<%
					for (int i = 0; i < teamNames.size(); i++)
					{
						%><tr>
						<td><form name="meeting_form" method="GET" action = "TeamPage.jsp">
							<input type="submit" class="btn btn-outline-primary" name="teamName" value="<%=teamNames.get(i)%>"/>
						</form></td></tr><%
						
					}
				%>
			
			</table>
		</div>
		</div>
	</body>
</html>