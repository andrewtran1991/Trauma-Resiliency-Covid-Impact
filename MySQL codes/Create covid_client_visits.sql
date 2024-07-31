# create pre/post COVID client table with zipcode
# 3/22/21 checked svccount
# 4/12/21 add sex, race, primary dxgroups
# 4/13/21 added race grouping and ethid
# 6/7/21 modifed for service counts/visits


# pre table
DROP TABLE IF EXISTS tmp_client_svcs_pre ;
CREATE TEMPORARY TABLE tmp_client_svcs_pre
SELECT
1 AS timepoint,
azc_services_precovid.`Client id` AS CLIENT_ID,
azc_services_precovid.`Case num` AS casenum,
azc_services_precovid.`Beg date` AS svcdate,
CAST(COUNT(azc_services_precovid.service_id) AS DECIMAL) AS svcdays,
SUM(azc_services_precovid.Hrs) AS tothrs,
SUM(azc_services_precovid.Mins) AS totmins,
azc_services_precovid.dtfilter,
azc_services_precovid.filedate
FROM
azc_services_precovid
GROUP BY
azc_services_precovid.`Client id`,
azc_services_precovid.`Beg date`
ORDER BY
azc_services_precovid.`Client id` ;

SELECT * FROM tmp_client_svcs_pre ;

SELECT * FROM azc_services_precovid 
WHERE azc_services_precovid.`Client id` = 22515 ;

SELECT * FROM tmp_client_svcs_pre 
WHERE CLIENT_ID = 22515 ;


DROP TABLE IF EXISTS tmp_client_days_pre ;
CREATE TEMPORARY TABLE tmp_client_days_pre
SELECT
1 AS timepoint,
tmp_client_svcs_pre.CLIENT_ID,
tmp_client_svcs_pre.casenum,
Min(tmp_client_svcs_pre.svcdate) AS minsvcdt,
Max(tmp_client_svcs_pre.svcdate) AS maxsvcdt,
SUM(tmp_client_svcs_pre.svcdays) AS svcdays,
SUM(azc_services_precovid.Hrs) AS tothrs,
SUM(azc_services_precovid.Mins) AS totmins,
azc_services_precovid.dtfilter,
azc_services_precovid.filedate
FROM
azc_services_precovid
GROUP BY
azc_services_precovid.`Client id`,
azc_services_precovid.`Beg date`
ORDER BY
azc_services_precovid.`Client id` ;

SELECT * FROM tmp_client_svcs_pre ;

SELECT * FROM azc_services_precovid 
WHERE azc_services_precovid.`Client id` = 22515 ;

SELECT * FROM tmp_client_svcs_pre 
WHERE CLIENT_ID = 22515 ;


# post table
DROP TABLE IF EXISTS tmp_client_svcs_post ;
CREATE TEMPORARY TABLE tmp_client_svcs_post
SELECT
2 AS timepoint,
azc_services_postcovid.`Client id` AS CLIENT_ID,
azc_services_postcovid.`Case num` AS casenum,
Min(azc_services_postcovid.`Beg date`) AS minsvcdt,
Max(azc_services_postcovid.`Beg date`) AS maxsvcdt,
CAST(COUNT(azc_services_postcovid.service_id) AS DECIMAL) AS svccount,
SUM(azc_services_postcovid.Hrs) AS tothrs,
SUM(azc_services_postcovid.Mins) AS totmins,
azc_services_postcovid.dtfilter,
azc_services_postcovid.filedate
FROM
azc_services_postcovid
GROUP BY
azc_services_postcovid.`Client id`
ORDER BY
azc_services_postcovid.`Client id` ;

SELECT * FROM tmp_client_svcs_post ;

SELECT * FROM tmp_client_svcs_post 
WHERE CLIENT_ID = 22515 ;



# combine pre & post
DROP TABLE IF EXISTS covid_client_svcs ;
CREATE TABLE covid_client_svcs 
SELECT * FROM tmp_client_svcs_pre
UNION
SELECT * FROM tmp_client_svcs_post ;


SELECT * FROM covid_client_svcs ;

SELECT * FROM covid_client_svcs WHERE timepoint = 1 ;
SELECT * FROM covid_client_svcs WHERE timepoint = 2 ;



SELECT * FROM covid_client_svcs
WHERE CLIENT_ID = 22515 ;



