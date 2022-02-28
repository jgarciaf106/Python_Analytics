Select Distinct
    s."Report Date",
    s."HP Person ID",
    s."Email Address",
    s."Cohort", 
    s."Cohort Name",        
    s."Cohort Start Date",
    s."Cohort End Date",
    s."Enrollment Date",
    s."Worker Status", 
    s."Attrition Type",
    s."Business Group Descr",
    s."Record Status",
    s."Is on Success Plan"
From (

    Select Distinct
        wd."Report Date",
        cat."HP Person ID",
        cat."Email Address",
        cat."Cohort",
        cat."Cohort Name",        
        cat."Cohort Start Date",
        cat."Cohort End Date",        
        cat."Enrollment Date",
        cat."Worker Status",
        wd."Attrition Type",
        cat."Business Group Descr",
        cat."Record Status",
        tal."Has Ready Now Successor" As "Is on Success Plan"
    From 
        "PD_CATALYST" As cat
    Left Join 
        "HPW_DATA" As wd  On cat."HP Person ID" = wd."Worker ID" And wd."Report Date" >= (Select Min("Enrollment Date") From "PD_CATALYST")
    Left Join 
        "HPW_TAL" As tal On cat."HP Person ID" = tal."Employee ID" And tal."Has Ready Now Successor" = 'Yes'
    Where 
        cat."Worker Status" <> 'T'
    And 
        wd."Attrition Type" = '*'


    Union All

    Select Distinct
        wd."Report Date",
        cat."HP Person ID",
        cat."Email Address",
        cat."Cohort",
        cat."Cohort Name",        
        cat."Cohort Start Date",
        cat."Cohort End Date",        
        cat."Enrollment Date",
        cat."Worker Status",
        wd."Attrition Type",
        cat."Business Group Descr",
        cat."Record Status",
        tal."Has Ready Now Successor" As "Is on Success Plan"
    From 
        "PD_CATALYST" As cat
    Left Join 
        "HPW_DATA" As wd  On cat."HP Person ID" = wd."Worker ID" And wd."Report Date" >= (Select Min("Enrollment Date") From "PD_CATALYST")
    Left Join 
        "HPW_TAL" As tal On cat."HP Person ID" = tal."Employee ID" And tal."Has Ready Now Successor" = 'Yes'
    Where 
        cat."Worker Status" = 'T'
    And 
        wd."Attrition Type" <> '*'

) As s

Order By
    s."Report Date"







