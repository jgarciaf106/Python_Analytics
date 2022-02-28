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
	S.[Management Level Category],
	S.[Management Level],
	S.[Leadership],  
    S.[Region],
    S.[Board Flag],
	S.[TCP Job],
	S.[Length of Service in Years],
	S.[Job Family],
	SUM(S.[Headcount]) AS [HC],
	SUM(S.[Voluntary Attrition]) AS [Voluntary Attrits]
FROM (
	-- HC SELECT
	SELECT 
		WD.[Report Date],
		COALESCE(F1.[Business Lvl 1 (Group) Code],WD.[Business Lvl 1 (Group) Code]) AS [Hybrid L1],
		COALESCE(F2.[Business Lvl 2 (Unit) Desc],WD.[Business Lvl 2 (Unit) Desc]) AS [Hybrid L2],

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
		WD.[Management Level Category],
		WD.[Management Level],
		CASE
            WHEN wd.[Management Level] In ('MAS','FEL') Then 'Yes'
            ELSE 'No'
        END AS [Leadership],
		CASE
			WHEN WD.[Worker Reg / Temp Code] = 'R' AND WD.[Worker Status Category Code] = 'A' THEN 1
			ELSE 0
		END [Headcount],
		CASE
			WHEN WD.[Worker Status Category Code] = 'T' AND WD.[Attrition Type] = 'Voluntary' THEN 1
			ELSE 0
		END [Voluntary Attrition],
        WD.[Job Family Code],
        WD.[Pay Group Theater Code] AS [Region],
        CASE 
            WHEN 
                WD.[Business Lvl 1 (Group) Code] = 'HPIP'  AND WD.[Job Family Code] IN (
                        'SVC56_020',
                        'ENG31_020',
                        'SVC48_021',
                        'ENG01_020',
                        'SVC31_020',
                        'ENG25_020',
                        'ENG33_020',
                        'ENG09_020',
                        'SVC37_025',
                        'SVC45_021',
                        'ENG32_020',
                        'INT04_020',
                        'SVC15_020',
                        'ENG07_020',
                        'ENG03_020',
                        'SAL09_022',
                        'ENG12_020',
                        'ENG08_020',
                        'ENG05_020',
                        'ENG36_020',
                        'QUA17_020',
                        'SVC46_021',
                        'ENG30_020',
                        'ENG02_020',
                        'ENG34_020',
                        'ENG35_020',
                        'SVC36_025',
                        'ENG04_020',
                        'SVC30_020',
                        'SVC53_020'
                ) THEN 'TCP_HPIP'
            WHEN 
                WD.[Business Lvl 1 (Group) Code] = 'PSYS' AND WD.[Job Family Code] IN (
                        'SVC56_020',
                        'ENG31_020',
                        'SVC48_021',
                        'ENG01_020',
                        'SVC31_020',
                        'ENG25_020',
                        'ENG33_020',
                        'ENG09_020',
                        'SVC37_025',
                        'SVC45_021',
                        'ENG32_020',
                        'INT04_020',
                        'SVC15_020',
                        'ENG07_020',
                        'ENG03_020',
                        'SAL09_022',
                        'ENG12_020',
                        'ENG08_020',
                        'ENG05_020',
                        'ENG36_020',
                        'QUA17_020',
                        'SVC46_021',
                        'ENG30_020',
                        'ENG02_020',
                        'ENG34_020',
                        'ENG35_020',
                        'SVC36_025',
                        'ENG04_020',
                        'SVC30_020',
                        'SVC53_020',
                        'ENG37_020'
                ) THEN 'TCP_PSYS'
            WHEN 
                WD.[Business Lvl 3 (Org Chart) Code] = 'LABS' AND WD.[Job Family Code] IN (
                        'SVC56_020',
                        'ENG31_020',
                        'SVC48_021',
                        'ENG01_020',
                        'SVC31_020',
                        'ENG25_020',
                        'ENG33_020',
                        'ENG09_020',
                        'SVC37_025',
                        'SVC45_021',
                        'ENG32_020',
                        'INT04_020',
                        'SVC15_020',
                        'ENG07_020',
                        'ENG03_020',
                        'SAL09_022',
                        'ENG12_020',
                        'ENG08_020',
                        'ENG05_020',
                        'ENG36_020',
                        'QUA17_020',
                        'SVC46_021',
                        'ENG30_020',
                        'ENG02_020',
                        'ENG34_020',
                        'ENG35_020',
                        'SVC36_025',
                        'ENG04_020',
                        'SVC30_020',
                        'SVC53_020'
                ) THEN 'TCP_LABS'
            WHEN 
                WD.[Job Family Code] = 'ENG20_020' THEN 'TCP_PM'
             WHEN 
                WD.[Business Lvl 1 (Group) Code] IN ('SBM',
                    'FIN',
                    'HFED',
                    'HPIT',
                    'HPEM',
                    'OPER',
                    'HPAM',
                    'HPAP',
                    'HPHR',
                    'HPTO',
                    'OTHS',
                    'HPGC',
                    'CMP',
                    'GCOM',
                    'HPHQ'
                ) 
            AND WD.[Job Family Code] IN (
                        'SVC56_020',
                        'ENG31_020',
                        'SVC48_021',
                        'ENG01_020',
                        'SVC31_020',
                        'ENG25_020',
                        'ENG33_020',
                        'ENG09_020',
                        'SVC37_025',
                        'SVC45_021',
                        'ENG32_020',
                        'INT04_020',
                        'SVC15_020',
                        'ENG07_020',
                        'ENG03_020',
                        'SAL09_022',
                        'ENG12_020',
                        'ENG08_020',
                        'ENG05_020',
                        'ENG36_020',
                        'QUA17_020',
                        'SVC46_021',
                        'ENG30_020',
                        'ENG02_020',
                        'ENG34_020',
                        'ENG35_020',
                        'SVC36_025',
                        'ENG04_020',
                        'SVC30_020',
                        'SVC53_020',
                        'ENG37_020'
                ) THEN 'TCP_REGIONS'
        END AS [Board Flag],
		WD.[TCP Job],
		WD.[Length of Service in Years],
		WD.[Job Family],
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
		COALESCE(F1.[Business Lvl 1 (Group) Code],WD.[Business Lvl 1 (Group) Code]) AS [Hybrid L1],
		COALESCE(F2.[Business Lvl 2 (Unit) Desc],WD.[Business Lvl 2 (Unit) Desc]) AS [Hybrid L2],
	
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
		WD.[Management Level Category],
		WD.[Management Level],		
		CASE
            WHEN wd.[Management Level] In ('MAS','FEL') Then 'Yes'
            ELSE 'No'
        END AS [Leadership],
		CASE
			WHEN WD.[Worker Reg / Temp Code] = 'R' AND WD.[Worker Status Category Code] = 'A' THEN 1
			ELSE 0
		END [Headcount],
	
		CASE
			WHEN WD.[Worker Status Category Code] = 'T' AND WD.[Attrition Type] = 'Voluntary' THEN 1
			ELSE 0
		END AS [Voluntary Attrition],
        WD.[Job Family Code],
        WD.[Pay Group Theater Code] AS [Region],
        CASE 
            WHEN 
                WD.[Business Lvl 1 (Group) Code] = 'HPIP'  AND WD.[Job Family Code] IN (
                        'SVC56_020',
                        'ENG31_020',
                        'SVC48_021',
                        'ENG01_020',
                        'SVC31_020',
                        'ENG25_020',
                        'ENG33_020',
                        'ENG09_020',
                        'SVC37_025',
                        'SVC45_021',
                        'ENG32_020',
                        'INT04_020',
                        'SVC15_020',
                        'ENG07_020',
                        'ENG03_020',
                        'SAL09_022',
                        'ENG12_020',
                        'ENG08_020',
                        'ENG05_020',
                        'ENG36_020',
                        'QUA17_020',
                        'SVC46_021',
                        'ENG30_020',
                        'ENG02_020',
                        'ENG34_020',
                        'ENG35_020',
                        'SVC36_025',
                        'ENG04_020',
                        'SVC30_020',
                        'SVC53_020'
                ) THEN 'TCP_HPIP'
            WHEN 
                WD.[Business Lvl 1 (Group) Code] = 'PSYS' AND WD.[Job Family Code] IN (
                        'SVC56_020',
                        'ENG31_020',
                        'SVC48_021',
                        'ENG01_020',
                        'SVC31_020',
                        'ENG25_020',
                        'ENG33_020',
                        'ENG09_020',
                        'SVC37_025',
                        'SVC45_021',
                        'ENG32_020',
                        'INT04_020',
                        'SVC15_020',
                        'ENG07_020',
                        'ENG03_020',
                        'SAL09_022',
                        'ENG12_020',
                        'ENG08_020',
                        'ENG05_020',
                        'ENG36_020',
                        'QUA17_020',
                        'SVC46_021',
                        'ENG30_020',
                        'ENG02_020',
                        'ENG34_020',
                        'ENG35_020',
                        'SVC36_025',
                        'ENG04_020',
                        'SVC30_020',
                        'SVC53_020',
                        'ENG37_020'
                ) THEN 'TCP_PSYS'
            WHEN 
                WD.[Business Lvl 3 (Org Chart) Code] = 'LABS' AND WD.[Job Family Code] IN (
                        'SVC56_020',
                        'ENG31_020',
                        'SVC48_021',
                        'ENG01_020',
                        'SVC31_020',
                        'ENG25_020',
                        'ENG33_020',
                        'ENG09_020',
                        'SVC37_025',
                        'SVC45_021',
                        'ENG32_020',
                        'INT04_020',
                        'SVC15_020',
                        'ENG07_020',
                        'ENG03_020',
                        'SAL09_022',
                        'ENG12_020',
                        'ENG08_020',
                        'ENG05_020',
                        'ENG36_020',
                        'QUA17_020',
                        'SVC46_021',
                        'ENG30_020',
                        'ENG02_020',
                        'ENG34_020',
                        'ENG35_020',
                        'SVC36_025',
                        'ENG04_020',
                        'SVC30_020',
                        'SVC53_020'
                ) THEN 'TCP_LABS'
            WHEN 
                WD.[Job Family Code] = 'ENG20_020' THEN 'TCP_PM'
             WHEN 
                WD.[Business Lvl 1 (Group) Code] IN ('SBM',
                    'FIN',
                    'HFED',
                    'HPIT',
                    'HPEM',
                    'OPER',
                    'HPAM',
                    'HPAP',
                    'HPHR',
                    'HPTO',
                    'OTHS',
                    'HPGC',
                    'CMP',
                    'GCOM',
                    'HPHQ'
                ) 
            AND WD.[Job Family Code] IN (
                        'SVC56_020',
                        'ENG31_020',
                        'SVC48_021',
                        'ENG01_020',
                        'SVC31_020',
                        'ENG25_020',
                        'ENG33_020',
                        'ENG09_020',
                        'SVC37_025',
                        'SVC45_021',
                        'ENG32_020',
                        'INT04_020',
                        'SVC15_020',
                        'ENG07_020',
                        'ENG03_020',
                        'SAL09_022',
                        'ENG12_020',
                        'ENG08_020',
                        'ENG05_020',
                        'ENG36_020',
                        'QUA17_020',
                        'SVC46_021',
                        'ENG30_020',
                        'ENG02_020',
                        'ENG34_020',
                        'ENG35_020',
                        'SVC36_025',
                        'ENG04_020',
                        'SVC30_020',
                        'SVC53_020',
                        'ENG37_020'
                ) THEN 'TCP_REGIONS'
        END AS [Board Flag],
		WD.[TCP Job],
		WD.[Length of Service in Years],
		WD.[Job Family],
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
WHERE
    S.[Board Flag]  IS NOT NULL
GROUP BY 
	S.[Report Date],	
	S.[Hybrid L1],
	S.[Hybrid L2],
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
	S.[Management Level Category],
	S.[Management Level],
	S.[Leadership],
    S.[Region],
    S.[Board Flag],
	S.[TCP Job],
	S.[Length of Service in Years],
	S.[Job Family]
ORDER BY 
	S.[Report Date],	
	S.[Hybrid L1],
	S.[Hybrid L2],
	S.[Work Address - City],
	S.[Technical Job Family],
	S.[Business Lvl 4 (MRU) Code],
	S.[Veteran Status],
	S.[PWD Status],
	S.[Pay Group Country Desc]