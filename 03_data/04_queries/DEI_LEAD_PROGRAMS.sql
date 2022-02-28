Select 
    Count("HP Person ID") As "Worker Counter",
    Case 
    When LP."Source" = 'Catalyst' Then 'Catalyst'
    Else LP."Cohort"
    End As "Cohort",
    HPW."Ethnicity"
 From 
    "public"."PD_LEADERSHIP_PROGRAMS" As LP
 Inner Join 
    "public"."HPW_DATA" As HPW On "HP Person ID" = "Worker ID" And HPW."Report Date" = date_trunc('month', LP."Enrollment Date") + interval '1 month' - interval '1 day'
Where 
    LP."Billing Fiscal Year" in ('2020','2021')
And
    HPW."Pay Group Country Desc" Like 'United States of America'
Group By 
    Case 
    When LP."Source" = 'Catalyst' Then 'Catalyst'
    Else LP."Cohort"
    End,
    HPW."Ethnicity"

