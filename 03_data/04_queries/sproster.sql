-- PROCEDURE: public.sp_pbi_roster_security_cud(text, text, text, text, text, text, text)

-- DROP PROCEDURE public.sp_pbi_roster_security_cud(text, text, text, text, text, text, text);

CREATE OR REPLACE PROCEDURE public.sp_pbi_roster_security_cud(
	action text,
	"user" text,
	username text,
	email text,
	rf1 text,
	rf2 text,
	rf3 text)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
	IF "action" = 'C' THEN
		INSERT INTO "PBI_ROSTER_SECURITY" VALUES ("user", username, email, rf1, rf2, rf3);
	ELSIF "action" = 'U' THEN
		UPDATE "PBI_ROSTER_SECURITY"
		SET "User" = "user",
			"UserName" = username,
			"Email" = email,
			"RF1" = rf1,
			"RF2" = rf2,
			"RF3" = rf3
		WHERE
			"Email" Like email
		AND
			"RF1" = rf1
		AND
			"RF2" = rf2
		AND
			"RF3" = rf3;	
	ELSIF "action" = 'D' THEN
		DELETE FROM 
			"PBI_ROSTER_SECURITY"
		WHERE
			"Email" Like email;
	END IF;
END;
$BODY$;
