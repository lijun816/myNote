SELECT top 5 * FROM sys.dm_db_session_space_usage
ORDER BY (user_objects_alloc_page_count + internal_objects_alloc_page_count) DESC
go
select sum(user_object_reserved_page_count)*8 as user_objects_kb,
    sum(internal_object_reserved_page_count)*8 as internal_objects_kb,
    sum(version_store_reserved_page_count)*8  as version_store_kb,
    sum(unallocated_extent_page_count)*8 as freespace_kb
from sys.dm_db_file_space_usage
where database_id = 2
go
/*
partitioning
*/
CREATE PARTITION FUNCTION
PFL_Years (datetime)
AS RANGE RIGHT
FOR VALUES (
'20050101 00:00:00.000', '20070101 00:00:00.000', 
'20090101 00:00:00.000', '20110101 00:00:00.000', 
'20120101 00:00:00.000')
go
CREATE PARTITION SCHEME CYScheme
AS
PARTITION PFL_Years
TO ([CY04], [CY06], [CY08], [CY10], [CY11], [CY12])
go
CREATE PARTITION SCHEME CYScheme2
AS
PARTITION PFL_Years
TO ([Default], [Default], [Default], [Default], [Default], [Default])
go
CREATE TABLE [dbo].[Tickets]
(     [TicketID] [int] NOT NULL,
       [CustomerID] [int] NULL,
       [State] [int] NULL,
        [Status] [tinyint] NOT NULL,
        [TicketDate] [datetime] NOT NULL
        CONSTRAINT TicketYear
        CHECK ([TicketDate] >= '20050101 00:00:00.000'
AND [TicketDate] < '20120101 00:00:00.000'))
ON CYScheme (TicketDate)
GO
 
CREATE TABLE [dbo].[Activities]
(     [TicketID] [int] NOT NULL,
       [ActivityDetail] [varchar] (255) NULL,
      [TicketDate] [datetime] NOT NULL,
       [ActivityDate] [datetime] NOT NULL
       CONSTRAINT ActivityYear
       CHECK ([ActivityDate] >= '20050101 00:00:00.000'
AND [ActivityDate] < '20120101 00:00:00.000'))
ON CYScheme (TicketDate)
GO
USE AdventureWorks;
CREATE PARTITION FUNCTION [OrderDateRangePFN](datetime)
AS RANGE RIGHT
FOR VALUES (N'2009-01-01 00:00:00', N'2010-01-01 00:00:00',
N'2011-01-01 00:00:00', N'2012-01-01 00:00:00');
go
CREATE PARTITION SCHEME [OrderDatePScheme]
AS PARTITION [OrderDateRangePFN]
TO ([Primary], [Primary], [Primary], [Primary], [Primary]);
go
CREATE TABLE [dbo].[SalesOrderHeader](
  [SalesOrderID] [int] NULL,
  [RevisionNumber] [tinyint] NOT NULL,
  [OrderDate] [datetime] NOT NULL,
  [DueDate] [datetime] NOT NULL,
  [ShipDate] [datetime] NULL,
  [Status] [tinyint] NOT NULL
) ON [OrderDatePScheme]([OrderDate]);
 
CREATE TABLE [dbo].[SalesOrderHeaderOLD](
  [SalesOrderID] [int] NULL,
  [RevisionNumber] [tinyint] NOT NULL,
  [OrderDate] [datetime] NOT NULL  ,
  [DueDate] [datetime] NOT NULL,
  [ShipDate] [datetime] NULL,
  [Status] [tinyint] NOT NULL);
 
INSERT INTO SalesOrderHeader SELECT [SalesOrderID],[RevisionNumber],
[OrderDate],[DueDate],[ShipDate],[Status] FROM SALES.[SalesOrderHeader];
 
CREATE CLUSTERED INDEX SalesOrderHeaderCLInd
ON SalesOrderHeader(OrderDate) ON OrderDatePScheme(OrderDate);
 
 CREATE CLUSTERED INDEX SalesOrderHeaderOLDCLInd ON
SalesOrderHeaderOLD(OrderDate);
 
ALTER  TABLE [DBO].[SalesOrderHeaderOLD]  WITH CHECK  ADD CONSTRAINT
[CK_SalesOrderHeaderOLD_ORDERDATE] CHECK  ([ORDERDATE]>=('2011-01-01
00:00:00') AND [ORDERDATE]<('2012-01-01 00:00:00'));
go
SELECT $partition.OrderDateRangePFN(OrderDate) AS 'Partition Number', 
min(OrderDate) AS 'Min Order Date',
max(OrderDate) AS 'Max Order Date',
count(*) AS 'Rows In Partition'
FROM SalesOrderHeader 
GROUP BY $partition.OrderDateRangePFN(OrderDate);
go
SELECT * FROM [SalesOrderHeaderOLD]
go
ALTER TABLE SalesOrderHeader
SWITCH PARTITION 4 TO SalesOrderHeaderOLD;
go
ALTER TABLE SalesOrderHeaderOLD  
SWITCH TO SalesOrderHeader PARTITION 4;
go
ALTER PARTITION FUNCTION OrderDateRangePFN()
MERGE RANGE ('2011-01-01 00:00:00');
go
ALTER PARTITION SCHEME OrderDatePScheme NEXT USED [Primary];
ALTER PARTITION FUNCTION OrderDateRangePFN()
SPLIT RANGE ('2013-01-01 00:00:00');
/*
compression
*/
/*
CREATE OUR DEMO DATABASE
AND TABLE
*/
USE MASTER
GO
IF EXISTS(SELECT NAME FROM SYS.DATABASES WHERE NAME='COMPRDEMOS')
BEGIN
	DROP DATABASE COMPRDEMOS
END
GO
CREATE DATABASE COMPRDEMOS
GO
USE COMPRDEMOS
GO
CREATE TABLE UNCOMPRESSED
	(
		MYID INT IDENTITY(1,1)
		,MYCHAR CHAR(500) DEFAULT 'A'
	)
GO
/*
INSERT 5000 UNCOMPRESSED ROWS
INTO OUR TABLE
*/
INSERT INTO UNCOMPRESSED
DEFUALT VALUES
GO 5000
/*
EXAMINE THE SPACE USED BY TABLE
UNCOMPRESSED BEFORE APPLYING
ROW COMPRESSION AND AFTER
*/

SP_SPACEUSED 'UNCOMPRESSED'
GO
ALTER TABLE UNCOMPRESSED
REBUILD WITH(DATA_COMPRESSION=ROW)
GO
SP_SPACEUSED 'UNCOMPRESSED'
go
USE AdventureWorks
 GO
 CREATE TABLE [Person].[AddressType_Compressed_Page](
  [AddressTypeID] [int] IDENTITY(1,1) NOT NULL,
  [Name] [dbo].[Name] NOT NULL,
  [rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
  [ModifiedDate] [datetime] NOT NULL,
 )
 WITH (DATA_COMPRESSION=PAGE)
 GO

  USE AdventureWorks
 GO
 ALTER TABLE Person.AddressType_Compressed_Page REBUILD
 WITH (DATA_COMPRESSION=PAGE)
 GO
  USE AdventureWorks
 GO
 
 CREATE PARTITION FUNCTION [TableCompression](Int)
 AS RANGE RIGHT
 FOR VALUES (1, 10001, 12001, 16001);
 GO
 
 CREATE PARTITION SCHEME KeyRangePS
 AS
 PARTITION [TableCompression]
 TO ([Default], [Default], [Default], [Default], [Default])
 GO
 
 CREATE TABLE PartitionTable
 (KeyID int,
 Description varchar(30))
 ON KeyRangePS (KeyID)
 WITH
 (
 DATA_COMPRESSION = ROW ON PARTITIONS (1),
 DATA_COMPRESSION = PAGE ON PARTITIONS (2 TO 4)
 )
 GO
 
 CREATE INDEX IX_PartTabKeyID
  ON PartitionTable (KeyID)
 WITH (DATA_COMPRESSION = ROW ON PARTITIONS(1),
 DATA_COMPRESSION = PAGE ON PARTITIONS (2 TO 4 ) )
 GO

 /*
 Resource Governor
 */
 USE Master;
BEGIN TRAN;
CREATE RESOURCE POOL poolAdhoc with
( MIN_CPU_PERCENT = 10, MAX_CPU_PERCENT = 30,
MIN_MEMORY_PERCENT= 15, MAX_MEMORY_PERCENT= 25,
MIN_IOPS_PER_VOLUME=0, MAX_IOPS_PER_VOLUME=2147483647);
 
CREATE RESOURCE POOL poolReports with
( MIN_CPU_PERCENT = 20, MAX_CPU_PERCENT = 35,
MIN_MEMORY_PERCENT= 15,  MAX_MEMORY_PERCENT= 45,
MIN_IOPS_PER_VOLUME=0, MAX_IOPS_PER_VOLUME=2147483647);

CREATE RESOURCE POOL poolAdmin with
( MIN_CPU_PERCENT = 15, MAX_CPU_PERCENT = 25,
MIN_MEMORY_PERCENT= 15,  MAX_MEMORY_PERCENT= 30,
MIN_IOPS_PER_VOLUME=0, MAX_IOPS_PER_VOLUME=2147483647);

CREATE WORKLOAD GROUP groupAdhoc using poolAdhoc;
CREATE WORKLOAD GROUP groupReports with (MAX_DOP = 8) using poolReports;
CREATE WORKLOAD GROUP groupAdmin using poolAdmin;
GO
CREATE FUNCTION rgclassifier_v1() RETURNS SYSNAME
WITH SCHEMABINDING
AS
BEGIN
     DECLARE @grp_name AS SYSNAME
       IF (SUSER_NAME() = 'sa')
           SET @grp_name = 'groupAdmin'
       IF (APP_NAME() LIKE '%MANAGEMENT STUDIO%')
           OR (APP_NAME() LIKE '%QUERY ANALYZER%')
           SET @grp_name = 'groupAdhoc'
       IF (APP_NAME() LIKE '%REPORT SERVER%')
           SET @grp_name = 'groupReports'
     RETURN @grp_name
END;
GO
ALTER RESOURCE GOVERNOR WITH (CLASSIFIER_FUNCTION= dbo.rgclassifier_v1);
COMMIT TRAN;
ALTER RESOURCE GOVERNOR RECONFIGURE;
