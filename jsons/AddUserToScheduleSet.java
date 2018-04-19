package jsons;

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
import java.util.ArrayList;
import java.util.Calendar;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class AddUserToScheduleSet extends Thread{
	private String name;
	private ScheduleSet ss;
	private Calendar start;
	private Calendar dead;

	public AddUserToScheduleSet(String name, ScheduleSet s, Calendar st, Calendar e)
	{
		this.name = name;
		ss = s;
		start = st;
		dead =e;
		this.start();
	}
	public void run()
	{
		/*Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String authorizationToken="";

		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/Final?user=root&password=root&useSSL=false");
			st = conn.createStatement();
			String sel = "SELECT * FROM user WHERE userName='"+name+"'";
			System.out.println(sel);
			ps = conn.prepareStatement(sel);
			rs = ps.executeQuery();
			authorizationToken = rs.getString("access_token");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} // anything done after this line will be using this driver
		catch (SQLException e) {
			e.printStackTrace();
		}*/
		String authorizationToken ="ya29.GlyiBRd8fqLNpYk9QZEJnMBeLGktC3rQpoYPG4PFgusOYiP8MGqKrlVuC0oxj-HXikHH0xOMk9biLq-GaYyuYvLkZBdNNpvy9wRC05Nrf1hrSl2TUxG6PpmMU-YMWg";
		URL url;
		try {
			url = new URL("https://www.googleapis.com/calendar/v3/calendars/primary/events");
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("GET");
			con.setRequestProperty("Authorization", "Bearer " + authorizationToken);
			int status = con.getResponseCode();
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
    	    System.out.println(json);
    	    JsonParser parser = new JsonParser();
    		JsonElement jsonTree = parser.parse(json);
    		JsonObject jsonObject = jsonTree.getAsJsonObject();	
    		JsonArray arr = jsonObject.get("items").getAsJsonArray();
    		System.out.println(jsonObject.get("items"));
    		for(int index = 0; index < arr.size();index++ )
    		{
    			try {

    			String start = arr.get(index).getAsJsonObject().get("start").getAsJsonObject().get("dateTime").getAsString();
    			String end = arr.get(index).getAsJsonObject().get("end").getAsJsonObject().get("dateTime").getAsString();
	    		JsonElement rec = arr.get(index).getAsJsonObject().get("recurrence");
	    		String recurrence = "";
	    		if(rec!=null)
	    			 recurrence = rec.getAsJsonArray().get(0).getAsString();
	    		Event e = new Event(start,end,recurrence);
	    		ss.add(e.getSchedule(this.start, this.dead));
    			}
    			catch(NullPointerException e)
    			{
    				 continue;
    			}
    		}
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (ProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
