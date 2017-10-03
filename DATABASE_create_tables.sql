USE [Name_Generator]
GO
/****** Object:  Table [dbo].[markov_Model]    Script Date: 10/2/2017 10:08:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[markov_Model](
	[char1] [nvarchar](50) NULL,
	[char2] [nvarchar](50) NULL,
	[char3] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[markov_Output]    Script Date: 10/2/2017 10:08:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[markov_Output](
	[markov_Output] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[markov_Subset]    Script Date: 10/2/2017 10:08:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[markov_Subset](
	[name_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](max) NULL,
	[processed] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[name_Culture]    Script Date: 10/2/2017 10:08:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[name_Culture](
	[guid_Culture] [uniqueidentifier] NOT NULL,
	[name_Culture] [nvarchar](100) NULL,
 CONSTRAINT [PK_name_Culture] PRIMARY KEY CLUSTERED 
(
	[guid_Culture] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[name_DataSource]    Script Date: 10/2/2017 10:08:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[name_DataSource](
	[guid_Source] [uniqueidentifier] NOT NULL,
	[name_Source] [nvarchar](max) NULL,
 CONSTRAINT [PK_data_Source] PRIMARY KEY CLUSTERED 
(
	[guid_Source] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[name_Era]    Script Date: 10/2/2017 10:08:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[name_Era](
	[guid_Era] [uniqueidentifier] NOT NULL,
	[name_Era] [nvarchar](50) NULL,
 CONSTRAINT [PK_name_Era] PRIMARY KEY CLUSTERED 
(
	[guid_Era] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[name_Name]    Script Date: 10/2/2017 10:08:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[name_Name](
	[guid_Name] [uniqueidentifier] NOT NULL,
	[name_Name] [nvarchar](max) NOT NULL,
	[guid_Source] [uniqueidentifier] NULL,
	[TEMP_name_sex] [nvarchar](10) NULL,
 CONSTRAINT [PK_name_Name] PRIMARY KEY CLUSTERED 
(
	[guid_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[name_rl_Name_Culture]    Script Date: 10/2/2017 10:08:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[name_rl_Name_Culture](
	[guid_Name] [uniqueidentifier] NOT NULL,
	[guid_Culture] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_name_rl_Name_Culture] PRIMARY KEY CLUSTERED 
(
	[guid_Name] ASC,
	[guid_Culture] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[name_rl_Name_Culture_Era_Frequency]    Script Date: 10/2/2017 10:08:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[name_rl_Name_Culture_Era_Frequency](
	[guid_Name] [uniqueidentifier] NULL,
	[guid_Culture] [uniqueidentifier] NULL,
	[guid_Era] [uniqueidentifier] NULL,
	[frequency] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[name_rl_Name_Era]    Script Date: 10/2/2017 10:08:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[name_rl_Name_Era](
	[guid_Era] [uniqueidentifier] NOT NULL,
	[guid_Name] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_name_rl_Name_Era] PRIMARY KEY CLUSTERED 
(
	[guid_Era] ASC,
	[guid_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[name_Sex]    Script Date: 10/2/2017 10:08:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[name_Sex](
	[guid_Sex] [uniqueidentifier] NOT NULL,
	[sex_Distribution] [nvarchar](10) NULL,
	[description_Sex_Distribution] [nvarchar](max) NULL,
 CONSTRAINT [PK_name_Sex] PRIMARY KEY CLUSTERED 
(
	[guid_Sex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RAW_character_Dictionary]    Script Date: 10/2/2017 10:08:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RAW_character_Dictionary](
	[bracket_character] [nvarchar](10) NULL,
	[replacement_character] [nvarchar](10) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RAW_file_import]    Script Date: 10/2/2017 10:08:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RAW_file_import](
	[import] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RAW_frequency_split_by_origin]    Script Date: 10/2/2017 10:08:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RAW_frequency_split_by_origin](
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
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TEMP_name_Name]    Script Date: 10/2/2017 10:08:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TEMP_name_Name](
	[name_Name] [nvarchar](max) NULL,
	[name_Culture] [nvarchar](max) NULL,
	[Frequency] [int] NULL,
	[name_Source] [varchar](36) NOT NULL,
	[name_Era] [varchar](6) NOT NULL,
	[name_Sex] [nvarchar](8) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TEMP_name_Name_NOT_CORRECTED_FOR_NON_ISO]    Script Date: 10/2/2017 10:08:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TEMP_name_Name_NOT_CORRECTED_FOR_NON_ISO](
	[name_Name] [nvarchar](max) NULL,
	[name_Culture] [nvarchar](max) NULL,
	[Frequency] [int] NULL,
	[name_Source] [varchar](36) NOT NULL,
	[name_Era] [varchar](6) NOT NULL,
	[name_Sex] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
