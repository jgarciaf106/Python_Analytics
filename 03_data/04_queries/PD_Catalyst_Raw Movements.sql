Select 
	S."Report Date",
	S."PreviousReportDate",
	S."EID",
	S."Cohort Start Date",
	S."Cohort End Date",
	S."Catalyst Enrollment Date",
	S."Catalyst Record Status",
	S."Business Group Descr",
	S."Name",
	S."Cohort",
	S."Cohort Name",
	S."Change Nature",
	S."Previous Level",
	S."Current Level",
	S."Previous Title",
	S."Current Title",
	S."Worker Status Category Code"

From (
	Select
	"ReportDate" As "Report Date",
	"PreviousReportDate",
	"HP Person ID" As "EID",
	"Cohort Start Date",
	"Cohort End Date",
	"Enrollment Date" As "Catalyst Enrollment Date",
	"Record Status" As "Catalyst Record Status",
	"Business Group Descr",
	HWD1."Preferred Name" As "Name",
	"Cohort",
	"Cohort Name",
	"ChangeSubCategory" As "Change Nature",
	"PreviousJobLevel" As "Previous Level",
	"CurrentJobLevel" As "Current Level",
	HWD1."Job Title" As "Previous Title",
	HWD2."Job Title" As"Current Title",
	Case
		When HWD3."Worker ID" Is Null Then 'T'
		Else HWD3."Worker Status Category Code"
	End As "Worker Status Category Code"

From

	"HPW_TRACKING" As HTC
	Inner Join
         "PD_CATALYST" As CAT On CAT."HP Person ID" = HTC."EmployeeID" And HTC."ReportDate" > CAT."Offering Start Date"
	Inner Join 
        "HPW_DATA" As HWD1 On HWD1."Worker ID" = CAT."HP Person ID" And HWD1."Report Date" = HTC."PreviousReportDate"
	Inner Join 
        "HPW_DATA" As HWD2 On HWD2."Worker ID" = CAT."HP Person ID" And HWD2."Report Date" = HTC."ReportDate"
	Left Join 
        "HPW_DATA" As HWD3 On HWD3."Worker ID" = CAT."HP Person ID" And HWD3."Report Date" = (Select Max("Report Date") From "HPW_DATA")

Where
	"ChangeCategory" In ('IN','INTRA')
And
	"ChangeSubCategory" In ('Promotion','Lateral Move','Demotion','Transfer In - Promotion','Transfer In - Lateral Move','Transfer In - Demotion')

Union All 

Select
	"ReportDate" As "Report Date",
	"PreviousReportDate",
	"HP Person ID" As "EID",
	"Cohort Start Date",
	"Cohort End Date",
	"Enrollment Date" As "Catalyst Enrollment Date",
	"Record Status" As "Catalyst Record Status",
	"Business Group Descr",
	HWD1."Preferred Name" As "Name",
	"Cohort",
	"Cohort Name",
	'No Change' As "Change Nature",
	"PreviousJobLevel" As "Previous Level",
	"CurrentJobLevel" As "Current Level",
	HWD1."Job Title" As "Previous Title",
	HWD2."Job Title" As"Current Title",
	Case
		When HWD3."Worker ID" Is Null Then 'T'
		Else HWD3."Worker Status Category Code"
	End As "Worker Status Category Code"

From

	"HPW_TRACKING" As HTC
	Inner Join
         "PD_CATALYST" As CAT On CAT."HP Person ID" = HTC."EmployeeID" And HTC."ReportDate" > CAT."Offering Start Date"
	Inner Join 
        "HPW_DATA" As HWD1 On HWD1."Worker ID" = CAT."HP Person ID" And HWD1."Report Date" = HTC."PreviousReportDate"
	Inner Join 
        "HPW_DATA" As HWD2 On HWD2."Worker ID" = CAT."HP Person ID" And HWD2."Report Date" = HTC."ReportDate"
	Left Join 
        "HPW_DATA" As HWD3 On HWD3."Worker ID" = CAT."HP Person ID" And HWD3."Report Date" = (Select Max("Report Date") From "HPW_DATA")

Where
	"ChangeCategory" Not In ('IN','INTRA')
And
	"ChangeSubCategory" Not In ('Promotion','Lateral Move','Demotion','Transfer In - Promotion','Transfer In - Lateral Move','Transfer In - Demotion')
) As S

Order By
	S."Cohort",
	S."EID",
	S."Report Date"

