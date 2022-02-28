select 
	[Report Date],
	[Worker ID] as [Employee ID],
    Trim(Substring([Preferred Name], 1,Charindex(',', [Preferred Name])-1)) as [Last Name],
    Trim(Substring([Preferred Name], Charindex(',', [Preferred Name])+1, LEN([Preferred Name]))) as [First Name],
	[Work Address - Country] as [Country],
	[Work Address - City] as [Location],
	[Worker Reg / Temp Desc] as [Employee Type],
	[Worker Status Category Desc] as [Worker Status],
	[Termination Date],
	case
		when [Military Status Discharge Date] is not null then 'Y'
		when [Military Status Desc] in (
			'Armed Forces Service Medal Vet (United States of America)',
			'Disabled Armed Forces Service Medal Vet (United States of America)',
			'Disabled Other Protected & AFS Medal (United States of America)',
			'Disabled Other Protected Veteran (United States of America)',
			'Disabled Service Medal & Other Vet (United States of America)',
			'Disabled Vet Not Indicated (Puerto Rico)',
			'Disabled Vet Not Indicated (United States of America)',
			'Other Protected & AFS Medal (United States of America)',
			'Other Protected Veteran (Puerto Rico)',
			'Other Protected Veteran (United States of America)',
			'Service Medal & Other Vet (United States of America)') then 'Y'
		else 'N'
	end [Veteran Status],
    [Military Status Discharge Date]

from 
	hpw_daily
where 
    case
		when [Military Status Discharge Date] is not null then 'Y'
		when [Military Status Desc] in (
			'Armed Forces Service Medal Vet (United States of America)',
			'Disabled Armed Forces Service Medal Vet (United States of America)',
			'Disabled Other Protected & AFS Medal (United States of America)',
			'Disabled Other Protected Veteran (United States of America)',
			'Disabled Service Medal & Other Vet (United States of America)',
			'Disabled Vet Not Indicated (Puerto Rico)',
			'Disabled Vet Not Indicated (United States of America)',
			'Other Protected & AFS Medal (United States of America)',
			'Other Protected Veteran (Puerto Rico)',
			'Other Protected Veteran (United States of America)',
			'Service Medal & Other Vet (United States of America)') then 'Y'
		else 'N'
	end = 'Y'