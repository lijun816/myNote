select *, 1 as sample, getdate() as sample_time
 into #wait_stats
 from sys.dm_os_wait_stats
 
 waitfor delay '00:00:30'
 insert #wait_stats
 select *, 2, getdate()
 from sys.dm_os_wait_stats
 
 -- figure out the deltas
 
 select w2.wait_type
 ,w2.waiting_tasks_count - w1.waiting_tasks_count as d_wtc
 , w2.wait_time_ms - w1.wait_time_ms as d_wtm
 , cast((w2.wait_time_ms - w1.wait_time_ms) as float) /
 cast((w2.waiting_tasks_count - w1.waiting_tasks_count) as float) as avg_wtm
 , datediff(ms, w1.sample_time, w2.sample_time) as interval
 from #wait_stats as w1 inner join #wait_stats as w2 on w1.wait_type =
 w2.wait_type
 where w1.sample = 1
 and w2.sample = 2
 and w2.wait_time_ms - w1.wait_time_ms > 0
 and w2.waiting_tasks_count - w1.waiting_tasks_count > 0
 order by 3 desc
 
 drop table #wait_stats
