Declare @db_connection as Nvarchar(15) = (Select db_name())

If @db_connection = 'HRAnalytics'
    Select 
        *
    From(

        Select 'WorkerData' As Source, Max([Report Date]) As [Max Reported Date] From WorkerData

        Union All 

        Select 'DailyHC' As Source,  Max([Report Date]) As [Max Reported Date]  From DailyHC

        Union All 

        Select 'AttritionData' As Source,  Max([Report Date]) As [Max Reported Date]  From AttritionData

        Union All 

        Select  'HCTracking' As Source,  Max([ReportDate]) As [Max Reported Date]  From HCTracking

        Union All 

        Select 'Openreqs' As Source,  Max([Report Effective Date]) As [Max Reported Date]  From OpenReqs
    ) As D
Else
    Select 
        *
    From(

        Select 'hpw_data' As Source, Max([Report Date]) As [Max Reported Date] From hpw_data

        Union All 

        Select 'hpw_daily' As Source,  Max([Report Date]) As [Max Reported Date]  From hpw_daily

        Union All 

        Select 'hpw_attrition' As Source,  Max([Report Date]) As [Max Reported Date]  From hpw_attrition

        Union All 

        Select  'hpw_tracking' As Source,  Max([ReportDate]) As [Max Reported Date]  From hpw_tracking

        Union All 

        Select 'Openreqs' As Source,  Max([Report Effective Date]) As [Max Reported Date]  From hpw_open_req
    ) As D


