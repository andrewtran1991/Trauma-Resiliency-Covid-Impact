# create pre/post COVID client table with zipcode
# 3/22/21 checked svccount
# 3/11/22 for expanded date ranges

# pre table
DROP TABLE IF EXISTS tmp_client_pre ;
CREATE TEMPORARY TABLE tmp_client_pre
SELECT
1 AS timepoint,
azc_services_precovid.`Client id` AS CLIENT_ID,
azc_services_precovid.`Case num` AS casenum,
azc_services_precovid.age,
Min(azc_services_precovid.`Beg date`) AS minsvcdt,
Max(azc_services_precovid.`Beg date`) AS maxsvcdt,
Count(azc_services_precovid.service_id) AS svccount,
azc_services_precovid.dtfilter,
azc_services_precovid.filedate
FROM
azc_services_precovid
GROUP BY
azc_services_precovid.`Client id`,
azc_services_precovid.`Case num`,
azc_services_precovid.age
ORDER BY
azc_services_precovid.`Client id` ;

SELECT * FROM tmp_client_pre ;

SELECT * FROM tmp_client_pre 
WHERE CLIENT_ID = 22515 ;


DROP TABLE IF EXISTS tmp_client_pre_zip ;
CREATE TEMPORARY TABLE tmp_client_pre_zip
SELECT
tmp_client_pre.*,
az_client_zip_precovid.FREEZE_DATE,
az_client_zip_precovid.ZIP
FROM tmp_client_pre
LEFT JOIN az_client_zip_precovid
ON tmp_client_pre.CLIENT_ID = az_client_zip_precovid.CLIENT_ID ;

SELECT * FROM tmp_client_pre_zip ;

SELECT * FROM tmp_client_pre_zip
WHERE CLIENT_ID = 22515 ;


# post table
DROP TABLE IF EXISTS tmp_client_post ;
CREATE TEMPORARY TABLE tmp_client_post
SELECT
2 AS timepoint,
azc_services_postcovid.`Client id` AS CLIENT_ID,
azc_services_postcovid.`Case num` AS casenum,
azc_services_postcovid.age,
Min(azc_services_postcovid.`Beg date`) AS minsvcdt,
Max(azc_services_postcovid.`Beg date`) AS maxsvcdt,
Count(azc_services_postcovid.service_id) AS svccount,
azc_services_postcovid.dtfilter,
azc_services_postcovid.filedate
FROM
azc_services_postcovid
GROUP BY
azc_services_postcovid.`Client id`,
azc_services_postcovid.`Case num`,
azc_services_postcovid.age
ORDER BY
azc_services_postcovid.`Client id` ;

SELECT * FROM tmp_client_post ;

DROP TABLE IF EXISTS tmp_client_post_zip ;
CREATE TEMPORARY TABLE tmp_client_post_zip
SELECT
tmp_client_post.*,
az_client_zip_postcovid.FREEZE_DATE,
az_client_zip_postcovid.ZIP
FROM tmp_client_post
LEFT JOIN az_client_zip_postcovid
ON tmp_client_post.CLIENT_ID = az_client_zip_postcovid.CLIENT_ID ;

SELECT * FROM tmp_client_post_zip ;



# combine pre & post
DROP TABLE IF EXISTS covid_client_zip ;
CREATE TABLE covid_client_zip 
SELECT * FROM tmp_client_pre_zip
UNION
SELECT * FROM tmp_client_post_zip ;


SELECT * FROM covid_client_zip ;


SELECT * FROM covid_client_zip
WHERE CLIENT_ID = 22515 ;



