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
	ArrayList<Integer> meetingIds = new ArrayList<Integer>();

	ArrayList<String> teamNames = new ArrayList<String>();
	ArrayList<Integer> teamIds = new ArrayList<Integer>();
	
	Connection conn = null;
	Statement st = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	try {
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://localhost/Final?user=root&password=qawsqaws&useSSL=false");
		st = conn.createStatement();
		String id = (request.getParameter("user_id"));
		// rs = st.executeQuery("SELECT * from Student where fname='" + name + "'");
		
		// check if user is in database
		ps = conn.prepareStatement("SELECT * FROM users WHERE userID=?");
		ps.setString(1, id); // set first variable in prepared statement
		rs = ps.executeQuery();
		
		// add user to database if they are not already there
		if (!rs.next())
		{
			ps = conn.prepareStatement("INSERT INTO USERS (userID, userName) VALUES (?, ?)");
			ps.setString(1, request.getParameter("user_id"));
			ps.setString(2, request.getParameter("name"));
			ps.execute();
		}
		
		// fill in arraylists with info about user's meetings
		ps = conn.prepareStatement("SELECT * FROM meeting_users WHERE userID=?");
		ps.setString(1, request.getParameter("user_id"));
		rs = ps.executeQuery();
		
		while(rs.next())
		{
			String name = rs.getString("meetingName");
			String time = rs.getString("meetingTime");
			int meetId = rs.getInt("meetingId");
			meetingNames.add(name);
			meetingTimes.add(time);
			meetingIds.add(meetId);
		}
		
		
		// fill in arraylists with info about user teams
		ps = conn.prepareStatement("SELECT * FROM TeamMembers WHERE userID=?");
		ps.setString(1, id);
		rs = ps.executeQuery();
		
		while(rs.next())
		{
			int teamId = rs.getInt("teamID");
			System.out.println("Team id = " + teamId);
			teamIds.add(teamId);
			PreparedStatement psT = conn.prepareStatement("SELECCT * FROM Team WHERE teamID=?");
			psT.setInt(1, teamId);
			ResultSet rsT = psT.executeQuery();
			String teamName = rsT.getString("teamName");
			System.out.println("Team name = " + teamName);
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
	meetingIds.add(1);
	meetingIds.add(2);
	meetingIds.add(3);
	meetingNames.add("Meet1");
	meetingNames.add("Meet2");
	meetingNames.add("Meet3");
	meetingTimes.add("Time1");
	meetingTimes.add("Time2");
	meetingTimes.add("Time3");
	teamIds.add(1);
	teamNames.add("Team1");
	
	
	%>
</head>
	<body>
	
		<h1><%= request.getParameter("name") %>'s Profile</h1>
		<h3>Id: <%= request.getParameter("user_id") %></h3>
		<div id="meeting_page_form">
			<form name = "meeting_form" method="GET" action = "CreateMeeting.jsp">
				<input type="submit" name="submit" value="Create a Meeting" />
			</form>
		</div>
		<div id = "meetings">
			<h3>Meetings</h3>
			<table>
			<tr><td>Meeting ID</td>
			<td>Meeting Name</td>
			<td>Meeting Time</td></tr>
				<%
					for (int i = 0; i < meetingIds.size(); i++)
					{
						%><tr><td><%= meetingIds.get(i) %></td>
						<td><form name="meeting_form" method="GET" action = "Meeting.jsp">
							<input type="submit" name="meetingName" value=<%= meetingNames.get(i) %> />
						</form></td>
						<td><%= meetingTimes.get(i) %></td>
						
						
						</tr><%
						
					}
				%>
			
			</table>
		</div>
		<div id="teams">
			<h3>Teams</h3>
			<table>
			<tr><td>Team ID</td>
			<td>Team Name</td></tr>
				<%
					for (int i = 0; i < teamIds.size(); i++)
					{
						%><tr><td><%= teamIds.get(i) %></td>
						<td><form name="meeting_form" method="GET" action = "TeamPage.jsp">
							<input type="submit" name="teamName" value=<%= teamNames.get(i) %> />
						</form></td></tr><%
						
					}
				%>
			
			</table>
		</div>
	</body>
</html>