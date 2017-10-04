/*
*	This import procedure needs to be corrected to handle multiple data sources and eras
*	Currently only set up for the Heise name dictionary
*/

use Name_Generator
go

begin transaction

set xact_abort on 

-- Split raw data out in preparation for univoting
declare @split table
(
	name_gender nvarchar(4),
	the_name nvarchar(40),
	lang_freq nvarchar(max)
)

insert into @split (
	name_gender,
	the_name,
	lang_freq
)
select	
	rtrim(left(i.import,3)) as name_gender,
	rtrim(ltrim(SUBSTRING(i.import, 4, 26))) as the_name,
	substring(i.import, 31, len(i.import) + 1) as lang_freq
from RAW_file_import i

-- Break 'columns' into actual table columns
declare @RAW_frequency_split_by_origin table (
	[name] [nvarchar](40) NULL,
	[Great_Britain] [nvarchar](max) NULL,
	[Ireland] [nvarchar](max) NULL,
	[U_S_A] [nvarchar](max) NULL,
	[Italy] [nvarchar](max) NULL,
	[Malta] [nvarchar](max) NULL,
	[Portugal] [nvarchar](max) NULL,
	[Spain] [nvarchar](max) NULL,
	[France] [nvarchar](max) NULL,
	[Belgium] [nvarchar](max) NULL,
	[Luxembourg] [nvarchar](max) NULL,
	[the_Netherlands] [nvarchar](max) NULL,
	[East_Frisia] [nvarchar](max) NULL,
	[Germany] [nvarchar](max) NULL,
	[Austria] [nvarchar](max) NULL,
	[Swiss] [nvarchar](max) NULL,
	[Iceland] [nvarchar](max) NULL,
	[Denmark] [nvarchar](max) NULL,
	[Norway] [nvarchar](max) NULL,
	[Sweden] [nvarchar](max) NULL,
	[Finland] [nvarchar](max) NULL,
	[Estonia] [nvarchar](max) NULL,
	[Latvia] [nvarchar](max) NULL,
	[Lithuania] [nvarchar](max) NULL,
	[Poland] [nvarchar](max) NULL,
	[Czech_Republic] [nvarchar](max) NULL,
	[Slovakia] [nvarchar](max) NULL,
	[Hungary] [nvarchar](max) NULL,
	[Romania] [nvarchar](max) NULL,
	[Bulgaria] [nvarchar](max) NULL,
	[Bosnia_and_Herzegovina] [nvarchar](max) NULL,
	[Croatia] [nvarchar](max) NULL,
	[Kosovo] [nvarchar](max) NULL,
	[Macedonia] [nvarchar](max) NULL,
	[Montenegro] [nvarchar](max) NULL,
	[Serbia] [nvarchar](max) NULL,
	[Slovenia] [nvarchar](max) NULL,
	[Albania] [nvarchar](max) NULL,
	[Greece] [nvarchar](max) NULL,
	[Russia] [nvarchar](max) NULL,
	[Belarus] [nvarchar](max) NULL,
	[Moldova] [nvarchar](max) NULL,
	[Ukraine] [nvarchar](max) NULL,
	[Armenia] [nvarchar](max) NULL,
	[Azerbaijan] [nvarchar](max) NULL,
	[Georgia] [nvarchar](max) NULL,
	[Kazakhstan_Uzbekistan] [nvarchar](max) NULL,
	[Turkey] [nvarchar](max) NULL,
	[Arabia_Persia] [nvarchar](max) NULL,
	[Israel] [nvarchar](max) NULL,
	[China] [nvarchar](max) NULL,
	[India_Sri_Lanka] [nvarchar](max) NULL,
	[Japan] [nvarchar](max) NULL,
	[Korea] [nvarchar](max) NULL,
	[Vietnam] [nvarchar](max) NULL,
	[other_countries] [nvarchar](max) NULL,
	[name_Gender] [nvarchar](10) NULL
) 

insert into @RAW_frequency_split_by_origin
select 
	the_name as name, SUBSTRING(lang_freq,1,1) as Great_Britain,SUBSTRING(lang_freq,2,1) as Ireland,SUBSTRING(lang_freq,3,1) as U_S_A,SUBSTRING(lang_freq,4,1) as Italy,SUBSTRING(lang_freq,5,1) as Malta,SUBSTRING(lang_freq,6,1) as Portugal,SUBSTRING(lang_freq,7,1) as Spain,SUBSTRING(lang_freq,8,1) as France,SUBSTRING(lang_freq,9,1) as Belgium,SUBSTRING(lang_freq,10,1) as Luxembourg,SUBSTRING(lang_freq,11,1) as the_Netherlands,SUBSTRING(lang_freq,12,1) as East_Frisia,SUBSTRING(lang_freq,13,1) as Germany,SUBSTRING(lang_freq,14,1) as Austria,SUBSTRING(lang_freq,15,1) as Swiss,SUBSTRING(lang_freq,16,1) as Iceland,SUBSTRING(lang_freq,17,1) as Denmark,SUBSTRING(lang_freq,18,1) as Norway,SUBSTRING(lang_freq,19,1) as Sweden,SUBSTRING(lang_freq,20,1) as Finland,SUBSTRING(lang_freq,21,1) as Estonia,SUBSTRING(lang_freq,22,1) as Latvia,SUBSTRING(lang_freq,23,1) as Lithuania,SUBSTRING(lang_freq,24,1) as Poland,SUBSTRING(lang_freq,25,1) as Czech_Republic,SUBSTRING(lang_freq,26,1) as Slovakia,SUBSTRING(lang_freq,27,1) as Hungary,SUBSTRING(lang_freq,28,1) as Romania,SUBSTRING(lang_freq,29,1) as Bulgaria,SUBSTRING(lang_freq,30,1) as Bosnia_and_Herzegovina,SUBSTRING(lang_freq,31,1) as Croatia,SUBSTRING(lang_freq,32,1) as Kosovo,SUBSTRING(lang_freq,33,1) as Macedonia,SUBSTRING(lang_freq,34,1) as Montenegro,SUBSTRING(lang_freq,35,1) as Serbia,SUBSTRING(lang_freq,36,1) as Slovenia,SUBSTRING(lang_freq,37,1) as Albania,SUBSTRING(lang_freq,38,1) as Greece,SUBSTRING(lang_freq,39,1) as Russia,SUBSTRING(lang_freq,40,1) as Belarus,SUBSTRING(lang_freq,41,1) as Moldova,SUBSTRING(lang_freq,42,1) as Ukraine,SUBSTRING(lang_freq,43,1) as Armenia,SUBSTRING(lang_freq,44,1) as Azerbaijan,SUBSTRING(lang_freq,45,1) as Georgia,SUBSTRING(lang_freq,46,1) as Kazakhstan_Uzbekistan,SUBSTRING(lang_freq,47,1) as Turkey,SUBSTRING(lang_freq,48,1) as Arabia_Persia,SUBSTRING(lang_freq,49,1) as Israel,SUBSTRING(lang_freq,50,1) as China,SUBSTRING(lang_freq,51,1) as India_Sri_Lanka,SUBSTRING(lang_freq,52,1) as Japan,SUBSTRING(lang_freq,53,1) as Korea,SUBSTRING(lang_freq,54,1) as Vietnam,SUBSTRING(lang_freq,55,1) as other_countries, name_gender as name_gender
from @split
 
-- Unpivot on name_culture
 declare @unpivot table
(
	name nvarchar(max),
	language nvarchar(max),
	frequency nvarchar(5),
	sex nvarchar(max)
)

insert into @unpivot (
	name, 
	language, 
	frequency,
	sex
)
select 
	name,
	culture,
	case
		when frequency = '' then null
		else frequency
	end as frequency,
	name_Gender
from (
	select *
	from @RAW_frequency_split_by_origin
) names
unpivot
(
	frequency for culture in (Great_Britain,Ireland,U_S_A,Italy,Malta,Portugal,Spain,France,Belgium,Luxembourg,the_Netherlands,East_Frisia,Germany,Austria,Swiss,Iceland,Denmark,Norway,Sweden,Finland,Estonia,Latvia,Lithuania,Poland,Czech_Republic,Slovakia,Hungary,Romania,Bulgaria,Bosnia_and_Herzegovina,Croatia,Kosovo,Macedonia,Montenegro,Serbia,Slovenia,Albania,Greece,Russia,Belarus,Moldova,Ukraine,Armenia,Azerbaijan,Georgia,Kazakhstan_Uzbekistan,Turkey,Arabia_Persia,Israel,China,India_Sri_Lanka,Japan,Korea,Vietnam,other_countries)
) as culture

-- Delete names with no frequency in a culture
delete up
from @unpivot up
where frequency is null

-- Convert hex to decimal
update u
	set frequency = case frequency 
					    when 'A' then '10' 
						when 'B' then '11' 
						when 'C' then '12' 
						when 'D' then '13' 
					else frequency end
from @unpivot u

/********** Begin name inserts **********/

-- Remove nicknames, but preserve Maria de/del/do/da names, present in Iberian languages
update u
	set name = SUBSTRING(name, CHARINDEX(' ', name) + 1, len(name))
from @unpivot u
where name like '% %'
	and CHARINDEX(' ', name) <> 0
	and (name not like 'María %'
		and name not like 'Maria %')

-- Replace '+' with a dash, and spaces with an underscore
-- Relevant for Chinese/Korean and Iberian names, respectively
update @unpivot
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
	name collate Latin1_General_100_CI_AS
from @unpivot 

update nn 
	set guid_Name = newid()
from @distinct_names nn

-- This will need to be corrected for new data sources
insert into name_Name (
	guid_name,
	name_Name,
	guid_Source
)
select 
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
select 
	n.guid_Name,
	c.guid_Language
from @distinct_names n
join @unpivot u
	on n.name_Name = u.name
join name_Language c
	on c.name_Language = u.language

-- Name Era
insert into name_rl_Name_Era (
	guid_Name,
	guid_Era
)
select 
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
select 
	n.guid_Name,
	c.guid_Language,
	e.guid_Era,
	u.Frequency
from @distinct_names n
join @unpivot u
	on u.name = n.name_Name
join name_Language c 
	on u.language = c.name_Language
join name_Era e
	on 1 = 1

-- Correct characters in name_Name table
update nn
	set name_Name = replace(nn.name_Name, rc.bracket_character, rc.replacement_character)
from name_Name nn
join RAW_character_Dictionary rc
	on nn.name_Name like '%' + rc.bracket_character + '%'

select *
from name_Name

rollback transaction