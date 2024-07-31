# 2/22/10
# 5/14/10 changed to use view mv_maxrace
# 3/24/21 change to not use mv_maxrace
# 4/12/21 for pre/post covid comparisons
# 3/11/22 for new date ranges: most recent for each timepoint (2/29/20 or 2/28/21)
/*
UPDATE azrace
SET azrace.freezedtm=CONCAT(SUBSTRING(azrace.`Freeze date`,7,4),':',
	SUBSTRING(azrace.`Freeze date`,1,2),':',
	SUBSTRING(azrace.`Freeze date`,4,2),':',
	TRIM(azrace.`Freeze time`)),
 azrace.race1=SUBSTRING(azrace.`Race`,1,1),
 azrace.race2=SUBSTRING(azrace.`Race`,3,1),
 azrace.multi=IF(SUBSTRING(azrace.`Race`,3,1) NOT IN('','9'),1,0) ;
*/

DROP TABLE IF EXISTS tmp_azc_race ;
CREATE TEMPORARY TABLE tmp_azc_race
SELECT
azrace.`Client id` AS CLIENT_ID,
azrace.`Trt plan id`,
azrace.`Del flag`,
azrace.Race,
azrace.race1,
race1lu.description AS race1desc,
race1lu.racecode AS racecode1,
race1lu.racegrp AS racegrp1,
azrace.race2,
race2lu.description AS race2desc,
race2lu.racecode AS racecode2,
race2lu.racegrp AS racegrp2,
azrace.multi,
azrace.Recnum,
[$ENDDATE] AS dtfilter,
azrace.filedate,
DATE(NOW()) AS createdt
FROM
azrace
Left Join azlu_race AS race1lu ON azrace.race1 = race1lu.id
Left Join azlu_race AS race2lu ON azrace.race2 = race2lu.id 
INNER JOIN
(SELECT 
	MAX(azrace.Recnum) AS maxrecnum
	FROM azrace
	WHERE 
	azrace.Race IS NOT NULL
  AND azrace.`Freeze date` <= [$ENDDATE]
	GROUP BY azrace.`Client id`) as t2
 ON t2.maxrecnum = azrace.Recnum ;

SELECT * FROM tmp_azc_race ;


# 3/10/22 new date ranges: pre 2020-02-29 post 2021-02-28

/*
DROP TABLE IF EXISTS azc_race_precovid ;
CREATE TABLE azc_race_precovid
SELECT * FROM tmp_azc_race ;

ALTER TABLE azc_race_precovid ADD INDEX (CLIENT_ID) ;

SELECT * FROM azc_race_precovid ;
*/


DROP TABLE IF EXISTS azc_race_postcovid ;
CREATE TABLE azc_race_postcovid
SELECT * FROM tmp_azc_race ;

ALTER TABLE azc_race_postcovid ADD INDEX (CLIENT_ID) ;

SELECT * FROM azc_race_postcovid ;











#SELECT * FROM azc_race ;

/*
select 
        `socedb`.`azrace`.`Client id` AS `Client id`,
        max(`socedb`.`azrace`.`Recnum`) AS `maxrecnum`,
        count(`socedb`.`azrace`.`Recnum`) AS `count`
    from
        `azrace`
    where
        (`socedb`.`azrace`.`Race` is not null)
    group by `socedb`.`azrace`.`Client id`
    order by `socedb`.`azrace`.`Client id` 
*/