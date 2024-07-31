* Encoding: UTF-8.

*Compare the intake outcomes between trauma and w/o trauma groups

DATASET ACTIVATE DataSet1.
T-TEST GROUPS=CANS_AnyTraumaV2.0(0 1)
  /MISSING=ANALYSIS
  /VARIABLES=PSC_Score.0
  /ES DISPLAY(TRUE)
  /CRITERIA=CI(.95).

T-TEST GROUPS=CANS_AnyTraumaV2.0(0 1)
  /MISSING=ANALYSIS
  /VARIABLES=PSCY_Score.0
  /ES DISPLAY(TRUE)
  /CRITERIA=CI(.95).


T-TEST GROUPS=CANS_AnyTraumaV2.0(0 1)
  /MISSING=ANALYSIS
  /VARIABLES=CB_NEEDS.0 LD_NEEDS.0 RB_NEEDS.0 NEEDS.0
  /ES DISPLAY(TRUE)
  /CRITERIA=CI(.95).

T-TEST GROUPS=CANS_AnyTraumaV2.0(0 1)
  /MISSING=ANALYSIS
  /VARIABLES=STRENGTHS.0
  /ES DISPLAY(TRUE)
  /CRITERIA=CI(.95).

T-TEST GROUPS=CANS_AnyTraumaV2.0(0 1)
  /MISSING=ANALYSIS
  /VARIABLES=pscxattn.0 pscxint.0 pscxext.0
  /ES DISPLAY(TRUE)
  /CRITERIA=CI(.95).

T-TEST GROUPS=CANS_AnyTraumaV2.0(0 1)
  /MISSING=ANALYSIS
  /VARIABLES=pscyxattn.0 pscyxint.0 pscyxext.0
  /ES DISPLAY(TRUE)
  /CRITERIA=CI(.95).

*Compare the intake outcomes by years between trauma and w/o trauma groups
    

