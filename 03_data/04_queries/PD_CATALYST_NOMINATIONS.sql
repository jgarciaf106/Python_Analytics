Select 
    "Worker ID",
    "Preferred Name",
    "Email - Primary Work",
    "Management Chain - Level 02 Preferred Name",
    "Management Chain - Level 03 Preferred Name",
    "Management Chain - Level 04 Preferred Name",
    "Time in Job Profile",
    "Management Level",
    "Job Family",
    "TCP Job",
    "Work Address - Country Code",
    "Work Address - City",
    "Supervisor - Level 01 Preferred name",
    "Supervisor - Level 01 Email",
    "Business Lvl 1 (Group) Code",
    "Management Chain - Level 01 Preferred Name",
    "Work Location Theater Code"
From "HPW_DATA"
Where 
    "Management Level" In (
        'EXP',
        'DIR',
        'FEL',
        'INT',
        'MAS',
        'MG1',
        'MG2',
        'SPE',
        'STR',
        'SU1',
        'SU2')
And 
    "Report Date" = '2021-07-31'
And 
    "Worker Reg / Temp Code" = 'R'
And 
    "Worker Status Category Code" = 'A'
And 
    "Time in Job Profile"  > 12

