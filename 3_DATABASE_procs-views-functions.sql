USE [Name_Generator]
GO
/****** Object:  UserDefinedFunction [dbo].[markov_Name_Count]    Script Date: 10/4/2017 8:45:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nate Anderson
-- Create date: 20171003
-- Description:	Returns count of names, grouped by language
-- =============================================
CREATE FUNCTION [dbo].[markov_Name_Count]
(	
	-- Add the parameters for the function here
	@name1 nvarchar(50),
	@name2 nvarchar(50),
	@name3 nvarchar(50)
)
RETURNS TABLE 
AS
RETURN 
(
	select 
		nl.name_Language,
		count(*) as name_Count
	from name_Name nn
	join name_rl_Name_Language rl_nl
		on nn.guid_name = rl_nl.guid_Name
	join name_Language nl
		on rl_nl.guid_Language = nl.guid_Language
	where nl.name_Language in (@name1, @name2, @name3)
	group by nl.name_Language

)

GO
/****** Object:  View [dbo].[name_Full_Details]    Script Date: 10/4/2017 8:45:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[name_Full_Details]
AS
SELECT nn.name_Name AS Name, nl.name_Language AS Language, e.name_Era AS Era, freq.frequency AS Frequency
FROM     dbo.name_Name AS nn INNER JOIN
                  dbo.name_rl_Name_Language AS nrlnl ON nrlnl.guid_Name = nn.guid_Name INNER JOIN
                  dbo.name_Language AS nl ON nl.guid_Language = nrlnl.guid_Language INNER JOIN
                  dbo.name_rl_Name_Era AS ne ON ne.guid_Name = nn.guid_Name INNER JOIN
                  dbo.name_Era AS e ON e.guid_Era = ne.guid_Era INNER JOIN
                  dbo.name_rl_Name_Language_Era_Frequency AS freq ON freq.guid_Name = nn.guid_Name AND freq.guid_Language = nl.guid_Language AND freq.guid_Era = e.guid_Era

GO
/****** Object:  StoredProcedure [dbo].[markov_Build_Model]    Script Date: 10/4/2017 8:45:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nate Anderson
-- Create date: 20170903
-- Description:	Build the Markov model from the chosen languages
-- =============================================
CREATE PROCEDURE [dbo].[markov_Build_Model]
	-- Add the parameters for the stored procedure here
	@final_name_count int,

	@lang1 nvarchar(max),
	@lang1_count int,
	
	@lang2 nvarchar(max),
	@lang2_count int,

	@lang3 nvarchar(max) = null,
	@lang3_count int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	delete markov_Subset
	delete markov_Model

	dbcc checkident ('markov_Subset', reseed, 0)

	-- Lang 1
	insert into markov_subset (
		name, 
		processed
	)
	select distinct top (@lang1_count)
		Name, 
		0
	from name_Full_Details
	where language = @lang1

	print cast(@@rowcount as nvarchar(10)) + ' ' + @lang1 + ' names inserted' 

	-- Lang 2
	insert into markov_subset (
		name, 
		processed
	)
	select distinct top (@lang2_count)
		Name, 
		0
	from name_Full_Details
	where language = @lang2

	print cast(@@rowcount as nvarchar(10)) + ' ' + @lang2 + ' names inserted' 

	-- Lang 3
	insert into markov_subset (
		name, 
		processed
	)
	select distinct top (@lang3_count)
		Name, 
		0
	from name_Full_Details
	where language = @lang3

	print cast(@@rowcount as nvarchar(10)) + ' ' + @lang3 + ' names inserted' 

	-- Process each name in the subset table
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

		-- To hold characters on each loop through the names
		declare @inserted table
		(
			char1 nchar,
			char2 nchar,
			char3 nchar
		)

		declare @startTime datetime = getdate()

		-- This will loop until BREAK is called, or until a timeout of 30 seconds.
		WHILE (getdate() < dateadd(ss, 30, @startTime))
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

			-- Break if we hit the end of a chain
			if ((select char3 from @inserted) = '')
			begin
			
				update markov_Subset
					set processed = 1
				where name_id = @name_id

				delete @inserted

				break

			end

			delete @inserted

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

END

GO
/****** Object:  StoredProcedure [dbo].[markov_Complete]    Script Date: 10/4/2017 8:45:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nate Anderson
-- Create date: 20171004
-- Description:	Builds the model and generates the names for the chosen languages
-- =============================================
CREATE PROCEDURE [dbo].[markov_Complete]
	-- Add the parameters for the stored procedure here
	@final_name_count int,

	@lang1 nvarchar(max),
	@lang1_count int,
	
	@lang2 nvarchar(max),
	@lang2_count int,

	@lang3 nvarchar(max) = null,
	@lang3_count int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	exec markov_Build_Model
		@final_name_count = @final_name_count,
		@lang1 = @lang1,
		@lang1_count = @lang1_count,
		@lang2 = @lang2,
		@lang2_count = @lang2_count,
		@lang3 = @lang3,
		@lang3_count = @lang3_count

	exec markov_Create_Names
		@final_name_count = @final_name_count

	select distinct 
		markov_Output
	from markov_Output
	order by markov_Output
    
END

GO
/****** Object:  StoredProcedure [dbo].[markov_Create_Names]    Script Date: 10/4/2017 8:45:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nate Anderson
-- Create date: 20170903
-- Description:	Build names from the prepared model
-- =============================================
CREATE PROCEDURE [dbo].[markov_Create_Names] 
	-- Add the parameters for the stored procedure here
	@final_name_count int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	delete markov_Output

	declare @start_time datetime = getdate()

	declare @new_name nvarchar(max)

	while ((@final_name_count > 0) and dateadd(mm, 5, @start_time) > getdate())
	begin

		set @new_name = (

				select top 1
					char1 + char2 + char3 
				from markov_Model
				where char1 = ' '
					and char2 = ' '
				order by newid()
		
			)

		declare @name_time datetime = getdate()
	
		-- This will loop until BREAK is called, or until a timeout of 5 seconds.
		while (getdate() < dateadd(ss, 5, @name_time))
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

		set @final_name_count -= 1

	end
END

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "nn"
            Begin Extent = 
               Top = 22
               Left = 453
               Bottom = 185
               Right = 655
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "nrlnl"
            Begin Extent = 
               Top = 29
               Left = 226
               Bottom = 148
               Right = 422
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "nl"
            Begin Extent = 
               Top = 188
               Left = 0
               Bottom = 307
               Right = 203
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ne"
            Begin Extent = 
               Top = 16
               Left = 921
               Bottom = 135
               Right = 1115
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 208
               Left = 1179
               Bottom = 327
               Right = 1373
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "freq"
            Begin Extent = 
               Top = 150
               Left = 732
               Bottom = 313
               Right = 928
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'name_Full_Details'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'name_Full_Details'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'name_Full_Details'
GO
