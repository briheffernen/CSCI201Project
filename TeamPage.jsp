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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css">
		<title>Team Page</title>
		<style>
#searchoptions {
    margin-top: 60px;
    text-align: center;
    font-size: 50px;
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
#createmeeting_button {
    margin: 20px auto;
    width: 200px;
}

.centerme {
    margin: auto auto;
    width: 20%;
    float: right;
}
.teamName {
	margin: auto auto;
	width: 20%;
}
</style>
<%
    		HttpSession mySession = request.getSession();
    		String currentUser = (String)mySession.getAttribute("userID");
    		String currentUserName = (String)mySession.getAttribute("userName");
    		System.out.println("CURRENT USER + " + currentUser);
    		String tN = (String)request.getParameter("teamName");
    		mySession.setAttribute("teamName", tN);
    		ArrayList<String> userNames = new ArrayList<String>();
    		ArrayList<String> userIDs = new ArrayList<String>();
    		ArrayList<String> meetingNames = new ArrayList<String>();
			ArrayList<String> meetingLocations = new ArrayList<String>();
			ArrayList<String> meetingTimes = new ArrayList<String>();
    		Connection conn = null;
			Statement st = null;

			ResultSet rs = null;
			ResultSet temp = null;
			try {
				Class.forName("com.mysql.jdbc.Driver");
				// anything done after this line will be using this driver
				conn = DriverManager.getConnection("jdbc:mysql://localhost/Final?user=root&password=Chalked1512!&useSSL=false");
				st = conn.createStatement();
				System.out.println("working");
				rs = st.executeQuery("SELECT t.teamID FROM Team t WHERE teamName='" + tN +"';");
	
				rs.next();
				System.out.println("still working");
				int teamID = rs.getInt("teamID");
				rs = st.executeQuery("SELECT u.userID FROM TeamMembers u WHERE teamID='" + teamID + "';");	
				
				while (rs.next())
				{

					String userID = rs.getString("userID");
					
					userIDs.add(userID);
					
				}  /*
				for (int i=0; i<userIDs.size(); i++)
				{
					System.out.println("USER ID " + userIDs.get(i));
					rs = st.executeQuery("SELECT u.userName FROM users u WHERE userID='" + userIDs.get(i) + "';");
					rs.next();
					String name = rs.getString("userName");
					userNames.add(name);
				} 
				String test = "SELECT m.meetingName m.meetingLocation m.meetingTime FROM meeting m WHERE teamID='" + teamID + "';";
				*/
				rs = st.executeQuery("SELECT m.meetingName, m.meetingLocation, m.meetingTime FROM meeting m WHERE teamID='" + teamID + "';");
				System.out.println("STILL WORKING");
				while (rs.next())
				{
					String meetingName = rs.getString("meetingName");
					String meetingLocation = rs.getString("meetingLocation");
					String meetingTime = rs.getString("meetingTime");
					meetingNames.add(meetingName);
					meetingLocations.add(meetingLocation);
					meetingTimes.add(meetingTime);
				}
				

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
					if (temp != null) {
						temp.close();
					}

					if (conn != null) {
						conn.close();
					}
				} catch (SQLException sqle) {
					System.out.println("sqle closing streams: " + sqle.getMessage());
				}
			}
			mySession.setAttribute("teamMemberIDs", userIDs);
			mySession.setAttribute("teamMemberNames", userNames);
    
    %>
<script>
	var socket;
	function connectToServer() {
		socket = new WebSocket("ws://localhost:8080/CSCI_201FinalProject/ws");
		socket.onopen = function(event) {
			
			var message = '<%=currentUserName%>';
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
	<body onload="connectToServer()">
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
    
    <div class="container-fluid">
			<h4 class="teamName"><%=request.getParameter("teamName")%> Team Page</h4> <form action="" method="GET" id="createMeeting">
                <div class="centerme">
                    <input type="hidden" name="teamName" id="teamName" value="<%=(String)request.getParameter("teamName")%>">
                </div>
            </form>
			<h2>Team Members</h2> 
			<table>
			<% String numMembers = request.getParameter("memberCount");
			
			for (int i=0; i<userIDs.size(); i++)
			{
				int j = i+1;
				String tM = "teamMember" + j;
				%> <tr><h4><%=userIDs.get(i)%></h4></tr> <% 
			}
			
			%>
			</table>
		</div>
		<div id="currentMeetings" class="container-fluid">
			<h3>Team Meetings</h3>
			<table>
					<% for (int i=0; i<meetingNames.size(); i++) { %>
						<tr>
						<form name="myForm" method="GET" action="Meeting.jsp">
						<td><input name="meetingName" type="submit" value="<%=meetingNames.get(i)%>"></td>
						</form><br>
						<td>Time: <h5><%=meetingTimes.get(i)%></h5></td><br>
						<td>Location: <h5><%=meetingLocations.get(i)%></h5></td>
						</tr>
						<% } %>
			</table>
		</div>

		<div class="test" id="notification">
		
		</div>
		<script>
$('.test').click(function(){
	$('.test').hide();
});
     </script>


	</body>
</html>