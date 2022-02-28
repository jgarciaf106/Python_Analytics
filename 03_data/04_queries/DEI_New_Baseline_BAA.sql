Select 
    D."Report Date",
    D."Management Level",
    D."New Hire",
    D."Workday Div Ind",
    D."Attrition Type",
    Sum(D."HC") "HC",
    Sum(D."Attrit") "Attrit"

From(

    Select 
        wd."Report Date",
        "Management Level",
        Case
            When ("Original Hire Date" > '2020-10-31' Or "Hire Date" > '2020-10-31') Then 'Y'
            Else 'N'
        End "New Hire",
        Case
            When baa."Worker ID" Is Null Then 'N'
            Else 'Y'
        End "Workday Div Ind",
        "Attrition Type",
        1 "HC",
        0 "Attrit"

    From
        "HPW_RESTATED_HC" wd
        Left Join "HPW_BAA_VIEW" baa On baa."Worker ID" = wd."Worker ID"
        Left Join "TECHNICAL_JOBS" tt On tt."Job Family Code" = wd."Job Family Code"
        Left Join "HPW_VETERANS" tv On tv."Employee ID" = wd."Worker ID" And tv."Report Date" = (Select Max("Report Date") From "HPW_VETERANS") 
        Left Join "HPW_W_DISABILITIES" tpwd On tpwd."Employee ID" = wd."Worker ID" And tpwd."Report Date" = (Select Max("Report Date") From "HPW_W_DISABILITIES") 

    Where

        "Attrition Type" Not In ('Involuntary','Unknown','Voluntary') And "Management Level" = 'EXE' And
        Case
            When "Pay Group Country Desc" = 'United States of America' Then 'USA'
            Else 'Other'
        End = 'USA'

    Union All

    Select 

        wd."Report Date",
        "Management Level",
        Case
            When ("Original Hire Date" > '2020-10-31' Or "Hire Date" > '2020-10-31') Then 'Y'
            Else 'N'
        End "New Hire",
            Case
            When baa."Worker ID" Is Null Then 'N'
            Else 'Y'
        End "Workday Div Ind",
        "Attrition Type",
        0 "HC",
        1 "Attrit"

    From
        "HPW_RESTATED_HC" wd
        Left Join "HPW_BAA_VIEW" baa On baa."Worker ID" = wd."Worker ID"
        Left Join "TECHNICAL_JOBS" tt On tt."Job Family Code" = wd."Job Family Code"
        Left Join "HPW_VETERANS" tv On tv."Employee ID" = wd."Worker ID" And tv."Report Date" = (Select Max("Report Date") From "HPW_VETERANS") 
        left join "HPW_W_DISABILITIES" tpwd On tpwd."Employee ID" = wd."Worker ID" And tpwd."Report Date" = (Select Max("Report Date") From "HPW_W_DISABILITIES") 
    Where
        "Attrition Type" = 'Voluntary' And "Management Level" = 'EXE' And
        Case
            When "Pay Group Country Desc" = 'United States of America' Then 'USA'
            Else 'Other'
        End = 'USA'
) D
group by
	D."Report Date",
	D."Management Level",
	D."New Hire",
	D."Workday Div Ind",
	D."Attrition Type"