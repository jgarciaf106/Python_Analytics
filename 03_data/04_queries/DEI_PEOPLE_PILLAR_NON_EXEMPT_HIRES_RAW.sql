Select Distinct
    [Worker ID],
    [Hybrid L1 Code],
    1 As [Headcount],
    [Total Base Pay - Amount (USD)],
    [Metro Area],
    [Sales Job Indicator],
    WD.[Job Family],
    [Original Hire Date],
    [Hire Date],
    [Ethnicity Group]
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
    Case
        When WD.[Original Hire Date] > '2020-10-31' or WD.[Hire Date] > '2020-10-31' Then 'Yes'
        Else 'No'
    End = 'Yes'
And
    [Exempt] = 'N'
And 
    [Report Date] = '2021-10-31'