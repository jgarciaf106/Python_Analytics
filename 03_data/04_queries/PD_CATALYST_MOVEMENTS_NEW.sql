Select 
	S.[Report Date],
	S.[PreviousReportDate],
	S.[EID],
    S.[Email Address],
	S.[Cohort Start Date],
	S.[Cohort End Date],
	S.[Catalyst Enrollment Date],
	S.[Catalyst Record Status],
	S.[Business Group Descr],
	S.[Cohort],
	S.[Cohort Name],  
	S.[Change Nature],
	S.[Previous Level],
	S.[Current Level],
	S.[Previous Title],
	S.[Current Title],
	S.[Worker Status Category Code],	
	S.[Management Level],
	S.[Length of Service in Years],
	S.[Gender Code]

From (
	Select
		[ReportDate] As [Report Date],
		[PreviousReportDate],
		[HP Person ID] As [EID],
        [Email Address],
		[Cohort Start Date],
		[Cohort End Date],
		[Enrollment Date] As [Catalyst Enrollment Date],
		[Record Status] As [Catalyst Record Status],
		[Business Group Descr],
		[Cohort],
		[Cohort Name],
		Case
		When [ChangeSubCategory] In ('Demotion', 'Transfer In - Demotion') Then 'Downward'
		When [ChangeSubCategory] In ('Promotion', 'Transfer In - Promotion') Then 'Promotion'
		When [ChangeSubCategory] IN ('Transfer In - Lateral Move','Lateral move') Then 'Lateral Move'
		Else [ChangeSubCategory]
		End As [Change Nature],
		[PreviousJobLevel] As [Previous Level],
		[CurrentJobLevel] As [Current Level],
		HWD1.[Job Title] As [Previous Title],
		HWD2.[Job Title] As [Current Title],
		Case
		When HWD3.[Worker ID] Is Null Then 'T'
		Else HWD3.[Worker Status Category Code]
		End As [Worker Status Category Code],
		HWD3.[Management Level],
		HWD3.[Length of Service in Years],
		[GenderCode] As [Gender Code]
	From
		hpw_tracking As HTC
	Inner Join
		pd_catalyst As CAT On CAT.[HP Person ID] = HTC.[EmployeeID] And HTC.[ReportDate] > CAT.[Offering Start Date]
	Inner Join 
		hpw_data As HWD1 On HWD1.[Worker ID] = CAT.[HP Person ID] And HWD1.[Report Date] = HTC.[PreviousReportDate]
	Inner Join 
		hpw_data As HWD2 On HWD2.[Worker ID] = CAT.[HP Person ID] And HWD2.[Report Date] = HTC.[ReportDate]
	Left Join 
		hpw_data As HWD3 On HWD3.[Worker ID] = CAT.[HP Person ID] And HWD3.[Report Date] = (Select Max([Report Date]) From hpw_data)

	Where
		[ChangeCategory] In ('IN','INTRA')
	And
		[ChangeSubCategory] In ('Promotion','Lateral move','Demotion','Transfer In - Promotion','Transfer In - Lateral Move','Transfer In - Demotion')

	Union All 

	Select
		[ReportDate] As [Report Date],
		[PreviousReportDate],
		[HP Person ID] As [EID],
        [Email Address],
		[Cohort Start Date],
		[Cohort End Date],
		[Enrollment Date] As [Catalyst Enrollment Date],
		[Record Status] As [Catalyst Record Status],
		[Business Group Descr],
		[Cohort],
		[Cohort Name],    
		'No Change' As [Change Nature],
		[PreviousJobLevel] As [Previous Level],
		[CurrentJobLevel] As [Current Level],
		HWD1.[Job Title] As [Previous Title],
		HWD2.[Job Title] As [Current Title],
		Case
		When HWD3.[Worker ID] Is Null Then 'T'
		Else HWD3.[Worker Status Category Code]
		End As [Worker Status Category Code],
		HWD3.[Management Level],
		HWD3.[Length of Service in Years],
		[GenderCode] As [Gender Code]
	From
		hpw_tracking As HTC
	Inner Join
		pd_catalyst As CAT On CAT.[HP Person ID] = HTC.[EmployeeID] And HTC.[ReportDate] > CAT.[Offering Start Date]
	Inner Join 
		hpw_data As HWD1 On HWD1.[Worker ID] = CAT.[HP Person ID] And HWD1.[Report Date] = HTC.[PreviousReportDate]
	Inner Join 
		hpw_data As HWD2 On HWD2.[Worker ID] = CAT.[HP Person ID] And HWD2.[Report Date] = HTC.[ReportDate]
	Left Join 
		hpw_data As HWD3 On HWD3.[Worker ID] = CAT.[HP Person ID] And HWD3.[Report Date] = (Select Max([Report Date]) From hpw_data)

	Where
		[ChangeCategory] In ('IN','INTRA')
	And
		[ChangeSubCategory] Not In ('Promotion','Lateral move','Demotion','Transfer In - Promotion','Transfer In - Lateral Move','Transfer In - Demotion')

    Union All 
    Select
		Null As [Report Date],
		Null As [PreviousReportDate],
		[HP Person ID] As [EID],
        [Email Address],
		[Cohort Start Date],
		[Cohort End Date],
		[Enrollment Date] As [Catalyst Enrollment Date],
		[Record Status] As [Catalyst Record Status],
		[Business Group Descr],
		[Cohort],
		[Cohort Name],
		'No Change' As [Change Nature],
		Null  As [Previous Level],
		Null  As [Current Level],
		Null As [Previous Title],
		Null  As [Current Title],
		Case
		When HWD3.[Worker ID] Is Null Then 'T'
		Else HWD3.[Worker Status Category Code]
		End As [Worker Status Category Code],
		HWD3.[Management Level],
		HWD3.[Length of Service in Years],
		HWD3.[Gender Code] As [Gender Code]
	From
		pd_catalyst As CAT 
	Left Join 
		hpw_data As HWD3 On HWD3.[Worker ID] = CAT.[HP Person ID] And HWD3.[Report Date] = (Select Max([Report Date]) From [HPW_DATA])

	Where
        [Email Address] Not In (
                                    Select
                                            [Email Address]
                                        From
                                            hpw_tracking As HTC
                                        Inner Join
                                            pd_catalyst As CAT On CAT.[HP Person ID] = HTC.[EmployeeID] And HTC.[ReportDate] > CAT.[Offering Start Date]
                                        Inner Join 
                                            hpw_data As HWD1 On HWD1.[Worker ID] = CAT.[HP Person ID] And HWD1.[Report Date] = HTC.[PreviousReportDate]
                                        Inner Join 
                                            hpw_data As HWD2 On HWD2.[Worker ID] = CAT.[HP Person ID] And HWD2.[Report Date] = HTC.[ReportDate]
                                        Left Join 
                                            hpw_data As HWD3 On HWD3.[Worker ID] = CAT.[HP Person ID] And HWD3.[Report Date] = (Select Max([Report Date]) From hpw_data)

                                        Where
                                            [ChangeCategory] In ('IN','INTRA')
                                        And
                                            [ChangeSubCategory] In ('Promotion','Lateral move','Demotion','Transfer In - Promotion','Transfer In - Lateral Move','Transfer In - Demotion')

                                        Union All 

                                        Select
                                            [Email Address]
                                        From
                                            hpw_tracking As HTC
                                        Inner Join
                                            pd_catalyst As CAT On CAT.[HP Person ID] = HTC.[EmployeeID] And HTC.[ReportDate] > CAT.[Offering Start Date]
                                        Inner Join 
                                            hpw_data As HWD1 On HWD1.[Worker ID] = CAT.[HP Person ID] And HWD1.[Report Date] = HTC.[PreviousReportDate]
                                        Inner Join 
                                            hpw_data As HWD2 On HWD2.[Worker ID] = CAT.[HP Person ID] And HWD2.[Report Date] = HTC.[ReportDate]
                                        Left Join 
                                            hpw_data As HWD3 On HWD3.[Worker ID] = CAT.[HP Person ID] And HWD3.[Report Date] = (Select Max([Report Date]) From hpw_data)

                                        Where
                                            [ChangeCategory] In ('IN','INTRA')
                                        And
                                            [ChangeSubCategory] Not In ('Promotion','Lateral move','Demotion','Transfer In - Promotion','Transfer In - Lateral Move','Transfer In - Demotion')
    )
) As S
Where 
   S.[Worker Status Category Code] In ('A','I')
Order By
	S.[Cohort],
	S.[EID],
	S.[Report Date]