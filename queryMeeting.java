package CSCI201_Final_Project;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class queryMeeting
 */
@WebServlet("/queryMeeting")
public class queryMeeting extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("getting meeting info");
		String search = request.getParameter("meetingName");
		System.out.println("Meeting name: " + search);

		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		ResultSet rs3 = null;

		String time = "";
		String users = "";
		String teams = "";
		String locationName = "";

		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager
					.getConnection("jdbc:mysql://localhost/Final?user=root&password=Cactus1010&useSSL=false");
			st = conn.createStatement();

			// Get meeting location and ID
			ps = conn.prepareStatement("SELECT l.locName, m.meetingID, m.meetingTime" + " FROM Location l, meeting m"
					+ " WHERE meetingName=?" + " AND l.locationID=m.LocationID");

			// String name = search.replaceAll("\\s+", "");
			System.out.println("Query with " + search);
			ps.setString(1, search);

			rs = ps.executeQuery();

			String loc = "";
			int meetingID = 0;
			String meetingTime = "";

			if (rs.next()) {
				loc = rs.getString("locName");
				meetingID = rs.getInt("meetingID");
				meetingTime = rs.getString("meetingTime");
			}

			System.out.println("meeting id: " + meetingID);

			time += "<p>" + meetingTime + "<p>";

			System.out.println("Location name: " + loc);

			System.out.println("Meeting time: " + meetingTime);
			locationName = loc;

			ps.close();
			rs.close();

			// Get users in the meeting

			ps = conn.prepareStatement("SELECT u.userID, m.meetingID" + " FROM Users u, meeting_users m"
					+ " WHERE meetingID=?" + " AND m.userID=u.userID");
			ps.setInt(1, meetingID);

			rs2 = ps.executeQuery();
			System.out.println("Reading in users");

			if (!rs2.next()) {
				users += "<p>This meeting has no users<p><br>";

			} else {
				String userName = rs.getString("userID");
				users += "<p>" + userName + "<p><br>";
				System.out.println("Reading in users");

				while (rs2.next()) {
					userName = rs.getString("userID");
					if (userName != null) {
						users += "<p>" + userName + "<p><br>";

					}
				}
			}

			ps.close();
			rs2.close();

			ps = conn.prepareStatement("SELECT t.teamName, t.teamID" + " FROM Team t, meeting m"
					+ " WHERE m.teamID=t.teamID " + "AND m.meetingID=?");
			ps.setInt(1, meetingID);
			rs3 = ps.executeQuery();

			if (!rs3.next()) {
				teams += "This meeting has no teams<br>";
			} else {
				String teamName = rs3.getString("teamName");
				teams += "<p>" + teamName + "<p><br>";

				while (rs3.next()) {
					teamName = rs3.getString("teamName");
					if (teamName != null) {
						teams += "<p>" + teamName + "<p><br>";
					}
				}
			}

			rs3.close();
			ps.close();

		} catch (SQLException sqle) {
			System.out.println("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println("ClassNotFoundException: " + cnfe.getMessage());
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

			request.getSession().setAttribute("time", time);
			request.getSession().setAttribute("users", users);
			request.getSession().setAttribute("teams", teams);

			request.getSession().setAttribute("locationName", locationName);
			System.out.println("Passing location name: " + locationName);

			String pageToForward = "/Meeting.jsp?meetingName=" + search;

			RequestDispatcher dispatch = getServletContext().getRequestDispatcher(pageToForward);
			dispatch.forward(request, response); // separates front end from back end
		}
	}
}
