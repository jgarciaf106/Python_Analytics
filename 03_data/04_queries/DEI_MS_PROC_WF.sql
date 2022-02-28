SELECT 
	WD."Report Date",
	CASE
		WHEN TT."Job Family Code" IS NULL THEN 'No'
		ELSE 'Yes'
	END AS "Technical Job Family",
	CASE
		WHEN VET."Employee ID" IS NULL THEN 'U'
		ELSE VET."Veteran Status"
	END AS "Veteran Status",
	CASE
		WHEN WD."Pay Group Country Code" = N'USA' THEN WD."Ethnicity Group"
		ELSE 'Other'
	END AS "Ethnicity Group",
	COALESCE(WD."Gender Code",'U') AS "Gender Code",

	CASE
		WHEN WD."Management Level Category" <> 'NONE' THEN 'Yes'
		ELSE 'No'
	END AS "Is Professional",
	WD."Management Level Category",

	CASE
		WHEN WD."Worker Reg / Temp Code" = 'R' AND WD."Worker Status Category Code" = 'A' THEN 1
		ELSE 0
	END "Headcount"

FROM "HPW_DATA" AS WD

LEFT JOIN "JOB_FUNCTION" AS JF ON JF."Job Family Group" = WD."Job Family Group"
LEFT JOIN "LABOR_PYRAMID" AS LP ON LP."Management Level" = WD."Management Level"
LEFT JOIN "FEDL1" AS F1 ON F1."Business Lvl 4 (MRU) Code" = WD."Business Lvl 4 (MRU) Code"
LEFT JOIN "FEDL2" AS F2 ON F2."Business Lvl 4 (MRU) Code" = WD."Business Lvl 4 (MRU) Code"
LEFT JOIN "FEDL3" AS F3 ON F3."Business Lvl 4 (MRU) Code" = WD."Business Lvl 4 (MRU) Code"
LEFT JOIN "TECHNICAL_JOBS" AS TT ON TT."Job Family Code" = WD."Job Family Code"
LEFT JOIN "HPW_VETERANS" AS VET ON VET."Report Date" = WD."Report Date" AND VET."Employee ID" = WD."Worker ID" AND VET."Veteran Status" = 'Y'
LEFT JOIN "HPW_W_DISABILITIES" AS PWD ON PWD."Employee ID" = WD."Worker ID" AND PWD."Report Date" = (Select Max("Report Date") From "HPW_W_DISABILITIES")

WHERE 
	WD."Report Date" = '2020-10-31'
	AND WD."Worker Reg / Temp Code" = 'R'
	AND WD."Worker Status Category Code" = 'A'
	AND WD."Pay Group Country Code" = 'USA'