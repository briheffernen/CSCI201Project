package jsons;

import java.util.concurrent.RecursiveTask;

public class Merge extends RecursiveTask<Schedule> {
     private Schedule b;
      private Schedule a;
      public static final long serialVersionUID = 1;
      public Merge(Schedule a, Schedule b) {
        this.a = a;
        this.b = b;
      }
      protected Schedule compute() {
    	  int a_index = 0;
    	  int b_index = 0;
    	  Schedule s = new Schedule(a.frame);
    	  while(a_index < a.sched.size() || b_index < b.sched.size())
    	  {
    		  Interval inter = null;
    		  if(a_index < a.sched.size() && b_index < b.sched.size())
    		  {
        		  if(a.sched.get(a_index).intersect(b.sched.get(b_index)))
        		  {
        			  inter = a.sched.get(a_index).merge(b.sched.get(b_index));
        			  a_index++;
        			  b_index++;
        		  }
        		  if(a.sched.get(a_index).before(b.sched.get(b_index)))
        		  {
        			  inter = a.sched.get(a_index);
        			  a_index++;
        		  }
        		  if(a.sched.get(a_index).after(b.sched.get(b_index)))
        		  {
        			  inter = b.sched.get(b_index);
        			  b_index++;
        		  }
    		  }
    		  if(a_index == a.sched.size())
    		  {
    			  inter = b.sched.get(b_index);
    			  b_index++;
    		  }
       		  if(b_index == b.sched.size())
    		  {
    			  inter = a.sched.get(a_index);
    			  a_index++;
    		  }
       		  if(s.sched.get(s.sched.size()-1).intersect(inter))
       		  {
       			  inter = s.sched.get(s.sched.size()-1).merge(inter);
       			  s.sched.remove(s.sched.size()-1);
       		  }
       		  s.sched.add((inter));
    	  }
      return s;
    }
}
