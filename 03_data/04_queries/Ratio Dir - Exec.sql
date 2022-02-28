Select 
    * 
From (
    Select 
        [Gender Desc],
        [Management Level Category],
        [Work Location Theater Code],
        1 As [Worker Count]
    From
        hpw_daily
    Where 
        [Worker Reg / Temp Code] = 'R'
    And 
        [Worker Status Category Code] = 'A' 
    And 
        [Management Level Category] In  ('DIR','EXEC')
    And 
        [Gender Desc] <> 'Undeclared'
) As D
Pivot (Count([Worker Count]) For [Work Location Theater Code] In ([AMS],[EMEA],[APJ])) As pivot_table