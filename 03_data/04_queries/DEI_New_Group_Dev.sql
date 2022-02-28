SELECT 
    S."Report Date",
    S."Hybrid L1",
    S."Hybrid L2",
    S."Hybrid L3",    
    S."Is Extended IT",
    S."Work Address - City",
    S."Technical Job Family",
    S."Business Lvl 4 (MRU) Code",		
    S."Pay Group Country Desc",		
    S."Ethnicity Group",		
    S."Gender Code",
    S."Veteran Status",
    S."Is Professional",
    S."Is New Hire",
    S."Management Level Category",
    SUM(S."Headcount") AS "HC",
    SUM(S."Voluntary Attrition") AS "Voluntary Attrits"
FROM (
    -- HC SELECT
    SELECT 
        Date(WD."Report Date") AS "Report Date",
        CASE
            WHEN WD."Business Lvl 2 (Unit) Code" = 'PIN' THEN 'HPIB'
			WHEN WD."Business Lvl 2 (Unit) Code" = 'GRE' THEN 'HPPC'
			WHEN WD."Business Lvl 2 (Unit) Code" = 'PRO' THEN 'HPPC'
            ELSE COALESCE(F1."Business Lvl 1 (Group) Code",WD."Business Lvl 1 (Group) Code")
        END "Hybrid L1",
        COALESCE(F2."Business Lvl 2 (Unit) Code",WD."Business Lvl 2 (Unit) Code") AS "Hybrid L2",
        COALESCE(F3."Business Lvl 3 (Org Chart) Code",WD."Business Lvl 3 (Org Chart) Code") AS "Hybrid L3",

        CASE

            WHEN
                CASE
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'PIN' THEN 'HPIB'
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'GRE' THEN 'HPPC'
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'PRO' THEN 'HPPC'
                    ELSE COALESCE(F1."Business Lvl 1 (Group) Code",WD."Business Lvl 1 (Group) Code")
                END IN ('HPIT', 'HTMO') AND COALESCE(F2."Business Lvl 2 (Unit) Code",WD."Business Lvl 2 (Unit) Code") IN ('TM1','BPX','DIS') THEN 'BORDONI ORG'

            WHEN
                CASE
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'PIN' THEN 'HPIB'
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'GRE' THEN 'HPPC'
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'PRO' THEN 'HPPC'
                    ELSE COALESCE(F1."Business Lvl 1 (Group) Code",WD."Business Lvl 1 (Group) Code")
                END IN ('HPIT', 'HTMO') AND COALESCE(F2."Business Lvl 2 (Unit) Code",WD."Business Lvl 2 (Unit) Code") = 'DSA' THEN 'ELLIS ORG'

            WHEN
                CASE
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'PIN' THEN 'HPIB'
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'GRE' THEN 'HPPC'
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'PRO' THEN 'HPPC'
                    ELSE COALESCE(F1."Business Lvl 1 (Group) Code",WD."Business Lvl 1 (Group) Code")
                END IN ('HPIT', 'HTMO') AND COALESCE(F2."Business Lvl 2 (Unit) Code",WD."Business Lvl 2 (Unit) Code") = 'TOH' THEN 'Transformation HQ'
            
            WHEN
                CASE
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'PIN' THEN 'HPIB'
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'GRE' THEN 'HPPC'
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'PRO' THEN 'HPPC'
                    ELSE COALESCE(F1."Business Lvl 1 (Group) Code",WD."Business Lvl 1 (Group) Code")
                END IN ('HPIT', 'HTMO') THEN 
                    CASE
                        WHEN WD."Business Lvl 2 (Unit) Code" = 'PIN' THEN 'HPIB'
                        WHEN WD."Business Lvl 2 (Unit) Code" = 'GRE' THEN 'HPPC'
                        WHEN WD."Business Lvl 2 (Unit) Code" = 'PRO' THEN 'HPPC'
                        ELSE COALESCE(F1."Business Lvl 1 (Group) Code",WD."Business Lvl 1 (Group) Code")
                    END
        
            ELSE
                'No'
        END AS "Is Extended IT",

        CASE
            WHEN WD."Work Address - City" = N'Pantnagar' THEN WD."Work Address - City"
            WHEN WD."Work Address - City" = N'Boise' THEN WD."Work Address - City"
            WHEN WD."Work Address - City" = N'Vancouver' THEN WD."Work Address - City"
            ELSE 'Other'
        END AS "Work Address - City",

        CASE
            WHEN TT."Job Family Code" IS NULL THEN 'No'
            ELSE 'Yes'
        END AS "Technical Job Family",

        CASE
            WHEN WD."Business Lvl 4 (MRU) Code" = N'G034' THEN WD."Business Lvl 4 (MRU) Code"
            ELSE 'Other'
        END AS "Business Lvl 4 (MRU) Code",
        CASE
            WHEN VET."Employee ID" IS NULL THEN 'U'
            ELSE VET."Veteran Status"
        END AS "Veteran Status",

        CASE
            WHEN WD."Pay Group Country Code" = N'USA' THEN WD."Pay Group Country Desc"
            ELSE 'Other'
        END AS "Pay Group Country Desc",

        CASE
            WHEN WD."Pay Group Country Code" = N'USA' THEN WD."Ethnicity Group"
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

        CASE
            WHEN WD."Worker Reg / Temp Code" = 'R' AND WD."Worker Status Category Code" = 'A' THEN 1
            ELSE 0
        END "Headcount",
        CASE
            WHEN WD."Worker Status Category Code" = 'T' AND WD."Attrition Type" = 'Voluntary' THEN 1
            ELSE 0
        END "Voluntary Attrition",
        'HC' AS "Type"

    FROM "HPW_DATA" AS WD

    LEFT JOIN "JOB_FUNCTION" AS JF ON JF."Job Family Group" = WD."Job Family Group"
    LEFT JOIN "LABOR_PYRAMID" AS LP ON LP."Management Level" = WD."Management Level"
    LEFT JOIN "FEDL1" AS F1 ON F1."Business Lvl 4 (MRU) Code" = WD."Business Lvl 4 (MRU) Code"
    LEFT JOIN "FEDL2" AS F2 ON F2."Business Lvl 4 (MRU) Code" = WD."Business Lvl 4 (MRU) Code"
    LEFT JOIN "FEDL3" AS F3 ON F3."Business Lvl 4 (MRU) Code" = WD."Business Lvl 4 (MRU) Code"
    LEFT JOIN "TECHNICAL_JOBS" AS TT ON TT."Job Family Code" = WD."Job Family Code"
    LEFT JOIN "HPW_VETERANS" AS VET ON VET."Report Date" = WD."Report Date" AND VET."Employee ID" = WD."Worker ID" AND VET."Veteran Status" = 'Y'

    WHERE 
        WD."Report Date" > (Select Max("Report Date") - interval '1 year' From "HPW_DATA")
        AND WD."Worker Reg / Temp Code" = 'R'
        AND WD."Worker Status Category Code" = 'A'
        AND WD."Business Lvl 4 (MRU) Code" <> 'G034'
        AND NOT (WD."Business Lvl 1 (Group) Code" = 'OPER' AND WD."Work Address - City" = 'Pantnagar')

    UNION ALL 

    -- Attrition Select
    SELECT 
        Date(date_trunc('month', WD."Termination Date") + interval '1 month' - interval '1 day') AS "Report Date",
        CASE
            WHEN WD."Business Lvl 2 (Unit) Code" = 'PIN' THEN 'HPIB'
			WHEN WD."Business Lvl 2 (Unit) Code" = 'GRE' THEN 'HPPC'
			WHEN WD."Business Lvl 2 (Unit) Code" = 'PRO' THEN 'HPPC'
            ELSE COALESCE(F1."Business Lvl 1 (Group) Code",WD."Business Lvl 1 (Group) Code")
        END "Hybrid L1",
        COALESCE(F2."Business Lvl 2 (Unit) Code",WD."Business Lvl 2 (Unit) Code") AS "Hybrid L2",
        COALESCE(F3."Business Lvl 3 (Org Chart) Code",WD."Business Lvl 3 (Org Chart) Code") AS "Hybrid L3",

        CASE

            WHEN
                CASE
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'PIN' THEN 'HPIB'
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'GRE' THEN 'HPPC'
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'PRO' THEN 'HPPC'
                    ELSE COALESCE(F1."Business Lvl 1 (Group) Code",WD."Business Lvl 1 (Group) Code")
                END IN ('HPIT', 'HTMO') AND COALESCE(F2."Business Lvl 2 (Unit) Code",WD."Business Lvl 2 (Unit) Code") IN ('TM1','BPX','DIS') THEN 'BORDONI ORG'

            WHEN
                CASE
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'PIN' THEN 'HPIB'
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'GRE' THEN 'HPPC'
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'PRO' THEN 'HPPC'
                    ELSE COALESCE(F1."Business Lvl 1 (Group) Code",WD."Business Lvl 1 (Group) Code")
                END IN ('HPIT', 'HTMO') AND COALESCE(F2."Business Lvl 2 (Unit) Code",WD."Business Lvl 2 (Unit) Code") = 'DSA' THEN 'ELLIS ORG'

            WHEN
                CASE
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'PIN' THEN 'HPIB'
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'GRE' THEN 'HPPC'
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'PRO' THEN 'HPPC'
                    ELSE COALESCE(F1."Business Lvl 1 (Group) Code",WD."Business Lvl 1 (Group) Code")
                END IN ('HPIT', 'HTMO') AND COALESCE(F2."Business Lvl 2 (Unit) Code",WD."Business Lvl 2 (Unit) Code") = 'TOH' THEN 'Transformation HQ'
            
            WHEN
                CASE
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'PIN' THEN 'HPIB'
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'GRE' THEN 'HPPC'
                    WHEN WD."Business Lvl 2 (Unit) Code" = 'PRO' THEN 'HPPC'
                    ELSE COALESCE(F1."Business Lvl 1 (Group) Code",WD."Business Lvl 1 (Group) Code")
                END IN ('HPIT', 'HTMO') THEN 
                    CASE
                        WHEN WD."Business Lvl 2 (Unit) Code" = 'PIN' THEN 'HPIB'
                        WHEN WD."Business Lvl 2 (Unit) Code" = 'GRE' THEN 'HPPC'
                        WHEN WD."Business Lvl 2 (Unit) Code" = 'PRO' THEN 'HPPC'
                        ELSE COALESCE(F1."Business Lvl 1 (Group) Code",WD."Business Lvl 1 (Group) Code")
                    END
        
            ELSE
                'No'
        END AS "Is Extended IT",

        CASE
            WHEN WD."Work Address - City" = N'Pantnagar' THEN WD."Work Address - City"
            ELSE 'Other'
        END AS "Work Address - City",

        CASE
            WHEN TT."Job Family Code" IS NULL THEN 'No'
            ELSE 'Yes'
        END AS "Technical Job Family",

        CASE
            WHEN WD."Business Lvl 4 (MRU) Code" = N'G034'THEN WD."Business Lvl 4 (MRU) Code"
            ELSE 'Other'
        END AS "Business Lvl 4 (MRU) Code",

        CASE
            WHEN VET."Employee ID" IS NULL THEN 'U'
            ELSE VET."Veteran Status"
        END AS "Veteran Status",

        CASE
            WHEN WD."Pay Group Country Code" = N'USA' THEN WD."Pay Group Country Desc"
            ELSE 'Other'
        END AS "Pay Group Country Desc",

        CASE
            WHEN WD."Pay Group Country Code" = N'USA' THEN WD."Ethnicity Group"
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

        CASE
            WHEN WD."Worker Reg / Temp Code" = 'R' AND WD."Worker Status Category Code" = 'A' THEN 1
            ELSE 0
        END "Headcount",

        CASE
            WHEN WD."Worker Status Category Code" = 'T' AND WD."Attrition Type" = 'Voluntary' THEN 1
            ELSE 0
        END AS "Voluntary Attrition",
        'Attrition' AS "Type"
    FROM "HPW_DATA" AS WD

        INNER JOIN "HPW_ATTRITION" AS AD ON AD."Report Date" = WD."Report Date" AND AD."Worker ID" = WD."Worker ID"
        INNER JOIN "HPI_ORGS" AS HP ON HP."Business Lvl 1 (Group) Code" = WD."Business Lvl 1 (Group) Code"
        LEFT JOIN "JOB_FUNCTION" AS JF ON JF."Job Family Group" = WD."Job Family Group"
        LEFT JOIN "LABOR_PYRAMID" AS LP ON LP."Management Level" = WD."Management Level"
        LEFT JOIN "FEDL1" AS F1 ON F1."Business Lvl 4 (MRU) Code" = WD."Business Lvl 4 (MRU) Code"
        LEFT JOIN "FEDL2" AS F2 ON F2."Business Lvl 4 (MRU) Code" = WD."Business Lvl 4 (MRU) Code"
        LEFT JOIN "FEDL3" AS F3 ON F3."Business Lvl 4 (MRU) Code" = WD."Business Lvl 4 (MRU) Code"
        LEFT JOIN "TECHNICAL_JOBS" AS TT ON TT."Job Family Code" = WD."Job Family Code"
        LEFT JOIN "HPW_VETERANS" AS VET ON VET."Report Date" = WD."Report Date"	AND VET."Employee ID" = WD."Worker ID"	AND VET."Veteran Status" = 'Y'
        
    WHERE 
        date_trunc('month', WD."Termination Date") + interval '1 month' - interval '1 day' > (Select Max("Report Date") - interval '1 year' From "HPW_DATA")
        AND WD."Business Lvl 4 (MRU) Code" <> 'G034'
        AND NOT (WD."Business Lvl 1 (Group) Code" = 'OPER'AND WD."Work Address - City" = 'Pantnagar')
) AS S
GROUP BY 
    S."Report Date",	
    S."Hybrid L1",
    S."Hybrid L2",
    S."Hybrid L3",
    S."Is Extended IT",
    S."Work Address - City",
    S."Technical Job Family",
    S."Business Lvl 4 (MRU) Code",
    S."Veteran Status",
    S."Pay Group Country Desc",
    S."Ethnicity Group",
    S."Gender Code",
    S."Is Professional",
    S."Is New Hire",
    S."Management Level Category"
ORDER BY 
    S."Report Date",	
    S."Hybrid L1",
    S."Hybrid L2",
    S."Hybrid L3",    
    S."Is Extended IT",
    S."Work Address - City",
    S."Technical Job Family",
    S."Business Lvl 4 (MRU) Code",
    S."Veteran Status",
    S."Pay Group Country Desc"