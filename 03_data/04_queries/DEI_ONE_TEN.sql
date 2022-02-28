Select 
    [Total Base Pay - Amount (USD)],
    [Metro Area],
    [Sales Job Indicator],
    [Job Family],
    [Original Hire Date],
    [Hire Date],
    [Ethnicity Group]
From 
    hpw_daily
Where 
    [Work Address - Country Code] = 'USA'
And 
    [Management Level] In ('ADV','BAS','COR','PRI','SEN')
And 
    ([Hire Date] > '2021-10-31' Or [Original Hire Date] > '2021-10-31')
And 
    [Worker Reg / Temp Code] = 'R'
And 
    [Worker Status Category Code] = 'A'
And 
    [Management Level Category] = 'NONE'
