package jsons;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
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
		URL url;
		String authorizationToken="";
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
    	    //System.out.println(json);
    	    JsonParser parser = new JsonParser();
    		JsonElement jsonTree = parser.parse(json);
    		JsonObject jsonObject = jsonTree.getAsJsonObject();	
    		JsonArray arr = jsonObject.get("items").getAsJsonArray();
    		for(int index = 0; index < arr.size();index++ )
    		{
    			String start = arr.get(index).getAsJsonObject().get("start").getAsJsonObject().get("dateTime").getAsString();
    			String end = arr.get(index).getAsJsonObject().get("end").getAsJsonObject().get("dateTime").getAsString();
	    		JsonElement rec = arr.get(index).getAsJsonObject().get("recurrence");
	    		String recurrence = "";
	    		if(rec!=null)
	    			 recurrence = rec.getAsJsonArray().get(0).getAsString();
	    		Event e = new Event(start,end,recurrence);
	    		ss.add(e.getSchedule(this.start, this.dead));
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
