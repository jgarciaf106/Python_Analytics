declare @TechDate date

select @TechDate = max([Report Date]) from technical_job_map

declare @LastDate date

select @LastDate = eomonth(dateadd(month,-1,max([Report Date]))) from hpw_data


select
	dc.[Report Date],
	dc.[Worker ID],
	dc.[Preferred Name],
	dc.[Email - Primary Work],
	dc.[Hybrid L1 Code][Current L1],
	dc.[Hybrid L2 Code][Current L2],
	isnull(f1.[Business Lvl 1 (Group) Code], wd.[Business Lvl 1 (Group) Code]) [Previous L1],
	isnull(f2.[Business Lvl 2 (Unit) Code], wd.[Business Lvl 2 (Unit) Code]) [Previous L2],
	wd.[Work Address - Country][Previous Country],
	dc.[Work Address - Country][Current Country],
	wd.[Management Level][Previous Mgt Level],
	dc.[Management Level][Current Mgt Level],
	dc.[Supervisor - Level 01 Preferred Name],
	dc.[Supervisor - Level 01 Email],
	dc.[Job Family],
	dc.[TCP Job],
	dc.[Technical Job],
	dc.[Time in Job Profile Start Date]
	--'Promotion' [Movement Type]
	--case
	--	when tj.[Job Family] is null then 'N'
	--else 'Y'
	--end [Previous Tech]
	 
 from
	hpw_daily dc
	inner join hpw_data wd on wd.[Worker ID] = dc.[Worker ID]
	left join FEDL1 f1 on f1.[Business Lvl 4 (MRU) Code] = wd.[Business Lvl 4 (MRU) Code]
	left join FEDL2 f2 on f2.[Business Lvl 4 (MRU) Code] = wd.[Business Lvl 4 (MRU) Code]
	left join technical_job_map tj on tj.[Job Family] = wd.[Job Family] and	tj.[Report Date] = @TechDate

 where
	dc.[Management Level] in ('STR','MAS') and
	dc.[Worker Status Category Code] <> 'T' and
	wd.[Worker Status Category Code] <> 'T' and
	dc.[Worker Reg / Temp Code] = 'R' and
	wd.[Worker Reg / Temp Code] = 'R' and
	(dc.[Technical Job] = 'Y' or dc.[TCP Job] = 'Y') and
	wd.[Management Level] not in ('STR','MAS') and
	wd.[Management Level Category] in ('NONE','PROF') and
	wd.[Report Date] = @LastDate

union all

select
	dc.[Report Date],
	dc.[Worker ID],
	dc.[Preferred Name],
	dc.[Email - Primary Work],
	dc.[Hybrid L1 Code][Current L1],
	dc.[Hybrid L2 Code][Current L2],
	isnull(f1.[Business Lvl 1 (Group) Code], wd.[Business Lvl 1 (Group) Code]) [Previous L1],
	isnull(f2.[Business Lvl 2 (Unit) Code], wd.[Business Lvl 2 (Unit) Code]) [Previous L2],
	wd.[Work Address - Country][Previous Country],
	dc.[Work Address - Country][Current Country],
	wd.[Management Level][Previous Mgt Level],
	dc.[Management Level][Current Mgt Level],
	dc.[Supervisor - Level 01 Preferred Name],
	dc.[Supervisor - Level 01 Email],
	dc.[Job Family],
	dc.[TCP Job],
	dc.[Technical Job],
	dc.[Time in Job Profile Start Date]
	--'Promotion' [Movement Type]
	--case
	--	when tj.[Job Family] is null then 'N'
	--else 'Y'
	--end [Previous Tech]
	 
 from
	hpw_daily dc
	inner join hpw_data wd on wd.[Worker ID] = dc.[Worker ID]
	left join FEDL1 f1 on f1.[Business Lvl 4 (MRU) Code] = wd.[Business Lvl 4 (MRU) Code]
	left join FEDL2 f2 on f2.[Business Lvl 4 (MRU) Code] = wd.[Business Lvl 4 (MRU) Code]
	left join technical_job_map tj on tj.[Job Family] = wd.[Job Family] and	tj.[Report Date] = @TechDate

 where
	dc.[Management Level] in ('STR') and
	dc.[Worker Status Category Code] <> 'T' and
	wd.[Worker Status Category Code] <> 'T' and
	dc.[Worker Reg / Temp Code] = 'R' and
	wd.[Worker Reg / Temp Code] = 'R' and
	(dc.[Technical Job] = 'Y' or dc.[TCP Job] = 'Y') and
	wd.[Management Level] not in ('STR') and
	wd.[Management Level Category] in ('NONE','PROF') and
	wd.[Report Date] = @LastDate

--select
--	dc.[Report Date],
--	dc.[Worker ID],
--	dc.[Preferred Name],
--	dc.[Email - Primary Work],
--	dc.[Hybrid L1 Code][Current L1],
--	dc.[Hybrid L2 Code][Current L2],
--	null [Previous L1],
--	null [Previous L2],
--	null[Previous Country],
--	dc.[Work Address - Country][Current Country],
--	null [Previous Mgt Level],
--	dc.[Management Level][Current Mgt Level],
--	dc.[Supervisor - Level 01 Preferred Name],
--	dc.[Supervisor - Level 01 Email],
--	dc.[Job Family],
--	dc.[TCP Job],
--	dc.[Technical Job],
--	'New Hire' [Movement Type]

--from 
--	DailyHC dc

--where
--	(dc.[Hire Date] > @LastDate or dc.[Original Hire Date] > @LastDate) and
--	dc.[Worker Status Category Code] <> 'T' and
--	dc.[Worker Reg / Temp Code] = 'R' and
--	(dc.[Technical Job] = 'Y' or dc.[TCP Job] = 'Y') and
--	dc.[Management Level] in ('STR','MAS')

order by
	[Current L1],
	[Current L2],
	[Current Country],
	[Previous Country]