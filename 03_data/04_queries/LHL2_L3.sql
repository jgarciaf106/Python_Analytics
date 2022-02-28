Set Nocount On

Declare @ReportDate Date

Select 
	@ReportDate = max([Report Date]) 
From 
	hpw_data 
Where 
	[Worker Reg / Temp Code] = 'R' 
And 
	[Worker Status Category Code] = 'A'

Select Distinct 
	[Hybrid L2 Code],
	[Hybrid L3 Code],
	[Hybrid L3 Desc] + ' [' + [Hybrid L3 Code] + ']' [Business Lvl 3 (Org Chart) Desc]
From 
	hpw_data
Where 
	[Worker Reg / Temp Code] = 'R' 
And 
	[Worker Status Category Code] = 'A' 
And 
	[Report Date] = @ReportDate
Order By 
	[Hybrid L2 Code],
	[Hybrid L3 Code]