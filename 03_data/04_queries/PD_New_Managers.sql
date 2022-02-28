Select

	dhc.[Worker ID],
	dhc.[Preferred Name] As [Name],
	dhc.[Email - Primary Work] As [Email],
	me.[Management Level] As [Previous Management Level],
	dhc.[Management Level] As [Current Management Level],
	me.[Metro Area] As [City/Location],
	dhc.[Pay Group Country Desc],
	dhc.[Pay Group Theater Code],
	dhc.[Supervisor - Level 01 Preferred name] As [Manager],
	dhc.[Supervisor - Level 01 Email] As [Manager Email],
	'Promotion' As [Type of Movement],
	dhc.[Management Chain - Level 01 Preferred Name],
	dhc.[Management Chain - Level 02 Preferred Name],
	dhc.[Management Chain - Level 03 Preferred Name],
	dhc.[Hybrid L1 Desc] As [L1 Business]


from
	
	[hpw_data] As me
	inner join [hpw_daily] As dhc on dhc.[Worker ID] = me.[Worker ID] 

where
	me.[Report Date] = {0} and
	me.[Management Level Category] in ('PROF','NONE') and
	me.[Worker Reg / Temp Code] = 'R' and
	me.[Worker Status Category Code] <> 'T' and
	dhc.[Management Level Category] not in ('PROF','NONE') and
	dhc.[Worker Reg / Temp Code] = 'R' and
	dhc.[Worker Status Category Code] <> 'T'

union all

select

	hc.[Worker ID],
	hc.[Preferred Name] As [Name],
	hc.[Email - Primary Work] As [Email],
	null As [Previous Management Level],
	hc.[Management Level] As [Current Management Level],
	hc.[Metro Area] As [City/Location],
	hc.[Pay Group Country Desc],
	hc.[Pay Group Theater Code],
	hc.[Supervisor - Level 01 Preferred name] As [Manager],
	hc.[Supervisor - Level 01 Email] As [Manager Email],
	'New Hire' As [Type of Movement],
	hc.[Management Chain - Level 01 Preferred Name],
	hc.[Management Chain - Level 02 Preferred Name],
	hc.[Management Chain - Level 03 Preferred Name],
	hc.[Hybrid L1 Desc] As [L1 Business]

from
	[hpw_daily] As hc
where
	hc.[Management Level Category] not in ('PROF','NONE') and
	hc.[Worker Reg / Temp Code] = 'R' and
	hc.[Worker Status Category Code] <> 'T' and
	(hc.[Original Hire Date] >= {1} or hc.[Hire Date] >= {1});