Declare @fy_start As Date
-- Uncomment if fiscal year input should be manual
Set @fy_start = '2020-10-31'

-- Comment if fiscal year input should be manual
-- Set @fy_start = (
--     Select 
-- 		Case
-- 			When 
-- 				Month(GetDate()) > 11 Then DateFromParts(Year(GetDate()),10,31)
-- 			Else
-- 				DateFromParts(Year(GetDate()) - 1,10,31)
-- 			End
-- )

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
    S.[Hybrid L3],
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
            WD.[Hybrid L1 Code] AS [Hybrid L1],
            WD.[Hybrid L2 Code] AS [Hybrid L2],
            WD.[Hybrid L3 Code] AS [Hybrid L3],

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
			WHEN (WD.[Original Hire Date] > eomonth(WD.[Report Date], -12) ) or ( WD.[Hire Date] > eomonth(WD.[Report Date], -12) ) THEN 'Yes'
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
            
            'HC' AS [Type]

        FROM hpw_data AS WD

            LEFT JOIN job_function AS JF ON JF.[Job Family Group] = WD.[Job Family Group]
            LEFT JOIN labor_pyramid AS LP ON LP.[Management Level] = WD.[Management Level]
            LEFT JOIN fedl1 AS F1 ON F1.[Business Lvl 4 (MRU) Code] = WD.[Business Lvl 4 (MRU) Code]
            LEFT JOIN fedl2 AS F2 ON F2.[Business Lvl 4 (MRU) Code] = WD.[Business Lvl 4 (MRU) Code]
            LEFT JOIN fedl3 AS F3 ON F3.[Business Lvl 4 (MRU) Code] = WD.[Business Lvl 4 (MRU) Code]
            LEFT JOIN technical_job AS TT ON TT.[Job Family Code] = WD.[Job Family Code]
            LEFT JOIN hpw_veteran AS VET ON VET.[Report Date] = WD.[Report Date] AND VET.[Employee ID] = WD.[Worker ID] AND VET.[Veteran Status] = 'Y'
            LEFT JOIN hpw_w_disability AS PWD ON PWD.[Employee ID] = WD.[Worker ID] AND PWD.[Report Date] = (Select Max([Report Date])
                From hpw_w_disability)

        WHERE 
		WD.[Report Date] >= @rolling_date
            AND WD.[Worker Reg / Temp Code] = 'R'
            AND WD.[Worker Status Category Code] = 'A'

    UNION ALL

        -- Attrition Select
        SELECT
            Eomonth(Dateadd(d, 1, wd.[Termination Date]), 0) AS [Report Date],
            WD.[Hybrid L1 Code] AS [Hybrid L1],
            WD.[Hybrid L2 Code] AS [Hybrid L2],
            WD.[Hybrid L3 Code] AS [Hybrid L3],

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
			WHEN (WD.[Original Hire Date] > eomonth(Eomonth(Dateadd(d, 1, wd.[Termination Date]), 0), -12) ) or ( WD.[Hire Date] > eomonth(Eomonth(Dateadd(d, 1, wd.[Termination Date]), 0), -12) ) THEN 'Yes'
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
            LEFT JOIN hpw_veteran AS VET ON VET.[Report Date] = WD.[Report Date] AND VET.[Employee ID] = WD.[Worker ID] AND VET.[Veteran Status] = 'Y'
            LEFT JOIN hpw_w_disability AS PWD ON PWD.[Employee ID] = WD.[Worker ID] AND PWD.[Report Date] = (Select Max([Report Date])
                From hpw_w_disability)
        WHERE 
		Eomonth(Dateadd(d, 1, wd.[Termination Date]), 0) >= @rolling_date
) AS S
GROUP BY 
	S.[Report Date],	
	S.[Hybrid L1],
	S.[Hybrid L2],
	S.[Hybrid L3],
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
	S.[Hybrid L3],
	S.[Work Address - City],
	S.[Technical Job Family],
	S.[Business Lvl 4 (MRU) Code],
	S.[Veteran Status],
	S.[PWD Status],
	S.[Pay Group Country Desc]