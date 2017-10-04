use Name_Generator
go

begin transaction 

set xact_abort on 

delete RAW_unpivot

insert into RAW_unpivot (
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
	from RAW_frequency_split_by_origin
) names
unpivot
(
	frequency for culture in (Great_Britain,Ireland,U_S_A,Italy,Malta,Portugal,Spain,France,Belgium,Luxembourg,the_Netherlands,East_Frisia,Germany,Austria,Swiss,Iceland,Denmark,Norway,Sweden,Finland,Estonia,Latvia,Lithuania,Poland,Czech_Republic,Slovakia,Hungary,Romania,Bulgaria,Bosnia_and_Herzegovina,Croatia,Kosovo,Macedonia,Montenegro,Serbia,Slovenia,Albania,Greece,Russia,Belarus,Moldova,Ukraine,Armenia,Azerbaijan,Georgia,Kazakhstan_Uzbekistan,Turkey,Arabia_Persia,Israel,China,India_Sri_Lanka,Japan,Korea,Vietnam,other_countries)
) as culture

-- Delete names with no frequency in a culture
delete up
from RAW_unpivot up
where frequency is null

-- Convert hex to decimal
update u
	set frequency = case frequency 
					    when 'A' then '10' 
						when 'B' then '11' 
						when 'C' then '12' 
						when 'D' then '13' 
					else frequency end
from RAW_unpivot u

rollback transaction
