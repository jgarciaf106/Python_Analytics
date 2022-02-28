Select 
	HTC.[ReportDate],
	HTC.[PreviousReportDate],
	HTC.[EmployeeID],
	HTC.[Name],
	HTC.[PreviousL1],
	HTC.[CurrentL1],
	HTC.[PreviousL2],
	HTC.[CurrentL2],
	HTC.[PreviousL3],
	HTC.[CurrentL3],
	HTC.[PreviousL4],
	HTC.[CurrentL4],
	HTC.[PreviousPayrollRegion],
	HTC.[CurrentPayrollRegion],
	HTC.[PreviousJobCode],
	HTC.[CurrentJobCode],
	HTC.[PreviousJobLevel],
	HTC.[CurrentJobLevel],
	HTC.[PreviousSupervisor],
	HTC.[CurrentSupervisor],
	HTC.[ChangeDescription],
	HTC.[ChangeSubCategory],
	HTC.[ChangeCategory],
	HTC.[OriginalHireDate],
	HTC.[TerminationDate],
	HTC.[RehireDate],
	HTC.[LH1],
	HTC.[CurrentRptLevel1MgrName],
	HTC.[CurrentRptLevel2MgrName],
	HTC.[CurrentRptLevel3MgrName],
	HTC.[CurrentRptLevel4MgrName],
	HTC.[PreviousRptLevel1MgrName],
	HTC.[PreviousRptLevel2MgrName],
	HTC.[PreviousRptLevel3MgrName],
	HTC.[PreviousRptLevel4MgrName],
	HTC.[CurrentJobMonthsInJob],
	HTC.[PreviousJobMonthsInJob],
	HTC.[GenderCode],
	HWD1.[Job Family] As [CurrentJobFamily],
	HWD2.[Job Family] As [PreviousJobFamily],
	HWD1.[TCP Job] As [CurrentTCPJob],
	HWD2.[TCP Job] As [PreviousTCPJob],
	Case
		When TJF1.[Job Family] is not null Then 'Y'
		Else 'N'
	End [CurrentTechnicalJob],
	Case
		When TJF2.[Job Family] is not null Then 'Y'
		Else 'N'
	End [PreviousTechnicalJob],
	dbo.FX_F_QUARTER(HTC.[ReportDate]) As [FiscalQuarter],
	dbo.FX_F_YEAR(HTC.[ReportDate]) As [FiscalQuarter]
From 
	 [dbo].[HC_TRACK_CHANGES] As HTC
	Inner Join [dbo].[JOB_MOVES] As JM On JM.[Move Type] = HTC.[ChangeSubCategory]
	Left Join [dbo].[HP_WORKER_DATA] As HWD1 On HWD1.[Report Date] = HTC.[ReportDate] and HWD1.[Worker ID] = HTC.EmployeeID
	Left Join [dbo].[HP_WORKER_DATA] As HWD2 On HWD2.[Report Date] = HTC.[PreviousReportDate] and HWD2.[Worker ID] = HTC.EmployeeID
	Left Join [dbo].[TECH_JOBS_FAM] As TJF1 On TJF1.[Job Family] = HWD1.[Job Family]
	Left Join [dbo].[TECH_JOBS_FAM] As  TJF2 On TJF2.[Job Family] = HWD2.[Job Family]
Where 
	Year(HTC.ReportDate) >= 2016
And 
	Month(HTC.ReportDate) In (5,6,7,8,9,10)
And 
	HTC.[CurrentJobLevel] Like 'MAS'
And
	HWD1.[TCP Job] Like 'Y'
And 
	HTC.[ChangeCategory] In ('INTRA','IN')
And 
	HTC.[ChangeSubCategory] In ('Promotion','Transfer In - Promotion')
Order By 
	HTC.[ReportDate] Asc,
	HTC.[CurrentL1],
	HTC.[CurrentL2],
	HTC.[CurrentL3],
	HTC.[CurrentL4],
	HTC.[CurrentPayrollRegion],
	HTC.[CurrentPayrollCountry],
	HTC.[CurrentRptLevel1MgrName],
	HTC.[CurrentRptLevel2MgrName],
	HTC.[CurrentRptLevel3MgrName],
	HTC.[CurrentRptLevel4MgrName],
	HWD1.[Job Family],
	HTC.[CurrentJobCode]