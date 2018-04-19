import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import jsons.Event;

/**
 * Servlet implementation class Validation
 */
@WebServlet("/Validate")
public class Validate extends HttpServlet {
	private static final long serialVersionUID = 1L;
    protected void doGet(HttpServletRequest request, HttpServletResponse response){
    	String data = request.getParameter("code");
    	String code ="code="+data+"&";
    	try
        {
            Map<String,Object> params = new LinkedHashMap<>();
            params.put("grant_type","authorization_code");
            params.put("client_id","130203725109-1aapvdgu050h3glci9cu7go2qtji7rbu.apps.googleusercontent.com");
            params.put("client_secret","b4wt641TwpMItxrG_iXMyI-A");
            params.put("code",data);
            params.put("redirect_uri","http://localhost:8080/Final/Validate");

            StringBuilder postData = new StringBuilder();
            for(Map.Entry<String,Object> param : params.entrySet())
            {
                if(postData.length() != 0)
                {
                    postData.append('&');
                }
                postData.append(URLEncoder.encode(param.getKey(),"UTF-8"));
                postData.append('=');
                postData.append(URLEncoder.encode(String.valueOf(param.getValue()),"UTF-8"));
            }
            byte[] postDataBytes = postData.toString().getBytes("UTF-8");

            URL url = new URL("https://www.googleapis.com/oauth2/v4/token");
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setDoOutput(true);
            con.setUseCaches(false);
            con.setRequestMethod("POST");
            con.getOutputStream().write(postDataBytes);

            BufferedReader  reader = new BufferedReader(new InputStreamReader(con.getInputStream()));
            StringBuffer buffer = new StringBuffer();
            for (String line = reader.readLine(); line != null; line = reader.readLine())
            {
                buffer.append(line);
            }
			con.disconnect();

            String json = buffer.toString();	
    	    JsonParser parser = new JsonParser();
    		JsonElement jsonTree = parser.parse(json);
    		JsonObject jsonObject = jsonTree.getAsJsonObject();	
    		System.out.println(json);
    		String access_token = jsonObject.get("access_token").getAsString();
    		String refresh_token = null;
    		if(jsonObject.get("refresh_token") != null)
    			refresh_token = jsonObject.get("refresh_token").getAsString();
				url = new URL("https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token="+access_token);
				HttpURLConnection connect = (HttpURLConnection) url.openConnection();
				connect.setRequestMethod("GET");
				int status = connect.getResponseCode();
				System.out.println(status);

				BufferedReader in = new BufferedReader(
						  new InputStreamReader(connect.getInputStream()));
						String inputLine;
						StringBuffer content = new StringBuffer();
						while ((inputLine = in.readLine()) != null) {
						    content.append(inputLine);
						}
						in.close();
				connect.disconnect();
				 json = content.toString();	
	    	    //System.out.println(json);
	    	     parser = new JsonParser();
	    		 jsonTree = parser.parse(json);
	    		 jsonObject = jsonTree.getAsJsonObject();	
	    	String name = jsonObject.get("name").getAsString();
	    	String email = jsonObject.get("email").getAsString();
	    	System.out.println(name);
	    	System.out.println(email);
	    	request.getSession().setAttribute("userName", name);
	    	request.getSession().setAttribute("userID", email);
    		String next = "/profile.jsp";
    		
//////////////////////SQL CODE /////////////////////////
    		
    		
    		
    		
    		
    		
    		
    		
    		
	Connection conn = null;
	Statement st = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	try {
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://localhost/Final?user=root&password=qawsqaws&useSSL=false");
		st = conn.createStatement();
		
		// check if user is in database
		ps = conn.prepareStatement("SELECT * FROM users WHERE userID=?");
		ps.setString(1, (String)request.getSession().getAttribute("userName")); // set first variable in prepared statement
		rs = ps.executeQuery();
		
		// add user to database if they are not already there
		if (!rs.next())
		{
			ps = conn.prepareStatement("INSERT INTO USERS (userID, userName, accessToken, refreshToken) VALUES (?, ?, ?, ?)");
			System.out.println("!!!!" + request.getParameter("email"));
			ps.setString(1, request.getParameter("email"));
			ps.setString(2, request.getParameter("name"));
			ps.setString(3, access_token);
			if(refresh_token != null)
			{
				ps.setString(4, refresh_token);
			}
			else
			{
				ps.setString(4, "");
			}
			ps.execute();
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
	///////////////////// END SQL CODE ///////////////////////
	
    	
	RequestDispatcher dispatch = getServletContext().getRequestDispatcher(next);
		
    	try {
    		dispatch.forward(request,response);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        }  catch (Exception ex)
        {
            ex.printStackTrace(); 
        }
    }
    

}