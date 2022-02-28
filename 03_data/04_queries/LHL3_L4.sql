Set Nocount On

Declare @ReportDate Date

Select 
	@ReportDate = max([Report Date]) 
From 
	hpw_data 
Where 
	[Worker Reg / Temp Code] = N'R' 
And 
	[Worker Status Category Code] = N'A'

Select Distinct 
	[Business Lvl 3 (Org Chart) Code],
	[Business Lvl 4 (MRU) Code],
	[Business Lvl 4 (MRU) Desc] + ' [' + [Business Lvl 4 (MRU) Code] + ']' [Business Lvl 4 (MRU) Desc]
From 
	hpw_data
Where 
	[Worker Reg / Temp Code] = N'R' 
And 
	[Worker Status Category Code] = N'A' 
And 
	[Report Date] = @ReportDate
Order By 
	[Business Lvl 3 (Org Chart) Code],
	[Business Lvl 4 (MRU) Code]