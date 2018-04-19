package jsons;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;

public class Event {
	private Calendar start;
	private Calendar end;
	private String recurrence;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.ENGLISH);

	
	public Event(String s, String e, String d)
	{
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
	
	public Schedule getSchedule(Calendar s, Calendar e)
	{
		Schedule sch = new Schedule(s,e);
		if(recurrence.equals(""))
		{
			sch.addInterval(new Interval(start,end));
		}
		return sch;
	}
}
