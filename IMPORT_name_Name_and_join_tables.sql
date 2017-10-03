use Name_Generator
go

begin transaction

delete name_Name

update TEMP_name_Name
	set name_Name = rtrim(ltrim(replace(name_name, '+','-')))

update t_nn
	set name_name = SUBSTRING(name_name, CHARINDEX(' ', name_Name) + 1, len(name_name))
from TEMP_name_Name t_nn
where name_name like '% %'
	and CHARINDEX(' ', name_Name) <> 0 
	 
declare @name_name table
(	
	guid_Name uniqueidentifier,
	name_Name nvarchar(max),
	name_culture nvarchar(max),
	frequency int
)

insert into @name_Name (
	name_Name
)
select	distinct
	name_Name
from TEMP_name_Name 
where name_name like '%'
collate Latin1_General_100_CI_AS

update nn 
	set guid_Name = newid()
from @name_name nn



 
insert into name_Name (
	guid_name,
	name_Name,
	guid_Source
)
output inserted.*
select 
	n.guid_Name,
	n.name_Name,
	d.guid_Source
from @name_name n
join name_DataSource d
	on 1 = 1

rollback transaction return



--insert into name_rl_Name_Culture (
--	guid_Name, 
--	guid_Culture
--)
--select 
--	n.guid_Name,
--	c.guid_Culture
--from @name_name n
--join name_Culture c 
--	on n.name_Culture = c.name_Culture
--join name_Era e
--	on 1 = 1
--where n.name_name like '%'
--collate Latin1_General_100_CI_AS


--insert into name_rl_Name_Era (
--	guid_Name,
--	guid_Era
--)
--select 
--	n.guid_Name,
--	e.guid_Era
--from @name_name n
--join name_Culture c 
--	on n.name_Culture = c.name_Culture
--join name_Era e
--	on 1 = 1
--where n.name_name like '%'
--collate Latin1_General_100_CI_AS



--insert into [dbo].[name_rl_Name_Culture_Era_Frequency] (
--	guid_Name, 
--	guid_Culture, 
--	guid_Era, 
--	frequency
--)
--select 
--	n.guid_Name,
--	c.guid_Culture,
--	e.guid_Era,
--	n.Frequency
--from @name_name n
--join name_Culture c 
--	on n.name_Culture = c.name_Culture
--join name_Era e
--	on 1 = 1
--where n.name_name like '%'
--collate Latin1_General_100_CI_AS




rollback transaction