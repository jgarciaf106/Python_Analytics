Declare @report_date Date = '2022-01-31'

Select
    D.[Table],
    D.[Metric],
    Sum(D.[Headcount]) As [Rep Headcount]
From (
    Select
        [Report Date], 
        'B/AA Technical' As [Metric],
        1 As [Headcount],
        'Exempt' As [Table]
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
    And
        Case
            When TT.[Job Family Code] Is Null Then 'No'
            Else 'Yes'
        End = 'Yes'
    And
        [Exempt] = 'Y'
        
    Union All

    Select
        [Report Date], 
        'B/AA Representation' As [Metric],
        1 As [Headcount],
        'Exempt' As [Table]
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
    And
        [Exempt] = 'Y'
        
    Union All

    Select 
        [Report Date],
        'B/AA VP+ level' As [Metric],
        1 As [Headcount],
        'Exempt' As [Table]
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
    And 
        [Management Level] In ('EXE','SFL','FEL')
    And
            [Exempt] = 'Y'
) As D
Where
    D.[Report Date] = @report_date

Group By 
    D.[Table],
    D.[Metric]