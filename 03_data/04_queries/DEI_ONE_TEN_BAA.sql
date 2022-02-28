Select
    [Preferred Name],
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
    [Ethnicity Group] = 'BLACK_USA'
-- And
--     Case
--         When TT.[Job Family Code] Is Null Then 'No'
--         Else 'Yes'
--     End = 'Yes'
And
    [Exempt] = 'N'
And
    [Report Date] = '2022-01-31'
And 
    CASE
        WHEN WD.[Original Hire Date] > '2020-10-31' OR WD.[Hire Date] > '2020-10-31' THEN 'Yes'
        ELSE 'No'
    END = 'Yes'