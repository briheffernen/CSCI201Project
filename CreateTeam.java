package CSCI_201;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class CreateTeam
 */
@WebServlet("/CreateTeam")
public class CreateTeam extends HttpServlet {
	private static final long serialVersionUID = 1L;
 	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String pageToForward = "/TeamPage.jsp";
		String teamName = request.getParameter("teamName");
		if (teamName == null || teamName.equals(""))
		{
			pageToForward = "/CreateATeam.jsp";
			request.setAttribute("nameError", "Error: need  a team name.");
		}
		int numMembers = Integer.parseInt(request.getParameter("memberCount"));
		String memberCount = request.getParameter("memberCount");
		System.out.println(memberCount);
		request.setAttribute("memberCount", memberCount);
		ArrayList<String> teamMembers = new ArrayList<String>();
		
		for (int i=0; i<numMembers; i++)
		{
			int j = i+1;
			String tM = "teamMember" + j;
			System.out.println(tM);
			if (request.getParameter(tM) == null)
			{
				pageToForward = "/CreateATeam.jsp";
				request.setAttribute("memberError", "Error: Team Members cannot be empty or duplicates.");
			}
			if (teamMembers.contains(request.getParameter(tM)))
			{
				pageToForward = "/CreateATeam.jsp";
				request.setAttribute("memberError", "Error: Team Members cannot be empty or duplicates.");
			}
			teamMembers.add(request.getParameter(tM));
			request.setAttribute(tM, teamMembers.get(i));
			System.out.println(request.getParameter(tM));
		}
		System.out.println(teamName);
		request.setAttribute("teamName",teamName);
	
		System.out.println(numMembers);
		ArrayList<String> users= new ArrayList<String>();
		// code for populating array list of users
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			Class.forName("com.mysql.jdbc.Driver"); // anything done after this line will be using this driver
			conn = DriverManager.getConnection("jdbc:mysql://localhost/Final?user=root&password=Chalked1512!&useSSL=false");
			st = conn.createStatement();
			ps = conn.prepareStatement("SELECT u.userName " +  " FROM Users u;");
			rs = ps.executeQuery();
			//rs = st.executeQuery("SELECT s.fname, s.lname, c.prefix, c.num, g.letterGrade " +  " FROM Student s, Grade g, Class c" + " WHERE fname='" + firstName + "' " + " AND s.studentID=g.studentID AND c.classID = g.classID;"); // query returns a table, update used with insert or update and returns an int for how many rows updated
			// use statment if only going to run once and not taking input from the user
			while (rs.next()) {
				String userName = rs.getString("userName");
				users.add(userName);
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
		
		RequestDispatcher dispatch = getServletContext().getRequestDispatcher(pageToForward);
		dispatch.forward(request, response);
	}

	

}
