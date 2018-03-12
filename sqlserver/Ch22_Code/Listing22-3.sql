INSERT INTO [dbo].[SubscriptionInfo] 
       ( [SubscriptionInfoID]
       , [SubscriberName]
       , [EmailAddress]
       , [Path]
       , [FileName]
       , [Format]
       , [Comment]
       , [ReportNameFilter]
       ) 
VALUES (   '1'
         , 'Bradley Schacht'
         , 'bogusaddress@somedomain.com'
         , '\\JURJD31DSBC\FileShare'
         , 'Bradleys File'
         , 'IMAGE'
         , 'Hi Bradley, here is your report.'
         , 'Employee Sales Summary')
     , (   '2'
         , 'Collin Knight'
         , 'bogusaddress@somedomain.com'
         , '\\JURJD31DSBC\FileShare'
         , 'Collins Data'
         , 'MHTML'
         , 'Hey Collin, here is your report.'
         , 'Employee Sales Summary'
       )
     , (   '3'
         , 'Captain America'
         , 'arcanecode@gmail.com'
         , '\\JURJD31DSBC\FileShare'
         , 'Captain Americas Stuff'
         , 'PDF'
         , 'The Hulk stole my shield again.'
         , 'Employee Sales Summary'
       );
