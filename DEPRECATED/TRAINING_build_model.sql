use Name_Generator
go

begin transaction

/********** Prepare dataset **********/
--40% maltese, 60% azerbaijan, 8000 names

select distinct 
	name_language,
	count(nn.guid_name)
from name_language nl
join name_rl_name_language rlnl
	on nl.guid_language = rlnl.guid_language
join name_Name nn
	on rlnl.guid_Name = nn.guid_name
group by nl.name_Language

delete markov_Subset
delete markov_Model

dbcc checkident ('markov_Subset', reseed, 0)

insert into markov_subset (
	name, 
	processed
)
select distinct top 2000 
	name_Name, 
	0
from TEMP_name_Name
where name_Culture = 'Latvia'

insert into markov_subset (
	name, 
	processed
)
select distinct top 0 
	name_Name, 
	0
from TEMP_name_Name
where name_Culture = 'Iceland'

rollback transaction return

declare @inserted table
(
	char1 nchar,
	char2 nchar,
	char3 nchar
)



/*************/

while ((select count(*) from markov_Subset where processed = 0) > 1)
begin

	declare @position int = -1

	declare @name_id int = (
			select top 1 
				name_id
			from markov_Subset
			where processed = 0
		)

	declare @name_in_process nvarchar(max) = (
			select top 1 
				name 
			from markov_Subset
			where name_id = @name_id

		)

	declare @startTime datetime = getdate()

	-- This will loop until BREAK is called, or until a timeout of 45 seconds.
	WHILE (getdate() < dateadd(mm, 1, @startTime))
	begin

		insert into markov_Model (
			char1,
			char2,
			char3
		)
		output
			inserted.char1, 
			inserted.char2, 
			inserted.char3 
		into @inserted (
			char1, 
			char2, 
			char3
		)
		select 
			SUBSTRING(@name_in_process, @position, 1),
			SUBSTRING(@name_in_process, @position + 1, 1),
			SUBSTRING(@name_in_process, @position + 2, 1)

		set @position += 1

		if ((select char3 from @inserted) = '')
		begin
			
			delete @inserted

			break

		end

		delete @inserted

		update markov_Subset
			set processed = 1
		where name_id = @name_id

	end

end

update mm
	set char1 = ' '
from markov_Model mm
where char1 = ''

update mm
	set char2 = ' '
from markov_Model mm
where char2 = ''

update mm
	set char3 = ' '
from markov_Model mm
where char3 = ''

select top 5000 *
from markov_Model

rollback transaction