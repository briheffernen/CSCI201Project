package jsons;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Interval {
	private LocalDateTime start;
	private LocalDateTime end;
	
	public Interval(String s, String e)
	{
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
		start = LocalDateTime.parse(s, formatter);
		end = LocalDateTime.parse(e, formatter);
	}
	public Interval(LocalDateTime s, LocalDateTime e)
	{
		start = s;
		end = e;
	}
	public boolean intersect(Interval that)
	{
		if(this.end.compareTo(that.start)==-1)
			return false;
		if(that.end.compareTo(this.start)==-1)
			return false;
		return true;
	}
	public boolean between(Interval first, Interval second)
	{
		return first.before(this) && second.after(this);
	}
	public boolean before(Interval that)
	{
		return (this.end.compareTo(that.start)==-1);
	}
	public boolean after(Interval that)
	{
		return that.before(this);
	}
	public void fitInto(Interval that)
	{
		if(that.end.compareTo(this.end) ==-1)
			this.end = that.end;
		if(this.start.compareTo(that.start)==-1)
			this.start= that.start;
	}
	public Interval merge(Interval that)
	{
		if(!intersect(that))
			return null;
		if(this.end.compareTo(that.end)==-1 && that.start.compareTo(this.start) == -1)
			return that;
		if(that.end.compareTo(this.end)==-1 && this.start.compareTo(that.start) == -1)
			return this;
		if(this.end.compareTo(that.end)==-1)
			return new Interval(this.start, that.end);
		return new Interval(that.start, this.end);
	}


}
