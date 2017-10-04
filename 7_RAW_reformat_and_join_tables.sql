use Name_Generator
go

begin transaction 

set xact_abort on 

delete name_name
delete name_rl_Name_Language_Era_Frequency
delete name_rl_Name_Era
delete name_rl_Name_Language

-- Remove nicknames, but preserve Maria de/del/do/da names, present in Iberian languages
update u
	set name = SUBSTRING(name, CHARINDEX(' ', name) + 1, len(name))
from RAW_unpivot u
where name like '% %'
	and CHARINDEX(' ', name) <> 0
	and (name not like 'María d%'
		and name not like 'Maria d%')

-- Replace '+' with a dash, and spaces with an underscore
-- Relevant for Chinese/Korean and Iberian names, respectively
update RAW_unpivot
	set name = rtrim(ltrim(replace(replace(name,' ','_'), '+','-')))


declare @distinct_names table
(	
	guid_Name uniqueidentifier,
	name_Name nvarchar(max),
	name_language nvarchar(max),
	name_gender nvarchar(10),
	frequency int
)

insert into @distinct_names (
	name_Name
)
select	distinct
	name collate Latin1_General_100_CI_AS as name_Name
from RAW_unpivot 

update nn 
	set guid_Name = newid()
from @distinct_names nn

-- This will need to be corrected for new data sources
insert into name_Name (
	guid_name,
	name_Name,
	guid_Source
)
select distinct
	n.guid_Name,
	n.name_Name,
	d.guid_Source
from @distinct_names n
join name_DataSource d
	on 1 = 1

-- Name Culture
insert into name_rl_Name_Language(
	guid_Name, 
	guid_Language
)
select distinct
	n.guid_Name,
	c.guid_Language
from @distinct_names n
join RAW_unpivot u
	on n.name_Name = u.name
join name_Language c
	on c.name_Language = u.culture

-- Name Era
insert into name_rl_Name_Era (
	guid_Name,
	guid_Era
)
select distinct
	n.guid_Name,
	e.guid_Era
from @distinct_names n
join name_Era e
	on 1 = 1

-- Name Culture Era Frequency
insert into name_rl_Name_Language_Era_Frequency (
	guid_Name, 
	guid_Language, 
	guid_Era, 
	frequency
)
select distinct
	n.guid_Name,
	c.guid_Language,
	e.guid_Era,
	u.Frequency
from @distinct_names n
join RAW_unpivot u
	on u.name = n.name_Name
join name_Language c 
	on u.culture = c.name_Language
join name_Era e
	on 1 = 1

-- Correct characters in name_Name table, loop because we're using a like statement, so we won't get
-- the names that have multiple special characters
while ((select count(*) from name_Name where name_Name like '%<%') > 0)
begin

	update nn
		set name_Name = replace(nn.name_Name, rc.bracket_character, rc.replacement_character)
	from name_Name nn
	join RAW_character_Dictionary rc
		on nn.name_Name like '%' + rc.bracket_character + '%' collate Latin1_General_100_CS_AS 

end

update nn
	set name_Name = replace(nn.name_Name, '_',' ')
from name_Name nn

rollback  transaction