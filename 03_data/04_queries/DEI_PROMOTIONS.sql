SELECT 
    hct.[ReportDate],
    hct.[PreviousReportDate],
    hct.[EmployeeID],
    hct.[Name],
    wd1.[Email - Primary Work] AS [Email],
    hct.[PreviousL1],
    hct.[CurrentL1],
    hct.[PreviousL2],
    hct.[CurrentL2],
    hct.[PreviousL3],
    hct.[CurrentL3],
    hct.[PreviousL4],
    hct.[CurrentL4],
    hct.[PreviousPayrollRegion] AS [PreviousPayrollTheater],
    hct.[CurrentPayrollRegion] AS [CurrentPayrollTheater],
    hct.[PreviousPayrollCountry],
    hct.[CurrentPayrollCountry],
    hct.[PreviousSalaryGrade],
    hct.[CurrentSalaryGrade],
    hct.[PreviousJobCode],
    hct.[CurrentJobCode],
    CASE 
        WHEN hct.[PreviousJobLevel] = 'CEO' OR hct.[EmployeeID] IN (SELECT [Worker ID] FROM [hpw_l1_leader]) THEN '(L1) C-Suite'
        WHEN hct.[PreviousJobLevel] = 'EXE'  THEN '(L3) Executive'
        WHEN hct.[PreviousJobLevel]= 'DIR'  THEN '(L4) Senior Level'
        WHEN hct.[PreviousJobLevel] IN ('SU1','SU2','MG1','MG2')  THEN '(L5) Mid-Level'
        WHEN hct.[PreviousJobLevel] IN ('ENT','INT','SPE','EXP','MAS','STR','FEL','SFL')  THEN '(L6) Professional'
        ELSE '(L7) Non-Professional'
	END AS [PreviousJobLevel],
    CASE 
        WHEN hct.[CurrentJobLevel] = 'CEO' OR hct.[EmployeeID] IN (SELECT [Worker ID] FROM [hpw_l1_leader]) THEN '(L1) C-Suite'
        WHEN hct.[CurrentJobLevel] = 'EXE'  THEN '(L3) Executive'
        WHEN hct.[CurrentJobLevel] = 'DIR'  THEN '(L4) Senior Level'
        WHEN hct.[CurrentJobLevel] IN ('SU1','SU2','MG1','MG2')  THEN '(L5) Mid-Level'
        WHEN hct.[CurrentJobLevel] IN ('ENT','INT','SPE','EXP','MAS','STR','FEL','SFL')  THEN '(L6) Professional'
        ELSE '(L7) Non-Professional'
	END AS [CurrentJobLevel],
    hct.[PreviousSupervisor],
    hct.[CurrentSupervisor],
    hct.[ChangeDescription],
    hct.[ChangeSubCategory],
    hct.[ChangeCategory],
    hct.[OriginalHireDate],
    hct.[TerminationDate],
    hct.[RehireDate],
    hct.[LH1],
    hct.[CurrentRptLevel1MgrName],
    hct.[CurrentRptLevel2MgrName],
    hct.[CurrentRptLevel3MgrName],
    hct.[CurrentRptLevel4MgrName],
    hct.[PreviousRptLevel1MgrName],
    hct.[PreviousRptLevel2MgrName],
    hct.[PreviousRptLevel3MgrName],
    hct.[PreviousRptLevel4MgrName],
    hct.[CurrentJobMonthsInJob],
    hct.[PreviousJobMonthsInJob],
    hct.[GenderCode],
    wd1.[Job Family Group] AS [CurrentJobFamilyGroup],
    wd2.[Job Family Group] AS [PreviousJobFamilyGroup],
    wd1.[Job Family] AS [CurrentJobFamily],
    wd2.[Job Family] AS [PreviousJobFamily],
    wd1.[TCP Job] AS [CurrentTCPJob],
    wd2.[TCP Job] AS [PreviousTCPJob],
    CASE
        WHEN tj1.[Job Family] IS NOT NULL THEN 'Y'
        ELSE 'N'
    END AS [CurrentTechnicalJob],
    CASE
        WHEN tj2.[Job Family] IS NOT NULL THEN 'Y'
        ELSE 'N'
    END AS [PreviousTechnicalJob]
FROM 
[hpw_tracking] hct
    JOIN [job_move] jm ON jm.jobmoves = hct.[ChangeSubCategory]
    LEFT JOIN [hpw_data] wd1 ON wd1.[Report Date] = hct.[ReportDate] AND wd1.[Worker ID] = hct.[EmployeeID]
    LEFT JOIN [hpw_data] wd2 ON wd2.[Report Date] = hct.[PreviousReportDate] AND wd2.[Worker ID] = hct.[EmployeeID]
    LEFT JOIN [technical_job] tj1 ON tj1.[Job Family] = wd1.[Job Family]
    LEFT JOIN [technical_job] tj2 ON tj2.[Job Family] = wd2.[Job Family]
WHERE 
    hct.[ReportDate] >= '2019-10-31'
AND 
    hct.[PreviousL1] = 'CMP'
AND
    [ChangeSubCategory] = 'Promotion'
AND
    [ChangeCategory] = 'INTRA'
ORDER BY 
    hct.[ReportDate] DESC,
    hct.[CurrentL1],
    hct.[CurrentL2],
    hct.[CurrentL3],
    hct.[CurrentL4],
    hct.[CurrentPayrollRegion],
    hct.[CurrentPayrollCountry],
    hct.[CurrentRptLevel1MgrName],
    hct.[CurrentRptLevel2MgrName],
    hct.[CurrentRptLevel3MgrName],
    hct.[CurrentRptLevel4MgrName],
    wd1.[Job Family],
    hct.[CurrentJobCode]
