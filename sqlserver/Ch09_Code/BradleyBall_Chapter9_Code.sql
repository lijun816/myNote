/*
Create In Memory OLTP Example DB
*/
USE [master]
GO
CREATE DATABASE [example_InMemOLTP]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'example_InMemOLTP', FILENAME = N'E:\MSSQL\example_InMemOLTP_xtp.mdf' , SIZE = 3264KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [college_xtp_mod] CONTAINS MEMORY_OPTIMIZED_DATA  DEFAULT
( NAME = N'example_InMemOLTP_mod1', FILENAME = N'F:\MSSQL\example_InMemOLTP_mod1' , MAXSIZE = UNLIMITED)
 LOG ON 
( NAME = N'example_InMemOLTP_log', FILENAME = N'E:\MSSQL\example_InMemOLTP_log.ldf' , SIZE = 270016KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
/*
Alter AdventureWorks to add Filegroup with Memory optimized data
*/
IF NOT EXISTS(SELECT * FROM AdventureWorks.sys.data_spaces WHERE type='FX')
ALTER DATABASE AdventureWorks
ADD FILEGROUP [AdventureWorks_Mod] CONTAINS MEMORY_OPTIMIZED_DATA
GO
IF NOT EXISTS(SELECT * FROM AdventureWorks.sys.data_spaces ds join AdventureWorks.sys.database_files df on ds.data_space_id=df.data_space_id where ds.type='FX')
ALTER DATABASE AdventureWorks
ADD FILE (name='AdventureWorks_Mod', filename='F:\MSSQL\Adventure_Works_Mod') TO FILEGROUP AdventureWorks_Mod
/*
First Memory Optimized Table
*/
use example_InMemOLTP
go
CREATE TABLE first_InMemOLTP(
	c1 int identity(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
	,c2 int NOT NULL INDEX first_xtp_nclx_index 
		hash with(bucket_count=10000000)
	,c3 int NOT NULL INDEX first_xtp_nclx_index2 
		hash with(bucket_count=10000000)
	,c4 int NOT NULL INDEX first_xtp_nclx_index3 
		hash with(bucket_count=10000000)
	,c5 int 
	,c6 char(100)  COLLATE Latin1_General_100_bin2 NOT NULL INDEX first_xtp_nclx_char
	,c7 char(80)
)WITH(memory_optimized=on, DURABILITY=SCHEMA_AND_DATA)
/*
find collations that are use _bin2
*/
select * from sys.fn_helpcollations() where name like '%BIN2'
/*
Table used for estimating purposes
*/
use example_InMemOLTP
go
if exists(select name from sys.objects where name='xtp_estimate')
begin
	drop table xtp_extimate
end
go
CREATE TABLE xtp_Estimate(
	c1 int identity(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
	,c2 int NOT NULL INDEX xtp_nclx_index 
		hash with(bucket_count=10000000)
	,c3 int NOT NULL INDEX xtp_nclx_index2 
		hash with(bucket_count=10000000)
	,c4 int NOT NULL INDEX xtp_nclx_index3 
		hash with(bucket_count=10000000)
	,c5 int NOT NULL INDEX xtp_nclx_index4
	,c6 char(100)
	,c7 char(80)
)WITH(memory_optimized=on)

/*
Timestamps = 24 bytes
Index pointers=8 bytes * 4 Indexes = 32 bytes
Data = (4+4+4+4+4) + 100 + 80 = 200 bytes
total = 24 + 32 + 200 = 256 bytes per row
256 * 100 million rows = 25,600,000,000 bytes

23.8 GB * 4(for version store) = 95.2 GB

*/


/*
Create a Resource Pool to Manage the In-Memory DB on AdventureWorks
*/
IF NOT EXISTS (SELECT * FROM sys.resource_governor_resource_pools WHERE name=N'Pool_AdventureWorks')
BEGIN		
	CREATE RESOURCE POOL Pool_AdventureWorks 
		WITH ( MAX_MEMORY_PERCENT = 80 );
	ALTER RESOURCE GOVERNOR RECONFIGURE;
END
GO
/*
Bind AdventureWorks to the Resource Pool
*/
EXEC sp_xtp_bind_db_resource_pool 'AdventureWorks', 'Pool_AdventureWorks'
GO
/*
Take AdventureWorks offline and back online
*/
ALTER DATABASE AdventureWorks SET OFFLINE WITH ROLLBACK IMMEDIATE
GO
ALTER DATABASE AdventureWorks SET ONLINE
GO

/*
Use perfrmon or the following DMV to monitor allocation
of memory by resource group
*/
SELECT pool_id
     , Name
     , min_memory_percent
     , max_memory_percent
     , max_memory_kb/1024 AS max_memory_mb
     , used_memory_kb/1024 AS used_memory_mb 
     , target_memory_kb/1024 AS target_memory_mb
   FROM sys.dm_resource_governor_resource_pools

/*
create natively compiled stored procedure
*/
use example_InMemOLTP
go
if exists(select name from sys.procedures where name='p_ins_new_record')
begin
	DROP PROCEDURE dbo.p_ins_new_record
end
go
use example_InMemOLTP
go
if exists(select name from sys.procedures where name='p_ins_new_record')
begin
	DROP PROCEDURE dbo.p_ins_new_record
end
go
CREATE PROCEDURE dbo.p_ins_new_record (@rowcount int)
WITH NATIVE_COMPILATION
,SCHEMABINDING
,EXECUTE AS OWNER
AS
BEGIN ATOMIC WITH
(TRANSACTION ISOLATION LEVEL=SNAPSHOT, LANGUAGE='us_english')
declare @i int=0
while @i<@rowcount
	begin
		set @i=@i+1
		INSERT INTO dbo.xtp_Estimate(c2, c3,c4, c5, c6, c7)
		VALUES(@i, @i, @i, @i, 'a','b')
	end
END
GO
/*
create disk based structures
*/
use example_InMemOLTP
go
if exists(select name from sys.objects where name='disk_Estimate')
begin
	drop table disk_Estimate
end
go
CREATE TABLE disk_Estimate(
	c1 int identity(1,1) NOT NULL PRIMARY KEY NONCLUSTERED
	,c2 int NOT NULL INDEX disk_nclx_index 
	,c3 int NOT NULL INDEX disk_nclx_index2 
	,c4 int NOT NULL INDEX disk_nclx_index3 
	,c5 int NOT NULL INDEX disk_nclx_index4
	,c6 char(100)
	,c7 char(80)
)

if exists(select name from sys.procedures where name='p_ins_new_disk_record')
begin
	DROP PROCEDURE dbo.p_ins_new_disk_record
end
go
CREATE PROCEDURE dbo.p_ins_new_disk_record (@c2 int, @c3 int, @c4 int, @c5 int, @c6 char(100), @c7 char(80))
AS
BEGIN 
INSERT INTO dbo.disk_Estimate(c2, c3,c4, c5, c6, c7)
VALUES(@c2, @c3, @c4, @c5, @c6, @c7)
END
GO
if exists(select name from sys.procedures where name='p_ins_tsql_xtp_record')
begin
	DROP PROCEDURE dbo.p_ins_tsql_xtp_record
end
go
CREATE PROCEDURE dbo.p_ins_tsql_xtp_record (@c2 int, @c3 int, @c4 int, @c5 int, @c6 char(100), @c7 char(80))
AS
BEGIN 
INSERT INTO dbo.xtp_Estimate(c2, c3,c4, c5, c6, c7)
VALUES(@c2, @c3, @c4, @c5, @c6, @c7)
END
GO
/*
execute the stored procedure
*/
declare @starttime datetime2=sysdatetime()
declare @timems int
declare @i int
--disk based table & classic t-sql stored procedure
set @starttime=sysdatetime()
set @i=0
while @i<10000
begin
	set @i=@i+1
	exec dbo.p_ins_new_disk_record @i, @i, @i, @i, 'a', 'b'
end

set @timems = datediff(ms, @starttime, sysdatetime())
select 'Disk based table and T-SQL stored proc: ' + cast(@timems as varchar(10)) + ' ms'
--Memory Optimized Table & Classic t-sql stored procedure
set @starttime=sysdatetime()
set @i=0
while @i<10000
begin
	set @i=@i+1
	exec dbo.p_ins_tsql_xtp_record @i, @i, @i, @i, 'a', 'b'
end

set @timems = datediff(ms, @starttime, sysdatetime())
select 'Memory Optimized table and T-SQL stored proc: ' + cast(@timems as varchar(10)) + ' ms'
--natively compiled
set @starttime=sysdatetime()
exec dbo.p_ins_new_record 10000

set @timems = datediff(ms, @starttime, sysdatetime())
select 'Natively Compiled stored proc: ' + cast(@timems as varchar(10)) + ' ms'

select * from dbo.xtp_Estimate order by c1 
/*
get info about natviely compiled stored proc
*/
select name, [description], * from sys.dm_os_loaded_modules
where description='XTP Native DLL'

select ep.name,* from sys.procedures ep
left join  sys.objects so
on ep.object_id=so.object_id
/*
info about natively compiled stored procedures
*/
select object_id,
       object_name(object_id) as 'object name',
       cached_time,
       last_execution_time,
       execution_count,
       total_worker_time,
       last_worker_time,
       min_worker_time,
       max_worker_time,
       total_elapsed_time,
       last_elapsed_time,
       min_elapsed_time,
       max_elapsed_time 
from sys.dm_exec_procedure_stats
where database_id=db_id() and object_id in (select object_id 
from sys.sql_modules where uses_native_compilation=1)
order by total_worker_time desc
