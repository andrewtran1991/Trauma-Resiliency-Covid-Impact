# create pre/post COVID client table with zipcode
# 3/22/21 checked svccount
# 4/12/21 add sex, race, primary dxgroups
# 4/13/21 added race grouping and ethid
# 6/7/21 modifed for service counts/visits
# 6/8/21 filtering for OP only
# 6/10/21 separate by contact type Telehealth (E) vs face to face (F)


# pre table
DROP TABLE IF EXISTS tmp_client_svcs_pre ;
CREATE TEMPORARY TABLE tmp_client_svcs_pre
SELECT
1 AS timepoint,
azc_services_precovid.`Client id` AS CLIENT_ID,
azc_services_precovid.`Case num` AS casenum,
azc_services_precovid.loc,
Min(azc_services_precovid.`Beg date`) AS minsvcdt,
Max(azc_services_precovid.`Beg date`) AS maxsvcdt,
CAST(COUNT(azc_services_precovid.service_id) AS DECIMAL) AS svccount,
SUM(azc_services_precovid.Hrs) AS tothrs,
SUM(azc_services_precovid.Mins) AS totmins,
azc_services_precovid.dtfilter,
azc_services_precovid.filedate
FROM
azc_services_precovid
WHERE
azc_services_precovid.loc IN ('OP')
GROUP BY
azc_services_precovid.`Client id`
ORDER BY
azc_services_precovid.`Client id` ;

SELECT * FROM tmp_client_svcs_pre ;

SELECT * FROM azc_services_precovid 
WHERE azc_services_precovid.`Client id` = 6710 ;

SELECT * FROM tmp_client_svcs_pre 
WHERE CLIENT_ID = 6710 ;


# post table
DROP TABLE IF EXISTS tmp_client_svcs_post ;
CREATE TEMPORARY TABLE tmp_client_svcs_post
SELECT
2 AS timepoint,
azc_services_postcovid.`Client id` AS CLIENT_ID,
azc_services_postcovid.`Case num` AS casenum,
azc_services_postcovid.loc,
Min(azc_services_postcovid.`Beg date`) AS minsvcdt,
Max(azc_services_postcovid.`Beg date`) AS maxsvcdt,
CAST(COUNT(azc_services_postcovid.service_id) AS DECIMAL) AS svccount,
SUM(azc_services_postcovid.Hrs) AS tothrs,
SUM(azc_services_postcovid.Mins) AS totmins,
azc_services_postcovid.dtfilter,
azc_services_postcovid.filedate
FROM
azc_services_postcovid
WHERE
azc_services_postcovid.loc IN ('OP')
GROUP BY
azc_services_postcovid.`Client id`
ORDER BY
azc_services_postcovid.`Client id` ;

SELECT * FROM tmp_client_svcs_post ;

SELECT * FROM tmp_client_svcs_post 
WHERE CLIENT_ID = 6710 ;



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
WHERE CLIENT_ID = 6710 ;



