package jsons;

import java.util.Calendar;
import java.util.ArrayList;

public class Schedule {
	public ArrayList<Interval>sched;
	public Interval frame;
	public Schedule(Calendar s, Calendar e)
	{
		frame = new Interval(s,e);
		sched = new ArrayList<Interval>();
	}
	public Schedule(Interval f)
	{
		frame = f;
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
	public Schedule getInverse()
	{
		Schedule n = new Schedule(this.frame);
		if(sched.isEmpty())
			return n;
		n.addInterval(new Interval(frame.start,sched.get(0).start));
		for(int i = 0; i <sched.size()-1;i++)
			n.addInterval(new Interval(sched.get(i).end,sched.get(i+1).start));
		n.addInterval(new Interval(sched.get(sched.size()-1).end,frame.end));
		return n;
	}
	public void print()
	{
		for(int i = 0; i < sched.size();i++)
			sched.get(i).print();
	}
}
