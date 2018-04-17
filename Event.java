package jsons;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Event {
	private LocalDateTime start;
	private LocalDateTime end;
	private String recurrence;
	
	public Event(String s, String e, String d)
	{
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
		start = LocalDateTime.parse(s, formatter);
		end = LocalDateTime.parse(e, formatter);
		recurrence = d;
	}
	
	public Schedule getSchedule(LocalDateTime s, LocalDateTime e)
	{
		Schedule sch = new Schedule(s,e);
		if(recurrence.equals(""))
		{
			sch.addInterval(new Interval(start,end));
		}
		return sch;
	}
}
