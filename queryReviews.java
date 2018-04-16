package CSCI201_Final_Project;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Servlet implementation class validate
 */
@WebServlet("/queryReviews")
public class queryReviews extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("IN VALIDATION");
		String total = "";
		String search = request.getParameter("search");
		String sentFrom = request.getParameter("sentFrom");
		System.out.println("Got review parameter: " + search + "\nSent from: " + sentFrom);

		if (sentFrom.equals("location")) {
			Connection conn = null;
			Statement st = null;
			PreparedStatement ps = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				conn = DriverManager
						.getConnection("jdbc:mysql://localhost/StudySpots?user=root&password=Cactus1010&useSSL=false");
				st = conn.createStatement();
				ps = conn.prepareStatement(
						"SELECT u.userName, r.review, l.locName " + "FROM Users u, LocationReviews r, Location l"
								+ " WHERE locName=?" + " AND r.locationID=l.locationID" + " AND u.userID=r.userID");

				String name = search.replaceAll("\\s+", "");
				System.out.println("Query with " + name);

				ps.setString(1, name);

				rs = ps.executeQuery();

				while (rs.next()) {
					String user = rs.getString("userName");
					String review = rs.getString("review");
					total += user + ":\n" + review + "</br>";
				}

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
			}

			PrintWriter out = response.getWriter(); // command shift o imports everything for you

			System.out.println(total);
			out.println("<p>" + total + "<p>");

			// String pageToForward = "";
			//
			// if (search != null) {
			// pageToForward = "/Location.jsp";
			// }
			//
			// RequestDispatcher dispatch =
			// getServletContext().getRequestDispatcher(pageToForward);
			// dispatch.forward(request, response); // separates front end from back

		} else if (sentFrom.equals("meeting")) {
			String pageToForward = "";

			if (search != null) {
				pageToForward = "/Meeting.jsp";

			}

			RequestDispatcher dispatch = getServletContext().getRequestDispatcher(pageToForward);
			dispatch.forward(request, response); // separates front end from back

		}

	}
}
