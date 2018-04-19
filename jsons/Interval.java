package jsons;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class Interval {
	public Calendar start;
	public Calendar end;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.ENGLISH);

	/*public Interval(String s, String e)
	{
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
		start = Calendar.parse(s, formatter);
		end = Calendar.parse(e, formatter);
	}*/
	public Interval(Calendar s, Calendar e)
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
		return (this.end.compareTo(that.start)==-1)||this.end.getTimeInMillis() == that.start.getTimeInMillis();
	}
	public boolean after(Interval that)
	{
		return that.before(this);
	}
	public Interval fitInto(Interval that)
	{
		Calendar newend = Calendar.getInstance();
		Calendar newstart = Calendar.getInstance();
		newend = that.end.compareTo(this.end)==-1?that.end:this.end;
		newstart = this.start.compareTo(that.start)==-1?that.start:this.start;
		return new Interval(newstart,newend);
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
	public boolean timeInInterval(Calendar t)
	{
		return t.after(this.start) && t.before(this.end);
	}
	boolean timeBetweenIntervals(Interval that, Calendar t)
	{
		if(this.intersect(that))
			return false;
		if(that.before(this))
			return t.after(that.end)& t.before(this.start);
		return t.after(this.end)& t.before(that.start);
	}
	public boolean isCloser(Interval that, Calendar target)
	{
		long my_dist = 	java.lang.Math.min(	java.lang.Math.abs(this.end.getTimeInMillis()-target.getTimeInMillis()),java.lang.Math.abs(this.start.getTimeInMillis()-target.getTimeInMillis()));
		long their_dist = java.lang.Math.min(java.lang.Math.abs(that.end.getTimeInMillis()-target.getTimeInMillis()),java.lang.Math.abs(that.start.getTimeInMillis()-target.getTimeInMillis()));
		return my_dist<their_dist;
	}
	boolean fitsBetween(Interval that, int dur)
	{
		if(this.intersect(that))
			return false;
		if(that.before(this))
			return (this.start.getTimeInMillis()-that.end.getTimeInMillis())<dur;
		return (that.start.getTimeInMillis()-this.end.getTimeInMillis())<dur;
	}
	public long getSize()
	{
		return this.end.getTimeInMillis()-this.start.getTimeInMillis();
	}
	public void print()
	{
		System.out.println("start: "+sdf.format((Date)start.getTime()));
		System.out.println("end: "+sdf.format((Date)end.getTime()));
	}

}
