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
	S.[Custom View 1],
	S.[Custom View 2],
	S.[Work Address - City],
	S.[Technical Job Family],
	S.[Veteran Status],
	S.[PWD Status],
	S.[Pay Group Country Desc],
	S.[Ethnicity Group],
	S.[Gender Code],
	S.[Is Professional],
	S.[Is New Hire],
	S.[Management Level Category],
	S.[Management],
	SUM(S.[Headcount]) AS [HC],
	SUM(S.[Voluntary Attrition]) AS [Voluntary Attrits]
FROM (
	-- HC SELECT
	SELECT 
		WD.[Report Date],
		CASE 
			WHEN WD.[Hybrid L2 Code] = 'CS1' THEN 'HCCO'
			WHEN WD.[Hybrid L2 Code] = 'PRO' THEN 'GIP'
			WHEN WD.[Hybrid L2 Code] = 'GRE' THEN 'CREW'
			WHEN WD.[Hybrid L3 Code] IN ('3_DP', '3DCO', '3DMT', '3DSW','3DSY', '3DVT', 'G_SB', 'GSBS') THEN 'SNI'
			WHEN WD.[Hybrid L2 Code] IN ('SBQ','STC') THEN 'SNI'
			--WHEN WD.[Hybrid L1 Code]  = 'HPIB' THEN 'HPIP'
			ELSE WD.[Hybrid L1 Code] 
		END AS [Hybrid L1],
		CASE
			WHEN WD.[Hybrid L3 Code] IN ('3_DP', '3DCO', '3DMT', '3DSW','3DSY', '3DVT', 'G_SB', 'GSBS') THEN 'P3D'
			WHEN WD.[Hybrid L3 Code] IN ('GSBM','I_DP','IGTM','PSPS') THEN 'IDO'
			WHEN WD.[Hybrid L3 Code] IN ('IHPS','LFPI','PWIP') THEN 'PWI'
			ELSE WD.[Hybrid L2 Code] 
		END AS [Hybrid L2],
		CASE
			WHEN 
				CASE 
					WHEN WD.[Hybrid L2 Code] = 'CS1' THEN 'HCCO'
					WHEN WD.[Hybrid L2 Code] = 'PRO' THEN 'GIP'
					WHEN WD.[Hybrid L2 Code] = 'GRE' THEN 'CREW'
					WHEN WD.[Hybrid L3 Code] IN ('3_DP', '3DCO', '3DMT', '3DSW','3DSY', '3DVT', 'G_SB', 'GSBS') THEN 'SNI'
					WHEN WD.[Hybrid L2 Code] IN ('SBQ','STC') THEN 'SNI'
					--WHEN WD.[Hybrid L1 Code]  = 'HPIB' THEN 'HPIP'
					ELSE WD.[Hybrid L1 Code] 
				END in ('HPIT', 'HTMO') then 'HPIT+HTMO'
			ELSE 'OTHER'
		END AS [Custom View 1],
		CASE
			WHEN 
				CASE 
					WHEN WD.[Hybrid L2 Code] = 'CS1' THEN 'HCCO'
					WHEN WD.[Hybrid L2 Code] = 'PRO' THEN 'GIP'
					WHEN WD.[Hybrid L2 Code] = 'GRE' THEN 'CREW'
					WHEN WD.[Hybrid L3 Code] IN ('3_DP', '3DCO', '3DMT', '3DSW','3DSY', '3DVT', 'G_SB', 'GSBS') THEN 'SNI'
					WHEN WD.[Hybrid L2 Code] IN ('SBQ','STC') THEN 'SNI'
					--WHEN WD.[Hybrid L1 Code]  = 'HPIB' THEN 'HPIP'
					ELSE WD.[Hybrid L1 Code] 
				END in ('FIN', 'GIP', 'CREW') then 'FIN+GIP+CREW'
			ELSE 'OTHER'
		END AS [Custom View 2],
		CASE
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
		CASE
            WHEN WD.[Management Level] IN ('EXE', 'DIR', 'SFL', 'FEL', 'STR', 'MG2', 'MG1', 'SU2', 'SU1') THEN 'Yes'
            ELSE 'No'
        END AS [Management],
		WD.[Management Level Category],

		CASE
			WHEN WD.[Worker Reg / Temp Code] = 'R' AND WD.[Worker Status Category Code] = 'A' THEN 1
			ELSE 0
		END [Headcount],
		
		CASE
			WHEN WD.[Worker Status Category Code] = 'T' AND WD.[Attrition Type] = 'Voluntary' THEN 1
			ELSE 0
		END [Voluntary Attrition],
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
			WHEN WD.[Hybrid L2 Code] = 'CS1' THEN 'HCCO'
			WHEN WD.[Hybrid L2 Code] = 'PRO' THEN 'GIP'
			WHEN WD.[Hybrid L2 Code] = 'GRE' THEN 'CREW'
			WHEN WD.[Hybrid L3 Code] IN ('3_DP', '3DCO', '3DMT', '3DSW','3DSY', '3DVT', 'G_SB', 'GSBS') THEN 'SNI'
			WHEN WD.[Hybrid L2 Code] IN ('SBQ','STC') THEN 'SNI'
			--WHEN WD.[Hybrid L1 Code]  = 'HPIB' THEN 'HPIP'
			ELSE WD.[Hybrid L1 Code] 
		END AS [Hybrid L1],
		CASE
			WHEN WD.[Hybrid L3 Code] IN ('3_DP', '3DCO', '3DMT', '3DSW','3DSY', '3DVT', 'G_SB', 'GSBS') THEN 'P3D'
			WHEN WD.[Hybrid L3 Code] IN ('GSBM','I_DP','IGTM','PSPS') THEN 'IDO'
			WHEN WD.[Hybrid L3 Code] IN ('IHPS','LFPI','PWIP') THEN 'PWI'
			ELSE WD.[Hybrid L2 Code] 
		END AS [Hybrid L2],
		CASE
			WHEN 
				CASE 
					WHEN WD.[Hybrid L2 Code] = 'CS1' THEN 'HCCO'
					WHEN WD.[Hybrid L2 Code] = 'PRO' THEN 'GIP'
					WHEN WD.[Hybrid L2 Code] = 'GRE' THEN 'CREW'
					WHEN WD.[Hybrid L3 Code] IN ('3_DP', '3DCO', '3DMT', '3DSW','3DSY', '3DVT', 'G_SB', 'GSBS') THEN 'SNI'
					WHEN WD.[Hybrid L2 Code] IN ('SBQ','STC') THEN 'SNI'
					--WHEN WD.[Hybrid L1 Code]  = 'HPIB' THEN 'HPIP'
					ELSE WD.[Hybrid L1 Code] 
				END in ('HPIT', 'HTMO') then 'HPIT+HTMO'
			ELSE 'OTHER'
		END AS [Custom View 1],
		CASE
			WHEN 
				CASE 
					WHEN WD.[Hybrid L2 Code] = 'CS1' THEN 'HCCO'
					WHEN WD.[Hybrid L2 Code] = 'PRO' THEN 'GIP'
					WHEN WD.[Hybrid L2 Code] = 'GRE' THEN 'CREW'
					WHEN WD.[Hybrid L3 Code] IN ('3_DP', '3DCO', '3DMT', '3DSW','3DSY', '3DVT', 'G_SB', 'GSBS') THEN 'SNI'
					WHEN WD.[Hybrid L2 Code] IN ('SBQ','STC') THEN 'SNI'
					--WHEN WD.[Hybrid L1 Code]  = 'HPIB' THEN 'HPIP'
					ELSE WD.[Hybrid L1 Code] 
				END in ('FIN', 'GIP', 'CREW') then 'FIN+GIP+CREW'
			ELSE 'OTHER'
		END AS [Custom View 2],
		CASE
			WHEN WD.[Work Address - City] = 'Boise' THEN WD.[Work Address - City]
			WHEN WD.[Work Address - City] = 'Vancouver' THEN WD.[Work Address - City]
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
		CASE
            WHEN WD.[Management Level] IN ('EXE', 'DIR', 'SFL', 'FEL', 'STR', 'MG2', 'MG1', 'SU2', 'SU1') THEN 'Yes'
            ELSE 'No'
        END AS [Management],
		WD.[Management Level Category],
	
		CASE
			WHEN WD.[Worker Reg / Temp Code] = 'R' AND WD.[Worker Status Category Code] = 'A' THEN 1
			ELSE 0
		END [Headcount],
	
		CASE
			WHEN WD.[Worker Status Category Code] = 'T' AND WD.[Attrition Type] = 'Voluntary' THEN 1
			ELSE 0
		END AS [Voluntary Attrition],
		'Attrition' AS [Type]
	FROM hpw_data AS WD
	
		INNER JOIN hpw_attrition AS AD ON AD.[Report Date] = WD.[Report Date] AND AD.[Worker ID] = WD.[Worker ID]
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
-- WHERE
--     CASE 
--         WHEN (S.[Report Date] <=  @fy_start AND S.[Business Lvl 4 (MRU) Code] = 'G034') THEN 'E'
--         WHEN (S.[Report Date] <=  @fy_start AND S.[Hybrid L1] = 'OPER' AND S.[Work Address - City] = 'Pantnagar') THEN 'E'
--         ELSE 'I'
--     END LIKE 'I'
GROUP BY 
	S.[Report Date],	
	S.[Hybrid L1],
	S.[Hybrid L2],
	S.[Custom View 1],
	S.[Custom View 2],
	S.[Work Address - City],
	S.[Technical Job Family],
	S.[Veteran Status],
	S.[PWD Status],
	S.[Pay Group Country Desc],
	S.[Ethnicity Group],
	S.[Gender Code],
	S.[Is Professional],
	S.[Is New Hire],
	S.[Management Level Category],
	S.[Management]
ORDER BY 
	S.[Report Date],	
	S.[Hybrid L1],
	S.[Hybrid L2],
	S.[Custom View 1],
	S.[Custom View 2],
	S.[Work Address - City],
	S.[Technical Job Family],
	S.[Veteran Status],
	S.[PWD Status],
	S.[Pay Group Country Desc]