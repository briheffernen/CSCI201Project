package jsons;

import java.time.LocalDateTime;
import java.util.ArrayList;

public class Schedule {
	public ArrayList<Interval>sched;
	public LocalDateTime start;
	public LocalDateTime deadline;
	public Interval frame;
	public Schedule(LocalDateTime s, LocalDateTime e)
	{
		start = s;
		deadline = e;
		frame = new Interval(s,e);
		sched = new ArrayList<Interval>();
	}
	public void merge(Schedule that)
	{
		for(int i = 0; i < that.sched.size();i++)
		{
			this.addInterval(that.sched.get(i));
		}
	}
	public void addInterval(Interval inter)
	{
		if(!frame.intersect(inter))
			return;
		inter.fitInto(frame);
		if(sched.isEmpty())
		{
			sched.add(inter);
			return;
		}
		if(inter.before(sched.get(0)))
		{
			sched.add(0, inter);
			return;
		}
		if(inter.after(sched.get(sched.size()-1)))
		{
			sched.add(inter);
			return;
		}
		for(int i = 0; i < sched.size()-1; i++)
		{
			if(inter.between(sched.get(i),sched.get(i+1)))
			{
				sched.add(i+1, inter);
				return;
			}
			if(inter.intersect(sched.get(i)))
			{
				sched.get(i).merge(inter);
				while(true)
				{
					if(i+1 == sched.size())
						break;
					if(!sched.get(i+1).intersect(sched.get(i)))
						break;
					sched.get(i).merge(sched.get(i+1));
					sched.remove(i+1);
				}
			}
		}
	}
	
}
