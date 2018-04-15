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
 * Servlet implementation class addReview
 */
@WebServlet("/addReview")
public class addReview extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("ADDING");

		String review = request.getParameter("leaveReview");
		String name = request.getParameter("user");
		String location = request.getParameter("loc").replaceAll("\\s+", "");

		System.out.println("add review for " + location);

		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		PreparedStatement existCheck = null;

		ResultSet rs1 = null;
		ResultSet rs2 = null;
		ResultSet rs3 = null;

		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager
					.getConnection("jdbc:mysql://localhost/StudySpots?user=root&password=Cactus1010&useSSL=false");
			st = conn.createStatement();

			// Check if User exists
			existCheck = conn.prepareStatement("SELECT u.userID" + " FROM Users u" + " WHERE u.userName=?");
			existCheck.setString(1, name);

			rs1 = existCheck.executeQuery();

			if (!rs1.next()) {
				ps = conn.prepareStatement("INSERT INTO Users (userName)" + " VALUES (?)");
				ps.setString(1, name);

				ps.executeUpdate();
				System.out.println("No " + name + "existed. done 1");

				ps.close();
			}
			existCheck.close();
			rs1.close();
			System.out.println("done this thing");

			// Check if Location exists
			existCheck = conn.prepareStatement("SELECT l.locationID" + " FROM Location l" + " WHERE l.locName=?");
			existCheck.setString(1, location);

			rs2 = existCheck.executeQuery();

			if (!rs2.next()) {
				ps = conn.prepareStatement("INSERT INTO Location (locName) VALUES (?)");
				ps.setString(1, location);

				ps.executeUpdate();
				System.out.println("done 2");

				ps.close();
			}
			rs2.close();
			existCheck.close();
			System.out.println("done this thing too");

			// Add to LocationReviews table

			ps = conn.prepareStatement("SELECT u.userID, l.locationID" + " FROM Users u, Location l"
					+ " WHERE u.userName=?" + " AND l.locName=?");

			ps.setString(1, name); // set first variable in prepared statement
			ps.setString(2, location);

			rs3 = ps.executeQuery();
			System.out.println("done 3");

			int user;
			int loc;

			if (rs3.next()) {
				user = rs3.getInt("userID");
				loc = rs3.getInt("locationID");

				System.out.println("Got result stuff");
				System.out.println("userid: " + user + "\nlocid: " + loc);

				ps = conn.prepareStatement("INSERT INTO LocationReviews (locationID, userID, review) VALUES (?,?,?)");

				ps.setInt(1, loc); // set first variable in prepared statement
				ps.setInt(2, user);
				ps.setString(3, review);

				ps.executeUpdate();
				System.out.println("done 4");

			}

			// Now now longer subject to SQL Injection

		} catch (SQLException sqle) {
			System.out.println("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (rs3 != null) {
					rs3.close();
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
		}

		String pageToForward = "/Location.jsp";

		RequestDispatcher dispatch = getServletContext().getRequestDispatcher(pageToForward);
		dispatch.forward(request, response); // separates front end from back

	}

}
