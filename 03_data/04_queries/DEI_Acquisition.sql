Select 
    op.[Report Effective Date],
    ac.[Job Requisition #],
    op.[Management Level],
    op.[Hybrid Business Group (L1) Code],
    op.[Hybrid Business Unit (L2) Code],
    ac.[Candidate ID],
    Case
        When ac.[Candidate Stage] In ('Screen', 'Review', 'Interview') Then 'Interested'
        When ac.[Candidate Stage] = 'Rejected' Then 'Rejected'
        When ac.[Candidate Stage] In ('Offer', 'Background Check', 'Ready For Hire', 'Declined by Candidate') Then 'Selected'
    End As [Candidate Stage],
    Isnull(ac.[Gender], 'Undeclared') As [Gender],
    Case
        When ac.[Wider Ethnicity Group] In ('American Indian','Hawaiian/Pacific Islander') Then 'Other Minorities'
        Else ac.[Wider Ethnicity Group] 
    End As [Wider Ethnicity Group],
    Case
        When Isnull(ac.[Veteran Status], 'Unknown') = 'Unknown' Then 'U'
        When Isnull(ac.[Veteran Status], 'Unknown') Like '%I DO NOT WISH%' Then 'U'
        When Isnull(ac.[Veteran Status], 'Unknown') Like '%I AM NOT%' Then 'N'
        When Isnull(ac.[Veteran Status], 'Unknown') Like '%I IDENTIFY AS A%' Then 'Y'
        When Isnull(ac.[Veteran Status], 'Unknown') Like '%I IDENTIFY AS ONE OR%' Then 'Y'
    End As [Veteran Status],
    Isnull(ac.[Disability Status], 'Unknown') As [Disability Status],
    Case
        When tt.[Job Family Code] Is Null Then 'No'
        Else 'Yes'
    End As [Technical Job Family]
From
	[hpw_dei_acquisition] as ac
Left Join 
    [hpw_open_req] As op on op.[Requisition NO] = ac.[Job Requisition #]
Left Join 
    technical_job As tt ON tt.[Job Family Code] = op.[Job Family Code]
Where
    op.[Country] = 'United States of America'
And
	op.[Job Requisition Status] = 'Open'
And
	op.[Management Level] <> '22 N/A'
And
    op.[Worker Sub-Type Hiring Requirement] = 'Reg Employee' 
And
	op.[Recruiting Instruction] <> 'Internal Only'