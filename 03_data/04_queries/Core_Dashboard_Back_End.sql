use hrods
go

/* Core Dashboard Query */ 

-- Report Start for HC
-- First monthly snapshot for 12 months rolling

declare @ReportStart date = '2020-12-31'

-- Fiscal Year variable

declare @FiscalStart date = '2021-10-31'

-- Date Variables
-- Last monthly snapshot from the WorkerData table

declare @LastMonthlySnapshot date

select 
	@LastMonthlySnapshot = max([Report Date]) 
from 
	hpw_data
where 
	[Worker Reg / Temp Code] = 'R' and 
	[Worker Status Category Code] = 'A'

-- Table Variable for dates
-- Stores the date values of the necesary monthly snapshots from the WorkerData table

declare @Dates table (
	[ID] tinyint identity(1, 1) not null,
	[Report Date] date
)

insert into @Dates

select distinct 
	[Report Date]
from
	hpw_data
where
	[Worker Reg / Temp Code] = 'R' and
	[Worker Status Category Code] = 'A' and
	[Report Date] <= @LastMonthlySnapshot and
	[Report Date] >= @ReportStart

-- Loop variables

declare @Iteration tinyint = 0
declare @IterationCount tinyint

-- Set @IterationCount variable

select 
	@IterationCount = max([ID])
from 
	@Dates

-- Staging Table Variable
-- Stores values from all data sources

declare @Staging table (
	[Report Date] date not null,

	[Hybrid L1 Code] nvarchar(5) null,
	[Hybrid L2 Code] nvarchar(5) null,
	[Hybrid L3 Code] nvarchar(5) null,
	[Business Lvl 4 (MRU) Code] nvarchar(5) null,

	[Is Technical Job] varchar(5) null,

	[HC] tinyint default(0),
	[Voluntary Attrits] tinyint default(0),

	[Women Management HC] tinyint default(0),
	[Management HC] tinyint default(0),
	[Lead HC] tinyint default(0),
	[Lead Women  HC] tinyint default(0),
	[VP+ HC] tinyint default(0),
	[BAA VP+ HC] tinyint default(0),
	[Technical HC] tinyint default(0),
	[Technical Women HC] tinyint default(0),
	[TCP HC] tinyint default(0),
	[TCP Women HC] tinyint default(0),

	[New Hire HC] tinyint default(0),
	[Fiscal Year Hire HC] tinyint default(0),
	[US Professional Fiscal Year Hire HC] tinyint default(0),
	[US Fiscal Year Hire HC] tinyint default(0),
	[New Hire Voluntary Attrits] tinyint default(0),

	[US Professional HC] tinyint default(0),
	[US Professional Asian HC] tinyint default(0),
	[US Professional African American HC] tinyint default(0),
	[US Professional Hispanic HC] tinyint default(0),
	[US Professional Caucasian HC] tinyint default(0),
	[US Professional American Indian HC] tinyint default(0),
	[US Professional Hawaiian/Pacific Islander HC] tinyint default(0),
	[US Professional Two+ Races HC] tinyint default(0),

	[US Population] tinyint default(0),
	[US Veteran Population] tinyint default(0),

	[US Technical HC] tinyint default(0),
	[US African American Technical HC] tinyint default(0),

	[Data Type] varchar(20),

	[Custom View 1] varchar(15) null,
	[Custom View 2] varchar(15) null,
	[Custom View 3] varchar(15) null,
	[Fiscal Quarter] nchar(6))

-- Report Date variable for loop

declare @RD date

-- HC Data insert
-- uses loop to speed up insert

while @Iteration < @IterationCount

begin

set
	@Iteration = @Iteration + 1

select 
	@RD = [Report Date] 
from 
	@Dates 
where 
	[ID] = @Iteration

insert into @Staging (
	[Report Date],

	[Hybrid L1 Code],
	[Hybrid L2 Code],
	[Hybrid L3 Code],
	[Business Lvl 4 (MRU) Code],

	[Is Technical Job],

	[HC],
	[Voluntary Attrits],
	[Lead HC],
	[Lead Women  HC],
	[Technical HC],
	[Technical Women HC],
	[TCP HC],
	[TCP Women HC],

	[New Hire HC],
	[Fiscal Year Hire HC],
	[US Professional Fiscal Year Hire HC],
	[US Fiscal Year Hire HC],
	[New Hire Voluntary Attrits],

	[US Professional HC],
	[US Professional Asian HC],
	[US Professional African American HC],
	[US Professional Hispanic HC],

	[US Population],
	[US Veteran Population],

	[US Technical HC],
	[US Asian Technical HC],
	[US African American Technical HC],
	[US Hispanic Technical HC],

	[Women Management HC],
	[Management HC],

	[Data Type],

	[Custom View 1],
	[Custom View 2],
	[Custom View 3],
	[Fiscal Quarter]
	)

select 
	wd.[Report Date],
	wd.[Hybrid L1 Code],
	wd.[Hybrid L2 Code],
	wd.[Hybrid L3 Code],
	wd.[Business Lvl 4 (MRU) Code],
	case
		when tj.[Job Family] is not null then 'Yes'
		else 'No'
	end [Is Technical Job],
	case
		when wd.[Worker Status Category Code] = 'A' then 1
		else 0
	end [HC],
	case
		when wd.[Worker Status Category Code] = 'T' and 
		wd.[Attrition Type] = 'Voluntary' then 1 
		else 0
	end [Voluntary Attrits],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Dir/VP Ind] = 'Y' then 1
		else 0
	end [Executive HC],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Dir/VP Ind] = 'N' then 1
		else 0
	end [NonExecutive HC],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Dir/VP Ind] = 'Y' and 
		wd.[Gender Code] = 'F' then 1
		else 0
	end [Women Executive HC],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Dir/VP Ind] = 'Y' and 
		wd.[Length of Service in Months] <= 36 then 1
		else 0
	end [Executive New Hire HC],
	case
		when wd.[Worker Status Category Code] = 'T' and 
		wd.[Attrition Type] = 'Voluntary' and 
		wd.[Dir/VP Ind] = 'Y' and 
		wd.[Length of Service in Months] <= 36 then 1
		else 0
	end [Executive New Hire Voluntary Attrits],
	case
		when wd.[Worker Status Category Code] = 'T' and 
		wd.[Attrition Type] = 'Voluntary' and 
		wd.[Dir/VP Ind] = 'Y' then 1
		else 0
	end [Executive Voluntary Attrits],
	case
		when wd.[Worker Status Category Code] = 'T' and 
		wd.[Attrition Type] = 'Involuntary' and 
		wd.[Dir/VP Ind] = 'Y' then 1
		else 0
	end [Executive Involuntary Attrits],

	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Dir/VP Ind] = 'Y' and 
		wd.[Length of Service in Months] >= 24 then 1
		else 0
	end [Executive Over 2 Years HC],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Dir/VP Ind] = 'Y' and 
		wd.[Length of Service in Months] < 24 then 1
		else 0
	end [Executive Under 2 Years HC],
	case
		when wd.[Worker Status Category Code] = 'T' and 
		wd.[Attrition Type] = 'Voluntary' and 
		wd.[Dir/VP Ind] = 'Y' and 
		wd.[Length of Service in Months] >= 24 then 1
		else 0
	end [Executive Over 2 Years Voluntary Attrits],
	case
		when wd.[Worker Status Category Code] = 'T' and 
		wd.[Attrition Type] = 'Voluntary' and 
		wd.[Dir/VP Ind] = 'Y' and 
		wd.[Length of Service in Months] < 24 then 1
		else 0
	end [Executive Under 2 Years Voluntary Attrits],
--
	case
		when wd.[Worker Status Category Code] = 'A'
		and wd.[Management Level] = 'EXE' then 1
		else 0
	end [EXE HC],
	case
		when wd.[Worker Status Category Code] = 'T' and 
		wd.[Attrition Type] = 'Voluntary' and 
		wd.[Management Level] = 'EXE' then 1
		else 0
	end [EXE Voluntary Attrits],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Management Level] = 'DIR' then 1
		else 0
	end [DIR HC],
	case
		when wd.[Worker Status Category Code] = 'T' and 
		wd.[Attrition Type] = 'Voluntary' and 
		wd.[Management Level] = 'DIR' then 1
		else 0
	end [DIR Voluntary Attrits],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		tj.[Job Family] is not null then 1
		else 0
	end [Technical HC],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Gender Code] = 'F' and 
		tj.[Job Family] is not null then 1
		else 0
	end [Technical Women HC],
--
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[TCP Job] = 'Y' then 1
		else 0
	end [TCP HC],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Gender Code] = 'F' and 
		wd.[TCP Job] = 'Y' then 1
		else 0
	end [TCP Women HC],
--
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Length of Service in Months] <= 12 then 1
		else 0
	end [New Hire HC],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		(wd.[Original Hire Date] > @FiscalStart or wd.[Hire Date] > @FiscalStart) then 1
		else 0
	end [Fiscal Year Hire HC], 
	case
		when wd.[Worker Status Category Code] = 'T' and 
		wd.[Attrition Type] = 'Voluntary' and 
		wd.[Length of Service in Months] <= 12 then 1
		else 0
	end [New Hire Voluntary Attrits],
--
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Work Address - Country Code] = 'USA' and 
		wd.[Management Level Category] <> 'NONE' then 1
		else 0
	end [US Professional HC],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Work Address - Country Code] = 'USA' and 
		wd.[Management Level Category] <> 'NONE' and 
		wd.[Ethnicity Group] = 'ASIAN_USA' then 1
		else 0
	end [US Professional Asian HC],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Work Address - Country Code] = 'USA' and 
		wd.[Management Level Category] <> 'NONE' and 
		wd.[Ethnicity Group] = 'BLACK_USA' then 1
		else 0
	end [US Professional African American HC],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Work Address - Country Code] = 'USA' and 
		wd.[Management Level Category] <> 'NONE' and 
		wd.[Ethnicity Group] = 'HISPA_USA' then 1
		else 0
	end [US Professional Hispanic HC],
--
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Compensation Range - Midpoint (USD)] > 0 then wd.[Primary Compensation Basis - Amount (USD)]
		else 0
	end [Salary Annual Rate (USD)],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Compensation Range - Midpoint (USD)] > 0 then wd.[Compensation Range - Midpoint (USD)]
		else 0
	end [Mid rate Annual (USD)],
--
	case
		when wd.[Is Supervisor] = 'Y' and 
		wd.[Worker Status Category Code] = 'A' and 
		wd.[Direct Supervised] <= 4 then 1
	else 0
	end [0 to 4 Supervised],
	case
		when wd.[Is Supervisor] = 'Y' and 
		wd.[Worker Status Category Code] = 'A' and 
		wd.[Direct Supervised] >= 5 and 
		wd.[Direct Supervised] < 9 then 1
	else 0
	end [5 to 8 Supervised],
	case
		when wd.[Is Supervisor] = 'Y' and 
		wd.[Worker Status Category Code] = 'A' and 
		wd.[Direct Supervised] >= 9 then 1
	else 0
	end [9+ Supervised],
	case
		when wd.[Worker Status Category Code] = 'A' then 1
	else 0
	end [Total Supervised],
	case
		when wd.[Is Supervisor] = 'Y' and 
		wd.[Worker Status Category Code] = 'A' then 1
	else 0
	end [Total Supervisors],
--
	case
		when wd.[Work Address - Country Code] = 'USA' and
		wd.[Worker Status Category Code] = 'A' then 1
		else 0
	end [US Population],
	case
		when wd.[Work Address - Country Code] = 'USA' and
		wd.[Worker Status Category Code] = 'A' and 
		tv.[Employee ID] is not null then 1
		else 0
	end [US Veteran Population],
--
	case
		when wd.[Work Address - Country Code] = 'USA' and 
		wd.[Management Level Category] <> 'NONE' and
		wd.[Worker Status Category Code] = 'A' and
		tj.[Job Family] is not null then 1
		else 0
	end [US Technical HC],

	case
		when wd.[Work Address - Country Code] = 'USA' and 
		wd.[Management Level Category] <> 'NONE' and
		wd.[Worker Status Category Code] = 'A' and
		wd.[Ethnicity Group] = 'ASIAN_USA' and
		tj.[Job Family] is not null then 1
		else 0
	end [US Asian Technical HC],

	case
		when wd.[Work Address - Country Code] = 'USA' and 
		wd.[Management Level Category] <> 'NONE' and
		wd.[Worker Status Category Code] = 'A' and
		wd.[Ethnicity Group] = 'BLACK_USA' and
		tj.[Job Family] is not null then 1
		else 0
	end [US African American Technical HC],

	case
		when wd.[Work Address - Country Code] = 'USA' and 
		wd.[Management Level Category] <> 'NONE' and
		wd.[Worker Status Category Code] = 'A' and
		wd.[Ethnicity Group] = 'HISPA_USA' and
		tj.[Job Family] is not null then 1
		else 0
	end [US Hispanic Technical HC],

	case
		when wd.[Management Level] in ('EXE', 'DIR', 'SFL', 'FEL', 'STR', 'MG2', 'MG1', 'SU2', 'SU1') and
		wd.[Gender Code] = 'F' and 
		wd.[Worker Status Category Code] = 'A' then 1 
		else 0
	end [Women Management HC],

	case
		when wd.[Management Level] in ('EXE', 'DIR', 'SFL', 'FEL', 'STR', 'MG2', 'MG1', 'SU2', 'SU1') and
		wd.[Worker Status Category Code] = 'A' then 1
		else 0
	end [Management HC],
--
	'A. HC' [Data Type]
from 
	hpw_data wd
	left join technical_job tj on tj.[Job Family Code] = wd.[Job Family Code]
	left join hpw_veteran tv on tv.[Report Date] = wd.[Report Date] and 
		tv.[Employee ID] = wd.[Worker ID] and
		tv.[Veteran Status] = 'Y'
where 
	wd.[Report Date] = @RD and 
	wd.[Worker Reg / Temp Code] = 'R' and 
	wd.[Worker Status Category Code] = 'A' 

end

-- Attrition Data insert 
-- uses AttritionData view

insert into @Staging (
	[Report Date],
	[Hybrid L1 Code],
	[Hybrid L2 Code],
	[Hybrid L3 Code],
	[Business Lvl 4 (MRU) Code],
	[Management Chain - Level 01],
	[Management Chain - Level 02],
	[Management Chain - Level 03],
	[Management Chain - Level 04],
	[Is Technical Job],
	[HC],
	[Voluntary Attrits],
	[Executive HC],
	[NonExecutive HC],
	[Women Executive HC],
	[Executive New Hire HC],
	[Executive New Hire Voluntary Attrits],
	[Executive Voluntary Attrits],
	[Executive Involuntary Attrits],
	[Executive Over 2 Years HC],
	[Executive Under 2 Years HC],
	[Executive Over 2 Years Voluntary Attrits],
	[Executive Under 2 Years Voluntary Attrits],
	[EXE HC],
	[EXE Voluntary Attrits],
	[DIR HC],
	[DIR Voluntary Attrits],
	[Technical HC],
	[Technical Women HC],
	[TCP HC],
	[TCP Women HC],
	[New Hire HC],
	[Fiscal Year Hire HC],
	[New Hire Voluntary Attrits],
	[US Professional HC],
	[US Professional Asian HC],
	[US Professional African American HC],
	[US Professional Hispanic HC],
	[Salary Annual Rate (USD)],
	[Mid rate Annual (USD)],
	[0 to 4 Supervised],
	[5 to 8 Supervised],
	[9+ Supervised],
	[Total Supervised],
	[Total Supervisors],

	[US Population],
	[US Veteran Population],

	[US Technical HC],
	[US Asian Technical HC],
	[US African American Technical HC],
	[US Hispanic Technical HC],

	[Women Management HC],
	[Management HC],

	[Data Type])

select 
	eomonth(dateadd(d, 1, wd.[Termination Date]), 0) [Report Date],
	wd.[Hybrid L1 Code],
	wd.[Hybrid L2 Code],
	wd.[Hybrid L3 Code],
	wd.[Business Lvl 4 (MRU) Code],
	wd.[Management Chain - Level 01],
	wd.[Management Chain - Level 02],
	wd.[Management Chain - Level 03],
	wd.[Management Chain - Level 04],
	case
		when tj.[Job Family] is not null then 'Yes'
		else 'No'
	end [Is Technical Job],
	case
		when wd.[Worker Status Category Code] = 'A' then 1
		else 0
	end [HC],
	case
		when wd.[Worker Status Category Code] = 'T' and 
		wd.[Attrition Type] = 'Voluntary' then 1 
		else 0
	end [Voluntary Attrits],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Dir/VP Ind] = 'Y' then 1
		else 0
	end [Executive HC],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Dir/VP Ind] = 'N' then 1
		else 0
	end [NonExecutive HC],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Dir/VP Ind] = 'Y' and 
		wd.[Gender Code] = 'F' then 1
		else 0
	end [Women Executive HC],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Dir/VP Ind] = 'Y' and 
		wd.[Length of Service in Months] <= 36 then 1
		else 0
	end [Executive New Hire HC],
	case
		when wd.[Worker Status Category Code] = 'T' and 
		wd.[Attrition Type] = 'Voluntary' and 
		wd.[Dir/VP Ind] = 'Y' and 
		wd.[Length of Service in Months] <= 36 then 1
		else 0
	end [Executive New Hire Voluntary Attrits],
	case
		when wd.[Worker Status Category Code] = 'T' and 
		wd.[Attrition Type] = 'Voluntary' and 
		wd.[Dir/VP Ind] = 'Y' then 1
		else 0
	end [Executive Voluntary Attrits],
	case
		when wd.[Worker Status Category Code] = 'T' and 
		wd.[Attrition Type] = 'Involuntary' and 
		wd.[Dir/VP Ind] = 'Y' then 1
		else 0
	end [Executive Involuntary Attrits],

	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Dir/VP Ind] = 'Y' and 
		wd.[Length of Service in Months] >= 24 then 1
		else 0
	end [Executive Over 2 Years HC],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Dir/VP Ind] = 'Y' and 
		wd.[Length of Service in Months] < 24 then 1
		else 0
	end [Executive Under 2 Years HC],
	case
		when wd.[Worker Status Category Code] = 'T' and 
		wd.[Attrition Type] = 'Voluntary' and 
		wd.[Dir/VP Ind] = 'Y' and 
		wd.[Length of Service in Months] >= 24 then 1
		else 0
	end [Executive Over 2 Years Voluntary Attrits],
	case
		when wd.[Worker Status Category Code] = 'T' and 
		wd.[Attrition Type] = 'Voluntary' and 
		wd.[Dir/VP Ind] = 'Y' and 
		wd.[Length of Service in Months] < 24 then 1
		else 0
	end [Executive Under 2 Years Voluntary Attrits],
--
	case
		when wd.[Worker Status Category Code] = 'A'
		and wd.[Management Level] = 'EXE' then 1
		else 0
	end [EXE HC],
	case
		when wd.[Worker Status Category Code] = 'T' and 
		wd.[Attrition Type] = 'Voluntary' and 
		wd.[Management Level] = 'EXE' then 1
		else 0
	end [EXE Voluntary Attrits],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Management Level] = 'DIR' then 1
		else 0
	end [DIR HC],
	case
		when wd.[Worker Status Category Code] = 'T' and 
		wd.[Attrition Type] = 'Voluntary' and 
		wd.[Management Level] = 'DIR' then 1
		else 0
	end [DIR Voluntary Attrits],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		tj.[Job Family] is not null then 1
		else 0
	end [Technical HC],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Gender Code] = 'F' and 
		tj.[Job Family] is not null then 1
		else 0
	end [Technical Women HC],
--
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[TCP Job] = 'Y' then 1
		else 0
	end [TCP HC],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Gender Code] = 'F' and 
		wd.[TCP Job] = 'Y' then 1
		else 0
	end [TCP Women HC],
--
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Length of Service in Months] <= 12 then 1
		else 0
	end [New Hire HC],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		(wd.[Original Hire Date] > @FiscalStart or wd.[Hire Date] > @FiscalStart) then 1
		else 0
	end [Fiscal Year Hire HC], 
	case
		when wd.[Worker Status Category Code] = 'T' and 
		wd.[Attrition Type] = 'Voluntary' and 
		wd.[Length of Service in Months] <= 12 then 1
		else 0
	end [New Hire Voluntary Attrits],
--
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Work Address - Country Code] = 'USA' and 
		wd.[Management Level Category] <> 'NONE' then 1
		else 0
	end [US Professional HC],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Work Address - Country Code] = 'USA' and 
		wd.[Management Level Category] <> 'NONE' and 
		wd.[Ethnicity Group] = 'ASIAN_USA' then 1
		else 0
	end [US Professional Asian HC],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Work Address - Country Code] = 'USA' and 
		wd.[Management Level Category] <> 'NONE' and 
		wd.[Ethnicity Group] = 'BLACK_USA' then 1
		else 0
	end [US Professional African American HC],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Work Address - Country Code] = 'USA' and 
		wd.[Management Level Category] <> 'NONE' and 
		wd.[Ethnicity Group] = 'HISPA_USA' then 1
		else 0
	end [US Professional Hispanic HC],
--
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Compensation Range - Midpoint (USD)] > 0 then wd.[Primary Compensation Basis - Amount (USD)]
		else 0
	end [Salary Annual Rate (USD)],
	case
		when wd.[Worker Status Category Code] = 'A' and 
		wd.[Compensation Range - Midpoint (USD)] > 0 then wd.[Compensation Range - Midpoint (USD)]
		else 0
	end [Mid rate Annual (USD)],
--
	case
		when wd.[Is Supervisor] = 'Y' and 
		wd.[Worker Status Category Code] = 'A' and 
		wd.[Direct Supervised] <= 4 then 1
	else 0
	end [0 to 4 Supervised],
	case
		when wd.[Is Supervisor] = 'Y' and 
		wd.[Worker Status Category Code] = 'A' and 
		wd.[Direct Supervised] >= 5 and 
		wd.[Direct Supervised] < 9 then 1
	else 0
	end [5 to 8 Supervised],
	case
		when wd.[Is Supervisor] = 'Y' and 
		wd.[Worker Status Category Code] = 'A' and 
		wd.[Direct Supervised] >= 9 then 1
	else 0
	end [9+ Supervised],
	case
		when wd.[Worker Status Category Code] = 'A' then 1
	else 0
	end [Total Supervised],
	case
		when wd.[Is Supervisor] = 'Y' and 
		wd.[Worker Status Category Code] = 'A' then 1
	else 0
	end [Total Supervisors],
--
	case
		when wd.[Work Address - Country Code] = 'USA' and
		wd.[Worker Status Category Code] = 'A' then 1
		else 0
	end [US Population],
	case
		when wd.[Work Address - Country Code] = 'USA' and
		wd.[Worker Status Category Code] = 'A' and 
		tv.[Employee ID] is not null then 1
		else 0
	end [US Veteran Population],
--
	case
		when wd.[Work Address - Country Code] = 'USA' and 
		wd.[Management Level Category] <> 'NONE' and
		wd.[Worker Status Category Code] = 'A' and
		tj.[Job Family] is not null then 1
		else 0
	end [US Technical HC],

	case
		when wd.[Work Address - Country Code] = 'USA' and 
		wd.[Management Level Category] <> 'NONE' and
		wd.[Worker Status Category Code] = 'A' and
		wd.[Ethnicity Group] = 'ASIAN_USA' and
		tj.[Job Family] is not null then 1
		else 0
	end [US Asian Technical HC],

	case
		when wd.[Work Address - Country Code] = 'USA' and 
		wd.[Management Level Category] <> 'NONE' and
		wd.[Worker Status Category Code] = 'A' and
		wd.[Ethnicity Group] = 'BLACK_USA' and
		tj.[Job Family] is not null then 1
		else 0
	end [US African American Technical HC],

	case
		when wd.[Work Address - Country Code] = 'USA' and 
		wd.[Management Level Category] <> 'NONE' and
		wd.[Worker Status Category Code] = 'A' and
		wd.[Ethnicity Group] = 'HISPA_USA' and
		tj.[Job Family] is not null then 1
		else 0
	end [US Hispanic Technical HC],

	case
		when wd.[Management Level] in ('EXE', 'DIR', 'SFL', 'FEL', 'STR', 'MG2', 'MG1', 'SU2', 'SU1') and
		wd.[Gender Code] = 'F' and 
		wd.[Worker Status Category Code] = 'A' then 1 
		else 0
	end [Women Management HC],

	case
		when wd.[Management Level] in ('EXE', 'DIR', 'SFL', 'FEL', 'STR', 'MG2', 'MG1', 'SU2', 'SU1') and
		wd.[Worker Status Category Code] = 'A' then 1
		else 0
	end [Management HC],
--
	'B. Attrit' [Data Type]
from 
	hpw_data wd
	inner join hpw_attrition ad on ad.[Report Date] = wd.[Report Date] and 
		ad.[Worker ID] = wd.[Worker ID]
	left join technical_job tj on tj.[Job Family Code] = wd.[Job Family Code]
	left join hpw_veteran tv on tv.[Report Date] = wd.[Report Date] and 
		tv.[Employee ID] = wd.[Worker ID] and
		tv.[Veteran Status] = 'Y'
where
	eomonth(dateadd(d, 1, wd.[Termination Date]), 0) >= @ReportStart

-- Manual Data Tweaks

-- move historical results from under HPCS/CS1 over to HCCO
update @Staging

set 
	[Hybrid L1 Code] = 'HCCO'
where
	[Hybrid L2 Code] = 'CS1'

-- move historical results from under HPIP/PIN over to SNI
update @Staging

set 
	[Hybrid L1 Code] = 'SNI',
	[Hybrid L2 Code] = 'P3D'
where
	[Hybrid L3 Code] in (
		'3_DP', '3DCO', '3DMT', '3DSW',
		'3DSY', '3DVT', 'G_SB', 'GSBS')

-- move historical results from under SBM "Other" over to SNI
update @Staging
+
+++uuyff
set 
	[Hybrid L1 Code] = 'SNI'
where
	[Hybrid L2 Code] in (
		'SBQ', 'STC')

-- move historical results from under HPIP/PIN over to current HPIP L2s

update @Staging

set
	[Hybrid L2 Code] = 'IDO'
where
	[Hybrid L3 Code] in (
		'GSBM', 'I_DP', 'IGTM', 'PSPS')

update @Staging

set
	[Hybrid L2 Code] = 'PWI'
where
	[Hybrid L3 Code] in (
		'IHPS', 'LFPI', 'PWIP')

-- move historical results from under SBM/GRE over to CREW L1

update @Staging

set
	[Hybrid L1 Code] = 'CREW'
where
	[Hybrid L2 Code] = 'GRE'

-- move historical results from under SBM/PRO over to GIP L1

update @Staging

set
	[Hybrid L1 Code] = 'GIP'
where
	[Hybrid L2 Code] = 'PRO'

-- Custom Views and Fiscal Quarter

update @Staging

set 
	[Custom View 1] = case
		when [Hybrid L1 Code] in ('HPIT', 'HTMO') then 'HPIT+HTMO'
		else 'OTHER'
	end,------- =
	+

	[Custom View 2] = case
		when [Hybrid L1 Code] in ('FIN', 'GIP', 'CREW') then 'FIN+GIP+CREW'
		else 'OTHER'
	end,
	[Fiscal Quarter] = 'FY' + 
		right(datename(yyyy, dateadd(d, 61, [Report Date])), 2) + 'Q' + 
		cast(floor(((12 + month([Report Date]) - 11) % 12) / 3 ) + 1 as nchar(1))

-- Final Insert

insert into hpw_core (
	[Report Date],

	[Hybrid L1 Code],
	[Hybrid L2 Code],
	[Hybrid L3 Code],
	[Business Lvl 4 (MRU) Code],

	[Management Chain - Level 01],
	[Management Chain - Level 02],
	[Management Chain - Level 03],
	[Management Chain - Level 04],

	[Is Technical Job],

	[HC],
	[Voluntary Attrits],
	[Executive HC],
	[NonExecutive HC],
	[Women Executive HC],
	[Executive New Hire HC],
	[Executive New Hire Voluntary Attrits],
	[Executive Voluntary Attrits],
	[Executive Involuntary Attrits],
	[Executive Over 2 Years HC],
	[Executive Under 2 Years HC],
	[Executive Over 2 Years Voluntary Attrits],
	[Executive Under 2 Years Voluntary Attrits],
	[EXE HC],
	[EXE Voluntary Attrits],
	[DIR HC],
	[DIR Voluntary Attrits],
	[Technical HC],
	[Technical Women HC],
	[TCP HC],
	[TCP Women HC],
	[New Hire HC],
	[Fiscal Year Hire HC],
	[New Hire Voluntary Attrits],
	[US Professional HC],
	[US Professional Asian HC],
	[US Professional African American HC],
	[US Professional Hispanic HC],
	[Salary Annual Rate (USD)],
	[Mid rate Annual (USD)],
	[0 to 4 Supervised],
	[5 to 8 Supervised],
	[9+ Supervised],
	[Total Supervised],
	[Total Supervisors],

	[US Population],
	[US Veteran Population],
	[US Technical HC],
	[US Asian Technical HC],
	[US African American Technical HC],
	[US Hispanic Technical HC],

	[Women Management HC],
	[Management HC],
	
	[Custom View 1],
	[Custom View 2],
	
	[Fiscal Quarter] ) 

select 
	s.[Report Date],

	s.[Hybrid L1 Code],
	s.[Hybrid L2 Code],
	s.[Hybrid L3 Code],
	s.[Business Lvl 4 (MRU) Code],

	s.[Management Chain - Level 01],
	s.[Management Chain - Level 02],
	s.[Management Chain - Level 03],
	s.[Management Chain - Level 04],

	s.[Is Technical Job],

	sum(s.[HC]) [HC],
	sum(s.[Voluntary Attrits]) [Voluntary Attrits],
	sum(s.[Executive HC]) [Executive HC],
	sum(s.[NonExecutive HC]) [NonExecutive HC],
	sum(s.[Women Executive HC]) [Women Executive HC],
	sum(s.[Executive New Hire HC]) [Executive New Hire HC],
	sum(s.[Executive New Hire Voluntary Attrits]) [Executive New Hire Voluntary Attrits],
	sum(s.[Executive Voluntary Attrits]) [Executive Voluntary Attrits],
	sum(s.[Executive Involuntary Attrits]) [Executive Involuntary Attrits],
	sum(s.[Executive Over 2 Years HC]) [Executive Over 2 Years HC],
	sum(s.[Executive Under 2 Years HC]) [Executive Under 2 Years HC],
	sum(s.[Executive Over 2 Years Voluntary Attrits]) [Executive Over 2 Years Voluntary Attrits],
	sum(s.[Executive Under 2 Years Voluntary Attrits]) [Executive Under 2 Years Voluntary Attrits],
	sum(s.[EXE HC]) [EXE HC],
	sum(s.[EXE Voluntary Attrits]) [EXE Voluntary Attrits],
	sum(s.[DIR HC]) [DIR HC],
	sum(s.[DIR Voluntary Attrits]) [DIR Voluntary Attrits],
	sum(s.[Technical HC]) [Technical HC],
	sum(s.[Technical Women HC]) [Technical Women HC],
	sum(s.[TCP HC]) [TCP HC],
	sum(s.[TCP Women HC]) [TCP Women HC],
	sum(s.[New Hire HC]) [New Hire HC],
	sum(s.[Fiscal Year Hire HC]) [Fiscal Year Hire HC],
	sum(s.[New Hire Voluntary Attrits]) [New Hire Voluntary Attrits],
	sum(s.[US Professional HC]) [US Professional HC],
	sum(s.[US Professional Asian HC]) [US Professional Asian HC],
	sum(s.[US Professional African American HC]) [US Professional African American HC],
	sum(s.[US Professional Hispanic HC]) [US Professional Hispanic HC],
	sum(s.[Salary Annual Rate (USD)]) [Salary Annual Rate (USD)],
	sum(s.[Mid rate Annual (USD)]) [Mid rate Annual (USD)],
	sum(s.[0 to 4 Supervised]) [0 to 4 Supervised],
	sum(s.[5 to 8 Supervised]) [5 to 8 Supervised],
	sum(s.[9+ Supervised]) [9+ Supervised],
	sum(s.[Total Supervised]) [Total Supervised],
	sum(s.[Total Supervisors]) [Total Supervisors],

	sum(s.[US Population]) [US Population],
	sum(s.[US Veteran Population]) [US Veteran Population],
	sum(s.[US Technical HC]) [US Technical HC],
	sum(s.[US Asian Technical HC]) [US Asian Technical HC],
	sum(s.[US African American Technical HC]) [US African American Technical HC],
	sum(s.[US Hispanic Technical HC]) [US Hispanic Technical HC],
	sum(s.[Women Management HC]) [Women Management HC],
	sum(s.[Management HC]) [Management HC],

	s.[Custom View 1],
	s.[Custom View 2],
	s.[Fiscal Quarter]
from 
	@Staging s
where 
	s.[Report Date] <= @LastMonthlySnapshot
group by
	s.[Report Date],

	s.[Hybrid L1 Code],
	s.[Hybrid L2 Code],
	s.[Hybrid L3 Code],
	s.[Business Lvl 4 (MRU) Code],

	s.[Management Chain - Level 01],
	s.[Management Chain - Level 02],
	s.[Management Chain - Level 03],
	s.[Management Chain - Level 04],

	s.[Is Technical Job],

	s.[Custom View 1],
	s.[Custom View 2],
	s.[Fiscal Quarter]
order by 
	s.[Report Date],
	s.[Hybrid L1 Code],
	s.[Hybrid L2 Code],
	s.[Hybrid L3 Code],
	s.[Business Lvl 4 (MRU) Code],
	s.[Management Chain - Level 01],
	s.[Management Chain - Level 02],
	s.[Management Chain - Level 03],
	s.[Management Chain - Level 04]