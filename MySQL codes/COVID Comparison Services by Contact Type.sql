
# telephone
SELECT
1 AS timepoint,
azc_services_precovid.`Client id` AS CLIENT_ID,
azc_services_precovid.`Case num` AS casenum,
azc_services_precovid.loc,
azc_services_precovid.service_id,
azc_services_precovid.Desc,
azc_services_precovid.CNTTYP_ID,
azc_services_precovid.`Beg date`,
azc_services_precovid.APPTYP_ID,
azc_services_precovid.PERSON_ID,
azc_services_precovid.dtfilter,
azc_services_precovid.filedate
FROM
azc_services_precovid
WHERE
azc_services_precovid.loc IN ('OP')
AND
azc_services_precovid.PERSON_ID IN ('B','C','F')
AND
azc_services_precovid.CNTTYP_ID = 'T' ;

# telehealth
SELECT
1 AS timepoint,
azc_services_precovid.`Client id` AS CLIENT_ID,
azc_services_precovid.`Case num` AS casenum,
azc_services_precovid.loc,
azc_services_precovid.service_id,
azc_services_precovid.Desc,
azc_services_precovid.CNTTYP_ID,
azc_services_precovid.`Beg date`,
azc_services_precovid.APPTYP_ID,
azc_services_precovid.PERSON_ID,
azc_services_precovid.dtfilter,
azc_services_precovid.filedate
FROM
azc_services_precovid
WHERE
azc_services_precovid.loc IN ('OP')
AND
azc_services_precovid.PERSON_ID IN ('B','C','F')
AND
azc_services_precovid.CNTTYP_ID = 'E' ;

# face to face
SELECT
1 AS timepoint,
azc_services_precovid.`Client id` AS CLIENT_ID,
azc_services_precovid.`Case num` AS casenum,
azc_services_precovid.loc,
azc_services_precovid.service_id,
azc_services_precovid.Desc,
azc_services_precovid.CNTTYP_ID,
azc_services_precovid.`Beg date`,
azc_services_precovid.APPTYP_ID,
azc_services_precovid.PERSON_ID,
azc_services_precovid.dtfilter,
azc_services_precovid.filedate
FROM
azc_services_precovid
WHERE
azc_services_precovid.loc IN ('OP')
AND
azc_services_precovid.PERSON_ID IN ('B','C','F')
AND
azc_services_precovid.CNTTYP_ID = 'F' ;



# post COVID
# telephone
SELECT
2 AS timepoint,
azc_services_postcovid.`Client id` AS CLIENT_ID,
azc_services_postcovid.`Case num` AS casenum,
azc_services_postcovid.loc,
azc_services_postcovid.service_id,
azc_services_postcovid.Desc,
azc_services_postcovid.CNTTYP_ID,
azc_services_postcovid.`Beg date`,
azc_services_postcovid.APPTYP_ID,
azc_services_postcovid.dtfilter,
azc_services_postcovid.filedate
FROM
azc_services_postcovid
WHERE
azc_services_postcovid.loc IN ('OP')
AND
azc_services_postcovid.PERSON_ID IN ('B','C','F')
AND
azc_services_postcovid.CNTTYP_ID = 'T' ;

# telehealth
SELECT
2 AS timepoint,
azc_services_postcovid.`Client id` AS CLIENT_ID,
azc_services_postcovid.`Case num` AS casenum,
azc_services_postcovid.loc,
azc_services_postcovid.service_id,
azc_services_postcovid.Desc,
azc_services_postcovid.CNTTYP_ID,
azc_services_postcovid.`Beg date`,
azc_services_postcovid.APPTYP_ID,
azc_services_postcovid.dtfilter,
azc_services_postcovid.filedate
FROM
azc_services_postcovid
WHERE
azc_services_postcovid.loc IN ('OP')
AND
azc_services_postcovid.PERSON_ID IN ('B','C','F')
AND
azc_services_postcovid.CNTTYP_ID = 'E' ;

# face to face
SELECT
2 AS timepoint,
azc_services_postcovid.`Client id` AS CLIENT_ID,
azc_services_postcovid.`Case num` AS casenum,
azc_services_postcovid.loc,
azc_services_postcovid.service_id,
azc_services_postcovid.Desc,
azc_services_postcovid.CNTTYP_ID,
azc_services_postcovid.`Beg date`,
azc_services_postcovid.APPTYP_ID,
azc_services_postcovid.dtfilter,
azc_services_postcovid.filedate
FROM
azc_services_postcovid
WHERE
azc_services_postcovid.loc IN ('OP')
AND
azc_services_postcovid.PERSON_ID IN ('B','C','F')
AND
azc_services_postcovid.CNTTYP_ID = 'F' ;