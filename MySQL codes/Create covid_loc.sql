# 3/28/22 using assignments for IP LOC 

# precovid March 2019 - February 2020 (2019-03-01, 2020-02-29 leap year)  age date 2019-01-01
# postyear1 March 2020 – February 2021 (2020-03-01, 2021-02-28) age date 2020-01-01
# postyear2 March 2021 - February 2022 (2021-03-01, 2022-02-28) age date 2021-01-01

# pre covid

DROP TABLE IF EXISTS tmp_assign_precovid;
CREATE TABLE tmp_assign_precovid
SELECT
azc_assignments.Id,
azc_assignments.clientid,
azc_assignments.`Case num` AS casenum,
azc_assignments.`Unit id` AS unit,
azc_assignments.unitnam,
azc_assignments.`Sub unit id` AS subunit,
azc_assignments.sunitnam,
azc_assignments.`Date opened` AS dtopened,
azc_assignments.`Date closed` AS dtclosed,
azc_assignments.azloc,
CONCAT([$bgndate],",",[$enddate]) AS dtfilter,
azc_assignments.filedate,
azc_assignments.creatdt
FROM
azc_assignments
WHERE
azc_assignments.`Date opened` BETWEEN [$bgndate] AND [$enddate] ;

SELECT * FROM tmp_assign_precovid ;


DROP TABLE IF EXISTS tmp_client_precovid;
CREATE TABLE tmp_client_precovid
SELECT
COUNT(tmp_assign_precovid.clientid) AS asgncount,
tmp_assign_precovid.clientid,
tmp_assign_precovid.azloc,
MIN(tmp_assign_precovid.dtopened) AS minopendt,
MAX(tmp_assign_precovid.dtopened) AS maxopendt,
tmp_assign_precovid.dtfilter,
tmp_assign_precovid.filedate
FROM
tmp_assign_precovid
GROUP BY
tmp_assign_precovid.clientid,
tmp_assign_precovid.azloc ;

SELECT * FROM tmp_client_precovid ;

DROP TABLE IF EXISTS tmp_loc_precovid;
CREATE TABLE tmp_loc_precovid
SELECT
1 AS timepoint,
COUNT(tmp_client_precovid.azloc) AS loccount,
tmp_client_precovid.azloc,
#MIN(tmp_assign_precovid.dtopened) AS minopendt,
#MAX(tmp_assign_precovid.dtopened) AS maxopendt,
tmp_client_precovid.dtfilter AS predtfilter
FROM
tmp_client_precovid
GROUP BY
tmp_client_precovid.azloc ;

SELECT * FROM tmp_loc_precovid ;


/*
# post covid/year 1

DROP TABLE IF EXISTS tmp_assign_precovid;
CREATE TABLE tmp_assign_precovid
SELECT
azc_assignments.Id,
azc_assignments.clientid,
azc_assignments.`Case num` AS casenum,
azc_assignments.`Unit id` AS unit,
azc_assignments.unitnam,
azc_assignments.`Sub unit id` AS subunit,
azc_assignments.sunitnam,
azc_assignments.`Date opened` AS dtopened,
azc_assignments.`Date closed` AS dtclosed,
azc_assignments.azlocx,
azc_assignments.azloc,
CONCAT([$bgndate],",",[$enddate]) AS dtfilter,
azc_assignments.filedate,
azc_assignments.creatdt
FROM
azc_assignments
WHERE
azc_assignments.`Date opened` BETWEEN [$bgndate] AND [$enddate] ;

SELECT * FROM tmp_assign_postcovid ;

DROP TABLE IF EXISTS tmp_assign_postcovid;
CREATE TABLE tmp_assign_postcovid
SELECT
1 AS timepoint,
COUNT(tmp_assign_precovid.azloc) AS loccount,
tmp_assign_precovid.azloc,
MIN(tmp_assign_precovid.dtopened) AS minopendt,
MAX(tmp_assign_precovid.dtopened) AS maxopendt,
tmp_assign_precovid.dtfilter AS postdtfilter
FROM
tmp_assign_postcovid
GROUP BY
tmp_assign_postcovid.azloc ;

SELECT * FROM tmp_assign_postcovid ;

*/
