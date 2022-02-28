Select
   [Invention Id],
   [Invention Status],
   [Invention Country],
   [Org],
   [Inventors],
   [Inventor EMail],
   [Employee ID],
   Case
      When [Inventors Country] = 'United States of America' Then '1. US'
      When [Inventors Country] = 'Taiwan' Then '2. Taiwan'
      When [Inventors Country] = 'Korea, Republic of (KR)' Then '3. South Korea'
      When [Inventors Country] = 'Spain' Then '4. Spain'
      When [Inventors Country] = 'Israel' Then '5. Israel'
      When [Inventors Country] = 'India' Then '6. India'
      Else '7. Others'
   End As [Inventors Country],
   'FY' + Right(Left([FYQuarter Received Date],4),2) As [Year],
   [FYQuarter Received Date],
   dh.[Gender Code],
   dh.[Work Address - Country],
   Case 
      When dh.[Hybrid L1 Code] = 'HPIP' Then '1. Print'
      When dh.[Hybrid L1 Code]  = 'PSYS' Then '2. PS'
      When dh.[Hybrid L1 Code]  = 'HPTO' Then '3. CTO'
      Else '4. Others'
   End As [Hybrid L1 Code],
   dh.[Length of Service in Years],
   Case
    When dh.[Management Level] = 'MAS' Then '1. Master (Senior IC)'
    When dh.[Management Level] = 'EXP' Then '2. Expert (Senior IC)'
    When dh.[Management Level] = 'SPE' Then '3. Specialist (Junior IC)'
    When dh.[Management Level] = 'INT' Then '4. Intermidiate (Junior IC)'
    When dh.[Management Level] = 'ENT' Then '5. Entry (Junior IC)'
    When dh.[Management Level] = 'MG1' Then '6. Manager 1'
    Else '7. Others'
   End As [Job Level],
   dh.[TCP Job],
   dh.[Job Family Group],
   dh.[Worker Reg / Temp Code],
   dh.[Worker Status Category Code],
   Case
    When Count([Invention Id]) Over(Partition By [Invention Id]) > 1 Then 'Group'
    Else 'Solo'
   End As [Solo/Group inventor],
   Case
    When Count([Inventors]) Over(Partition By [Inventors]) = 1 Then '1st TI'
    Else '-'
   End  As [First Time Inventor]
From 
   hpw_ip As ip
Inner Join
   hpw_daily As dh On ip.[Employee ID] = dh.[Worker ID]
