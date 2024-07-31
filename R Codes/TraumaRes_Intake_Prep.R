# 1. Data Preparation ----
rm(list=ls())
library(rstatix)
library(dplyr)
library(haven)
library(tidyverse)
library(ggpubr)
library(expss)
library(ggplot2)
library(car)
library(fastDummies)
library(openxlsx)
source("TraumaAnalysis_Functions.R")
options(dplyr.print_max = 1e9)

data_path <- "Z:/SOCE_STUDIES/PROTECTED/Trauma and Resiliency Data"

# Read in the outcome dataset for CCBH, CANS, PSCP and PSCY
## CANS ##################################################
CANS_dat_raw <- read_sav(paste0(data_path, "/CANSdata_Trauma.sav"))
CANS_dat_raw <- PI_period_setup(CANS_dat_raw, CANS_dat_raw$CANS_ASSESSMENT_DATE)
CANS_dat_intake <- CANS_dat_raw %>%
  filter(!is.na(PI_period)) %>%
  filter(ASSESS_TYPE==1) %>%
  filter(initage <= 25) %>%
  distinct() %>%
  group_by(PI_period, clientUsername) %>%
  arrange(CANS_ASSESSMENT_DATE) %>%
  mutate(n_service_per_PI_period = row_number()) %>%
  ungroup()
  
CANS_dat_discharge <- CANS_dat_raw %>%
  filter(!is.na(PI_period)) %>%
  filter(ASSESS_TYPE==4) %>%
  filter(initage <= 25) %>%
  distinct() %>%
  group_by(PI_period, clientUsername) %>%
  arrange(CANS_ASSESSMENT_DATE) %>%
  mutate(n_service_per_PI_period = row_number()) %>%
  ungroup()


# CANS Number Checks
# Intake
CANS_dat_intake %>% group_by(PI_period) %>% 
  summarise(n = n(), perc = n/nrow(CANS_dat_intake)) # Number of records per PI_period

CANS_dat_intake %>% group_by(PI_period, clientUsername) %>% 
  arrange(CANS_ASSESSMENT_DATE) %>%
  filter(row_number()==1) %>%
  ungroup() %>%
  group_by(PI_period) %>%
  summarise(n = n(), perc = n/nrow(CANS_dat_intake)) # Number of unique clients per PI_period

CANS_dat_intake %>% group_by(PI_period) %>% 
  filter(n_service_per_PI_period > 1) %>%
  distinct(clientUsername) %>%
  summarise(n = n(), perc = n/nrow(CANS_dat_intake)) # Number of clients with 2+ services per PI_period

# Discharge
CANS_dat_discharge %>% group_by(PI_period) %>% 
  summarise(n = n(), perc = n/nrow(CANS_dat_discharge)) # Number of records per PI_period

CANS_dat_discharge %>% group_by(PI_period, clientUsername) %>% 
  arrange(CANS_ASSESSMENT_DATE) %>%
  filter(row_number()==1) %>%
  ungroup() %>%
  group_by(PI_period) %>%
  summarise(n = n(), perc = n/nrow(CANS_dat_discharge)) # Number of unique clients per PI_period

CANS_dat_discharge %>% group_by(PI_period) %>% 
  filter(n_service_per_PI_period > 1) %>%
  distinct(clientUsername) %>%
  summarise(n = n(), perc = n/nrow(CANS_dat_discharge)) # Number of clients with 2+ services per PI_period

## CCBH ##################################################
CCBH_dat_raw <- readxl::read_excel(paste0(data_path, "/covid_client_trauma_20240626.xlsx"))
CCBH_dat_clean <- CCBH_dat_raw %>%
  mutate(PI_period = case_when(timepoint==1 ~'Year Pre',
                               timepoint==2 ~'Year 1',
                               timepoint==3 ~'Year 2',
                               timepoint==4 ~'Year 3',
                               timepoint==5 ~'Year 4'))

CCBH_dat_clean %>% group_by(PI_period) %>% 
  summarise(n = n(), perc = n/nrow(CCBH_dat_clean)) # Number of records/clients per PI_period

## PSC-P ##################################################
PSCP_dat_raw <- read_sav(paste0(data_path, "/PSCPdata_Trauma.sav"))
PSCP_dat_raw <- PI_period_setup(PSCP_dat_raw, PSCP_dat_raw$PSC_ASSESSMENT_DATE)

PSCP_dat_intake <- PSCP_dat_raw %>%
  filter(!is.na(PI_period)) %>%
  filter(PSC_ASSESS_TYPE==1) %>%
  filter(PSC_initage <= 18) %>%
  distinct() %>%
  group_by(PI_period, clientUsername) %>%
  arrange(PSC_ASSESSMENT_DATE) %>%
  mutate(n_service_per_PI_period = row_number()) %>%
  ungroup()

PSCP_dat_discharge <- PSCP_dat_raw %>%
  filter(!is.na(PI_period)) %>%
  filter(PSC_ASSESS_TYPE==4) %>%
  filter(PSC_initage <= 18) %>%
  distinct() %>%
  group_by(PI_period, clientUsername) %>%
  arrange(PSC_ASSESSMENT_DATE) %>%
  mutate(n_service_per_PI_period = row_number()) %>%
  ungroup()


# PSCP Number Checks
# Intake
PSCP_dat_intake %>% group_by(PI_period) %>% 
  summarise(n = n(), perc = n/nrow(PSCP_dat_intake)) # Number of records per PI_period

PSCP_dat_intake %>% group_by(PI_period, clientUsername) %>% 
  arrange(PSC_ASSESSMENT_DATE) %>%
  filter(row_number()==1) %>%
  ungroup() %>%
  group_by(PI_period) %>%
  summarise(n = n(), perc = n/nrow(PSCP_dat_intake)) # Number of unique clients per PI_period

PSCP_dat_intake %>% group_by(PI_period) %>% 
  filter(n_service_per_PI_period > 1) %>%
  distinct(clientUsername) %>%
  summarise(n = n(), perc = n/nrow(PSCP_dat_intake)) # Number of clients with 2+ services per PI_period

# Discharge
PSCP_dat_discharge %>% group_by(PI_period) %>% 
  summarise(n = n(), perc = n/nrow(PSCP_dat_discharge)) # Number of records per PI_period

PSCP_dat_discharge %>% group_by(PI_period, clientUsername) %>% 
  arrange(PSC_ASSESSMENT_DATE) %>%
  filter(row_number()==1) %>%
  ungroup() %>%
  group_by(PI_period) %>%
  summarise(n = n(), perc = n/nrow(PSCP_dat_discharge)) # Number of unique clients per PI_period

PSCP_dat_discharge %>% group_by(PI_period) %>% 
  filter(n_service_per_PI_period > 1) %>%
  distinct(clientUsername) %>%
  summarise(n = n(), perc = n/nrow(PSCP_dat_discharge)) # Number of clients with 2+ services per PI_period

## PSC-Y ##################################################
PSCY_dat_raw <- read_sav(paste0(data_path, "/PSCYdata_Trauma.sav"))
PSCY_dat_raw <- PI_period_setup(PSCY_dat_raw, PSCY_dat_raw$PSCY_ASSESSMENT_DATE)

PSCY_dat_intake <- PSCY_dat_raw %>%
  filter(!is.na(PI_period)) %>%
  filter(PSCY_ASSESS_TYPE==1) %>%
  filter(PSCY_initage <= 18) %>%
  distinct() %>%
  group_by(PI_period, clientUsername) %>%
  arrange(PSCY_ASSESSMENT_DATE) %>%
  mutate(n_service_per_PI_period = row_number()) %>%
  ungroup()

PSCY_dat_discharge <- PSCY_dat_raw %>%
  filter(!is.na(PI_period)) %>%
  filter(PSCY_ASSESS_TYPE==4) %>%
  filter(PSCY_initage <= 18) %>%
  distinct() %>%
  group_by(PI_period, clientUsername) %>%
  arrange(PSCY_ASSESSMENT_DATE) %>%
  mutate(n_service_per_PI_period = row_number()) %>%
  ungroup()


# PSCY Number Checks
# Intake
PSCY_dat_intake %>% group_by(PI_period) %>% 
  summarise(n = n(), perc = n/nrow(PSCY_dat_intake)) # Number of records per PI_period

PSCY_dat_intake %>% group_by(PI_period, clientUsername) %>% 
  arrange(PSCY_ASSESSMENT_DATE) %>%
  filter(row_number()==1) %>%
  ungroup() %>%
  group_by(PI_period) %>%
  summarise(n = n(), perc = n/nrow(PSCY_dat_intake)) # Number of unique clients per PI_period

PSCY_dat_intake %>% group_by(PI_period) %>% 
  filter(n_service_per_PI_period > 1) %>%
  distinct(clientUsername) %>%
  summarise(n = n(), perc = n/nrow(PSCY_dat_intake)) # Number of clients with 2+ services per PI_period

# Discharge
PSCY_dat_discharge %>% group_by(PI_period) %>% 
  summarise(n = n(), perc = n/nrow(PSCY_dat_discharge)) # Number of records per PI_period

PSCY_dat_discharge %>% group_by(PI_period, clientUsername) %>% 
  arrange(PSCY_ASSESSMENT_DATE) %>%
  filter(row_number()==1) %>%
  ungroup() %>%
  group_by(PI_period) %>%
  summarise(n = n(), perc = n/nrow(PSCY_dat_discharge)) # Number of unique clients per PI_period

PSCY_dat_discharge %>% group_by(PI_period) %>% 
  filter(n_service_per_PI_period > 1) %>%
  distinct(clientUsername) %>%
  summarise(n = n(), perc = n/nrow(PSCY_dat_discharge)) # Number of clients with 2+ services per PI_period

## Create clean datasets for each outcome #####################################
CANS_dat_intake_clean <- CANS_dat_intake %>%
  dplyr::select(clientUsername, clientId, enrollmentDate, CANS_ASSESSMENT_DATE, PI_period,
                CANS_Unit, CANS_Subunit, 
                CANS_CB_Q8X, CB_NEEDS, LD_NEEDS, RB_NEEDS,
                NEEDS, STRENGTHS)

PSCY_dat_intake_clean <- PSCY_dat_intake %>%
  dplyr::select(clientUsername, clientId, enrollmentDate, PSCY_ASSESSMENT_DATE, PI_period,
                PSCY_Score, pscyxattn, pscyxattnx, pscyxint, pscyxintx,
                pscyxext, pscyxextx, pscyscorex)

PSCP_dat_intake_clean <- PSCP_dat_intake %>%
  dplyr::select(clientUsername, clientId, enrollmentDate, PSC_ASSESSMENT_DATE, PI_period,
                PSC_Score, pscxattn, pscxattnx, pscxint, pscxintx,
                pscxext, pscxextx, pscscorex)

CCBH_dat_clean2 <- CCBH_dat_clean %>%
  dplyr::select(case_number, sex_id, age, race_multi, dx_group, region_bhs, bha_trauma, PI_period,
                svccount, locop, locday, locip, loccs) %>%
  dplyr::rename(clientUsername = case_number)  %>%
  dplyr::mutate(clientUsername = as.character(clientUsername))

CANS_unmatched <- CANS_dat_intake_clean %>%
  anti_join(CCBH_dat_clean2, by = c("clientUsername", "PI_period")) 

write.xlsx(CANS_unmatched, 'CANS_records_not_in_CCBH.xlsx')

CANS_unmatched %>%  group_by(PI_period) %>% count() # Records in CANS but not in CCBH
CANS_unmatched %>%  group_by(PI_period) %>% distinct(clientUsername, .keep_all = T) %>%count() # Records in CANS but not in CCBH

CANS_dat_intake_clean %>%  group_by(PI_period) %>% count()

CCBH_unmatched <- CCBH_dat_clean2 %>%
  anti_join(CANS_dat_intake_clean, by = c("clientUsername", "PI_period")) 
CCBH_unmatched %>%  group_by(PI_period) %>% count() # Records in CCBH but not in CANS
CCBH_unmatched %>%  distinct(clientUsername, .keep_all = T) %>% filter(locop==1) %>% count() 
write.xlsx(CCBH_unmatched, 'CCBH_records_not_in_CANS.xlsx')


CANS_dat_intake_clean %>% filter(CANS_Unit %in% c(2500,13200,1340,4270,3180,3080)) %>% group_by(CANS_Unit) %>% count()



TraumaRes_var <- CANS_dat_intake_clean %>%
  inner_join(CCBH_dat_clean2, by = c("clientUsername", "PI_period")) %>%
  dplyr::select(clientUsername, clientId, enrollmentDate, PI_period, sex_id, age, race_multi, dx_group,
                CANS_CB_Q8X, bha_trauma, locop, locip, loccs, locday, svccount) %>%
  dplyr::filter(bha_trauma %in% c("No", "Yes")) %>%
  dplyr::mutate(TraumaRes_group = case_when(bha_trauma=="No" ~ "No Trauma",
                                            bha_trauma=="Yes" & CANS_CB_Q8X==0 ~ "Low Impact",
                                            bha_trauma=="Yes" & CANS_CB_Q8X==1 ~ "High Impact")) %>%
  mutate(age_group = case_when(age <= 5 ~ "Ages 0-5",
                               age >= 6 & age <= 11 ~ "Ages 6-11",
                               age >= 12 & age <= 17 ~ "Ages 12-17",
                               age >= 18 ~ "Ages 18+")) %>% 
  mutate(sex_id = case_when(sex_id == "O" ~ "O",
                            sex_id == "U" ~ "U",
                            is.na(sex_id) ~ "U",
                           TRUE ~ as.character(sex_id))) %>%
  mutate(dx_group = case_when(dx_group == "Excluded" ~ "Excluded/Invalid",
                              dx_group == "Invalid" ~ "Excluded/Invalid",
                              dx_group == "Other" ~ "Other/Unknown",
                              is.na(dx_group)  ~ "Other/Unknown",
                              TRUE ~ as.character(dx_group))) 


CANS_dat_intake_clean2 <- CANS_dat_intake_clean %>%
  inner_join(TraumaRes_var, by=c("clientUsername", "clientId", "enrollmentDate", "PI_period", "CANS_CB_Q8X"))

PSCY_dat_intake_clean2 <- PSCY_dat_intake_clean %>%
  inner_join(TraumaRes_var, by=c("clientUsername", "clientId", "enrollmentDate", "PI_period"))

PSCP_dat_intake_clean2 <- PSCP_dat_intake_clean %>%
  inner_join(TraumaRes_var, by=c("clientUsername", "clientId", "enrollmentDate", "PI_period"))


CANS_dat_intake_clean2 %>% group_by(PI_period) %>% count()
CANS_dat_intake_clean2 %>% group_by(PI_period, TraumaRes_group) %>% count()
CANS_dat_intake_clean2 %>% filter(CANS_Unit %in% c(2500,13200,1340,4270,3180,3080)) %>% group_by(PI_period, CANS_Unit) %>% count()

PSCY_dat_intake_clean2 %>% group_by(PI_period) %>% count()
PSCY_dat_intake_clean2 %>% group_by(PI_period, TraumaRes_group) %>% count()

PSCP_dat_intake_clean2 %>% group_by(PI_period) %>% count()
PSCP_dat_intake_clean2 %>% group_by(PI_period, TraumaRes_group) %>% count()

# Create a new workbook
wb <- createWorkbook()

addWorksheet(wb, "CANS_dat")
writeData(wb, sheet = "CANS_dat", CANS_dat_intake_clean2)

addWorksheet(wb, "PSCY_dat")
writeData(wb, sheet = "PSCY_dat", PSCY_dat_intake_clean2)

addWorksheet(wb, "PSCP_dat")
writeData(wb, sheet = "PSCP_dat", PSCP_dat_intake_clean2)

# Save the workbook
saveWorkbook(wb, file = "TraumaRes_datasets_clean.xlsx", overwrite = TRUE)



CCBH_dat_clean2 %>% group_by(PI_period) %>% count()
CCBH_dat_clean2 %>% filter(locop==1) %>% group_by(PI_period) %>% count()
CANS_dat_intake_clean2_unique <- CANS_dat_intake_clean2 %>% group_by(PI_period, clientUsername) %>% arrange(desc(CANS_ASSESSMENT_DATE)) %>% slice(1)
CANS_dat_intake_clean2_unique %>% filter(locop==1) %>% group_by(PI_period) %>% count()
