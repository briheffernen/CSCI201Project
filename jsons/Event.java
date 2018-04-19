package jsons;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;

public class Event {
	private Calendar start;
	private Calendar end;
	private String recurrence;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);

	
	public Event(String s, String e, String d)
	{
		//System.out.println("Event start "+s);
		//System.out.println("Event end "+e);

		s=cleanDate(s);
		
		e = cleanDate(e);
		start = Calendar.getInstance();
		end = Calendar.getInstance();
		try {
			start.setTime(sdf.parse(s));
			end.setTime(sdf.parse(e));
		} catch (ParseException ex) {
			ex.printStackTrace();
		}

		recurrence = d;
	}
	public static String cleanDate(String d)
	{
		String ans="";
		String [] arr = d.replaceAll("T", " ").split("-");
		for(int i = 0; i < arr.length-1;i++)
			{
				ans+=arr[i];
				if(i <2)
					ans+="-";
			}
		return ans;
	}
	public Schedule getSchedule(Calendar s, Calendar e)
	{
		Schedule sch = new Schedule(s,e);
		if(recurrence.equals(""))
		{
			sch.addInterval(new Interval(start,end));
		}
		else{
			ArrayList<Interval> bases = new ArrayList<Interval>();
			for(int i =0; i < bases.size();i++)
				sch.addInterval(bases.get(i));
		}
		return sch;
	}
}
