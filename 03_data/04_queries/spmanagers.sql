-- PROCEDURE: public.sp_new_managers(date, date)

-- DROP PROCEDURE public.sp_new_managers(date, date);

CREATE OR REPLACE PROCEDURE public.sp_new_managers(
	datefrom date,
	dateto date)
LANGUAGE 'sql'
AS $BODY$
SELECT

	dhc."Worker ID",
	dhc."Preferred Name" As "Name",
	dhc."Email - Primary Work" As "Email",
	me."Management Level" As "Previous Management Level",
	dhc."Management Level" As "Current Management Level",
	dhc."Pay Group Country Desc",
	dhc."Pay Group Theater Code",
	dhc."Supervisor - Level 01 Preferred name" As "Manager",
	dhc."Supervisor - Level 01 Email" As "Manager Email",
	'Promotion' As "Type of Movement"

from
	
	"HPW_DATA" As me
	inner join "HPW_DAILY" As dhc on dhc."Worker ID" = me."Worker ID" and me."Report Date" Between dateFrom and dateTo

where
	me."Management Level Category" in ('PROF','NONE') and
	me."Worker Reg / Temp Code" = 'R' and
	me."Worker Status Category Code" <> 'T' and
	dhc."Management Level Category" not in ('PROF','NONE') and
	dhc."Worker Reg / Temp Code" = 'R' and
	dhc."Worker Status Category Code" <> 'T'

union all

select

	hc."Worker ID",
	hc."Preferred Name" As "Name",
	hc."Email - Primary Work" As "Email",
	null As "Previous Management Level",
	hc."Management Level" As "Current Management Level",
	hc."Pay Group Country Desc",
	hc."Pay Group Theater Code",
	hc."Supervisor - Level 01 Preferred name" As "Manager",
	hc."Supervisor - Level 01 Email" As "Manager Email",
	'New Hire' As "Type of Movement"

from
	"HPW_DAILY" As hc
where
	hc."Management Level Category" not in ('PROF','NONE') and
	hc."Worker Reg / Temp Code" = 'R' and
	hc."Worker Status Category Code" <> 'T' and
	(hc."Original Hire Date" Between dateFrom and dateTo or hc."Hire Date" Between dateFrom and dateTo);
$BODY$;
