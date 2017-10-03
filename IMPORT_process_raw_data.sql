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

insert into RAW_frequency_split_by_origin
select 
	the_name as name, SUBSTRING(lang_freq,1,1) as Great_Britain,SUBSTRING(lang_freq,2,1) as Ireland,SUBSTRING(lang_freq,3,1) as U_S_A,SUBSTRING(lang_freq,4,1) as Italy,SUBSTRING(lang_freq,5,1) as Malta,SUBSTRING(lang_freq,6,1) as Portugal,SUBSTRING(lang_freq,7,1) as Spain,SUBSTRING(lang_freq,8,1) as France,SUBSTRING(lang_freq,9,1) as Belgium,SUBSTRING(lang_freq,10,1) as Luxembourg,SUBSTRING(lang_freq,11,1) as the_Netherlands,SUBSTRING(lang_freq,12,1) as East_Frisia,SUBSTRING(lang_freq,13,1) as Germany,SUBSTRING(lang_freq,14,1) as Austria,SUBSTRING(lang_freq,15,1) as Swiss,SUBSTRING(lang_freq,16,1) as Iceland,SUBSTRING(lang_freq,17,1) as Denmark,SUBSTRING(lang_freq,18,1) as Norway,SUBSTRING(lang_freq,19,1) as Sweden,SUBSTRING(lang_freq,20,1) as Finland,SUBSTRING(lang_freq,21,1) as Estonia,SUBSTRING(lang_freq,22,1) as Latvia,SUBSTRING(lang_freq,23,1) as Lithuania,SUBSTRING(lang_freq,24,1) as Poland,SUBSTRING(lang_freq,25,1) as Czech_Republic,SUBSTRING(lang_freq,26,1) as Slovakia,SUBSTRING(lang_freq,27,1) as Hungary,SUBSTRING(lang_freq,28,1) as Romania,SUBSTRING(lang_freq,29,1) as Bulgaria,SUBSTRING(lang_freq,30,1) as Bosnia_and_Herzegovina,SUBSTRING(lang_freq,31,1) as Croatia,SUBSTRING(lang_freq,32,1) as Kosovo,SUBSTRING(lang_freq,33,1) as Macedonia,SUBSTRING(lang_freq,34,1) as Montenegro,SUBSTRING(lang_freq,35,1) as Serbia,SUBSTRING(lang_freq,36,1) as Slovenia,SUBSTRING(lang_freq,37,1) as Albania,SUBSTRING(lang_freq,38,1) as Greece,SUBSTRING(lang_freq,39,1) as Russia,SUBSTRING(lang_freq,40,1) as Belarus,SUBSTRING(lang_freq,41,1) as Moldova,SUBSTRING(lang_freq,42,1) as Ukraine,SUBSTRING(lang_freq,43,1) as Armenia,SUBSTRING(lang_freq,44,1) as Azerbaijan,SUBSTRING(lang_freq,45,1) as Georgia,SUBSTRING(lang_freq,46,1) as Kazakhstan_Uzbekistan,SUBSTRING(lang_freq,47,1) as Turkey,SUBSTRING(lang_freq,48,1) as Arabia_Persia,SUBSTRING(lang_freq,49,1) as Israel,SUBSTRING(lang_freq,50,1) as China,SUBSTRING(lang_freq,51,1) as India_Sri_Lanka,SUBSTRING(lang_freq,52,1) as Japan,SUBSTRING(lang_freq,53,1) as Korea,SUBSTRING(lang_freq,54,1) as Vietnam,SUBSTRING(lang_freq,55,1) as other_countries, name_gender as name_gender
from @split
 
-- Unpivot on name_culture
 declare @unpivot table
(
	name nvarchar(max),
	nationality nvarchar(max),
	frequency nvarchar(5),
	sex nvarchar(max)
)

insert into @unpivot (
	name, 
	nationality, 
	frequency,
	sex
)
select 
	name,
	nationality,
	case
		when frequency = '' then null
		else frequency
	end as frequency,
	name_Gender
from (
	select *
	from RAW_frequency_split_by_origin
) names
unpivot
(
	frequency for nationality in (Great_Britain,Ireland,U_S_A,Italy,Malta,Portugal,Spain,France,Belgium,Luxembourg,the_Netherlands,East_Frisia,Germany,Austria,Swiss,Iceland,Denmark,Norway,Sweden,Finland,Estonia,Latvia,Lithuania,Poland,Czech_Republic,Slovakia,Hungary,Romania,Bulgaria,Bosnia_and_Herzegovina,Croatia,Kosovo,Macedonia,Montenegro,Serbia,Slovenia,Albania,Greece,Russia,Belarus,Moldova,Ukraine,Armenia,Azerbaijan,Georgia,Kazakhstan_Uzbekistan,Turkey,Arabia_Persia,Israel,China,India_Sri_Lanka,Japan,Korea,Vietnam,other_countries)
) as nationality

delete up
from @unpivot up
where frequency is null

update u
	set frequency = case frequency 
					    when 'A' then '10' 
						when 'B' then '11' 
						when 'C' then '12' 
						when 'D' then '13' 
					else frequency end
from @unpivot u

/********** Not done ***********/
-- not actually inserted
-- Choose what temp table to use
-- make the name_name insert
-- make the name_culture insert
-- make the name_era insert

-- Update name_name with the dictionary

select 
	name as name_Name,
	nationality as name_Culture,
	cast(frequency as int) as Frequency,
	'Heise.de: astro.joerg@googlemail.com' as name_Source,
	'Modern' as name_Era,
	sex as name_Sex into TEMP_name_Name_NOT_CORRECTED_FOR_NON_ISO
from @unpivot

declare @countries_of_origin table 
(
	the_name nvarchar(max),Great_Britain nvarchar(5),Ireland nvarchar(5),U_S_A nvarchar(5),Italy nvarchar(5),Malta nvarchar(5),Portugal nvarchar(5),Spain nvarchar(5),France nvarchar(5),Belgium nvarchar(5),Luxembourg nvarchar(5),the_Netherlands nvarchar(5),East_Frisia nvarchar(5),Germany nvarchar(5),Austria nvarchar(5),Swiss nvarchar(5),Iceland nvarchar(5),Denmark nvarchar(5),Norway nvarchar(5),Sweden nvarchar(5),Finland nvarchar(5),Estonia nvarchar(5),Latvia nvarchar(5),Lithuania nvarchar(5),Poland nvarchar(5),Czech_Republic nvarchar(5),Slovakia nvarchar(5),Hungary nvarchar(5),Romania nvarchar(5),Bulgaria nvarchar(5),Bosnia_and_Herzegovina nvarchar(5),Croatia nvarchar(5),Kosovo nvarchar(5),Macedonia nvarchar(5),Montenegro nvarchar(5),Serbia nvarchar(5),Slovenia nvarchar(5),Albania nvarchar(5),Greece nvarchar(5),Russia nvarchar(5),Belarus nvarchar(5),Moldova nvarchar(5),Ukraine nvarchar(5),Armenia nvarchar(5),Azerbaijan nvarchar(5),Georgia nvarchar(5),Kazakhstan_Uzbekistan nvarchar(5),Turkey nvarchar(5),Arabia_Persia nvarchar(5),Israel nvarchar(5),China nvarchar(5),India_Sri_Lanka nvarchar(5),Japan nvarchar(5),Korea nvarchar(5),Vietnam nvarchar(5),other_countries nvarchar(5)
)



rollback transaction