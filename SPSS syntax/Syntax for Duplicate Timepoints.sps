* Encoding: UTF-8.

RECODE clientId (MISSING=-99) INTO Same.0.

DATASET ACTIVATE DataSet1.
DO IF  (timepoint.0 = timepoint.PSCY.0 = timepoint.PSCP.0).
RECODE clientId (ELSE=1) INTO Same.0.
END IF.
EXECUTE.

DO IF  NOT(timepoint.0 = timepoint.PSCY.0 = timepoint.PSCP.0).
RECODE clientId (ELSE=0) INTO Same.0.
END IF.
EXECUTE.

RECODE clientId (MISSING=-99) INTO Same.2.

DATASET ACTIVATE DataSet1.
DO IF  (timepoint.2 = timepoint.PSCY.2 = timepoint.PSCP.2).
RECODE clientId (MISSING=-99) (ELSE=1) INTO Same.2.
END IF.
EXECUTE.

DO IF  NOT(timepoint.2 = timepoint.PSCY.2 = timepoint.PSCP.2).
RECODE clientId (ELSE=0) INTO Same.2.
END IF.
EXECUTE.

VALUE LABELS Same.0 Same.2
    0 'Not the Same Across All 3'
    1 'Same Across All 3'. 


FREQUENCIES VARIABLES=Same.0 Same.2
  /ORDER=ANALYSIS.


************************************************************************************************************

RECODE clientId (MISSING=-99) INTO CANS_PSCP_S.0.
RECODE clientId (MISSING=-99) INTO CANS_PSCP_S.2.
RECODE clientId (MISSING=-99) INTO CANS_PSCY_S.0.
RECODE clientId (MISSING=-99) INTO CANS_PSCY_S.2.
RECODE clientId (MISSING=-99) INTO PSCP_PSCY_S.0.
RECODE clientId (MISSING=-99) INTO PSCP_PSCY_S.2.

DO IF  NOT(timepoint.0 = timepoint.PSCP.0).
RECODE clientId (ELSE=0) INTO CANS_PSCP_S.0.
END IF. 
EXECUTE. 

DO IF  (timepoint.0 = timepoint.PSCP.0).
RECODE clientId (ELSE=1) INTO CANS_PSCP_S.0.
END IF. 
EXECUTE. 

DO IF  NOT(timepoint.2 = timepoint.PSCP.2).
RECODE clientId (ELSE=0) INTO CANS_PSCP_S.2.
END IF. 
EXECUTE. 

DO IF  (timepoint.2 = timepoint.PSCP.2).
RECODE clientId (ELSE=1) INTO CANS_PSCP_S.2.
END IF. 
EXECUTE. 


-

DO IF  NOT(timepoint.0 = timepoint.PSCY.0).
RECODE clientId (ELSE=0) INTO CANS_PSCY_S.0.
END IF. 
EXECUTE. 

DO IF  (timepoint.0 = timepoint.PSCY.0).
RECODE clientId (ELSE=1) INTO CANS_PSCY_S.0.
END IF. 
EXECUTE. 

DO IF  NOT(timepoint.2 = timepoint.PSCY.2).
RECODE clientId (ELSE=0) INTO CANS_PSCY_S.2.
END IF. 
EXECUTE. 

DO IF  (timepoint.2 = timepoint.PSCY.2).
RECODE clientId (ELSE=1) INTO CANS_PSCY_S.2.
END IF. 
EXECUTE. 

-

DO IF  NOT(timepoint.PSCP.0 = timepoint.PSCY.0).
RECODE clientId (ELSE=0) INTO PSCP_PSCY_S.0.
END IF. 
EXECUTE. 

DO IF  (timepoint.PSCP.0 = timepoint.PSCY.0).
RECODE clientId (ELSE=1) INTO PSCP_PSCY_S.0.
END IF. 
EXECUTE. 

DO IF  NOT(timepoint.PSCP.2 = timepoint.PSCY.2).
RECODE clientId (ELSE=0) INTO PSCP_PSCY_S.2.
END IF. 
EXECUTE. 

DO IF  (timepoint.PSCP.2 = timepoint.PSCY.2).
RECODE clientId (ELSE=1) INTO PSCP_PSCY_S.2.
END IF. 
EXECUTE. 


VALUE LABELS CANS_PSCP_S.0 CANS_PSCP_S.2 CANS_PSCY_S.0 CANS_PSCY_S.2
    PSCP_PSCY_S.0 PSCP_PSCY_S.2
    0 'Not the Same'
    1 'The Same'. 

FREQUENCIES VARIABLES=CANS_PSCP_S.0 CANS_PSCP_S.2 CANS_PSCY_S.0 CANS_PSCY_S.2
    PSCP_PSCY_S.0 PSCP_PSCY_S.2
  /ORDER=ANALYSIS.
