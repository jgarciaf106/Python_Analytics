SELECT hwd."Worker Reg / Temp Desc" AS "Worker Type",
    hwd."Email - Primary Work",
    hwd."Preferred Name",
    hwd."Business Lvl 1 (Group) Code" AS "Hybrid L1 Code",
    hwd."Gender Code",
        CASE
            WHEN tt."Job Family Code" IS NULL THEN 'N'::text
            ELSE 'Y'::text
        END AS "Technical Job",
    hwd."TCP Job",
    hwd."Job Family Group",
    hwd."Job Family",
    hwd."Management Level",
    hwd."Work Location Theater Name",
    hwd."Work Address - Country",
    hwd."Work Address - State/Province",
    hwd."Metro Area",
    'N'::text AS "Opt In"
   FROM "HPW_DAILY" hwd
     LEFT JOIN "TECHNICAL_JOBS" tt ON tt."Job Family Code"::text = hwd."Job Family Code"::text
  WHERE hwd."Report Date" = (( SELECT max("HPW_DAILY"."Report Date") AS max
           FROM "HPW_DAILY")) AND hwd."Gender Code" ~~ 'F'::text AND hwd."Management Level"::text ~~ 'MAS'::text AND hwd."Worker Reg / Temp Code" ~~ 'R'::text AND hwd."Worker Status Category Code" ~~ 'A'::text AND
        CASE
            WHEN tt."Job Family Code" IS NULL THEN 'N'::text
            ELSE 'Y'::text
        END ~~ 'Y'::text AND NOT (hwd."Email - Primary Work"::text IN ( SELECT "TECH_F_MAS"."HP email address"
           FROM "TECH_F_MAS"))
UNION ALL
 SELECT hwd."Worker Reg / Temp Desc" AS "Worker Type",
    hwd."Email - Primary Work",
    hwd."Preferred Name",
    hwd."Business Lvl 1 (Group) Code" AS "Hybrid L1 Code",
    hwd."Gender Code",
    'Y'::text AS "Technical Job",
    hwd."TCP Job",
    hwd."Job Family Group",
    hwd."Job Family",
    hwd."Management Level",
    hwd."Work Location Theater Name",
    hwd."Work Address - Country",
    hwd."Work Address - State/Province",
    hwd."Metro Area",
    'Y'::text AS "Opt In"
   FROM "TECH_F_MAS" tfm
     JOIN "HPW_DAILY" hwd ON hwd."Email - Primary Work"::text = tfm."HP email address"::text
  WHERE hwd."Report Date" = (( SELECT max("HPW_DAILY"."Report Date") AS max
           FROM "HPW_DAILY"));
