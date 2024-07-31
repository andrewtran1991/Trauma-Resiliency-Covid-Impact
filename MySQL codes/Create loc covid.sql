# pre-COVID = 2019-04-01,2019-12-31
# post-COVID = 2020-14-01,2020-12-31


DROP TABLE IF EXISTS loc_precovid ;
CREATE TABLE loc_precovid
SELECT
1 AS timepoint,
azc_services_precovid.`Client id` AS CLIENT_ID,

/*
azc_services_precovid.`Case num` AS casenum,
azc_services_precovid.age,
azc_services_precovid.agedate,
azc_services_precovid.Sex,
azc_services_precovid.`Eth id` AS ethid,
*/

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
MAX(azc_services_precovid.loc_strtp) AS loc_strtp,
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
azc_services_precovid.`Client id`
ORDER BY
azc_services_precovid.`Client id` ;

SELECT * FROM loc_precovid ;



DROP TABLE IF EXISTS loc_postcovid ;
CREATE TABLE loc_postcovid
SELECT
1 AS timepoint,
azc_services_postcovid.`Client id` AS CLIENT_ID,
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
MAX(azc_services_postcovid.loc_strtp) AS loc_strtp,
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
azc_services_postcovid.`Client id`
ORDER BY
azc_services_postcovid.`Client id` ;

SELECT * FROM loc_postcovid ;