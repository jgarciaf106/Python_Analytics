set nocount on

declare @JobMoves table (
	JobMoves nvarchar(50) not null
)

insert into @JobMoves values 
	('Demotion'),
	('Lateral Move'),
	('Promotion'),
	('Transfer In - Demotion'),
	('Transfer In - Lateral Move'),
	('Transfer In - Promotion'),
	('Transfer Out - Demotion'),
	('Transfer Out - Lateral Move'),
	('Transfer Out - Promotion'),
	('L1 Bus Change'),
	('L2 Bus Change'),
	('L3 Bus Change'),
	('L4 Bus Change')

select 
	hct.[ReportDate],
	hct.[PreviousReportDate],
	hct.[EmployeeID],
	hct.[Name],
	hct.[PreviousL1],
	hct.[CurrentL1],
	hct.[PreviousL2],
	hct.[CurrentL2],
	hct.[PreviousL3],
	hct.[CurrentL3],
	hct.[PreviousL4],
	hct.[CurrentL4],
	hct.[PreviousPayrollRegion] [PreviousPayrollTheater],
	hct.[CurrentPayrollRegion] [CurrentPayrollTheater],
	hct.[PreviousPayrollCountry],
	hct.[CurrentPayrollCountry],
	hct.[PreviousSalaryGrade],
	hct.[CurrentSalaryGrade],
	hct.[PreviousJobCode],
	hct.[CurrentJobCode],
	hct.[PreviousJobLevel],
	hct.[CurrentJobLevel],
	hct.[PreviousSupervisor],
	hct.[CurrentSupervisor],
	hct.[ChangeDescription],
	hct.[ChangeSubCategory],
	hct.[ChangeCategory],
	hct.[OriginalHireDate],
	hct.[TerminationDate],
	hct.[RehireDate],
	hct.[LH1],
	hct.[CurrentRptLevel1MgrName],
	hct.[CurrentRptLevel2MgrName],
	hct.[CurrentRptLevel3MgrName],
	hct.[CurrentRptLevel4MgrName],
	hct.[PreviousRptLevel1MgrName],
	hct.[PreviousRptLevel2MgrName],
	hct.[PreviousRptLevel3MgrName],
	hct.[PreviousRptLevel4MgrName],
	hct.[CurrentJobMonthsInJob],
	hct.[PreviousJobMonthsInJob],
	hct.[GenderCode],
	wd1.[Job Family] [CurrentJobFamily],
	wd2.[Job Family] [PreviousJobFamily],
	wd1.[TCP Job] [CurrentTCPJob],
	wd2.[TCP Job] [PreviousTCPJob],
	case
		when tj1.[Job Family] is not null then 'Y'
		else 'N'
	end [CurrentTechnicalJob],
	case
		when tj2.[Job Family] is not null then 'Y'
		else 'N'
	end [PreviousTechnicalJob],
	CASE
			WHEN wd1.[Work Address - Country Code] = 'USA' THEN 
				CASE 
					WHEN wd1.[Ethnicity Group] = 'WHITE_USA' THEN 'Caucasian'
					WHEN wd1.[Ethnicity Group] = 'ASIAN_USA' THEN 'Asian'
					WHEN wd1.[Ethnicity Group] = 'BLACK_USA' THEN 'African American'
					WHEN wd1.[Ethnicity Group] = 'HISPA_USA' THEN 'Hispanic/Latino'
					WHEN wd1.[Ethnicity Group] = 'AMIND_USA' THEN 'American Indian'
					WHEN wd1.[Ethnicity Group] = 'PACIF_USA' THEN 'Hawaiian/Pacific Islander'
					WHEN wd1.[Ethnicity Group] = '9_USA' THEN 'Two+ Races'
					WHEN wd1.[Ethnicity Group] = 'NSPEC_USA' THEN 'Undisclosed'
					WHEN wd1.[Ethnicity Group] = 'UNK' THEN 'Unknown'
				END
			ELSE 'Other'
		END AS [Ethnicity Group]
from 
	hpw_tracking hct
	inner join job_move jm on jm.[jobmoves] = hct.[ChangeSubCategory]
	left join hpw_data wd1 on wd1.[Report Date] = hct.[ReportDate] and 
		wd1.[Worker ID] = hct.EmployeeID
	left join hpw_data wd2 on wd2.[Report Date] = hct.[PreviousReportDate] and 
		wd2.[Worker ID] = hct.EmployeeID
	left join technical_job tj1 on tj1.[Job Family] = wd1.[Job Family]
	left join technical_job tj2 on tj2.[Job Family] = wd2.[Job Family]
where 
	hct.ReportDate >= '2020-11-30'
and 
    hct.ReportDate <= '2021-10-31'
and 
    hct.[ChangeSubCategory] = 'Promotion'
order by 
	hct.[ReportDate] desc,
	hct.[CurrentL1],
	hct.[CurrentL2],
	hct.[CurrentL3],
	hct.[CurrentL4],
	hct.[CurrentPayrollRegion],
	hct.[CurrentPayrollCountry],
	hct.[CurrentRptLevel1MgrName],
	hct.[CurrentRptLevel2MgrName],
	hct.[CurrentRptLevel3MgrName],
	hct.[CurrentRptLevel4MgrName],
	wd1.[Job Family],
	hct.[CurrentJobCode]