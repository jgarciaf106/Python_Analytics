SELECT 
	S."Report Date",
	S."Hybrid L1",
	S."Hybrid L2",
	S."Work Address - City",
	S."Technical Job Family",
	S."Business Lvl 4 (MRU) Code",
	S."Veteran Status",
	S."PWD Status",
	S."Pay Group Country Desc",
	S."Ethnicity Group",
	S."Gender Code",
	S."Is Professional",
	S."Is New Hire",
	S."Management Level Category",
	S."Management Level",
	SUM(S."Headcount") AS "HC",
	SUM(S."Voluntary Attrition") AS "Voluntary Attrits"
FROM (
	-- HC SELECT
	SELECT 
		Date(WD."Report Date") As "Report Date",
		COALESCE(F1."Business Lvl 1 (Group) Code",WD."Business Lvl 1 (Group) Code") AS "Hybrid L1",
		COALESCE(F2."Business Lvl 2 (Unit) Code",WD."Business Lvl 2 (Unit) Code") AS "Hybrid L2",

		CASE
			WHEN WD."Work Address - City" = 'Pantnagar' THEN WD."Work Address - City"
			WHEN WD."Work Address - City" = 'Boise' THEN WD."Work Address - City"
			WHEN WD."Work Address - City" = 'Vancouver' THEN WD."Work Address - City"
			ELSE 'Other'
		END AS "Work Address - City",

		CASE
			WHEN TT."Job Family Code" IS NULL THEN 'No'
			ELSE 'Yes'
		END AS "Technical Job Family",

		CASE
			WHEN WD."Business Lvl 4 (MRU) Code" = 'G034' THEN WD."Business Lvl 4 (MRU) Code"
			ELSE 'Other'
		END AS "Business Lvl 4 (MRU) Code",
		CASE
			WHEN VET."Employee ID" IS NULL THEN 'U'
			ELSE VET."Veteran Status"
		END AS "Veteran Status",
		CASE
			WHEN WD."Pay Group Country Desc" IN (
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
			WHEN PWD."Employee ID" IS NULL THEN 'N'
			ELSE PWD."Is PWD?"
		END AS "PWD Status",

		CASE
			WHEN WD."Pay Group Country Code" = 'USA' THEN WD."Pay Group Country Desc"
			ELSE 'Other'
		END AS "Pay Group Country Desc",

		CASE
			WHEN WD."Pay Group Country Code" = 'USA' THEN WD."Ethnicity Group"
			ELSE 'Other'
		END AS "Ethnicity Group",
		COALESCE(WD."Gender Code",'U') AS "Gender Code",

		CASE
			WHEN WD."Management Level Category" <> 'NONE' THEN 'Yes'
			ELSE 'No'
		END AS "Is Professional",

		CASE
			WHEN WD."Original Hire Date" > '2020-10-31' OR WD."Hire Date" > '2020-10-31' THEN 'Yes'
			ELSE 'No'
		END AS "Is New Hire",
		WD."Management Level Category",		
		WD."Management Level",
		CASE
			WHEN WD."Worker Reg / Temp Code" = 'R' AND WD."Worker Status Category Code" = 'A' THEN 1
			ELSE 0
		END "Headcount",
		CASE
			WHEN WD."Worker Status Category Code" = 'T' AND WD."Attrition Type" = 'Voluntary' THEN 1
			ELSE 0
		END "Voluntary Attrition",
		'HC' AS "Type"
	
	FROM "HPW_DAILY" AS WD

	LEFT JOIN "JOB_FUNCTION" AS JF ON JF."Job Family Group" = WD."Job Family Group"
	LEFT JOIN "LABOR_PYRAMID" AS LP ON LP."Management Level" = WD."Management Level"
	LEFT JOIN "FEDL1" AS F1 ON F1."Business Lvl 4 (MRU) Code" = WD."Business Lvl 4 (MRU) Code"
	LEFT JOIN "FEDL2" AS F2 ON F2."Business Lvl 4 (MRU) Code" = WD."Business Lvl 4 (MRU) Code"
	LEFT JOIN "FEDL3" AS F3 ON F3."Business Lvl 4 (MRU) Code" = WD."Business Lvl 4 (MRU) Code"
	LEFT JOIN "TECHNICAL_JOBS" AS TT ON TT."Job Family Code" = WD."Job Family Code"
	LEFT JOIN "HPW_VETERANS_STG" AS VET ON VET."Report Date" = WD."Report Date" AND VET."Employee ID" = WD."Worker ID" AND VET."Veteran Status" = 'Y'
	LEFT JOIN "HPW_W_DISABILITIES" AS PWD ON PWD."Employee ID" = WD."Worker ID" AND PWD."Report Date" = (Select Max("Report Date") From "HPW_W_DISABILITIES")

	WHERE 
		WD."Worker Reg / Temp Code" = 'R'
		AND WD."Worker Status Category Code" = 'A'
	
	UNION ALL 
	
	-- Attrition Select
	SELECT 
		Case 
			When Date(date_trunc('month', WD."Termination Date") + interval '1 month' - interval '1 day') >= '2021-10-01' Then Date(WD."Report Date")
			Else Date(date_trunc('month', WD."Termination Date") + interval '1 month' - interval '1 day')
		End AS "Report Date",
		COALESCE(F1."Business Lvl 1 (Group) Code",WD."Business Lvl 1 (Group) Code") AS "Hybrid L1",
		COALESCE(F2."Business Lvl 2 (Unit) Code",WD."Business Lvl 2 (Unit) Code") AS "Hybrid L2",
	
		CASE
			WHEN WD."Work Address - City" = 'Pantnagar' THEN WD."Work Address - City"
			ELSE 'Other'
		END AS "Work Address - City",
	
		CASE
			WHEN TT."Job Family Code" IS NULL THEN 'No'
			ELSE 'Yes'
		END AS "Technical Job Family",
	
		CASE
			WHEN WD."Business Lvl 4 (MRU) Code" = 'G034'THEN WD."Business Lvl 4 (MRU) Code"
			ELSE 'Other'
		END AS "Business Lvl 4 (MRU) Code",
	
		CASE
			WHEN VET."Employee ID" IS NULL THEN 'U'
			ELSE VET."Veteran Status"
		END AS "Veteran Status",
	
		CASE
			WHEN WD."Pay Group Country Desc" IN (
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
			WHEN PWD."Employee ID" IS NULL THEN 'N'
			ELSE PWD."Is PWD?"
		END AS "PWD Status",
	
		CASE
			WHEN WD."Pay Group Country Code" = 'USA' THEN WD."Pay Group Country Desc"
			ELSE 'Other'
		END AS "Pay Group Country Desc",
	
		CASE
			WHEN WD."Pay Group Country Code" = 'USA' THEN WD."Ethnicity Group"
			ELSE 'Other'
		END AS "Ethnicity Group",
		COALESCE(WD."Gender Code",'U') AS "Gender Code",
	
		CASE
			WHEN WD."Management Level Category" <> 'NONE' THEN 'Yes'
			ELSE 'No'
		END AS "Is Professional",
	
		CASE
			WHEN WD."Original Hire Date" > '2020-10-31' OR WD."Hire Date" > '2020-10-31' THEN 'Yes'
			ELSE 'No'
		END AS "Is New Hire",
		WD."Management Level Category",
		WD."Management Level",
		CASE
			WHEN WD."Worker Reg / Temp Code" = 'R' AND WD."Worker Status Category Code" = 'A' THEN 1
			ELSE 0
		END "Headcount",
	
		CASE
			WHEN WD."Worker Status Category Code" = 'T' AND WD."Attrition Type" = 'Voluntary' THEN 1
			ELSE 0
		END AS "Voluntary Attrition",
		'Attrition' AS "Type"
	FROM "HPW_DAILY" AS WD
	
		INNER JOIN "HPW_ATTRITION_STG" AS AD ON AD."Report Date" = WD."Report Date" AND AD."Worker ID" = WD."Worker ID"
		INNER JOIN "HPI_ORGS" AS HP ON HP."Business Lvl 1 (Group) Code" = WD."Business Lvl 1 (Group) Code"
		LEFT JOIN "JOB_FUNCTION" AS JF ON JF."Job Family Group" = WD."Job Family Group"
		LEFT JOIN "LABOR_PYRAMID" AS LP ON LP."Management Level" = WD."Management Level"
		LEFT JOIN "FEDL1" AS F1 ON F1."Business Lvl 4 (MRU) Code" = WD."Business Lvl 4 (MRU) Code"
		LEFT JOIN "FEDL2" AS F2 ON F2."Business Lvl 4 (MRU) Code" = WD."Business Lvl 4 (MRU) Code"
		LEFT JOIN "FEDL3" AS F3 ON F3."Business Lvl 4 (MRU) Code" = WD."Business Lvl 4 (MRU) Code"
		LEFT JOIN "TECHNICAL_JOBS" AS TT ON TT."Job Family Code" = WD."Job Family Code"
		LEFT JOIN "HPW_VETERANS_STG" AS VET ON VET."Report Date" = date_trunc('month', WD."Termination Date") + interval '1 month' - interval '1 day'	AND VET."Employee ID" = WD."Worker ID"	AND VET."Veteran Status" = 'Y'
		LEFT JOIN "HPW_W_DISABILITIES" AS PWD ON PWD."Employee ID" = WD."Worker ID" AND PWD."Report Date" = (Select Max("Report Date") From "HPW_W_DISABILITIES")
	WHERE
		date_trunc('month', WD."Termination Date") + interval '1 month' - interval '1 day' > (Select Max(Date(date_trunc('month', "Report Date") + interval '1 month' - interval '1 day' - interval '1 year')) From "HPW_DAILY") 
	AND 
		WD."Worker Reg / Temp Code" = 'R'

) AS S
GROUP BY 
	S."Report Date",	
	S."Hybrid L1",
	S."Hybrid L2",
	S."Work Address - City",
	S."Technical Job Family",
	S."Business Lvl 4 (MRU) Code",
	S."Veteran Status",
	S."PWD Status",
	S."Pay Group Country Desc",
	S."Ethnicity Group",
	S."Gender Code",
	S."Is Professional",
	S."Is New Hire",
	S."Management Level Category",
	S."Management Level"
ORDER BY 
	S."Report Date",	
	S."Hybrid L1",
	S."Hybrid L2",
	S."Work Address - City",
	S."Technical Job Family",
	S."Business Lvl 4 (MRU) Code",
	S."Veteran Status",
	S."PWD Status",
	S."Pay Group Country Desc"