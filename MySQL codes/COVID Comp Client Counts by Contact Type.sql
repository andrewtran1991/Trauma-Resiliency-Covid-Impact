
# telephone
SELECT
1 AS timepoint,
azc_services_precovid.`Client id` AS CLIENT_ID,
azc_services_precovid.loc,
azc_services_precovid.CNTTYP_ID
FROM
azc_services_precovid
WHERE
azc_services_precovid.loc IN ('OP')
AND
azc_services_precovid.CNTTYP_ID = 'T' 
GROUP BY azc_services_precovid.`Client id` ;

# telehealth
SELECT
1 AS timepoint,
azc_services_precovid.`Client id` AS CLIENT_ID,
azc_services_precovid.`Case num` AS casenum,
azc_services_precovid.loc,
azc_services_precovid.CNTTYP_ID
FROM
azc_services_precovid
WHERE
azc_services_precovid.loc IN ('OP')
AND
azc_services_precovid.CNTTYP_ID = 'E'
GROUP BY azc_services_precovid.`Client id` ;

# face to face
SELECT
1 AS timepoint,
azc_services_precovid.`Client id` AS CLIENT_ID,
azc_services_precovid.`Case num` AS casenum,
azc_services_precovid.loc,
azc_services_precovid.CNTTYP_ID
FROM
azc_services_precovid
WHERE
azc_services_precovid.loc IN ('OP')
AND
azc_services_precovid.CNTTYP_ID = 'F' 
GROUP BY azc_services_precovid.`Client id` ;


# post COVID
# telephone
SELECT
2 AS timepoint,
azc_services_postcovid.`Client id` AS CLIENT_ID,
azc_services_postcovid.`Case num` AS casenum,
azc_services_postcovid.loc,
azc_services_postcovid.CNTTYP_ID
FROM
azc_services_postcovid
WHERE
azc_services_postcovid.loc IN ('OP')
AND
azc_services_postcovid.CNTTYP_ID = 'T' 
GROUP BY azc_services_postcovid.`Client id` ;

# telehealth
SELECT
2 AS timepoint,
azc_services_postcovid.`Client id` AS CLIENT_ID,
azc_services_postcovid.`Case num` AS casenum,
azc_services_postcovid.loc,
azc_services_postcovid.APPTYP_ID
FROM
azc_services_postcovid
WHERE
azc_services_postcovid.loc IN ('OP')
AND
azc_services_postcovid.CNTTYP_ID = 'E' 
GROUP BY azc_services_postcovid.`Client id` ;

# face to face
SELECT
2 AS timepoint,
azc_services_postcovid.`Client id` AS CLIENT_ID,
azc_services_postcovid.`Case num` AS casenum,
azc_services_postcovid.loc,
azc_services_postcovid.CNTTYP_ID
FROM
azc_services_postcovid
WHERE
azc_services_postcovid.loc IN ('OP')
AND
azc_services_postcovid.CNTTYP_ID = 'F' 
GROUP BY azc_services_postcovid.`Client id` ;