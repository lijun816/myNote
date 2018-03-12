select name, description, capabilities_desc, module_address
from sys.dm_xe_packages

select name
 from sys.dm_xe_objects
 where object_type ='event'
 order by name

  select p.name as package_name
 , k.event
 , k.keyword
 , c.channel
 , k.description
 from (
 select c.object_package_guid as event_package
 , c.object_name as event
 , v.map_value as keyword
 , o.description
 from sys.dm_xe_object_columns as c inner join sys.dm_xe_map_values as v
   on c.type_name = v.name
   and c.column_value = v.map_key
   and c.type_package_guid = v.object_package_guid
 inner join sys.dm_xe_objects as o
   on o.name = c.object_name
   and o.package_guid = c.object_package_guid
 where c.name = 'keyword'
 ) as k inner join (
 select c.object_package_guid as event_package
 , c.object_name as event
 , v.map_value as channel
 , o.description
 from sys.dm_xe_object_columns as c inner join sys.dm_xe_map_values as v
   on c.type_name = v.name
   and c.column_value = v.map_key
   and c.type_package_guid = v.object_package_guid
 inner join sys.dm_xe_objects as o
   on o.name = c.object_name
   and o.package_guid = c.object_package_guid
 where c.name = 'channel'
 ) as c
 on
 k.event_package = c.event_package and k.event = c.event
 inner join sys.dm_xe_packages as p on p.guid = k.event_package
 order by keyword
 , channel
 , event


select name
from sys.dm_xe_objects
where object_type = 'action'
order by name

 select name, description
 from sys.dm_xe_objects
 where object_type = 'pred_compare'
 order by name
 -- 111 77 rows
 
 select name, description
 from sys.dm_xe_object
 where object_type = 'pred_source'
 order by name
 -- 29 43 rows

 select object_type, count (*)
 from sys.dm_xe_objects 
group  by object_type
order by count (*) desc


 select name, description
 from sys.dm_xe_objects
 where object_type = 'target'
 order by name
