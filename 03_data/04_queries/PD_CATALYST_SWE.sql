Select
    *
From(
    Select Distinct
        --wd.[Report Date],
        cat.[HP Person ID],
        Case 
            When WD.[Management Level] = 'CEO' Or WD.[Worker ID] IN (Select [Worker ID] From [hpw_l1_leader]) Then '(L1) C-Suite'
            When WD.[Management Level] = 'EXE'  Then '(L3) Executive'
            When WD.[Management Level] = 'DIR'  Then '(L4) Senior Level'
            When WD.[Management Level] IN ('SU1','SU2','MG1','MG2')  Then '(L5) Mid-Level'
            When WD.[Management Level] IN ('ENT','INT','SPE','EXP','MAS','STR','FEL','SFL')  Then '(L6) Professional'
            Else '(L7) Non-Professional'
        End As [Management Level],
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
        row_number() over(partition by cat.[HP Person ID] order by wd.[Report Date] desc) As [Row Number],
        Case
			When TT.[Job Family Code] Is Null Then 'No'
			Else 'Yes'
		End As [Technical Job Family]
    From 
        [pd_catalyst] As cat
    Left Join 
        [hpw_data]As wd  On cat.[HP Person ID] = wd.[Worker ID] 
    And
        wd.[Report Date] >= (Select Min([Enrollment Date]) From [pd_catalyst])
    Left Join technical_job As tt On tt.[Job Family Code] = wd.[Job Family Code]
) As D
Where D.[Row Number] = 1
