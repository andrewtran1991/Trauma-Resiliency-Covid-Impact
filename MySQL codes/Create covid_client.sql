# create pre/post COVID client table with zipcode
# 3/22/21 checked svccount
# 4/12/21 add sex, race, primary dxgroups
# 4/13/21 added race grouping and ethid
# 3/21/22 added zip region
# 3/24/22 added zip sra

# pre table
DROP TABLE IF EXISTS tmp_client_pre ;
CREATE TEMPORARY TABLE tmp_client_pre
SELECT
1 AS timepoint,
azc_services_precovid.`Client id` AS CLIENT_ID,
azc_services_precovid.`Case num` AS casenum,
azc_services_precovid.age,
azc_services_precovid.agedate,
azc_services_precovid.Sex,
azc_services_precovid.`Eth id` AS ethid,
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
azc_services_precovid.age,
azc_services_precovid.Sex
ORDER BY
azc_services_precovid.`Client id` ;

SELECT * FROM tmp_client_pre ;

SELECT * FROM tmp_client_pre 
WHERE CLIENT_ID = 22515 ;


DROP TABLE IF EXISTS tmp_client_pre_zip ;
CREATE TEMPORARY TABLE tmp_client_pre_zip
SELECT
tmp_client_pre.*,
azc_race_precovid.race1,
azc_race_precovid.race1desc,
azc_race_precovid.racecode1,
azc_race_precovid.racegrp1,
azc_race_precovid.race2,
azc_race_precovid.race2desc,
azc_race_precovid.racecode2,
azc_race_precovid.racegrp2,
azc_race_precovid.multi,
azc_dx_prim_precovid.dxgroup,
azc_dx_prim_precovid.grpdesc,
az_client_zip_precovid.ZIP,
zipregion.region,
zipregion.region_name,
zipregion.sra,
zipregion.sra_name
FROM tmp_client_pre
LEFT JOIN azc_race_precovid
ON tmp_client_pre.CLIENT_ID = azc_race_precovid.CLIENT_ID 
LEFT JOIN azc_dx_prim_precovid
ON tmp_client_pre.CLIENT_ID = azc_dx_prim_precovid.CLIENT_ID 
LEFT JOIN az_client_zip_precovid
ON tmp_client_pre.CLIENT_ID = az_client_zip_precovid.CLIENT_ID 
LEFT JOIN zipregion
ON az_client_zip_precovid.ZIP = zipregion.Zip ;

SELECT * FROM tmp_client_pre_zip ;

#SELECT * FROM tmp_client_pre_zip
#WHERE CLIENT_ID = 22515 ;


# post table
DROP TABLE IF EXISTS tmp_client_post ;
CREATE TEMPORARY TABLE tmp_client_post
SELECT
2 AS timepoint,
azc_services_postcovid.`Client id` AS CLIENT_ID,
azc_services_postcovid.`Case num` AS casenum,
azc_services_postcovid.age,
azc_services_postcovid.agedate,
azc_services_postcovid.Sex,
azc_services_postcovid.`Eth id` AS ethid,
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
azc_race_postcovid.race1,
azc_race_postcovid.race1desc,
azc_race_postcovid.racecode1,
azc_race_postcovid.racegrp1,
azc_race_postcovid.race2,
azc_race_postcovid.race2desc,
azc_race_postcovid.racecode2,
azc_race_postcovid.racegrp2,
azc_race_postcovid.multi,
azc_dx_prim_postcovid.dxgroup,
azc_dx_prim_postcovid.grpdesc,
az_client_zip_postcovid.ZIP,
zipregion.region,
zipregion.region_name,
zipregion.sra,
zipregion.sra_name
FROM tmp_client_post
LEFT JOIN azc_race_postcovid
ON tmp_client_post.CLIENT_ID = azc_race_postcovid.CLIENT_ID 
LEFT JOIN azc_dx_prim_postcovid
ON tmp_client_post.CLIENT_ID = azc_dx_prim_postcovid.CLIENT_ID 
LEFT JOIN az_client_zip_postcovid
ON tmp_client_post.CLIENT_ID = az_client_zip_postcovid.CLIENT_ID
LEFT JOIN zipregion
ON az_client_zip_postcovid.ZIP = zipregion.Zip ;

SELECT * FROM tmp_client_post_zip ;



# combine pre & post
DROP TABLE IF EXISTS covid_client ;
CREATE TABLE covid_client 
SELECT * FROM tmp_client_pre_zip
UNION
SELECT * FROM tmp_client_post_zip ;


SELECT * FROM covid_client ;

SELECT * FROM covid_client WHERE timepoint = 1 ;
SELECT * FROM covid_client WHERE timepoint = 2 ;



#SELECT * FROM covid_client
#WHERE CLIENT_ID = 22515 ;



