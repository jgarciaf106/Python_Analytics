Select
	CAT.[HP Person ID] As [EID],
	CAT.[Name],
    CAT.[Business Group Descr] As [Business Group],
    CAT.[Cohort Start Date],
    CAT.[Cohort End Date],
    CAT.[Record Status] As [Catalyst Record Status],
	CAT.[Cohort Name],
	Case
		When HWD2.[Worker ID] Is Null Then 'T'
		Else HWD2.[Worker Status Category Code]
	End As [Worker Status Category Code],
	HWD2.[Gender Code]

From
    pd_catalyst CAT
	Left Join 
        hpw_data As HWD1 On HWD1.[Worker ID] = CAT.[HP Person ID] And HWD1.[Report Date] = EoMonth(CAT.[Cohort End Date])
	Left Join 
        hpw_data As HWD2 On HWD2.[Worker ID] = CAT.[HP Person ID] And HWD2.[Report Date] = (Select Max([Report Date]) From hpw_data)
Where
    CAT.[Business Group Descr] = 'Imaging and Printing'

Order By
	CAT.[HP Person ID],
    CAT.[Cohort Start Date]