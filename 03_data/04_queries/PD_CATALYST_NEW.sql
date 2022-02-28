Select Distinct
    s.[Report Date],
    s.[HP Person ID],
	s.[Management Level],
    s.[Email Address],
    s.[Cohort], 
    s.[Cohort Name],        
    s.[Cohort Start Date],
    s.[Cohort End Date],
    s.[Enrollment Date],
    s.[Worker Status Category Code], 
    Eomonth(Dateadd(d, 1, s.[Termination Date]), 0) As [Termination Date],
    s.[Attrition Type],
    s.[Gender Code],
    s.[Business Group Descr],
    s.[Record Status],
    s.[Is on Success Plan]
From (

    Select Distinct
        wd.[Report Date],
        cat.[HP Person ID],
		wd.[Management Level],
        cat.[Email Address],
        cat.[Cohort],
        cat.[Cohort Name],        
        cat.[Cohort Start Date],
        cat.[Cohort End Date],        
        cat.[Enrollment Date],
        wd.[Worker Status Category Code],
        wd.[Termination Date],
        wd.[Attrition Type],
        wd.[Gender Code],
        cat.[Business Group Descr],
        cat.[Record Status],
        tal.[Has Ready Now Successor] As [Is on Success Plan]
    From 
        pd_catalyst As cat
    Left Join 
        hpw_data As wd  On cat.[HP Person ID] = wd.[Worker ID] And wd.[Report Date] >= (Select Min([Enrollment Date]) From pd_catalyst)
    Left Join 
        hpw_talent As tal On cat.[HP Person ID] = tal.[Employee ID] And tal.[Has Ready Now Successor] = 'Yes'
    -- Where 
    --     cat."Worker Status" <> 'T'
    -- And 
    --     wd."Attrition Type" = '*'

    Union All

    Select Distinct
        wd.[Report Date],
        cat.[HP Person ID],
		wd.[Management Level],
        cat.[Email Address],
        cat.[Cohort],
        cat.[Cohort Name],        
        cat.[Cohort Start Date],
        cat.[Cohort End Date],        
        cat.[Enrollment Date],
        wd.[Worker Status Category Code],
        wd.[Termination Date],
        wd.[Attrition Type],
        wd.[Gender Code],
        cat.[Business Group Descr],
        cat.[Record Status],
        tal.[Has Ready Now Successor] As [Is on Success Plan]
    From 
        pd_catalyst As cat
    Left Join 
        hpw_data As wd  On cat.[HP Person ID] = wd.[Worker ID] And wd.[Report Date] >= (Select Min([Enrollment Date]) From pd_catalyst)
    Left Join 
        hpw_talent As tal On cat.[HP Person ID] = tal.[Employee ID] And tal.[Has Ready Now Successor] = 'Yes'
    Where 
        cat.[Worker Status] = 'T'
    And 
        wd.[Attrition Type] <> '*'

) As s
Order By
    s.[Report Date]