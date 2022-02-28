Select
	CAT."HP Person ID" As "EID",
	CAT."Name",
	"Enrollment Date" As "Catalyst Enrollment Date",
    "Record Status" As "Catalyst Record Status",
	CAT."Cohort",
	Case
		When HWD2."Worker ID" Is Null Then 'T'
		Else HWD2."Worker Status Category Code"
	End As "Worker Status Category Code"

From
    "PD_CATALYST" CAT
	Left Join 
        "HPW_DATA" As HWD1 On HWD1."Worker ID" = CAT."HP Person ID" And HWD1."Report Date" = CAT."Enrollment Date"
	Left Join 
        "HPW_DATA" As HWD2 On HWD2."Worker ID" = CAT."HP Person ID" And HWD2."Report Date" = (Select Max("Report Date") From "HPW_DATA")

Order By
	CAT."Enrollment Date",
	CAT."HP Person ID"



