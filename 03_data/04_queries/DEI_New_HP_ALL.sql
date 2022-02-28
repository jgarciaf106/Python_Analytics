Declare @fy_start As Date 
Set @fy_start = (
    Select 
		Case
			When 
				Month(GetDate()) > 11 Then DateFromParts(Year(GetDate()),10,31)
			Else
				DateFromParts(Year(GetDate()) - 1,10,31)
			End
)

Declare @rolling_date As Date
Select 
	@rolling_date = Eomonth(Max([Report Date]),-11)
From 
	hpw_data
Where 
	[Worker Reg / Temp Code] = 'R' 
And 
	[Worker Status Category Code] = 'A'

SELECT 
	S.[Report Date],
	S.[Hybrid L1],
	S.[Hybrid L2],
	S.[Hybrid L3 Code],
	S.[Work Address - City],
	S.[Technical Job Family],
	S.[Business Lvl 4 (MRU) Code],
	S.[Veteran Status],
	S.[PWD Status],
	S.[Pay Group Country Desc],
	S.[Ethnicity Group],
	S.[Gender Code],
	S.[Is Professional],
	S.[Is New Hire],
	S.[Acquisition Code],
	S.[Acquisition Desc],
	S.[Management Level Category],
	S.[Women in Management],
	SUM(S.[Headcount]) AS [HC],
	SUM(S.[Voluntary Attrition]) AS [Voluntary Attrits]
FROM (
	-- HC SELECT
	SELECT 
		WD.[Report Date],
		CASE
			WHEN WD.[Worker ID] IN ('21606160',
                                    '90017641',
                                    '21484294',
                                    '00232077',
                                    '00047873',
                                    '00580938',
                                    '00352311',
                                    '21645561',
                                    '60006802',
                                    '21797935',
                                    '90005357',
                                    '00352328',
                                    '00339632',
                                    '00351558',
                                    '00592038',
                                    '00645133',
                                    '71006028',
                                    '90028178',
                                    '71006040',
                                    '71006037',
                                    '71006034',
                                    '71006039',
                                    '71006038',
                                    '71006041',
                                    '71006045',
                                    '90027492',
                                    '71006043',
                                    '90035150',
                                    '90010011',
                                    '90001667',
                                    '21871740',
                                    '90035689',
                                    '21839763',
                                    '20003339',
                                    '90035331',
                                    '20340949',
                                    '00648556',
                                    '90007861',
                                    '90025714',
                                    '00591894',
                                    '21830028',
                                    '00545804',
                                    '20196242',
                                    '90032115',
                                    '71006035',
                                    '20082627',
                                    '90023382',
                                    '90005848',
                                    '00447902',
                                    '00644275',
                                    '60036011',
                                    '71006030',
                                    '21736225',
                                    '00645539',
                                    '04746183',
                                    '20119430',
                                    '90027056',
                                    '20163876',
                                    '90030092',
                                    '90002964',
                                    '90028466',
                                    '90028413',
                                    '71006044',
                                    '20177049',
                                    '08124848',
                                    '21845405',
                                    '71006046',
                                    '00402123',
                                    '20402555'
                                    ) THEN 'HPIP'
            WHEN WD.[Worker ID] IN ('00398243',
                                    '21969278',
                                    '60036308',
                                    '60059912',
                                    '60003670',
                                    '60060484',
                                    '00305310'
                                    ) THEN 'SNI'
            WHEN (WD.[Business Lvl 1 (Group) Code] = 'OPER' AND WD.[Work Address - City] = 'Pantnagar') THEN 'PANT'
			ELSE [Hybrid L1 Code]
		END AS [Hybrid L1],
		WD.[Hybrid L2 Code] AS [Hybrid L2],
		WD.[Hybrid L3 Code],

		CASE
			WHEN WD.[Work Address - City] = 'Pantnagar' THEN WD.[Work Address - City]
			WHEN WD.[Work Address - City] = 'Boise' THEN WD.[Work Address - City]
			WHEN WD.[Work Address - City] = 'Vancouver' THEN WD.[Work Address - City]
			ELSE 'Other'
		END AS [Work Address - City],

		CASE
			WHEN TT.[Job Family Code] IS NULL THEN 'No'
			ELSE 'Yes'
		END AS [Technical Job Family],

		CASE
			WHEN WD.[Business Lvl 4 (MRU) Code] = 'G034' THEN WD.[Business Lvl 4 (MRU) Code]
			ELSE 'Other'
		END AS [Business Lvl 4 (MRU) Code],
		CASE
			WHEN VET.[Employee ID] IS NULL THEN 'U'
			ELSE VET.[Veteran Status]
		END AS [Veteran Status],
		CASE
			WHEN WD.[Pay Group Country Desc] IN (
			'Austria',
			'Belgium',
			'Bulgaria',
			'Croatia',
			'Czechia',
			'Denmark',
			'FinlAnd',
			'Greece',
			'Hungary',
			'IrelAnd',
			'Israel',
			'Kazakhstan',
			'Luxembourg',
			'Morocco',
			'NetherlAnds',
			'Nigeria',
			'Norway',
			'PolAnd',
			'Portugal',
			'Russian FederatiOn',
			'Saudi Arabia',
			'Serbia',
			'Slovakia',
			'South Africa',
			'Sweden',
			'Tunisia',
			'Turkey',
			'United Arab Emirates')
			THEN 'U'
			WHEN PWD.[Employee ID] IS NULL THEN 'N'
			ELSE PWD.[Is PWD?]
		END AS [PWD Status],

		CASE
			WHEN WD.[Work Address - Country Code] = 'USA' THEN WD.[Work Address - Country]
			ELSE 'Other'
		END AS [Pay Group Country Desc],

		CASE
			WHEN WD.[Work Address - Country Code] = 'USA' THEN WD.[Ethnicity Group]
			ELSE 'Other'
		END AS [Ethnicity Group],
		COALESCE(WD.[Gender Code],'U') AS [Gender Code],

		CASE
			WHEN WD.[Management Level Category] <> 'NONE' THEN 'Yes'
			ELSE 'No'
		END AS [Is Professional],

		CASE
			WHEN WD.[Original Hire Date] > @fy_start OR WD.[Hire Date] > @fy_start THEN 'Yes'
			ELSE 'No'
		END AS [Is New Hire],
		WD.[Acquisition Code],
		WD.[Acquisition Desc],
		WD.[Management Level Category],
		CASE
            WHEN WD.[Management Level] IN ('EXE', 'DIR', 'SFL', 'FEL', 'STR', 'MG2', 'MG1', 'SU2', 'SU1') THEN 'Yes'
            ELSE 'No'
        END AS [Women in Management],
        CASE
            WHEN WD.[Management Level] IN ('EXE','SFL','FEL') THEN 'Yes'
            ELSE 'No'
        END AS [VP+],

		CASE
			WHEN WD.[Worker Reg / Temp Code] = 'R' AND WD.[Worker Status Category Code] = 'A' THEN 1
			ELSE 0
		END [Headcount],
		CASE
			WHEN WD.[Worker Status Category Code] = 'T' AND WD.[Attrition Type] = 'Voluntary' THEN 1
			ELSE 0
		END [Voluntary Attrition],
		CASE
			WHEN WD.[Worker Status Category Code] = 'T' AND WD.[Attrition Type] = 'Involuntary' AND WD.[Termination Reason Code] = 'WFM' THEN 1
			ELSE 0
		END AS [WFR],
		'HC' AS [Type]
	
	FROM hpw_data AS WD

	LEFT JOIN job_function AS JF ON JF.[Job Family Group] = WD.[Job Family Group]
	LEFT JOIN labor_pyramid AS LP ON LP.[Management Level] = WD.[Management Level]
	LEFT JOIN fedl1 AS F1 ON F1.[Business Lvl 4 (MRU) Code] = WD.[Business Lvl 4 (MRU) Code]
	LEFT JOIN fedl2 AS F2 ON F2.[Business Lvl 4 (MRU) Code] = WD.[Business Lvl 4 (MRU) Code]
	LEFT JOIN fedl3 AS F3 ON F3.[Business Lvl 4 (MRU) Code] = WD.[Business Lvl 4 (MRU) Code]
	LEFT JOIN technical_job AS TT ON TT.[Job Family Code] = WD.[Job Family Code]
	LEFT JOIN hpw_veteran AS VET ON VET.[Report Date] = WD.[Report Date] AND VET.[Employee ID] = WD.[Worker ID] AND VET.[Veteran Status] = 'Y'
	LEFT JOIN hpw_w_disability AS PWD ON PWD.[Employee ID] = WD.[Worker ID] AND PWD.[Report Date] = (Select Max([Report Date]) From hpw_w_disability)

	WHERE 
		WD.[Report Date] >= @rolling_date
		AND WD.[Worker Reg / Temp Code] = 'R'
		AND WD.[Worker Status Category Code] = 'A'
	
	UNION ALL 
	
	-- Attrition Select
	SELECT 
		Eomonth(Dateadd(d, 1, wd.[Termination Date]), 0) AS [Report Date],
		CASE
			WHEN WD.[Worker ID] IN ('21606160',
                                    '90017641',
                                    '21484294',
                                    '00232077',
                                    '00047873',
                                    '00580938',
                                    '00352311',
                                    '21645561',
                                    '60006802',
                                    '21797935',
                                    '90005357',
                                    '00352328',
                                    '00339632',
                                    '00351558',
                                    '00592038',
                                    '00645133',
                                    '71006028',
                                    '90028178',
                                    '71006040',
                                    '71006037',
                                    '71006034',
                                    '71006039',
                                    '71006038',
                                    '71006041',
                                    '71006045',
                                    '90027492',
                                    '71006043',
                                    '90035150',
                                    '90010011',
                                    '90001667',
                                    '21871740',
                                    '90035689',
                                    '21839763',
                                    '20003339',
                                    '90035331',
                                    '20340949',
                                    '00648556',
                                    '90007861',
                                    '90025714',
                                    '00591894',
                                    '21830028',
                                    '00545804',
                                    '20196242',
                                    '90032115',
                                    '71006035',
                                    '20082627',
                                    '90023382',
                                    '90005848',
                                    '00447902',
                                    '00644275',
                                    '60036011',
                                    '71006030',
                                    '21736225',
                                    '00645539',
                                    '04746183',
                                    '20119430',
                                    '90027056',
                                    '20163876',
                                    '90030092',
                                    '90002964',
                                    '90028466',
                                    '90028413',
                                    '71006044',
                                    '20177049',
                                    '08124848',
                                    '21845405',
                                    '71006046',
                                    '00402123',
                                    '20402555'
                                    ) THEN 'HPIP'
            WHEN WD.[Worker ID] IN ('00398243',
                                    '21969278',
                                    '60036308',
                                    '60059912',
                                    '60003670',
                                    '60060484',
                                    '00305310'
                                    ) THEN 'SNI'
            WHEN (WD.[Business Lvl 1 (Group) Code] = 'OPER' AND WD.[Work Address - City] = 'Pantnagar') THEN 'PANT'
			ELSE [Hybrid L1 Code]
		END AS [Hybrid L1],
		WD.[Hybrid L2 Code] AS [Hybrid L2],
		WD.[Hybrid L3 Code],
	
		CASE
			WHEN WD.[Work Address - City] = N'Pantnagar' THEN WD.[Work Address - City]
			ELSE 'Other'
		END AS [Work Address - City],
	
		CASE
			WHEN TT.[Job Family Code] IS NULL THEN 'No'
			ELSE 'Yes'
		END AS [Technical Job Family],
	
		CASE
			WHEN WD.[Business Lvl 4 (MRU) Code] = N'G034'THEN WD.[Business Lvl 4 (MRU) Code]
			ELSE 'Other'
		END AS [Business Lvl 4 (MRU) Code],
	
		CASE
			WHEN VET.[Employee ID] IS NULL THEN 'U'
			ELSE VET.[Veteran Status]
		END AS [Veteran Status],
	
		CASE
			WHEN WD.[Pay Group Country Desc] IN (
			'Austria',
			'Belgium',
			'Bulgaria',
			'Croatia',
			'Czechia',
			'Denmark',
			'FinlAnd',
			'Greece',
			'Hungary',
			'IrelAnd',
			'Israel',
			'Kazakhstan',
			'Luxembourg',
			'Morocco',
			'NetherlAnds',
			'Nigeria',
			'Norway',
			'PolAnd',
			'Portugal',
			'Russian FederatiOn',
			'Saudi Arabia',
			'Serbia',
			'Slovakia',
			'South Africa',
			'Sweden',
			'Tunisia',
			'Turkey',
			'United Arab Emirates') THEN 'U'
			WHEN PWD.[Employee ID] IS NULL THEN 'N'
			ELSE PWD.[Is PWD?]
		END AS [PWD Status],
	
		CASE
			WHEN WD.[Work Address - Country Code] = 'USA' THEN WD.[Work Address - Country]
			ELSE 'Other'
		END AS [Pay Group Country Desc],
	
		CASE
			WHEN WD.[Work Address - Country Code] = 'USA' THEN WD.[Ethnicity Group]
			ELSE 'Other'
		END AS [Ethnicity Group],
		COALESCE(WD.[Gender Code],'U') AS [Gender Code],
	
		CASE
			WHEN WD.[Management Level Category] <> 'NONE' THEN 'Yes'
			ELSE 'No'
		END AS [Is Professional],
	
		CASE
			WHEN WD.[Original Hire Date] > @fy_start OR WD.[Hire Date] > @fy_start THEN 'Yes'
			ELSE 'No'
		END AS [Is New Hire],
		WD.[Acquisition Code],
		WD.[Acquisition Desc],
		WD.[Management Level Category],
		CASE
            WHEN WD.[Management Level] IN ('EXE', 'DIR', 'SFL', 'FEL', 'STR', 'MG2', 'MG1', 'SU2', 'SU1') THEN 'Yes'
            ELSE 'No'
        END AS [Women in Management],
        CASE
            WHEN WD.[Management Level] IN ('EXE','SFL','FEL') THEN 'Yes'
            ELSE 'No'
        END AS [VP+],
	
		CASE
			WHEN WD.[Worker Reg / Temp Code] = 'R' AND WD.[Worker Status Category Code] = 'A' THEN 1
			ELSE 0
		END [Headcount],
	
		CASE
			WHEN WD.[Worker Status Category Code] = 'T' AND WD.[Attrition Type] = 'Voluntary' THEN 1
			ELSE 0
		END AS [Voluntary Attrition],
		CASE
			WHEN WD.[Worker Status Category Code] = 'T' AND WD.[Attrition Type] = 'Involuntary' AND WD.[Termination Reason Code] = 'WFM' THEN 1
			ELSE 0
		END AS [WFR],
		'Attrition' AS [Type]
	FROM hpw_data AS WD
	
		INNER JOIN hpw_attrition AS AD ON AD.[Report Date] = WD.[Report Date] AND AD.[Worker ID] = WD.[Worker ID]
		INNER JOIN hpi_org AS HP ON HP.[Business Lvl 1 (Group) Code] = WD.[Business Lvl 1 (Group) Code]
		LEFT JOIN job_function AS JF ON JF.[Job Family Group] = WD.[Job Family Group]
		LEFT JOIN labor_pyramid AS LP ON LP.[Management Level] = WD.[Management Level]
		LEFT JOIN fedl1 AS F1 ON F1.[Business Lvl 4 (MRU) Code] = WD.[Business Lvl 4 (MRU) Code]
		LEFT JOIN fedl2 AS F2 ON F2.[Business Lvl 4 (MRU) Code] = WD.[Business Lvl 4 (MRU) Code]
		LEFT JOIN fedl3 AS F3 ON F3.[Business Lvl 4 (MRU) Code] = WD.[Business Lvl 4 (MRU) Code]
		LEFT JOIN technical_job AS TT ON TT.[Job Family Code] = WD.[Job Family Code]
		LEFT JOIN hpw_veteran AS VET ON VET.[Report Date] = WD.[Report Date]	AND VET.[Employee ID] = WD.[Worker ID]	AND VET.[Veteran Status] = 'Y'
		LEFT JOIN hpw_w_disability AS PWD ON PWD.[Employee ID] = WD.[Worker ID] AND PWD.[Report Date] = (Select Max([Report Date]) From hpw_w_disability)
	WHERE 
		Eomonth(Dateadd(d, 1, wd.[Termination Date]), 0) >= @rolling_date
) AS S
GROUP BY 
	S.[Report Date],	
	S.[Hybrid L1],
	S.[Hybrid L2],
	S.[Hybrid L3 Code],
	S.[Work Address - City],
	S.[Technical Job Family],
	S.[Business Lvl 4 (MRU) Code],
	S.[Veteran Status],
	S.[PWD Status],
	S.[Pay Group Country Desc],
	S.[Ethnicity Group],
	S.[Gender Code],
	S.[Is Professional],
	S.[Is New Hire],
	S.[Acquisition Code],
	S.[Acquisition Desc],
	S.[Management Level Category],
	S.[Women in Management]
ORDER BY 
	S.[Report Date],	
	S.[Hybrid L1],
	S.[Hybrid L2],
	S.[Hybrid L3 Code],
	S.[Work Address - City],
	S.[Technical Job Family],
	S.[Business Lvl 4 (MRU) Code],
	S.[Veteran Status],
	S.[PWD Status],
	S.[Pay Group Country Desc]