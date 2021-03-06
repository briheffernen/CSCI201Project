

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


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
		
    	String date = request.getParameter("date");
    	String time = request.getParameter("time");
    	String prefdate = request.getParameter("prefdate");
    	String preftime = request.getParameter("preftime");
    	
    	String duration = request.getParameter("duration");
    	String names[] = request.getParameterValues("membername");
    	String name = request.getParameter("name");
    	for(int i = 0; i < names.length;i++)
    		System.out.println(names[i]);
    	
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.ENGLISH);
    	String location = "randomlocation";
    	Calendar deadline = Calendar.getInstance();
    	Calendar prefer = Calendar.getInstance();

    	try {
			deadline.setTime(sdf.parse(date+" "+time));
			prefer.setTime(sdf.parse(prefdate+" "+preftime));

		} catch (ParseException e) {
			e.printStackTrace();
		}
		SimpleDateFormat aaa = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);

    	Calendar set_time = getTimes(names, deadline, prefer,Integer.parseInt(duration)*60*60*1000);
    	String timedate = "'"+aaa.format((Date)set_time.getTime())+"'";
    	String next = "/Meeting.jsp";
    	
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
			 arg += "INSERT INTO meeting(timedate,meetingLocation,meetingName) VALUES(";
			 arg += timedate+",\""+location+"\",\""+name+"\"";
			 arg+=");";
			 System.out.println(arg);
			 st.execute(arg);
			 String sel = "SELECT * FROM meeting WHERE meetingName='"+name+"'";
				System.out.println(sel);
				ps = conn.prepareStatement(sel);
				rs = ps.executeQuery();
				addUsers(names, rs.getInt("meeting_Id"));
			 doLocation(location);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
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
	}
	protected Calendar getTimes(String []names, Calendar deadline, Calendar prefer, double dur) {
		
		ScheduleSet ss = new ScheduleSet();
		ExecutorService executor = Executors.newCachedThreadPool();
		Calendar start = Calendar.getInstance();
		for(int i = 0; i < names.length;i++)//For each user
			executor.execute(new AddUserToScheduleSet(names[i], ss, start, deadline));
		executor.shutdown();
		while (!executor.isTerminated()) {
			Thread.yield();
		}
		Schedule merge = ss.merge();
		dur = dur*60*60*1000;
		Schedule merge_inverse = merge.getInverse();
		int left_counter = 0;
		int right_counter = 0;
		Calendar ans = Calendar.getInstance();
		System.out.println(merge.sched.size());
		for(int i = 0; i < merge.sched.size();i++) {
			if(merge.sched.get(i).timeInInterval(prefer))
			{
				System.out.println("real"+i);

				if(i==0 && i == merge.sched.size()-1)
				{
					for(int j = merge_inverse.sched.size()-1; j >= 0; j--)
						if(merge_inverse.sched.get(j).before(merge.sched.get(i)))
						{
							left_counter = j;
							break;
						}
					for(int j = 0; j <merge_inverse.sched.size(); j++)
						if(merge_inverse.sched.get(j).after(merge.sched.get(i)))
						{
							right_counter = j;
							break;
						}
				}
				else if(i == 0)
				{
					for(int j = merge_inverse.sched.size()-1; j >= 0; j--)
						if(merge_inverse.sched.get(j).before(merge.sched.get(i)))
						{
							left_counter = j;
							break;
						}
					for(int j = 0; j < merge_inverse.sched.size()-1; j++)
						if(merge_inverse.sched.get(j).between(merge.sched.get(i), merge.sched.get(i+1)))
							right_counter = j;

				}
				else if(i == merge.sched.size()-1) 
				{
					for(int j = 0; j <merge_inverse.sched.size(); j++)
						if(merge_inverse.sched.get(j).after(merge.sched.get(i)))
						{
							right_counter = j;
							break;
						}
					for(int j = 1; j < merge_inverse.sched.size(); j++)
						if(merge_inverse.sched.get(j).between(merge.sched.get(i-1), merge.sched.get(i)))
							left_counter = j;
				}
				else {
					for(int j = 1; j < merge_inverse.sched.size(); j++)
						if(merge_inverse.sched.get(j).between(merge.sched.get(i-1), merge.sched.get(i)))
							left_counter = j;
					for(int j = 0; j < merge_inverse.sched.size()-1; j++)
						if(merge_inverse.sched.get(j).between(merge.sched.get(i), merge.sched.get(i+1)))
							right_counter = j;
				}

			}
		}
		for(int j = 0; j < merge_inverse.sched.size(); j++)
			if(merge_inverse.sched.get(j).timeInInterval(prefer))
			{
				System.out.println("inverse");
				Interval interval = new Interval(prefer,merge_inverse.sched.get(j).end );
				if(interval.getSize() > dur) 
					return prefer;
				if(	merge_inverse.sched.get(j).getSize() > dur) 
					{
						ans.setTimeInMillis(merge_inverse.sched.get(j).end.getTimeInMillis() - (long)dur);
						return ans;
					}
				left_counter = j;
				right_counter = j;
			}
		System.out.println("left "+left_counter);
		System.out.println("right "+right_counter);

		while(left_counter >=0 && right_counter < merge_inverse.sched.size())
		{
			System.out.println("here");
			if(merge_inverse.sched.get(left_counter).isCloser(merge_inverse.sched.get(right_counter), prefer))
			{
				if(	merge_inverse.sched.get(left_counter).getSize() > dur) {
					 ans.setTimeInMillis(merge_inverse.sched.get(left_counter).end.getTimeInMillis() - (long)dur);
					 System.out.println(left_counter);
					 break;
				}
				else
					left_counter --;
			}
			else
			{
				System.out.println(merge_inverse.sched.get(right_counter).getSize());
				if(	merge_inverse.sched.get(right_counter).getSize() > dur) {
					 ans.setTimeInMillis(merge_inverse.sched.get(right_counter).start.getTimeInMillis() + (long) dur);
					 System.out.println(right_counter);

					 break;
				}
				else
					right_counter ++;
			}
		}
		return ans;
	}
	
	public static void doLocation(String loc)
	{
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/Final?user=root&password=root&useSSL=false");
			st = conn.createStatement();
			String sel = "SELECT * FROM location WHERE locName='"+loc+"'";
			System.out.println(sel);
			ps = conn.prepareStatement(sel);
			rs = ps.executeQuery();
			String arg="";
			if(!rs.next())
			{
				 st = (Statement) conn.createStatement();
				 arg += "INSERT INTO Location(locName) VALUES(";
				 arg+="'"+loc+"'";
				 arg+=");";
				 System.out.println(arg);
				 st.execute(arg);
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} // anything done after this line will be using this driver
		catch (SQLException e) {
			e.printStackTrace();
		}
	}
	public static void addUsers(String [] names, int meeting_id)
	{
		for(int i = 0; i < names.length;i++) {
		Connection conn = null;
		Statement st = null;

		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/Final?user=root&password=root&useSSL=false");
			String arg="";
			st = conn.createStatement();
				 st = (Statement) conn.createStatement();
				 arg += "INSERT INTO meeting_users(meetingId, userID) VALUES(";
				 arg+=meeting_id+",";
				 arg+="'"+names[i]+"'";
				 arg+=");";
				 System.out.println(arg);
				 st.execute(arg);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} // anything done after this line will be using this driver
		catch (SQLException e) {
			e.printStackTrace();
		}}
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
