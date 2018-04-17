

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import jsons.*;


/**
 * Servlet implementation class Meeting_Validation
 */
@WebServlet("/Meeting_Validation")
public class Meeting_Validation extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Meeting_Validation() {
        super();
        // TODO Auto-generated constructor stub
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String loc = request.getParameter("locs").trim();
    	String date = request.getParameter("date");
    	String time = request.getParameter("time");
    	String duration = request.getParameter("duration");
    	String names[] = request.getParameterValues("membername");
    	String name = request.getParameter("name");
    	for(int i = 0; i < names.length;i++)
    		System.out.println(names[i]);
    	String location = "randomlocation";
    	String timedate = "'1999-04-26 13:00:00'";
    	String next = "/what.jsp";
    	System.out.println(loc);
    	System.out.println(date);
    	System.out.println(time);
    	Connection conn = null;
    	PreparedStatement ps = null;
    	ResultSet rs = null;
    	try {
			Class.forName("com.mysql.jdbc.Driver");
	    	 String arg ="";
	    	 conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/Final?user=root&password=root&useSSL=false");
			 Statement st = (Statement) conn.createStatement();
			 arg += "INSERT INTO meeting(meetingTime,meetingLocation,meetingName) VALUES(";
			 arg += timedate+",\""+location+"\",\""+name+"\"";
			 arg+=");";
			 System.out.println(arg);
			 st.execute(arg);
			 doLocation(location);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		 //System.out.println(arg);
		//RequestDispatcher dispatch = getServletContext().getRequestDispatcher(next);
		/*
    	try {
    		dispatch.forward(request,response);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
	}
	protected LocalDateTime[] getTimes(String []names, LocalDateTime deadline) {
		Schedule s = new Schedule(LocalDateTime.now(),deadline);
		for(int i = 0; i < names.length;i++)
		{
			URL url;
			String authorizationToken="";
			try {
				url = new URL("https://www.googleapis.com/calendar/v3/calendars/primary/events");
				HttpURLConnection con = (HttpURLConnection) url.openConnection();
				con.setRequestMethod("GET");
				con.setRequestProperty("Authorization", "Bearer " + authorizationToken);
				int status = con.getResponseCode();
				System.out.println(status);

				BufferedReader in = new BufferedReader(
						  new InputStreamReader(con.getInputStream()));
						String inputLine;
						StringBuffer content = new StringBuffer();
						while ((inputLine = in.readLine()) != null) {
						    content.append(inputLine);
						}
						in.close();
				con.disconnect();
				String json = content.toString();	
	    	    //System.out.println(json);
	    	    JsonParser parser = new JsonParser();
	    		JsonElement jsonTree = parser.parse(json);
	    		JsonObject jsonObject = jsonTree.getAsJsonObject();	
	    		JsonArray arr = jsonObject.get("items").getAsJsonArray();
	    		for(int index = 0; index < arr.size();i++ )
	    		{
	    			String start = arr.get(index).getAsJsonObject().get("start").getAsJsonObject().get("dateTime").getAsString();
	    			String end = arr.get(index).getAsJsonObject().get("end").getAsJsonObject().get("dateTime").getAsString();
		    		JsonElement rec = arr.get(index).getAsJsonObject().get("recurrence");
		    		String recurrence = "";
		    		if(rec!=null)
		    			 recurrence = rec.getAsJsonArray().get(0).getAsString();
		    		Event e = new Event(start,end,recurrence);
		    		s.merge(e.getSchedule(s.start, s.deadline));
	    		}
	
			} catch (MalformedURLException e) {
				e.printStackTrace();
			} catch (ProtocolException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return null;
	}
	protected void doLocation(String loc)
	{
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/Final?user=root&password=root&useSSL=false");
			st = conn.createStatement();
			ps = conn.prepareStatement("SELECT * FROM location WHERE locName='"+loc+"')");
			rs = ps.executeQuery();
			String arg="";
			if(!rs.next())
			{
				 st = (Statement) conn.createStatement();
				 arg += "INSERT INTO meeting(locName) VALUES(";
				 arg+=loc;
				 arg+=");";
				 System.out.println(arg);
				 st.execute(arg);
			}
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} // anything done after this line will be using this driver
		catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
