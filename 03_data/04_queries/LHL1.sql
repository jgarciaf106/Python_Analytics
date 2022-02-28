Set Nocount On

Select Distinct 
	Row_Number() OVER (Order By [Hybrid L1 Code]) As [Id],
	[Hybrid L1 Code],
	' [' + [Hybrid L1 Code] + ']' + ' - ' +  [Hybrid L1 Desc] [Hyrbid L1 Desc]
From 
	hpw_daily
Where 
	[Worker Reg / Temp Code] = 'R'
And 
	[Worker Status Category Code] = 'A' 
And 
	[Hybrid L1 Code] Not in ('HPHQ','HPAM','HFED','OTHS','HPCF', 'UNK')
Group By 
	[Hybrid L1 Code],
	' [' + [Hybrid L1 Code] + ']' + ' - ' +  [Hybrid L1 Desc]
Order By
	[Hybrid L1 Code] Asc

