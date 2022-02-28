set nocount on

declare @techtab table (
	[Job Family Code] nvarchar(9)
	)

insert into @techtab values

	('ENG31_020'),
	('SVC30_020'),
	('ENG39_020'),
	('SVC48_021'),
	('ENG38_020'),
	('ENG37_020'),
	('ENG01_020'),
	('ENG20_020'),
	('ENG33_020'),
	('SVC31_020'),
	('ENG25_020'),
	('ENG09_020'),
	('SVC37_025'),
	('SVC45_021'),
	('ENG32_020'),
	('INT04_020'),
	('ENG07_020'),
	('ENG03_020'),
	('SAL09_022'),
	('ENG12_020'),
	('ENG08_020'),
	('ENG05_020'),
	('QUA17_020'),
	('ENG36_020'),
	('SVC46_021'),
	('SVC15_020'),
	('ENG34_020'),
	('ENG35_020'),
	('ENG02_020'),
	('ENG30_020'),
	('SVC36_025'),
	('ENG04_020'),
	('SVC53_020')

-- Rolling Dates Calc

declare @EndDate date = '2020-10-31'

declare @VetDate date = '2020-10-31'

declare @PWDDate date = '2020-10-31'


declare @FYStart date = '2019-10-31'

-- Regular Active

select	
	wd.[Report Date],
	wd.[Worker ID],
	wd.[Preferred Name],
	case
		when wd.[Business Lvl 4 (MRU) Code] = 'G034' then 'China Factory'
		when wd.[Business Lvl 2 (Unit) Code] = 'PIN' then 'Personalization and Industrial'
		when (wd.[Work Address - City] = 'Pantnagar' and wd.[Business Lvl 1 (Group) Code] = 'OPER') then 'Pantnagar'
		else isnull(f1.[Business Lvl 1 (Group) Desc], wd.[Business Lvl 1 (Group) Desc])
	end [Hybrid L1],
	isnull(f2.[Business Lvl 2 (Unit) Desc], wd.[Business Lvl 2 (Unit) Desc]) [Hybrid L2],
	isnull(f3.[Business Lvl 3 (Org Chart) Desc], wd.[Business Lvl 3 (Org Chart) Desc]) [Hybrid L3],
	wd.[Functional Area Desc],
	wd.[Supervisor - Level 01 Employee ID],
	wd.[Supervisor - Level 01 Preferred name],
	wd.[Supervisor - Level 01 Email],
	wd.[Management Chain - Level 01 Preferred Name],
	wd.[Management Chain - Level 02 Preferred Name],
	wd.[Management Chain - Level 03 Preferred Name],
	wd.[Job Family Group],
	wd.[Job Family],
	wd.[Job Title],
	wd.[Management Level Category],
	wd.[Management Level],
	case
		when wd.[Management Level Category] <> N'NONE' then 'Y'
		else 'N'
	end [Is Professional],
	wd.[Worker Reg / Temp Desc],
	wd.[Worker Status Category Desc],
	wd.[Exempt],
	wd.[FTE],
	wd.[Sales Job Indicator],
	wd.[TCP Job],
	case
		when tt.[Job Family Code] is null then 'N'
	else 'Y'
	end [Technical Job],
	wd.[Dir/VP Ind],
	wd.[Is Supervisor],
	wd.[Total Supervised],
	wd.[Total Supervisors],
	wd.[Direct Supervised],
	wd.[Span of Ctrl],
	wd.[Rpt Level],
	wd.[Email - Primary Work],
	wd.[Pay Group Theater Desc],
	wd.[Pay Group Market Desc],
	wd.[Pay Group Country Desc],
	wd.[Work Location Market Name],
	wd.[Work Address - Country],
	wd.[Work Address - State/Province],
	wd.[Work Address - City],
	wd.[PeopleFinder State],
	wd.[PeopleFinder City],
	wd.[Location Name],
	wd.[Workplace Type ID],
	wd.[Workplace Type Desc],
	wd.[Site ID],
	wd.[Metro Area],
	wd.[Original Hire Date],
	wd.[Hire Date],
	wd.[Length of Service in Years],
	wd.[Length of Service in Months],
	case
		when wd.[Original Hire Date] > @FYStart or wd.[Hire Date] > @FYStart then 'Yes'
		else 'No'
	end [FY Hire],
	isnull(wd.[Gender Code], N'U') [Gender Code],
	case
		when wd.[Pay Group Country Code] = N'USA' then wd.[Ethnicity]
		else 'Other'
	end [Ethnicity],
	case 
		when wd.[Pay Group Country Code] <> 'USA' then 'U'
		when tv.[Employee ID] is null then 'N'
		else tv.[Veteran Status]
	end [Veteran Status],
	case 
		when  wd.[Pay Group Country Desc] in ('Austria','Belgium','Bulgaria','Croatia','Czechia','Denmark','Finland','Greece','Hungary','Ireland','Israel','Kazakhstan','Luxembourg','Morocco','Netherlands','Nigeria','Norway','Poland','Portugal','Russian Federation','Saudi Arabia','Serbia','Slovakia','South Africa','Sweden','Tunisia','Turkey','United Arab Emirates') then 'U'
		when tpwd.[Employee ID] is null then 'N'
		else tpwd.[PWD]
	end [PWD Status]

from 
	WorkerData wd
	left join FEDL1 f1 on f1.[Business Lvl 4 (MRU) Code] = wd.[Business Lvl 4 (MRU) Code]
	left join FEDL2 f2 on f2.[Business Lvl 4 (MRU) Code] = wd.[Business Lvl 4 (MRU) Code]
	left join FEDL3 f3 on f3.[Business Lvl 4 (MRU) Code] = wd.[Business Lvl 4 (MRU) Code]
	left join @techtab tt on tt.[Job Family Code] = wd.[Job Family Code]
	left join TMVet tv on tv.[Employee ID] = wd.[Worker ID] and
		tv.[Report Date] = @VetDate
	left join TMPWD tpwd on tpwd.[Employee ID] = wd.[Worker ID] and
		tpwd.[Report Date] = @PWDDate
where 
	wd.[Report Date] = @EndDate and 
	[Worker Reg / Temp Code] = N'R' and
	wd.[Worker Status Category Code] = N'A'

order by
	[Hybrid L1],
	[Hybrid L2],
	[Pay Group Country Desc],
	wd.[Worker ID]