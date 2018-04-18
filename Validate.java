import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;

import java.net.URL;
import java.net.URLEncoder;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

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
            String json = buffer.toString();	
    	    JsonParser parser = new JsonParser();
    		JsonElement jsonTree = parser.parse(json);
    		JsonObject jsonObject = jsonTree.getAsJsonObject();	
    		System.out.println(json);
    		String access_token = jsonObject.get("access_token").getAsString();
    		String refresh_token;
    		if(jsonObject.get("refresh_token") != null)
    			refresh_token = jsonObject.get("refresh_token").getAsString();
    		String next = "/profile.jsp";
    	
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
