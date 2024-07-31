* Encoding: UTF-8.

* CANS CLEANING 

GET
  FILE='C:\Users\EVelandia\OneDrive - UC San Diego\My Research\History of Trauma SOCE '+
    'Paper\SPSS\Originals\CANS_COVIDdata_Domains_Race_Dx.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.


SAVE OUTFILE='C:\Users\EVelandia\OneDrive - UC San Diego\My Research\History of Trauma SOCE Paper\SPSS\CANSlong_COVID_EV_2022.05.03.sav'
  /COMPRESSED.


VALUE LABELS TM_sexab TM_physab TM_neglect TM_emoab TM_medtrauma
    TM_disaster TM_famviol TM_commviol TM_crimact TM_war TM_discgloss TM_pcrimbeh
-99 'Item not entered'
-88 'Item not visible/skipped'
9 'Response missing'
0 'No'
1 'Yes'. 

VALUE LABELS TM_emoclose TM_freqab TM_duration TM_force TM_reaction
TM_emphdys TM_intrus TM_hyparous TM_griefsep TM_numbing TM_dissoc
0 'No evidence'
1 'History or suspicion'
2 'Interferes with functioning; action needed'
3 'Disabling, dangerous; immediate or intensive action needed'. 


DATASET ACTIVATE DataSet1.
RECODE CANS_CB_Q9 (ELSE=Copy) INTO CANS_AnyTrauma.
EXECUTE.

VALUE LABELS CANS_AnyTrauma
    -99 'Item not entered'
    -88 'Item not visable/skipped'
    0 'No evidence'
    1 'History or Suspicion'
    2 'Interferes with functioning; action needed'
    3 'Disabling, dangers; immediate or intensive action needed'
    9 'Response missing'. 

RECODE CANS_CB_Q9 (0=0) (1=0) (2=1) (3=1) (ELSE=Copy) INTO CANS_AnyTraumaV2.
EXECUTE.

VALUE LABELS CANS_AnyTraumaV2
    -99 'Item not entered'
    -88 'Item not visable/skipped'
    0 'No or History'
    1 'Confirmed, affects Functioning'
    9 'Response missing'.

RECODE Gender ('M'=0) ('F'=1) ('O'=2) ('U'=3) INTO gender_code.
EXECUTE.

VALUE LABELS gender_code
    0 'Male'
    1 'Female'
    2 'Other'
    3 'Unknown'. 

DATASET ACTIVATE DataSet1.
RECODE ASSESS_TYPE (1=0) (2=1) (4=2) INTO When.
EXECUTE.

*Make sure When has no decimals and LOS is Width 8

SAVE OUTFILE='C:\Users\EVelandia\OneDrive - UC San Diego\My Research\History of Trauma SOCE Paper\SPSS\CANSlong_COVID_EV_2022.05.03.sav'
  /COMPRESSED.

****************************************************************************************************************************************************************************************************

****************************************************************************************************************************************************************************************************

*CANS Long to Wide*


* Identify Duplicate Cases.
SORT CASES BY clientId(A) CANS_ASSESSMENT_DATE(A) timepoint(A).
MATCH FILES
  /FILE=*
  /BY clientId CANS_ASSESSMENT_DATE
  /FIRST=PrimaryFirst
  /LAST=PrimaryLast.
DO IF (PrimaryFirst).
COMPUTE  MatchSequence=1-PrimaryLast.
ELSE.
COMPUTE  MatchSequence=MatchSequence+1.
END IF.
LEAVE  MatchSequence.
FORMATS  MatchSequence (f7).
COMPUTE  InDupGrp=MatchSequence>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimaryFirst InDupGrp MatchSequence.
VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary'.
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryLast (ORDINAL).
FREQUENCIES VARIABLES=PrimaryLast.
EXECUTE.

*Delete all the clients that have a 0 listed for Primary Last (not just when Primary Last = 0). 
DELETE VARIABLES PrimaryLast. 


DATASET ACTIVATE DataSet1.
* Identify Duplicate Cases.
SORT CASES BY clientId(A) CB_NEEDS(A) LD_NEEDS(A) RB_NEEDS(A) NEEDS(A) STRENGTHS(A) 
    CANS_ASSESSMENT_DATE(A).
MATCH FILES
  /FILE=*
  /BY clientId CB_NEEDS LD_NEEDS RB_NEEDS NEEDS STRENGTHS
  /FIRST=PrimaryFirst
  /LAST=PrimaryLast.
DO IF (PrimaryFirst).
COMPUTE  MatchSequence=1-PrimaryLast.
ELSE.
COMPUTE  MatchSequence=MatchSequence+1.
END IF.
LEAVE  MatchSequence.
FORMATS  MatchSequence (f7).
COMPUTE  InDupGrp=MatchSequence>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimaryLast InDupGrp MatchSequence.
VARIABLE LABELS  PrimaryFirst 'Indicator of each first matching case as Primary'.
VALUE LABELS  PrimaryFirst 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryFirst (ORDINAL).
FREQUENCIES VARIABLES=PrimaryFirst.
EXECUTE.


RECODE PrimaryFirst (ELSE=0) INTO Delete.
EXECUTE.

DO IF  (LOS = 0).
RECODE PrimaryFirst (0=1) INTO Delete.
END IF.
EXECUTE.

FILTER OFF.
USE ALL.
SELECT IF (Delete = 0).
EXECUTE.


DELETE VARIABLES PrimaryFirst Delete. 

SAVE OUTFILE='C:\Users\EVelandia\OneDrive - UC San Diego\My Research\History of Trauma SOCE Paper\SPSS\CANSlong_COVID_EV_2022.05.03.sav'
  /COMPRESSED.


SORT CASES BY clientId When.
CASESTOVARS
  /ID=clientId
  /INDEX=When
  /GROUPBY=VARIABLE.


SAVE OUTFILE='C:\Users\EVelandia\OneDrive - UC San Diego\My Research\History of Trauma SOCE Paper\SPSS\CANS-w_COVID_2022.05.03.sav'
  /COMPRESSED.


****************************************************************************************************************************************************************************************************

****************************************************************************************************************************************************************************************************

*PSCP Cleaning*

GET
  FILE='C:\Users\EVelandia\OneDrive - UC San Diego\My Research\History of Trauma SOCE '+
    'Paper\SPSS\Originals\PSCP_COVIDdata_Race.sav'.
DATASET NAME DataSet2 WINDOW=FRONT.


RECODE Gender ('M'=0) ('F'=1) ('O'=2) ('U'=3) INTO gender_code.
EXECUTE.

VALUE LABELS gender_code
    0 'Male'
    1 'Female'
    2 'Other'
    3 'Unknown'. 

COMPUTE LOS=DATEDIFF (dischargeDate,enrollmentDate, "days").
EXECUTE.

DATASET ACTIVATE DataSet2.
RECODE ASSESS_TYPE (1=0) (2=1) (4=2) INTO When.
EXECUTE.

*Make sure When and LOS has no decimals

SAVE OUTFILE='C:\Users\EVelandia\OneDrive - UC San Diego\My Research\History of Trauma SOCE Paper\SPSS\PSCPlong_COVID_EV_2022.05.03.sav'
  /COMPRESSED.


****************************************************************************************************************************************************************************************************

****************************************************************************************************************************************************************************************************

*PSCP Long to Wide*
    

DATASET ACTIVATE DataSet2.
* Identify Duplicate Cases.
SORT CASES BY clientId(A) PSC_ASSESSMENT_DATE(A) timepoint(A).
MATCH FILES
  /FILE=*
  /BY clientId PSC_ASSESSMENT_DATE
  /FIRST=PrimaryFirst
  /LAST=PrimaryLast.
DO IF (PrimaryFirst).
COMPUTE  MatchSequence=1-PrimaryLast.
ELSE.
COMPUTE  MatchSequence=MatchSequence+1.
END IF.
LEAVE  MatchSequence.
FORMATS  MatchSequence (f7).
COMPUTE  InDupGrp=MatchSequence>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimaryFirst InDupGrp MatchSequence.
VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary'.
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryLast (ORDINAL).
FREQUENCIES VARIABLES=PrimaryLast.
EXECUTE.


*Delete all the clients that have a 0 listed for Primary Last (not just when Primary Last = 0). 
DELETE VARIABLES PrimaryLast. 


* Identify Duplicate Cases.
SORT CASES BY clientId(A) PSC_Score(A) pscxattn(A) pscxattnx(A) pscxint(A) pscxintx(A) pscxext(A) 
    pscxextx(A) pscscorex(A) PSC_ASSESSMENT_DATE(A).
MATCH FILES
  /FILE=*
  /BY clientId PSC_Score pscxattn pscxattnx pscxint pscxintx pscxext pscxextx pscscorex
  /FIRST=PrimaryFirst
  /LAST=PrimaryLast1.
DO IF (PrimaryFirst).
COMPUTE  MatchSequence=1-PrimaryLast1.
ELSE.
COMPUTE  MatchSequence=MatchSequence+1.
END IF.
LEAVE  MatchSequence.
FORMATS  MatchSequence (f7).
COMPUTE  InDupGrp=MatchSequence>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimaryLast1 InDupGrp MatchSequence.
VARIABLE LABELS  PrimaryFirst 'Indicator of each first matching case as Primary'.
VALUE LABELS  PrimaryFirst 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryFirst (ORDINAL).
FREQUENCIES VARIABLES=PrimaryFirst.
EXECUTE.

RECODE PrimaryFirst (ELSE=0) INTO Delete.
EXECUTE.

DO IF  (LOS = 0).
RECODE PrimaryFirst (0=1) INTO Delete.
END IF.
EXECUTE.


FILTER OFF.
USE ALL.
SELECT IF (Delete = 0).
EXECUTE.

DELETE VARIABLES PrimaryFirst Delete. 

SAVE OUTFILE='C:\Users\EVelandia\OneDrive - UC San Diego\My Research\History of Trauma SOCE Paper\SPSS\PSCPlong_COVID_EV_2022.05.03.sav'
  /COMPRESSED.

SORT CASES BY clientId When.
CASESTOVARS
  /ID=clientId
  /INDEX=When
  /GROUPBY=VARIABLE.


SAVE OUTFILE='C:\Users\EVelandia\OneDrive - UC San Diego\My Research\History of Trauma SOCE Paper\SPSS\PSCP-w_COVID_2022.05.03.sav'
  /COMPRESSED.

DATASET ACTIVATE DataSet2. 
RENAME VARIABLES Assignment=Assignment.PSCP timepoint.0=timepoint.PSCP.0 timepoint.2=timepoint.PSCP.2
    ASSESS_TYPE.0=ASSESS_TYPE.PSCP.0 ASSESS_TYPE.2=ASSESS_TYPE_PSCP.2 ClientAssessmentId.0=ClientAssessmentId.PSCP.0
    ClientAssessmentId.2=ClientAssessmentId.PSCP.2.

SAVE OUTFILE='C:\Users\EVelandia\OneDrive - UC San Diego\My Research\History of Trauma SOCE Paper\SPSS\PSCP-w_COVID_2022.05.03.sav'
  /COMPRESSED.

****************************************************************************************************************************************************************************************************

****************************************************************************************************************************************************************************************************

*PSCY Cleaning*
    

GET
  FILE='C:\Users\EVelandia\OneDrive - UC San Diego\My Research\History of Trauma SOCE '+
    'Paper\SPSS\Originals\PSCY_COVIDdata_Race.sav'.
DATASET NAME DataSet3 WINDOW=FRONT.


SAVE OUTFILE='C:\Users\EVelandia\OneDrive - UC San Diego\My Research\History of Trauma SOCE Paper\SPSS\PSCYlong_COVID_EV_2022.05.03.sav'
  /COMPRESSED.

RECODE Gender ('M'=0) ('F'=1) ('O'=2) ('U'=3) INTO gender_code.
EXECUTE.

VALUE LABELS gender_code
    0 'Male'
    1 'Female'
    2 'Other'
    3 'Unknown'. 


COMPUTE LOS=DATEDIFF (dischargeDate,enrollmentDate, "days").
EXECUTE.

DATASET ACTIVATE DataSet3.
RECODE ASSESS_TYPE (1=0) (2=1) (4=2) INTO When.
EXECUTE.
*Make sure When and LOS have no decimals


SAVE OUTFILE='C:\Users\EVelandia\OneDrive - UC San Diego\My Research\History of Trauma SOCE Paper\SPSS\PSCYlong_COVID_EV_2022.05.03.sav'
  /COMPRESSED.


****************************************************************************************************************************************************************************************************

****************************************************************************************************************************************************************************************************

*PSCY Long to Wide*
    

DATASET ACTIVATE DataSet3.
* Identify Duplicate Cases.
SORT CASES BY clientId(A) PSCY_ASSESSMENT_DATE(A) timepoint(A).
MATCH FILES
  /FILE=*
  /BY clientId PSCY_ASSESSMENT_DATE
  /FIRST=PrimaryFirst
  /LAST=PrimaryLast.
DO IF (PrimaryFirst).
COMPUTE  MatchSequence=1-PrimaryLast.
ELSE.
COMPUTE  MatchSequence=MatchSequence+1.
END IF.
LEAVE  MatchSequence.
FORMATS  MatchSequence (f7).
COMPUTE  InDupGrp=MatchSequence>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimaryFirst InDupGrp MatchSequence.
VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary'.
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryLast (ORDINAL).
FREQUENCIES VARIABLES=PrimaryLast.
EXECUTE.


*Delete all the clients that have a 0 listed for Primary Last (not just when Primary Last = 0). 
DELETE VARIABLES PrimaryLast. 


DATASET ACTIVATE DataSet3.
* Identify Duplicate Cases.
SORT CASES BY clientId(A) PSCY_Score(A) pscyxattn(A) pscyxattnx(A) pscyxint(A) pscyxintx(A) 
    pscyxext(A) pscyxextx(A) pscyscorex(A) ASSESS_TYPE(A).
MATCH FILES
  /FILE=*
  /BY clientId PSCY_Score pscyxattn pscyxattnx pscyxint pscyxintx pscyxext pscyxextx pscyscorex
  /FIRST=PrimaryFirst
  /LAST=PrimaryLast.
DO IF (PrimaryFirst).
COMPUTE  MatchSequence=1-PrimaryLast.
ELSE.
COMPUTE  MatchSequence=MatchSequence+1.
END IF.
LEAVE  MatchSequence.
FORMATS  MatchSequence (f7).
COMPUTE  InDupGrp=MatchSequence>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimaryLast InDupGrp MatchSequence.
VARIABLE LABELS  PrimaryFirst 'Indicator of each first matching case as Primary'.
VALUE LABELS  PrimaryFirst 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryFirst (ORDINAL).
FREQUENCIES VARIABLES=PrimaryFirst.
EXECUTE.


RECODE PrimaryFirst (ELSE=0) INTO Delete.
EXECUTE.

DO IF  (LOS = 0).
RECODE PrimaryFirst (0=1) INTO Delete.
END IF.
EXECUTE.

FILTER OFF.
USE ALL.
SELECT IF (Delete = 0).
EXECUTE.

DELETE VARIABLES PrimaryFirst Delete. 

SAVE OUTFILE='C:\Users\EVelandia\OneDrive - UC San Diego\My Research\History of Trauma SOCE Paper\SPSS\PSCYlong_COVID_EV_2022.05.03.sav'
  /COMPRESSED.


SORT CASES BY clientId When.
CASESTOVARS
  /ID=clientId
  /INDEX=When
  /GROUPBY=VARIABLE.


SAVE OUTFILE='C:\Users\EVelandia\OneDrive - UC San Diego\My Research\History of Trauma SOCE Paper\SPSS\PSCY-w_COVID_2022.05.03.sav'
  /COMPRESSED.


DATASET ACTIVATE DataSet3. 
RENAME VARIABLES Assignment=Assignment.PSCY timepoint.0=timepoint.PSCY.0 timepoint.2=timepoint.PSCY.2
    ASSESS_TYPE.0=ASSESS_TYPE.PSCY.0 ASSESS_TYPE.2=ASSESS_TYPE_PSCY.2 ClientAssessmentId.0=ClientAssessmentId.PSCY.0
    ClientAssessmentId.2=ClientAssessmentId.PSCY.2.

SAVE OUTFILE='C:\Users\EVelandia\OneDrive - UC San Diego\My Research\History of Trauma SOCE Paper\SPSS\PSCY-w_COVID_2022.05.03.sav'
  /COMPRESSED.

****************************************************************************************************************************************************************************************************

****************************************************************************************************************************************************************************************************

*Merging all 3 files 
    
*Must have all three wide files open
    
DATASET ACTIVATE DataSet1.
SORT CASES BY clientId enrollmentDate dischargeDate Gender Hispanic multiracial raceeth gender_code 
    LOS.
DATASET ACTIVATE DataSet2.
SORT CASES BY clientId enrollmentDate dischargeDate Gender Hispanic multiracial raceeth gender_code 
    LOS.
DATASET ACTIVATE DataSet1.
MATCH FILES /FILE=*
  /FILE='DataSet2'
  /BY clientId enrollmentDate dischargeDate Gender Hispanic multiracial raceeth gender_code LOS.
EXECUTE.


* Identify Duplicate Cases.
SORT CASES BY clientId(A) enrollmentDate(A).
MATCH FILES
  /FILE=*
  /BY clientId
  /FIRST=PrimaryFirst
  /LAST=PrimaryLast.
DO IF (PrimaryFirst).
COMPUTE  MatchSequence=1-PrimaryLast.
ELSE.
COMPUTE  MatchSequence=MatchSequence+1.
END IF.
LEAVE  MatchSequence.
FORMATS  MatchSequence (f7).
COMPUTE  InDupGrp=MatchSequence>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimaryFirst InDupGrp MatchSequence.
VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary'.
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryLast (ORDINAL).
FREQUENCIES VARIABLES=PrimaryLast.
EXECUTE.

DELETE VARIABLES PrimaryLast.


SAVE OUTFILE='C:\Users\EVelandia\OneDrive - UC San Diego\My Research\History of Trauma SOCE Paper\SPSS\CANS_PSC_Merged_COVID_2022.05.03.sav'
  /COMPRESSED.


SORT CASES BY clientId enrollmentDate dischargeDate Gender Hispanic multiracial raceeth gender_code 
    LOS.
DATASET ACTIVATE DataSet3.
SORT CASES BY clientId enrollmentDate dischargeDate Gender Hispanic multiracial raceeth gender_code 
    LOS.
DATASET ACTIVATE DataSet1.
MATCH FILES /FILE=*
  /FILE='DataSet3'
  /BY clientId enrollmentDate dischargeDate Gender Hispanic multiracial raceeth gender_code LOS.
EXECUTE.



* Identify Duplicate Cases.
SORT CASES BY clientId(A) enrollmentDate(A).
MATCH FILES
  /FILE=*
  /BY clientId
  /FIRST=PrimaryFirst
  /LAST=PrimaryLast.
DO IF (PrimaryFirst).
COMPUTE  MatchSequence=1-PrimaryLast.
ELSE.
COMPUTE  MatchSequence=MatchSequence+1.
END IF.
LEAVE  MatchSequence.
FORMATS  MatchSequence (f7).
COMPUTE  InDupGrp=MatchSequence>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimaryFirst InDupGrp MatchSequence.
VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary'.
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryLast (ORDINAL).
FREQUENCIES VARIABLES=PrimaryLast.
EXECUTE.

DELETE VARIABLES PrimaryLast.


SAVE OUTFILE='C:\Users\EVelandia\OneDrive - UC San Diego\My Research\History of Trauma SOCE Paper\SPSS\CANS_PSC_Merged_COVID_2022.05.03.sav'
  /COMPRESSED.

DATASET CLOSE DataSet2. 
DATASET CLOSE DataSet3. 

****************************************************************************************************************************************************************************************************

****************************************************************************************************************************************************************************************************

****************************************************************************************************************************************************************************************************

*Change Calculations
    
RECODE LOS (Lowest thru 59=0) (60 thru Highest=1) INTO Open60.
EXECUTE.

VARIABLE LABELS Open60 'Open 60+ Days'. 
VALUE LABELS Open60
    1 'Yes'
    0 'No'. 

*CANS Score Change

COMPUTE CB_Needs_Change=CB_NEEDS.2 - CB_NEEDS.0.
EXECUTE.

COMPUTE LD_Needs_Change=LD_NEEDS.2 - LD_NEEDS.0.
EXECUTE.

COMPUTE RB_Needs_Change=RB_NEEDS.2 - RB_NEEDS.0.
EXECUTE.

COMPUTE Needs_Change=NEEDS.2 - NEEDS.0.
EXECUTE.

COMPUTE Strengths_Change=STRENGTHS.2 - STRENGTHS.0.
EXECUTE.

RECODE CB_Needs_Change LD_Needs_Change RB_Needs_Change (Lowest thru -1=1) (0 thru Highest=0) INTO 
    CB_Progress LD_Progress RB_Progress.
EXECUTE.

VALUE LABELS CB_Progress LD_Progress RB_Progress
    0 'No'
    1 'Yes'. 

SAVE OUTFILE='C:\Users\EVelandia\OneDrive - UC San Diego\My Research\History of Trauma SOCE Paper\SPSS\CANS_PSC_Merged_COVID_2022.05.03.sav'
  /COMPRESSED.


*PSC Score Change
    
COMPUTE PSCP_Change=PSC_Score.2 - PSC_Score.0.
EXECUTE.

COMPUTE PSCY_Change=PSCY_Score.2 - PSCY_Score.0.
EXECUTE.

RECODE PSCP_Change PSCY_Change (Lowest thru -6=1) (-5 thru Highest=0) INTO PSCP_RI PSCY_RI.
EXECUTE.

VARIABLE LABELS PSCP_RI 'Reliable Improvement for All Clients PSCP'. 
VARIABLE LABELS PSCY_RI 'Reliable Improvement for All Clients PSCY'. 

VALUE LABELS PSCP_RI PSCY_RI
    0 'No'
    1 'Yes'. 

DO IF  (Open60 = 1).
RECODE PSCP_RI PSCY_RI (ELSE=Copy) INTO PSCP_RI_60 PSCY_RI_60.
END IF.
EXECUTE.

VARIABLE LABELS PSCP_RI_60 'Reliable Improvement for LOS>=60 PSCP'.
VARIABLE LABELS PSCY_RI_60 'Reliable Improvement for LOS>=60 PSCY'.

VALUE LABELS PSCP_RI_60 PSCY_RI_60
    0 'No'
    1 'Yes'. 

SAVE OUTFILE='C:\Users\EVelandia\OneDrive - UC San Diego\My Research\History of Trauma SOCE Paper\SPSS\CANS_PSC_Merged_COVID_2022.05.03.sav'
  /COMPRESSED.


VALUE LABELS pscxattnx.0 pscxattnx.2 pscxintx.0 pscxintx.2 pscxextx.0 pscxextx.2 
    pscyxattnx.0 pscyxattnx.2 pscyxintx.0 pscyxintx.2 pscyxextx.0 pscyxextx.2
    0 'Below Cutoff'
    1 'Above Cutoff'. 

COMPUTE PSCP_Att_CC=pscxattnx.2 - pscxattnx.0.
EXECUTE.

COMPUTE PSCP_Int_CC=pscxintx.2 - pscxintx.0.
EXECUTE.

COMPUTE PSCP_Ext_CC=pscxextx.2 - pscxextx.0.
EXECUTE.

COMPUTE PSCP_Total_CC=pscscorex.2 - pscscorex.0. 
EXECUTE. 

COMPUTE PSCY_Att_CC=pscyxattnx.2 - pscyxattnx.0.
EXECUTE.

COMPUTE PSCY_Int_CC=pscyxintx.2 - pscyxintx.0.
EXECUTE.

COMPUTE PSCY_Ext_CC=pscyxextx.2 - pscyxextx.0.
EXECUTE.

COMPUTE PSCY_Total_CC=pscyscorex.2 - pscyscorex.0. 
EXECUTE. 


VARIABLE LABELS PSCP_Att_CC 'PSCP Attention Cutoff Change' PSCP_Int_CC 'PSCP Internalizing Cutoff Change' PSCP_Ext_CC 'PSCP Externalizing Cutoff Change'
    PSCP_Total_CC 'PSCP Total Cutoff Change' PSCY_Att_CC 'PSCY Attention Cutoff Change' PSCY_Int_CC 'PSCY Internalizing Cutoff Change' 
    PSCY_Ext_CC 'PSCY Externalizing Cutoff Change' PSCY_Total_CC 'PSCY Total Cutoff Change'.

VALUE LABELS PSCP_Att_CC PSCP_Int_CC PSCP_Ext_CC PSCP_Total_CC
    PSCY_Att_CC PSCY_Int_CC PSCY_Ext_CC PSCY_Total_CC
    -1 'Moved Below Cutoff'
    0 'Stayed the Same'
    1 'Moved Above Cutoff'. 

RECODE PSCP_Change (MISSING=SYSMIS) (ELSE=0) INTO PSCP_CSI.
EXECUTE.

DO IF  (((PSCP_Att_CC = -1) OR (PSCP_Int_CC = -1) OR (PSCP_Ext_CC =-1) OR (PSCP_Total_CC=-1))  & 
    PSCP_RI = 1).
RECODE PSCP_Change (ELSE=1) INTO PSCP_CSI.
END IF.
EXECUTE.

RECODE PSCY_Change (MISSING=SYSMIS) (ELSE=0) INTO PSCY_CSI.
EXECUTE.

DO IF  (((PSCY_Att_CC = -1) OR (PSCY_Int_CC = -1) OR (PSCY_Ext_CC =-1) OR (PSCY_Total_CC=-1))  & 
    PSCY_RI = 1).
RECODE PSCY_Change (ELSE=1) INTO PSCY_CSI.
END IF.
EXECUTE.

VARIABLE LABELS PSCP_CSI 'Clinically Significant Improvement for All Clients - PSCP'
    PSCY_CSI 'Clinically Significant Improvement for All Clients - PSCY'.

VALUE LABELS PSCP_CSI PSCY_CSI
    0 'No'
    1 'Yes'.

DO IF  (Open60 = 1).
RECODE PSCP_CSI PSCY_CSI (ELSE=Copy) INTO PSCP_CSI_60 PSCY_CSI_60.
END IF.
EXECUTE.

VARIABLE LABELS PSCP_CSI_60 'Clinically Significant Improvement LOS >=60 - PSCP'
    PSCY_CSI_60 'Clinically Significant Improvement LOS >=60 - PSCY'.

VALUE LABELS PSCP_CSI_60 PSCY_CSI_60
    0 'No'
    1 'Yes'.

SAVE OUTFILE='C:\Users\EVelandia\OneDrive - UC San Diego\My Research\History of Trauma SOCE Paper\SPSS\CANS_PSC_Merged_COVID_2022.05.03.sav'
  /COMPRESSED.


****************************************************************************************************************************************************************************************************

****************************************************************************************************************************************************************************************************

****************************************************************************************************************************************************************************************************

*Outcomes Frequency and Descriptives
    

FREQUENCIES VARIABLES=CB_Progress LD_Progress RB_Progress PSCP_RI PSCY_RI PSCP_RI_60 PSCY_RI_60 
    PSCP_CSI PSCY_CSI PSCP_CSI_60 PSCY_CSI_60
  /ORDER=ANALYSIS.


CROSSTABS
  /TABLES=PSCP_RI PSCY_RI PSCP_RI_60 PSCY_RI_60 PSCP_CSI PSCY_CSI PSCP_CSI_60 PSCY_CSI_60 
    CB_Progress LD_Progress RB_Progress BY CANS_AnyTrauma.0
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT
  /COUNT ROUND CELL.
