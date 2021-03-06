begin transaction 

declare @char nvarchar(max) = N'>'

select *
FROM [Name_Generator].[dbo].[TEMP_name_Name] t
where name_name like '%' + @char + '%' COLLATE Latin1_General_CS_AS 

update t
	set name_name = replace(name_Name,@char,N'ł')
output inserted.*
FROM [Name_Generator].[dbo].[TEMP_name_Name] t
where name_name like '%' + @char + '%' COLLATE Latin1_General_CS_AS 

declare @commit_bit bit =  0

if (@commit_bit = 1)
begin

	print 'commit transaction'
	commit transaction

end

else
begin

	print 'rollback transaction'
	rollback transaction

end