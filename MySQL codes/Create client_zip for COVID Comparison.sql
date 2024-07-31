# 3/18/22 for expanded pandemic impact 

# precovid cutoff date 2020-02-29

DROP TABLE IF EXISTS az_client_zip_precovid ;
CREATE TABLE az_client_zip_precovid 
SELECT
trclqdem.CLIENT_ID,
trclqdem.RECNUM,
trclqdem.ZIP,
DATE(trclqdem.FREEZE_DATE) AS FREEZE_DATE,
trclqdem.filedate,
DATE(NOW()) AS createdate,
'2020-02-29' AS datefilter
FROM
trclqdem
INNER JOIN
(SELECT MAX(RECNUM) AS RECNUM
	FROM trclqdem
  WHERE
  trclqdem.ZIP IS NOT NULL
  AND trclqdem.FREEZE_DATE <= '2020-02-29'
	GROUP BY trclqdem.CLIENT_ID) as t2
ON
trclqdem.RECNUM = t2.RECNUM;

SELECT * FROM az_client_zip_precovid ;

SELECT MAX(FREEZE_DATE) FROM az_client_zip_precovid ;



# postcovid cutoff date 2021-02-28

DROP TABLE IF EXISTS az_client_zip_postcovid ;
CREATE TABLE az_client_zip_postcovid 
SELECT
trclqdem.CLIENT_ID,
trclqdem.RECNUM,
trclqdem.ZIP,
DATE(trclqdem.FREEZE_DATE) AS FREEZE_DATE,
trclqdem.filedate,
DATE(NOW()) AS createdate,
'2021-02-28' AS datefilter
FROM
trclqdem
INNER JOIN
(SELECT MAX(RECNUM) AS RECNUM
	FROM trclqdem
  WHERE
  trclqdem.ZIP IS NOT NULL
  AND trclqdem.FREEZE_DATE <= '2021-02-28'
	GROUP BY trclqdem.CLIENT_ID) as t2
ON
trclqdem.RECNUM = t2.RECNUM;

SELECT * FROM az_client_zip_postcovid ;

SELECT MAX(FREEZE_DATE) FROM az_client_zip_postcovid ;