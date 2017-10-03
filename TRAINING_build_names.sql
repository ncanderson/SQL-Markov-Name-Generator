use Name_Generator
go

begin transaction

declare @name_count int = 500
declare @start_time datetime = getdate()


while ((@name_count > 0) and dateadd(mm, 5, @start_time) > getdate())
begin

	declare @new_name nvarchar(max) = (

			select top 1
				char1 + char2 + char3 
			from markov_Model
			where char1 = ' '
				and char2 = ' '
			order by newid()
		
		)

	declare @name_time datetime = getdate()
	
	-- This will loop until BREAK is called, or until a timeout of 45 seconds.
	while (getdate() < dateadd(ss, 4, @name_time))
	begin 

		set @new_name = @new_name + (

				select top 1
					char3
				from markov_Model
				where right(@new_name, 1) = char2 collate Latin1_General_100_CS_AS
					and left(right(@new_name, 2),1) = char1 collate Latin1_General_100_CS_AS
				order by newid()

			)

		if (right(@new_name, 1) = ' ')
		begin 
	
			insert into markov_Output (markov_Output)
			select rtrim(ltrim(@new_name))
			
			break

		end

	end

	set @name_count -= 1

end

select * 
from markov_Output

rollback transaction