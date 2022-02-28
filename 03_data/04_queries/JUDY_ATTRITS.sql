SELECT 
		Date(date_trunc('month', WD."Termination Date") + interval '1 month' - interval '1 day') AS "Report Date",
        get_f_year_quarter('Y',Date(date_trunc('month', WD."Termination Date") + interval '1 month' - interval '1 day') ) As "Fiscal Year",
        get_f_year_quarter('Q',Date(date_trunc('month', WD."Termination Date") + interval '1 month' - interval '1 day') ) As "Quarter",
        CASE
			WHEN WD."Worker Status Category Code" = 'T' THEN 1
			ELSE 0
		END AS "Worker Counter",
        WD."Ethnicity Group",
        CASE
			WHEN TT."Job Family Code" IS NULL THEN 'No'
			ELSE 'Yes'
		END AS "Technical Job Family",
        WD."Pay Group Country Desc",
        CASE
            WHEN WD."Length of Service in Years" < 2 Then 'Less than 2 Years'
            WHEN WD."Length of Service in Years" < 6 Then '2 to 5 Years'
            WHEN WD."Length of Service in Years" < 11 Then '6 to 10 Years'
            WHEN WD."Length of Service in Years" < 16 Then '11 to 15 Years'
            WHEN WD."Length of Service in Years" < 21 Then '16 to 20 Years'
            WHEN WD."Length of Service in Years" > 20 Then 'More than 20 Years'
        END AS "Length of Service in Years",
        CASE
			WHEN WD."Management Level Category" <> 'NONE' THEN 'Yes'
			ELSE 'No'
		END AS "Is Professional",
        WD."Attrition Type"
	FROM "HPW_DATA" AS WD
	
		INNER JOIN "HPW_ATTRITION" AS AD ON AD."Report Date" = WD."Report Date" AND AD."Worker ID" = WD."Worker ID"
		INNER JOIN "HPI_ORGS" AS HP ON HP."Business Lvl 1 (Group) Code" = WD."Business Lvl 1 (Group) Code"
		LEFT JOIN "JOB_FUNCTION" AS JF ON JF."Job Family Group" = WD."Job Family Group"
		LEFT JOIN "LABOR_PYRAMID" AS LP ON LP."Management Level" = WD."Management Level"
		LEFT JOIN "FEDL1" AS F1 ON F1."Business Lvl 4 (MRU) Code" = WD."Business Lvl 4 (MRU) Code"
		LEFT JOIN "FEDL2" AS F2 ON F2."Business Lvl 4 (MRU) Code" = WD."Business Lvl 4 (MRU) Code"
		LEFT JOIN "FEDL3" AS F3 ON F3."Business Lvl 4 (MRU) Code" = WD."Business Lvl 4 (MRU) Code"
		LEFT JOIN "TECHNICAL_JOBS" AS TT ON TT."Job Family Code" = WD."Job Family Code"
	WHERE 
		date_trunc('month', WD."Termination Date") + interval '1 month' - interval '1 day' > '2015-11-30'
		AND WD."Business Lvl 4 (MRU) Code" <> 'G034'
		AND NOT (WD."Business Lvl 1 (Group) Code" = 'OPER'AND WD."Work Address - City" = 'Pantnagar')
        AND CASE
			WHEN WD."Worker Status Category Code" = 'T' THEN 1
			ELSE 0
		END = 1