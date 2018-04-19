package jsons;

import java.util.ArrayList;
import java.util.concurrent.ForkJoinPool;

public class ScheduleSet {
	public ArrayList<Schedule> ss;
	
	public ScheduleSet()
	{
		ss = new ArrayList<Schedule>();
	}
	public void add(Schedule s)
	{
		ss.add(s);
	}
	public Schedule merge()
	{
		while(ss.size() > 1)
		{
			ArrayList<Schedule> t = new ArrayList<Schedule>();
			ForkJoinPool pool = new ForkJoinPool();
			ArrayList<Merge> mergeThreads = new ArrayList<Merge>();
		    for (int i=0; i < ss.size(); i++) 
		    {
		    	if(i==ss.size()-1)
		    		t.add(ss.get(i));
		    	else
		    		mergeThreads.add(new Merge(ss.get(i),ss.get(i+1)));
		    	i++;
		    }
		    for (int i=0; i < mergeThreads.size(); i++) 
		    	pool.execute(mergeThreads.get(i));
		    for (int i=0; i < mergeThreads.size(); i++) 
		    	t.add(mergeThreads.get(i).join());
		    ss=t;
		}
		return ss.get(0);
	}
	public void print()
	{
		for(int i = 0; i < ss.size();i++)
			ss.get(i).print();
	}
}
