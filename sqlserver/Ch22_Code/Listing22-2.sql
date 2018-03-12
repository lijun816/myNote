CREATE TABLE [dbo].[SubscriptionInfo] (
      [SubscriptionInfoID] [int] NOT NULL PRIMARY KEY 
    , [SubscriberName] [nvarchar] (50) NOT NULL 
    , [EmailAddress] [nvarchar] (256) NOT NULL 
    , [Path] [nvarchar] (256) NOT NULL 
    , [FileName] [nvarchar] (256) NOT NULL 
    , [Format] [nvarchar] (20) NOT NULL 
    , [Comment] [nvarchar] (256) NOT NULL 
    , [ReportNameFilter] [nvarchar] (200) NOT NULL
) ON [PRIMARY]
GO