SELECT [SubscriberName]
     , [Path]
     , [FileName] + ' ' +
       CAST( 
         (YEAR(GetDate()) * 10000
         + Month(GetDate()) * 100
         + Day(GetDate()) 
         + CAST(DATEPART(hh, GetDate()) AS decimal) / 100
         + CAST(DATEPART(mi, GetDate()) AS DECIMAL) / 10000 
         + CAST(DATEPART(ss, GetDate()) AS DECIMAL) / 1000000)
       AS nvarchar(20)) AS [FileName]
     , [Format]
     , [Comment]
  FROM [dbo].SubscriptionInfo 
 WHERE [ReportNameFilter] = 'Employee Sales Summary'
