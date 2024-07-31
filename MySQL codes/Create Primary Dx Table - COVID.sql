# create current primary dx table
# for pre/post covid comparison
# 3/15/22 for pandemic impact update
# precovid March 2019 - February 2020 (2019-03-01, 2020-02-29 leap year)
# postyear1 March 2020 – February 2021 (2020-03-01, 2021-02-28)
# postyear2 March 2021 - February 2022 (2021-03-01, 2022-02-28)
# enddates: precovid 2020-02-29, postcovid 2021-02-28

# primary dx
DROP TABLE IF EXISTS tmp_current_dx ;
CREATE TEMPORARY TABLE tmp_current_dx
SELECT
azc_dx.Id,
azc_dx.Clientid AS CLIENT_ID,
azc_dx.Axis,
azc_dx.Priority,
azc_dx.`Diag id` AS DIAG_ID,
azc_dx.`Beg date` AS BEG_DATE,
[$enddate] AS dtfilter,
azc_dx.filedate,
DATE(NOW()) AS createdate
FROM
azc_dx
INNER JOIN
(SELECT 
	MAX(azc_dx.`Beg date`) AS max_date,
	MAX(azc_dx.Id) AS max_id
	FROM azc_dx
	WHERE 
	azc_dx.Axis = 1
	AND
	azc_dx.Priority = 1
	AND
	azc_dx.`Beg date` <= [$enddate]
	GROUP BY azc_dx.Clientid) as t2
ON
azc_dx.`Beg date` = t2.max_date
AND
azc_dx.Id = t2.max_id ;


SELECT * FROM tmp_current_dx ;


# check client
SELECT * FROM azc_dx WHERE Clientid = 483 
ORDER BY 
azc_dx.`Beg date`, azc_dx.Id ;

SELECT * FROM tmp_current_dx WHERE CLIENT_ID = 483 ;



# add grouping- pre covid
/*
DROP TABLE IF EXISTS azc_dx_prim_precovid ;
CREATE TABLE azc_dx_prim_precovid 
SELECT 
tmp_current_dx.*,
dxlookup.dxgroup,
dxlookup.grpdesc,
dxlookup.subsab
FROM
tmp_current_dx
LEFT JOIN
dxlookup ON tmp_current_dx.DIAG_ID = dxlookup.dxcode ;

ALTER TABLE azc_dx_prim_precovid ADD INDEX (CLIENT_ID) ;

SELECT * FROM azc_dx_prim_precovid ;
*/


# add grouping- post covid

DROP TABLE IF EXISTS azc_dx_prim_postcovid ;
CREATE TABLE azc_dx_prim_postcovid 
SELECT 
tmp_current_dx.*,
dxlookup.dxgroup,
dxlookup.grpdesc,
dxlookup.subsab
FROM
tmp_current_dx
LEFT JOIN
dxlookup ON tmp_current_dx.DIAG_ID = dxlookup.dxcode ;

ALTER TABLE azc_dx_prim_postcovid ADD INDEX (CLIENT_ID) ;

SELECT * FROM azc_dx_prim_postcovid ;


# check for duplicates
/*SELECT
CLIENT_ID,
COUNT(CLIENT_ID) AS dupcount
FROM
azc_dx_current_primary
GROUP BY
CLIENT_ID 
HAVING
dupcount > 1 ;
*/

