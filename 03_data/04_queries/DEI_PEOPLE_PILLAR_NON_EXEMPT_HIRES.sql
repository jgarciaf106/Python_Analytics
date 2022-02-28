Declare @report_date Date = '2021-10-31'

Select
    D.[Table],
    D.[Metric],
    Sum(D.[Headcount]) As [BAA Non-Exempt New Hires],
    Sum(D.[Total Hires]) As [Total Non-Exempt New Hires]
From (
    Select
        [Report Date], 
        'Hires' As [Metric],
        1 As [Headcount],
        0 As [Total Hires],
        'Non-Exempt' As [Table],
        CASE
			WHEN WD.[Original Hire Date] > '2020-10-31' OR WD.[Hire Date] > '2020-10-31' THEN 'Yes'
			ELSE 'No'
		END AS [Is New Hire]
    From 
        [hpw_data] As  WD
    Left Join
        [technical_job] AS TT ON TT.[Job Family Code] = WD.[Job Family Code]
    Where 
        [Worker Reg / Temp Code] = 'R'
    And 
        [Worker Status Category Code] = 'A'
    And
        [Pay Group Country Desc] = 'United States of America'
    And
        [Ethnicity Group] = 'BLACK_USA'
    -- And
    --     Case
    --         When TT.[Job Family Code] Is Null Then 'No'
    --         Else 'Yes'
    --     End = 'Yes'
    And
        [Exempt] = 'N'
        
    Union All

    Select
        [Report Date], 
        'Hires' As [Metric],
        0 As [Headcount],
        1 As [Total Hires],
        'Non-Exempt' As [Table],
        CASE
			WHEN WD.[Original Hire Date] > '2020-10-31' OR WD.[Hire Date] > '2020-10-31' THEN 'Yes'
			ELSE 'No'
		END AS [Is New Hire]
    From 
        [hpw_data] As  WD
    Left Join
        [technical_job] AS TT ON TT.[Job Family Code] = WD.[Job Family Code]
    Where 
        [Worker Reg / Temp Code] = 'R'
    And 
        [Worker Status Category Code] = 'A'
    And
        [Pay Group Country Desc] = 'United States of America'
    And
        [Exempt] = 'N'
    
) As D
Where
    D.[Report Date] = @report_date
    And D.[Is New Hire] = 'Yes'

Group By 
    D.[Table],
    D.[Metric]