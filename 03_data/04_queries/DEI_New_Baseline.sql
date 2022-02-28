Select
    D."Report Date",
	D."Hybrid L1",
	D."Hybrid L2 Code",
	D."Management Level",
	D."Management Level Category",
	D."Country",
	D."New Hire",
	D."Technical Job Family",
	D."Gender",
	D."Ethnicity",
	D."Veteran Status",
	D."PWD Status",
	D."Attrition Type",
    Sum(D."HC") "HC",
    Sum(D."Attrit") "Attrit"
From (
    Select 
        wd."Report Date",
        Case
            When "Business Lvl 4 (MRU) Code" = 'G034' Then 'HPCF'
            When "Hybrid L2 Code" = 'PIN' Then 'HPIB'
            When "Metro Area" = 'Udham Singh Nagar' And "Hybrid L1 Code" = 'OPER' Then 'Pant'
            Else "Hybrid L1 Code"
        End "Hybrid L1",
        "Hybrid L2 Code",
        "Management Level",
        "Management Level Category",
        Case
            When "Pay Group Country Desc" = 'United States of America' Then 'USA'
            Else 'Other'
        End "Country",
        Case
            When ("Original Hire Date" > '2020-10-31' or "Hire Date" > '2020-10-31') Then 'Y'
            Else 'N'
        End "New Hire",
        Case
            When tt."Job Family Code" Is Null Then 'No'
        Else 'Yes'
        End "Technical Job Family",
        Coalesce("Gender Code", 'U') "Gender",
        Case
            When "Pay Group Country Desc" = 'United States of America' Then "Ethnicity"
            Else 'Other'
        End "Ethnicity",
        Case 
            When "Pay Group Country Desc" <> 'United States of America' Then 'U'
            When tv."Employee ID" Is Null Then 'N'
            Else tv."Veteran Status"
        End "Veteran Status",
        Case 
            When wd."Pay Group Country Desc" In ('Austria','Belgium','Bulgaria','Croatia','Czechia','Denmark','Finland','Greece','Hungary','IrelAnd','Israel','Kazakhstan','Luxembourg','Morocco','NetherlAnds','Nigeria','Norway','PolAnd','Portugal','Russian FederatiOn','Saudi Arabia','Serbia','Slovakia','South Africa','Sweden','TunIsia','Turkey','United Arab Emirates') Then 'U'
            When tpwd."Employee ID" Is Null Then 'N'
            Else		
            'Y'
        End "PWD Status",
        "Attrition Type",
        1 "HC",
        0 "Attrit"
From
	"HPW_RESTATED_HC" wd
	Left Join 
        "TECHNICAL_JOBS" tt On tt."Job Family Code" = wd."Job Family Code"
	Left Join
         "HPW_VETERANS" tv On tv."Employee ID" = wd."Worker ID" And tv."Report Date" = (Select Max("Report Date") From "HPW_VETERANS") 
	Left Join 
        "HPW_W_DISABILITIES" tpwd On tpwd."Employee ID" = wd."Worker ID" And tpwd."Report Date" = (Select Max("Report Date") From "HPW_W_DISABILITIES") 

Where

	"Attrition Type" Not In ('Involuntary','Unknown','Voluntary')

Union All 

Select 
        wd."Report Date",
        Case
            When "Business Lvl 4 (MRU) Code" = 'G034' Then 'HPCF'
            When "Hybrid L2 Code" = 'PIN' Then 'HPIB'
            When "Metro Area" = 'Udham Singh Nagar' And "Hybrid L1 Code" = 'OPER' Then 'Pant'
            Else "Hybrid L1 Code"
        End "Hybrid L1",
        "Hybrid L2 Code",
        "Management Level",
        "Management Level Category",
        Case
            When "Pay Group Country Desc" = 'United States of America' Then 'USA'
            Else 'Other'
        End "Country",
        Case
            When ("Original Hire Date" > '2020-10-31' or "Hire Date" > '2020-10-31') Then 'Y'
            Else 'N'
        End "New Hire",
        Case
            When tt."Job Family Code" Is Null Then 'No'
        Else 'Yes'
        End "Technical Job Family",
        Coalesce("Gender Code", 'U') "Gender",
        Case
            When "Pay Group Country Desc" = 'United States of America' Then "Ethnicity"
            Else 'Other'
        End "Ethnicity",
        Case 
            When "Pay Group Country Desc" <> 'United States of America' Then 'U'
            When tv."Employee ID" Is Null Then 'N'
            Else tv."Veteran Status"
        End "Veteran Status",
        Case 
            When wd."Pay Group Country Desc" In ('Austria','Belgium','Bulgaria','Croatia','Czechia','Denmark','Finland','Greece','Hungary','IrelAnd','Israel','Kazakhstan','Luxembourg','Morocco','NetherlAnds','Nigeria','Norway','PolAnd','Portugal','Russian FederatiOn','Saudi Arabia','Serbia','Slovakia','South Africa','Sweden','TunIsia','Turkey','United Arab Emirates') Then 'U'
            When tpwd."Employee ID" Is Null Then 'N'
            Else		
            'Y'
        End "PWD Status",
        "Attrition Type",
        0 "HC",
        1 "Attrit"

From
	"HPW_RESTATED_HC" wd
	Left Join 
        "TECHNICAL_JOBS" tt On tt."Job Family Code" = wd."Job Family Code"
	Left Join
        "HPW_VETERANS" tv On tv."Employee ID" = wd."Worker ID" And tv."Report Date" = (Select Max("Report Date") From "HPW_VETERANS") 
	Left Join 
        "HPW_W_DISABILITIES" tpwd On tpwd."Employee ID" = wd."Worker ID" And tpwd."Report Date" = (Select Max("Report Date") From "HPW_W_DISABILITIES") 

Where
	"Attrition Type" = 'Voluntary'

) As D

Group By
	D."Report Date",
	D."Hybrid L1",
	D."Hybrid L2 Code",
	D."Management Level",
	D."Management Level Category",
	D."Country",
	D."New Hire",
	D."Technical Job Family",
	D."Gender",
	D."Ethnicity",
	D."Veteran Status",
	D."PWD Status",
	D."Attrition Type"
Order By
    D."Report Date",
	D."Hybrid L1",
	D."Hybrid L2 Code" Asc