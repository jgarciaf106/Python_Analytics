Declare @fy_start As Date 
Declare @rolling_date_Start As Date
Declare @rolling_date_End Date
Set @fy_start = '2020-10-31'
Set @rolling_date_Start = '2020-10-31'
Set @rolling_date_End = '2020-10-31'

SELECT  
	S.[Report Date],
	S.[Hybrid L1],
	S.[Hybrid L2],
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
	S.[Management Level],
	S.[Management],
	SUM(S.[Headcount]) AS [HC],
	SUM(S.[Voluntary Attrition]) AS [Voluntary Attrits],
	SUM(S.[Compensation]) As [Compensation],
	SUM(S.[Attrition Hires]) AS [Attrition Hires]
FROM (
	-- HC SELECT
	SELECT 
		WD.[Report Date],
		CASE 
			WHEN COALESCE(F1.[Business Lvl 1 (Group) Code],WD.[Business Lvl 1 (Group) Code]) = 'HPCS' THEN 'HCCO'
			WHEN COALESCE(F2.[Business Lvl 2 (Unit) Code],WD.[Business Lvl 2 (Unit) Code]) = 'PRO' THEN 'GIP'
			WHEN COALESCE(F2.[Business Lvl 2 (Unit) Code],WD.[Business Lvl 2 (Unit) Code]) = 'GRE' THEN 'CREW'
			WHEN COALESCE(F3.[Business Lvl 3 (Org Chart) Code],WD.[Business Lvl 3 (Org Chart) Code]) IN ('3_DP','3DCO','3DMT','3DSW','3DSY','3DVT') THEN 'SNI'
			WHEN COALESCE(F1.[Business Lvl 1 (Group) Code],WD.[Business Lvl 1 (Group) Code]) = 'SBM' THEN 'SNI'
			WHEN COALESCE(F1.[Business Lvl 1 (Group) Code],WD.[Business Lvl 1 (Group) Code]) = 'HPIB' THEN 'HPIP'
			ELSE COALESCE(F1.[Business Lvl 1 (Group) Code],WD.[Business Lvl 1 (Group) Code])
		END AS [Hybrid L1],
		COALESCE(F2.[Business Lvl 2 (Unit) Code],WD.[Business Lvl 2 (Unit) Code]) AS [Hybrid L2],

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

		WD.[Work Address - Country Code] AS [Pay Group Country Desc],

		CASE
			WHEN WD.[Work Address - Country Code] = 'USA' THEN 
				CASE 
					WHEN WD.[Ethnicity Group] = 'WHITE_USA' THEN 'Caucasian'
					WHEN WD.[Ethnicity Group] = 'ASIAN_USA' THEN 'Asian'
					WHEN WD.[Ethnicity Group] = 'BLACK_USA' THEN 'African American'
					WHEN WD.[Ethnicity Group] = 'HISPA_USA' THEN 'Hispanic/Latino'
					WHEN WD.[Ethnicity Group] = 'AMIND_USA' THEN 'American Indian'
					WHEN WD.[Ethnicity Group] = 'PACIF_USA' THEN 'Hawaiian/Pacific Islander'
					WHEN WD.[Ethnicity Group] = '9_USA' THEN 'Two+ Races'
					WHEN WD.[Ethnicity Group] = 'NSPEC_USA' THEN 'Undisclosed'
					WHEN WD.[Ethnicity Group] = 'UNK' THEN 'Unknown'
				END
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
		WD.[Management Level],

		CASE
			WHEN WD.[Worker Reg / Temp Code] = 'R' AND WD.[Worker Status Category Code] = 'A' THEN 1
			ELSE 0
		END [Headcount],
		
		CASE
			WHEN WD.[Worker Status Category Code] = 'T' AND WD.[Attrition Type] = 'Voluntary' THEN 1
			ELSE 0
		END [Voluntary Attrition],
		[Primary Compensation Basis - Amount (USD)] As [Compensation],
		CASE
			WHEN (WD.[Worker Status Category Code] = 'T' AND WD.[Attrition Type] = 'Voluntary') AND (WD.[Original Hire Date] > @fy_start OR WD.[Hire Date] > @fy_start) THEN 1
			ELSE 0
		END [Attrition Hires],
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
		WD.[Report Date] >= @rolling_date_Start
        AND WD.[Report Date] <= @rolling_date_End
		AND WD.[Worker Reg / Temp Code] = 'R'
		AND WD.[Worker Status Category Code] In ('A','I')
        AND WD.[Business Lvl 4 (MRU) Code] <> 'G034'
		AND NOT (WD.[Business Lvl 1 (Group) Code] = 'OPER' AND WD.[Work Address - City] = 'Pantnagar')
	
	UNION ALL 
	
	-- Attrition Select
	SELECT 
		Eomonth(Dateadd(d, 1, wd.[Termination Date]), 0) AS [Report Date],
		CASE 
			WHEN COALESCE(F1.[Business Lvl 1 (Group) Code],WD.[Business Lvl 1 (Group) Code]) = 'HPCS' THEN 'HCCO'
			WHEN COALESCE(F2.[Business Lvl 2 (Unit) Code],WD.[Business Lvl 2 (Unit) Code]) = 'PRO' THEN 'GIP'
			WHEN COALESCE(F2.[Business Lvl 2 (Unit) Code],WD.[Business Lvl 2 (Unit) Code]) = 'GRE' THEN 'CREW'
			WHEN COALESCE(F3.[Business Lvl 3 (Org Chart) Code],WD.[Business Lvl 3 (Org Chart) Code]) IN ('3_DP','3DCO','3DMT','3DSW','3DSY','3DVT') THEN 'SNI'
			WHEN COALESCE(F1.[Business Lvl 1 (Group) Code],WD.[Business Lvl 1 (Group) Code]) = 'SBM' THEN 'SNI'
			WHEN COALESCE(F1.[Business Lvl 1 (Group) Code],WD.[Business Lvl 1 (Group) Code]) = 'HPIB' THEN 'HPIP'
			ELSE COALESCE(F1.[Business Lvl 1 (Group) Code],WD.[Business Lvl 1 (Group) Code])
		END AS [Hybrid L1],
		COALESCE(F2.[Business Lvl 2 (Unit) Code],WD.[Business Lvl 2 (Unit) Code]) AS [Hybrid L2],
	
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
	
		WD.[Work Address - Country] AS [Pay Group Country Desc],
	
		CASE
			WHEN WD.[Work Address - Country Code] = 'USA' THEN 
				CASE 
					WHEN WD.[Ethnicity Group] = 'WHITE_USA' THEN 'Caucasian'
					WHEN WD.[Ethnicity Group] = 'ASIAN_USA' THEN 'Asian'
					WHEN WD.[Ethnicity Group] = 'BLACK_USA' THEN 'African American'
					WHEN WD.[Ethnicity Group] = 'HISPA_USA' THEN 'Hispanic/Latino'
					WHEN WD.[Ethnicity Group] = 'AMIND_USA' THEN 'American Indian'
					WHEN WD.[Ethnicity Group] = 'PACIF_USA' THEN 'Hawaiian/Pacific Islander'
					WHEN WD.[Ethnicity Group] = '9_USA' THEN 'Two+ Races'
					WHEN WD.[Ethnicity Group] = 'NSPEC_USA' THEN 'Undisclosed'
					WHEN WD.[Ethnicity Group] = 'UNK' THEN 'Unknown'
					ELSE WD.[Ethnicity Group]
				END
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
		WD.[Management Level],
	
		CASE
			WHEN WD.[Worker Reg / Temp Code] = 'R' AND WD.[Worker Status Category Code] = 'A' THEN 1
			ELSE 0
		END [Headcount],
	
		CASE
			WHEN WD.[Worker Status Category Code] = 'T' AND WD.[Attrition Type] = 'Voluntary' THEN 1
			ELSE 0
		END AS [Voluntary Attrition],
		[Primary Compensation Basis - Amount (USD)] As [Compensation],
		CASE
			WHEN (WD.[Worker Status Category Code] = 'T' AND WD.[Attrition Type] = 'Voluntary') AND (WD.[Original Hire Date] > @fy_start OR WD.[Hire Date] > @fy_start) THEN 1
			ELSE 0
		END [Attrition Hires],
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
		Eomonth(Dateadd(d, 1, wd.[Termination Date]), 0) >= @rolling_date_Start
        AND Eomonth(Dateadd(d, 1, wd.[Termination Date]), 0) <= @rolling_date_End
        AND WD.[Business Lvl 4 (MRU) Code] <> 'G034'
		AND NOT (WD.[Business Lvl 1 (Group) Code] = 'OPER' AND WD.[Work Address - City] = 'Pantnagar')
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
	S.[Management Level],
	S.[Management]
ORDER BY 
	S.[Report Date],	
	S.[Hybrid L1],
	S.[Hybrid L2],
	S.[Work Address - City],
	S.[Technical Job Family],
	S.[Veteran Status],
	S.[PWD Status],
	S.[Pay Group Country Desc]