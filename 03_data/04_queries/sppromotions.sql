-- PROCEDURE: public.sp_promotions_transfers(date)

-- DROP PROCEDURE public.sp_promotions_transfers(date);

CREATE OR REPLACE PROCEDURE public.sp_promotions_transfers(
	datefrom date)
LANGUAGE 'sql'
AS $BODY$
SELECT hct."ReportDate",
    hct."PreviousReportDate",
    hct."EmployeeID",
    hct."Name",
    wd1."Email - Primary Work" AS "Email",
    hct."PreviousL1",
    hct."CurrentL1",
    hct."PreviousL2",
    hct."CurrentL2",
    hct."PreviousL3",
    hct."CurrentL3",
    hct."PreviousL4",
    hct."CurrentL4",
    hct."PreviousPayrollRegion" AS "PreviousPayrollTheater",
    hct."CurrentPayrollRegion" AS "CurrentPayrollTheater",
    hct."PreviousPayrollCountry",
    hct."CurrentPayrollCountry",
    hct."PreviousSalaryGrade",
    hct."CurrentSalaryGrade",
    hct."PreviousJobCode",
    hct."CurrentJobCode",
    hct."PreviousJobLevel",
    hct."CurrentJobLevel",
    hct."PreviousSupervisor",
    hct."CurrentSupervisor",
    hct."ChangeDescription",
    hct."ChangeSubCategory",
    hct."ChangeCategory",
    hct."OriginalHireDate",
    hct."TerminationDate",
    hct."RehireDate",
    hct."LH1",
    hct."CurrentRptLevel1MgrName",
    hct."CurrentRptLevel2MgrName",
    hct."CurrentRptLevel3MgrName",
    hct."CurrentRptLevel4MgrName",
    hct."PreviousRptLevel1MgrName",
    hct."PreviousRptLevel2MgrName",
    hct."PreviousRptLevel3MgrName",
    hct."PreviousRptLevel4MgrName",
    hct."CurrentJobMonthsInJob",
    hct."PreviousJobMonthsInJob",
    hct."GenderCode",
    wd1."Job Family" AS "CurrentJobFamily",
    wd2."Job Family" AS "PreviousJobFamily",
    wd1."TCP Job" AS "CurrentTCPJob",
    wd2."TCP Job" AS "PreviousTCPJob",
        CASE
            WHEN tj1."Job Family" IS NOT NULL THEN 'Y'::text
            ELSE 'N'::text
        END AS "CurrentTechnicalJob",
        CASE
            WHEN tj2."Job Family" IS NOT NULL THEN 'Y'::text
            ELSE 'N'::text
        END AS "PreviousTechnicalJob"
   FROM "HPW_TRACKING" hct
     JOIN "JOB_MOVES" jm ON jm.jobmoves::text = hct."ChangeSubCategory"::text
     LEFT JOIN "HPW_DATA" wd1 ON wd1."Report Date" = hct."ReportDate" AND wd1."Worker ID"::text = hct."EmployeeID"::text
     LEFT JOIN "HPW_DATA" wd2 ON wd2."Report Date" = hct."PreviousReportDate" AND wd2."Worker ID"::text = hct."EmployeeID"::text
     LEFT JOIN "TECHNICAL_JOBS" tj1 ON tj1."Job Family"::text = wd1."Job Family"::text
     LEFT JOIN "TECHNICAL_JOBS" tj2 ON tj2."Job Family"::text = wd2."Job Family"::text
  WHERE hct."ReportDate" >= dateFrom::date
  ORDER BY hct."ReportDate" DESC, hct."CurrentL1", hct."CurrentL2", hct."CurrentL3", hct."CurrentL4", hct."CurrentPayrollRegion", hct."CurrentPayrollCountry", hct."CurrentRptLevel1MgrName", hct."CurrentRptLevel2MgrName", hct."CurrentRptLevel3MgrName", hct."CurrentRptLevel4MgrName", wd1."Job Family", hct."CurrentJobCode";
$BODY$;
