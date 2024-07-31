# create pre/post COVID client table with zipcode
# 3/22/21 checked svccount
# 4/12/21 add sex, race, primary dxgroups
# 4/13/21 added race grouping and ethid
# 5/11/21 add loc vars
# 3/21/22 added new loc vars loc_strtp_plus, loc_sandr
#         added zip region
# 3/28/22 added zip sra 

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
MAX(azc_services_precovid.loc_cm) AS loc_cm,
MAX(azc_services_precovid.loc_co) AS loc_co,
MAX(azc_services_precovid.loc_cs) AS loc_cs,
MAX(azc_services_precovid.loc_ctf) AS loc_ctf,
MAX(azc_services_precovid.loc_dt) AS loc_dt,
MAX(azc_services_precovid.loc_dtc) AS loc_dtc,
MAX(azc_services_precovid.loc_dtr) AS loc_dtr,
MAX(azc_services_precovid.loc_dt_ctf) AS loc_dt_ctf,
MAX(azc_services_precovid.loc_dt_phf) AS loc_dt_phf,
MAX(azc_services_precovid.loc_dt_rtc) AS loc_dt_rtc,
MAX(azc_services_precovid.loc_esu) AS loc_esu,
MAX(azc_services_precovid.loc_fsp) AS loc_fsp,
MAX(azc_services_precovid.loc_ipcaps) AS loc_ipcaps,
MAX(azc_services_precovid.loc_ip_ffs) AS loc_ip_ffs,
MAX(azc_services_precovid.loc_ip_phf) AS loc_ip_phf,
MAX(azc_services_precovid.loc_jfs) AS loc_jfs,
MAX(azc_services_precovid.loc_na) AS loc_na,
MAX(azc_services_precovid.loc_op) AS loc_op,
MAX(azc_services_precovid.loc_opr) AS loc_opr,
MAX(azc_services_precovid.loc_op_ermhs) AS loc_op_ermhs,
MAX(azc_services_precovid.loc_op_ffs) AS loc_op_ffs,
MAX(azc_services_precovid.loc_other) AS loc_other,
MAX(azc_services_precovid.loc_phf) AS loc_phf,
MAX(azc_services_precovid.loc_prv) AS loc_prv,
MAX(azc_services_precovid.loc_rtc) AS loc_rtc,
MAX(azc_services_precovid.loc_rtc_ses) AS loc_rtc_ses,
#MAX(azc_services_precovid.loc_strtp) AS loc_strtp,
MAX(azc_services_precovid.loc_strtp_plus) AS loc_strtp_plus,
MAX(azc_services_precovid.loc_sandr) AS loc_sandr,
MAX(azc_services_precovid.loc_tbs) AS loc_tbs,
MAX(azc_services_precovid.loc_uo) AS loc_uo,
MAX(azc_services_precovid.loc_wrap) AS loc_wrap,
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


# chek for clients with 3 loc types.
SELECT * FROM tmp_client_pre 
WHERE CLIENT_ID = 500066 ;

SELECT * FROM azc_services_precovid
WHERE `Client id` = 500066 ;



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
MAX(azc_services_postcovid.loc_cm) AS loc_cm,
MAX(azc_services_postcovid.loc_co) AS loc_co,
MAX(azc_services_postcovid.loc_cs) AS loc_cs,
MAX(azc_services_postcovid.loc_ctf) AS loc_ctf,
MAX(azc_services_postcovid.loc_dt) AS loc_dt,
MAX(azc_services_postcovid.loc_dtc) AS loc_dtc,
MAX(azc_services_postcovid.loc_dtr) AS loc_dtr,
MAX(azc_services_postcovid.loc_dt_ctf) AS loc_dt_ctf,
MAX(azc_services_postcovid.loc_dt_phf) AS loc_dt_phf,
MAX(azc_services_postcovid.loc_dt_rtc) AS loc_dt_rtc,
MAX(azc_services_postcovid.loc_esu) AS loc_esu,
MAX(azc_services_postcovid.loc_fsp) AS loc_fsp,
MAX(azc_services_postcovid.loc_ipcaps) AS loc_ipcaps,
MAX(azc_services_postcovid.loc_ip_ffs) AS loc_ip_ffs,
MAX(azc_services_postcovid.loc_ip_phf) AS loc_ip_phf,
MAX(azc_services_postcovid.loc_jfs) AS loc_jfs,
MAX(azc_services_postcovid.loc_na) AS loc_na,
MAX(azc_services_postcovid.loc_op) AS loc_op,
MAX(azc_services_postcovid.loc_opr) AS loc_opr,
MAX(azc_services_postcovid.loc_op_ermhs) AS loc_op_ermhs,
MAX(azc_services_postcovid.loc_op_ffs) AS loc_op_ffs,
MAX(azc_services_postcovid.loc_other) AS loc_other,
MAX(azc_services_postcovid.loc_phf) AS loc_phf,
MAX(azc_services_postcovid.loc_prv) AS loc_prv,
MAX(azc_services_postcovid.loc_rtc) AS loc_rtc,
MAX(azc_services_postcovid.loc_rtc_ses) AS loc_rtc_ses,
#MAX(azc_services_postcovid.loc_strtp) AS loc_strtp,
MAX(azc_services_postcovid.loc_strtp_plus) AS loc_strtp_plus,
MAX(azc_services_postcovid.loc_sandr) AS loc_sandr,
MAX(azc_services_postcovid.loc_tbs) AS loc_tbs,
MAX(azc_services_postcovid.loc_uo) AS loc_uo,
MAX(azc_services_postcovid.loc_wrap) AS loc_wrap,
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
DROP TABLE IF EXISTS covid_client_loc ;
CREATE TABLE covid_client_loc 
SELECT * FROM tmp_client_pre_zip
UNION
SELECT * FROM tmp_client_post_zip ;


SELECT * FROM covid_client_loc ;

SELECT * FROM covid_client WHERE timepoint = 1 ;
SELECT * FROM covid_client_loc WHERE timepoint = 1 ;
SELECT * FROM covid_client WHERE timepoint = 2 ;
SELECT * FROM covid_client_loc WHERE timepoint = 2 ;


#SELECT * FROM covid_client_loc
#WHERE CLIENT_ID = 22515 ;



