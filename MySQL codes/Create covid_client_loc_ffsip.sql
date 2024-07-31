



DROP TABLE IF EXISTS tmp_pre_clients ;
CREATE TEMPORARY TABLE tmp_pre_clients
SELECT
1 AS timepoint,
azclient.Id AS CLIENT_ID,
azclient.`Case num` AS casenum,
DATE(BG_DECRYPT3(azclient.Dob)) AS dob,
azclient.Sex,
azclient.`Eth id` AS eth_id,

loc_precovid.loc_cm,
loc_precovid.loc_co,
loc_precovid.loc_cs,
loc_precovid.loc_ctf,
loc_precovid.loc_dt,
loc_precovid.loc_dtc,
loc_precovid.loc_dtr,
loc_precovid.loc_dt_ctf,
loc_precovid.loc_dt_phf,
loc_precovid.loc_dt_rtc,
loc_precovid.loc_esu,
loc_precovid.loc_fsp,
loc_precovid.loc_ipcaps,
loc_precovid.loc_ip_ffs,
loc_precovid.loc_ip_phf,
loc_precovid.loc_jfs,
loc_precovid.loc_na,
loc_precovid.loc_op,
loc_precovid.loc_opr,
loc_precovid.loc_op_ermhs,
loc_precovid.loc_op_ffs,
loc_precovid.loc_other,
loc_precovid.loc_phf,
loc_precovid.loc_prv,
loc_precovid.loc_rtc,
loc_precovid.loc_rtc_ses,
loc_precovid.loc_strtp,
loc_precovid.loc_tbs,
loc_precovid.loc_uo,
loc_precovid.loc_wrap,
loc_precovid.minsvcdt,
loc_precovid.maxsvcdt,

ffsip_precovid.InFFSIP,
ffsip_precovid.IPFFS
FROM
azclient
LEFT JOIN loc_precovid
	ON azclient.Id = loc_precovid.CLIENT_ID
LEFT JOIN ffsip_precovid
	ON azclient.Id = ffsip_precovid.clientid 
WHERE
loc_precovid.timepoint IS NOT NULL
OR
ffsip_precovid.InFFSIP = 1 
ORDER BY
CLIENT_ID ;

SELECT * FROM tmp_pre_clients ;

SELECT * FROM tmp_pre_clients WHERE InFFSIP = 1 ;



# test adding race and dx
DROP TABLE IF EXISTS tmp_covid_client_pre ;
CREATE TEMPORARY TABLE tmp_covid_client_pre
SELECT
tmp_pre_clients.*,
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
az_client_zip_precovid.ZIP
FROM tmp_pre_clients 
LEFT JOIN azc_race_precovid 
	ON tmp_pre_clients.CLIENT_ID = azc_race_precovid.CLIENT_ID 
LEFT JOIN azc_dx_prim_precovid 
	ON tmp_pre_clients.CLIENT_ID = azc_dx_prim_precovid.CLIENT_ID
LEFT JOIN az_client_zip_precovid 
	ON tmp_pre_clients.CLIENT_ID = az_client_zip_precovid.CLIENT_ID 
ORDER BY CLIENT_ID ;


SELECT * FROM tmp_covid_client_pre ;
SELECT * FROM tmp_covid_client_pre  WHERE InFFSIP = 1 ;

