SELECT [InstanceName]
     , C.[Path] AS [ReportFolder]
     , C.[Name] AS [ReportName]
     , [UserName]
     , CASE [RequestType] 
         WHEN 0 THEN 'Interactive Report' 
         ELSE 'Subscription Report' 
         END AS [ReportType]
     , [TimeStart]
     , [TimeEnd]
     , [TimeDataRetrieval] AS [TimeDataRetrievalMilliseconds]
     , [TimeProcessing] AS [TimeProcessingMilliseconds]
     , [TimeRendering] AS [TimeRenderingMilliseconds]
     , CASE [Source]
         WHEN 1 THEN 'Live'
         WHEN 2 THEN 'Cache'
         WHEN 3 THEN 'Snapshot'
         WHEN 4 THEN 'History'
         WHEN 5 THEN 'Ad Hoc'
         WHEN 6 THEN 'Session'
         WHEN 7 THEN 'RDCE'
         ELSE 'Other'
         END AS [ReportSource]
     , [Status]
     , [ByteCount]
     , [RowCount]
  FROM [ReportServer].[dbo].[ExecutionLog] E
  JOIN [ReportServer].[dbo].[Catalog] C ON E.ReportID = C.ItemID