Select 
    CAT."Cohort",
    Count(1) As "Successor"
From
    "HPW_TAL_UNIQUE_VIEW" As TU6
Inner Join
    "PD_CATALYST" As CAT On CAT."HP Person ID" = TU6."Employee ID"
Inner Join
    "HPW_DATA" As HWD On HWD."Worker ID" = TU6."Employee ID"
Where
   HWD."Report Date" = (Select Max("Report Date") From "HPW_DATA")

Group By 
	CAT."Cohort"
