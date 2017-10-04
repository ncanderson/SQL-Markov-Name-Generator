/*
*	This import procedure needs to be corrected to handle multiple data sources and eras
*	Currently only set up for the Heise name dictionary
*/

use Name_Generator
go

begin transaction

set xact_abort on 

delete RAW_split
delete RAW_frequency_split_by_origin

insert into RAW_split (
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
insert into RAW_frequency_split_by_origin
select 
	the_name as name, SUBSTRING(lang_freq,1,1) as Great_Britain,SUBSTRING(lang_freq,2,1) as Ireland,SUBSTRING(lang_freq,3,1) as U_S_A,SUBSTRING(lang_freq,4,1) as Italy,SUBSTRING(lang_freq,5,1) as Malta,SUBSTRING(lang_freq,6,1) as Portugal,SUBSTRING(lang_freq,7,1) as Spain,SUBSTRING(lang_freq,8,1) as France,SUBSTRING(lang_freq,9,1) as Belgium,SUBSTRING(lang_freq,10,1) as Luxembourg,SUBSTRING(lang_freq,11,1) as the_Netherlands,SUBSTRING(lang_freq,12,1) as East_Frisia,SUBSTRING(lang_freq,13,1) as Germany,SUBSTRING(lang_freq,14,1) as Austria,SUBSTRING(lang_freq,15,1) as Swiss,SUBSTRING(lang_freq,16,1) as Iceland,SUBSTRING(lang_freq,17,1) as Denmark,SUBSTRING(lang_freq,18,1) as Norway,SUBSTRING(lang_freq,19,1) as Sweden,SUBSTRING(lang_freq,20,1) as Finland,SUBSTRING(lang_freq,21,1) as Estonia,SUBSTRING(lang_freq,22,1) as Latvia,SUBSTRING(lang_freq,23,1) as Lithuania,SUBSTRING(lang_freq,24,1) as Poland,SUBSTRING(lang_freq,25,1) as Czech_Republic,SUBSTRING(lang_freq,26,1) as Slovakia,SUBSTRING(lang_freq,27,1) as Hungary,SUBSTRING(lang_freq,28,1) as Romania,SUBSTRING(lang_freq,29,1) as Bulgaria,SUBSTRING(lang_freq,30,1) as Bosnia_and_Herzegovina,SUBSTRING(lang_freq,31,1) as Croatia,SUBSTRING(lang_freq,32,1) as Kosovo,SUBSTRING(lang_freq,33,1) as Macedonia,SUBSTRING(lang_freq,34,1) as Montenegro,SUBSTRING(lang_freq,35,1) as Serbia,SUBSTRING(lang_freq,36,1) as Slovenia,SUBSTRING(lang_freq,37,1) as Albania,SUBSTRING(lang_freq,38,1) as Greece,SUBSTRING(lang_freq,39,1) as Russia,SUBSTRING(lang_freq,40,1) as Belarus,SUBSTRING(lang_freq,41,1) as Moldova,SUBSTRING(lang_freq,42,1) as Ukraine,SUBSTRING(lang_freq,43,1) as Armenia,SUBSTRING(lang_freq,44,1) as Azerbaijan,SUBSTRING(lang_freq,45,1) as Georgia,SUBSTRING(lang_freq,46,1) as Kazakhstan_Uzbekistan,SUBSTRING(lang_freq,47,1) as Turkey,SUBSTRING(lang_freq,48,1) as Arabia_Persia,SUBSTRING(lang_freq,49,1) as Israel,SUBSTRING(lang_freq,50,1) as China,SUBSTRING(lang_freq,51,1) as India_Sri_Lanka,SUBSTRING(lang_freq,52,1) as Japan,SUBSTRING(lang_freq,53,1) as Korea,SUBSTRING(lang_freq,54,1) as Vietnam,SUBSTRING(lang_freq,55,1) as other_countries, name_gender as name_gender
from RAW_split

rollback transaction