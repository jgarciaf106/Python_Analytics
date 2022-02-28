Select 
    [Report Date],
    [Worker ID],
    [Management Level],
    [Ethnicity]
From 
    hpw_data WD
LEFT JOIN technical_job AS TT ON TT.[Job Family Code] = WD.[Job Family Code]
Where   
    Month([Report Date]) = 10
And 
    [Worker Reg / Temp Code] = 'R'
And 
    [Worker Status Category Code] = 'A'
And
    [Management Level] In ('STR','FEL')
And 
    [Gender Code] = 'F'
And 
    CASE
			WHEN TT.[Job Family Code] IS NULL THEN 'No'
			ELSE 'Yes'
		END = 'Yes'