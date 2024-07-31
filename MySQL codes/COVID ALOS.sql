
# pre-covid assignments

DROP TABLE IF EXISTS tmp_covid_assign_pre ;
CREATE TABLE tmp_covid_assign_pre 
SELECT
azassignment.Id AS assign_id,
azassignment.`Client id` AS client_id,
azassignment.`Unit id` AS unit_id,
azassignment.`Sub unit id` AS subunit_id,
azassignment.`Date opened` AS open_dt,
azassignment.`Date closed` AS close_dt
FROM
azassignment
WHERE
azassignment.`Date closed` BETWEEN '2019-04-01' AND '2019-12-31' ;



SELECT * FROM tmp_covid_assign_pre ;

#SELECT MIN(close_dt), MAX(close_dt) FROM tmp_covid_assign_pre;


SELECT
covid_client.*,
tmp_covid_assign_pre.assign_id,
tmp_covid_assign_pre.unit_id,
tmp_covid_assign_pre.subunit_id,
tmp_covid_assign_pre.open_dt,
tmp_covid_assign_pre.close_dt,
DATEDIFF(tmp_covid_assign_pre.close_dt,tmp_covid_assign_pre.open_dt)+1 AS los,
asgn_serv_sum.maxsrvdt,
asgn_serv_sum.minsrvdt,
subunit.azloc,
azlu_loc.levcare
FROM
covid_client
LEFT JOIN 
tmp_covid_assign_pre
	ON covid_client.CLIENT_ID = tmp_covid_assign_pre.client_id
LEFT JOIN
subunit
	ON tmp_covid_assign_pre.subunit_id = subunit.subunit
LEFT JOIN
asgn_serv_sum
	ON asgn_serv_sum.assign_id = tmp_covid_assign_pre.assign_id
LEFT JOIN
azlu_loc
	ON azlu_loc.azloc = subunit.azloc
WHERE
covid_client.timepoint = 1 ;




#SELECT * FROM covid_client WHERE covid_client.timepoint = 1 ;

/*
covid_client
LEFT JOIN
azassignment ON covid_client.CLIENT_ID = azassignment.`Client id`
WHERE
covid_client.timepoint = 1
AND
*/


/*
asgn_serv_sum.createdt AS asgn_serv_createdt,
asgn_serv_sum.maxsrvdt,
asgn_serv_sum.minsrvdt
FROM
azassignment 
LEFT JOIN asgn_serv_sum ON azassignment.Id = asgn_serv_sum.assign_id
*/


#FROM
#covid_client
