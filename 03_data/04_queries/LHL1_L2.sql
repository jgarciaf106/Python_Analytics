Set Nocount On

Select Distinct 
	Case
		When Len(Row_Number() OVER ( PARTITION BY [Hybrid L1 Code] Order By [Hybrid L1 Code])) > 1 Then [Hybrid L1 Code] + 'L2-' + CAST(Row_Number() OVER ( PARTITION BY [Hybrid L1 Code] Order By [Hybrid L1 Code]) As varchar)
		Else [Hybrid L1 Code] + 'L2-0' + CAST(Row_Number() OVER ( PARTITION BY [Hybrid L1 Code] Order By [Hybrid L1 Code]) As varchar)
	End As [Id], 
	[Hybrid L1 Code],
	[Hybrid L2 Code],
	[Hybrid L2 Desc] + ' [' + [Hybrid L2 Code] + ']' [Hybrid L2 Desc],
	[Hybrid L1 Code] + [Hybrid L2 Code] [Aux]
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
	[Hybrid L2 Code],
	[Hybrid L2 Desc] + ' [' + [Hybrid L2 Code] + ']'
Order By 

	[Hybrid L1 Code],
	[Hybrid L2 Code]