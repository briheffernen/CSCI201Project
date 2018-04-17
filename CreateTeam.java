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
import javax.servlet.http.HttpSession;

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
		HttpSession mySession = request.getSession();
		String currentUserID = (String) mySession.getAttribute("userID");
		String currentUserName = (String) mySession.getAttribute("userName");
		if (teamName == null || teamName.equals(""))
		{
			pageToForward = "/CreateATeam.jsp";
			request.setAttribute("nameError", "Error: need  a team name.");
		}
		HttpSession s = request.getSession();
	
		ArrayList<String> userList = (ArrayList<String>)s.getAttribute("users");
		int numMembers = Integer.parseInt(request.getParameter("memberCount"));
		String memberCount = request.getParameter("memberCount");
		
		request.setAttribute("memberCount", memberCount);
		ArrayList<String> teamMembers = new ArrayList<String>();
		teamMembers.add(currentUserName);
		request.setAttribute("teamMember1", currentUserName);
		for (int i=0; i<numMembers; i++)
		{
			int j = i+2;
			String tM = "teamMember" + j;
			System.out.println("team MEMBER ADD" + request.getParameter(tM));
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
			if (!userList.contains(request.getParameter(tM)))
			{
				pageToForward = "/CreateATeam.jsp";
				request.setAttribute("memberError", "Error: Team Members cannot be empty or duplicates.");
			}
			if (currentUserName.equals(request.getParameter(tM)))
			{
				pageToForward = "/CreateATeam.jsp";
				request.setAttribute("memberError", "Error: Team Members cannot be empty or duplicates.");
			}
			teamMembers.add(request.getParameter(tM));
			request.setAttribute(tM, teamMembers.get(i));
			
		}
		
		
		request.setAttribute("teamName",teamName);
	
		
		if (pageToForward.equals("/TeamPage.jsp")) {
			ArrayList<String> users= new ArrayList<String>();
			// code for populating array list of users
			Connection conn = null;
			Statement st = null;

			ResultSet rs = null;
			try {
				Class.forName("com.mysql.jdbc.Driver");
				// anything done after this line will be using this driver
				conn = DriverManager.getConnection("jdbc:mysql://localhost/Final?user=root&password=Chalked1512!&useSSL=false");
				st = conn.createStatement();
				String ps = "INSERT INTO Team (teamName) VALUES ('" + teamName + "');";
				st.execute(ps);
				

				rs = st.executeQuery("SELECT t.teamID FROM Team t WHERE teamName='" + teamName +"';");
				//rs = st.executeQuery("SELECT s.fname, s.lname, c.prefix, c.num, g.letterGrade " +  " FROM Student s, Grade g, Class c" + " WHERE fname='" + firstName + "' " + " AND s.studentID=g.studentID AND c.classID = g.classID;"); // query returns a table, update used with insert or update and returns an int for how many rows updated
				// use statment if only going to run once and not taking input from the user
				rs.next();
				int teamID = rs.getInt("teamID");
				ArrayList<String> userIDs = new ArrayList<String>();
				for (int i=0; i<teamMembers.size(); i++)
				{

					//rs = st.executeQuery("SELECT u.userID FROM users u WHERE userName='" + teamMembers.get(i) + "';");
					//rs.next();
					userIDs.add(teamMembers.get(i));
					String statement = "INSERT INTO TeamMembers(userID, teamID) VALUES ('" + teamMembers.get(i) + "','" + teamID + "');";
					st.execute(statement);
				} 
				s.setAttribute("userIDs", userIDs);
				s.setAttribute("teamMembers", teamMembers);

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

					if (conn != null) {
						conn.close();
					}
				} catch (SQLException sqle) {
					System.out.println("sqle closing streams: " + sqle.getMessage());
				}
			}
		}
		
		
		RequestDispatcher dispatch = getServletContext().getRequestDispatcher(pageToForward);
		dispatch.forward(request, response);
	}

	

}
