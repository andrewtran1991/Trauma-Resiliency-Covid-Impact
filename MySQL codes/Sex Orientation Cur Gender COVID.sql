# 11/21/17 to replace POS_SEX
# USE PERIOD FROM BEGINNING OF PREVIOUS FY TO END OF REPORT FY
# 1/12/18 added current gender MED_HX
# origonal date range trclqph.FREEZE_DATE BETWEEN '2018-06-01' AND '2020-06-30'
# 7/20/21 expand to 6/30/21


DROP TABLE IF EXISTS tmp_azsexorien;
CREATE TEMPORARY TABLE tmp_azsexorien

SELECT
trclqph.RECNUM,
trclqph.CLIENT_ID,
trclqph.TRT_PLAN_ID,
trclqph.DEL_FLAG,
trclqph.FREEZE_DATE,
trclqph.SIG_HEALTH,
SUBSTRING(trclqph.SIG_HEALTH,1,1) AS sexorien1,
SUBSTRING(trclqph.SIG_HEALTH,3,1) AS sexorien2,
IF(SUBSTRING(trclqph.SIG_HEALTH,3,1) NOT IN('','9'),1,0) AS sexmulti,
trclqph.MED_HX,
SUBSTRING(trclqph.MED_HX,1,1) AS curgendr1,
SUBSTRING(trclqph.MED_HX,3,1) AS curgendr2,
IF(SUBSTRING(trclqph.MED_HX,3,1) NOT IN('','9'),1,0) AS gendrmulti,
trclqph.filedate,
NOW() as createdt
FROM
trclqph
#HAVING sexmulti = 1

INNER JOIN
(SELECT MAX(RECNUM) AS RECNUM
	FROM trclqph
	WHERE trclqph.SIG_HEALTH IS NOT NULL AND
	trclqph.SIG_HEALTH <> "" AND
  trclqph.FREEZE_DATE BETWEEN '2018-06-01' AND '2021-06-30'
	GROUP BY trclqph.CLIENT_ID) as t2
ON
trclqph.RECNUM = t2.RECNUM;

ALTER TABLE tmp_azsexorien ADD INDEX (CLIENT_ID) ;

SELECT * FROM tmp_azsexorien ;

# add casenum for merging
DROP TABLE IF EXISTS azsexorien_covid ;
CREATE TABLE azsexorien_covid
SELECT 
azclient.`Case num` AS casenum,
tmp_azsexorien.*
FROM
tmp_azsexorien LEFT JOIN azclient
	ON tmp_azsexorien.CLIENT_ID = azclient.Id
ORDER BY 
azclient.`Case num` ;

SELECT * FROM azsexorien_covid ;


