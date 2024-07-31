# Data Preparation ----
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
source("TraumaAnalysis_Functions.R")
options(dplyr.print_max = 1e9)

# Read in the outcome dataset and create intake data for CANS, PSCP and PSCY
raw_dat <- read_sav("../Data/CANS_PSC_Merged_COVID_2022.05.03.sav")
raw_dat <- zap_formats(zap_labels(raw_dat)) %>%
  rename(casenum = clientusername)

# Recode the CANS_AnyTrauma and CANS_AnyTraumaV2 variables
# CANS_CB_Q8.0 is actually the trauma variable
raw_dat <- raw_dat %>%
  mutate(CANS_AnyTrauma.0 = CANS_CB_Q8.0, CANS_AnyTrauma.2 = CANS_CB_Q8.2) %>%
  mutate(CANS_AnyTraumaV2.0 = case_when(CANS_AnyTrauma.0==0 ~ 0,
                                        CANS_AnyTrauma.0==1 ~ 0,
                                        CANS_AnyTrauma.0==2 ~ 1,
                                        CANS_AnyTrauma.0==3 ~ 1,
                                        is.na(CANS_AnyTrauma.0) ~ NA)) %>%
  mutate(CANS_AnyTraumaV2.2 = case_when(CANS_AnyTrauma.2==0 ~ 0,
                                        CANS_AnyTrauma.2==1 ~ 0,
                                        CANS_AnyTrauma.2==2 ~ 1,
                                        CANS_AnyTrauma.2==3 ~ 1,
                                        is.na(CANS_AnyTrauma.2) ~ NA)) 


# Read in the demographics dataset. Include all records that have Yes and No Trauma
PI_demo_raw <- readr::read_csv("../Data/covid_client_trauma_ffsip 221213_v2.csv") %>% 
  mutate(casenum=as.character(casenum)) %>%
  rename(timepoint.0 = timepoint)
PI_demo_raw %>% group_by(timepoint.0) %>% count()
  
PI_demo <-  PI_demo_raw %>% filter(ANY_TRAUMA==1 | ANY_TRAUMA==2)
PI_demo %>% group_by(timepoint.0) %>% count()
PI_demo %>% group_by(timepoint.0, ANY_TRAUMA) %>% count()


# Merge the outcome datasets and demo 
# Select only cases that have history of trauma and CANS trauma values at intake
full_dat <- raw_dat %>% 
  left_join(PI_demo, by=c("casenum", "timepoint.0")) %>% 
  mutate(age_group = case_when(age <= 5 ~ "Ages 0-5",
                               age >= 6 & age <= 11 ~ "Ages 6-11",
                               age >= 12 & age <= 17 ~ "Ages 12-17",
                               age >= 18 ~ "Ages 18+")) %>% 
  mutate(raceeth = case_when(raceeth == 1 ~ "NH White",
                             raceeth == 2 ~ "Hispanic",
                             raceeth == 3 ~ "NH Black",
                             raceeth == 4 ~ "NH Asian",
                             raceeth == 5 ~ "NH Native American",
                             raceeth == 6 ~ "NH Other",
                             raceeth == 7 ~ "NH MultiRacial",
                             raceeth == 9 ~ "Unknown/NR",
                             is.na(raceeth) ~ "Unknown/NR")) %>%
  mutate(Sex = case_when(Sex == "O" ~ "O/U",
                         Sex == "U" ~ "O/U",
                         TRUE ~ as.character(Sex))) %>%
  mutate(grpdesc = case_when(grpdesc == "Excluded" ~ "Excluded/Invalid",
                             grpdesc == "Invalid" ~ "Excluded/Invalid",
                             grpdesc == "Other" ~ "Other/Unknown",
                             is.na(grpdesc)  ~ "Other/Unknown",
                             TRUE ~ as.character(grpdesc))) %>%
  filter(ANY_TRAUMA==1 | ANY_TRAUMA==2) %>% # 1: Yes, 2: No
  mutate(Trauma_group_intake = case_when(ANY_TRAUMA==2 ~ "No Trauma",
                                         ANY_TRAUMA==1 & CANS_AnyTraumaV2.0==0 ~ "Low Impact",
                                         ANY_TRAUMA==1 & CANS_AnyTraumaV2.0==1 ~ "High Impact")) %>%
  filter(!is.na(Trauma_group_intake)) %>%
  filter(!is.na(timepoint.0))

factor_cols = c("CANS_AnyTraumaV2.0","CANS_AnyTraumaV2.2","timepoint.0", "timepoint.2", "ANY_TRAUMA")
full_dat[factor_cols] <- lapply(full_dat[factor_cols], factor)  ## as.factor() could also be used

full_dat %>% group_by(timepoint.0) %>% count()
full_dat %>% group_by(timepoint.0, Trauma_group_intake) %>% count()

# Create individual outcome datasets
demo_cols = c("age", "age_group", "Sex", "raceeth", "grpdesc", 'region_name', "svccount", "locop", "locday", "locip", "loccs")
CANS_cols <- c("casenum", "timepoint.0", "CANS_AnyTrauma.0", "CANS_AnyTraumaV2.0", "CB_NEEDS.0", "LD_NEEDS.0", "RB_NEEDS.0", "NEEDS.0", "STRENGTHS.0")
PSCP_cols <- c("casenum", "timepoint.PSCP.0", "PSC_Score.0", "pscxattn.0", "pscxint.0", "pscxext.0")
PSCY_cols <- c("casenum", "timepoint.PSCY.0", "PSCY_Score.0", "pscyxattn.0", "pscyxint.0", "pscyxext.0")

CANS_dat_intake <- full_dat %>% 
  dplyr::select(Trauma_group_intake, all_of(CANS_cols), all_of(demo_cols), enrollmentDate) %>%
  filter(!is.na(timepoint.0)) %>%
  filter(!is.na(Trauma_group_intake)) %>%
  group_by(casenum, timepoint.0) %>%
  arrange(desc(enrollmentDate)) %>%
  slice(1) %>%
  ungroup()
  
PSCP_dat_intake <- full_dat %>% 
  dplyr::select(Trauma_group_intake, all_of(PSCP_cols), all_of(demo_cols), enrollmentDate) %>%
  rename(timepoint.0 = timepoint.PSCP.0) %>%
  filter(!is.na(timepoint.0)) %>%
  filter(!is.na(Trauma_group_intake)) %>%
  mutate(timepoint.0 = as.factor(timepoint.0)) %>%
  group_by(casenum, timepoint.0) %>%
  arrange(desc(enrollmentDate)) %>%
  slice(1) %>%
  ungroup()

PSCY_dat_intake <- full_dat %>% 
  dplyr::select(Trauma_group_intake, all_of(PSCY_cols), all_of(demo_cols), enrollmentDate) %>%
  rename(timepoint.0 = timepoint.PSCY.0) %>%
  filter(!is.na(timepoint.0)) %>%
  filter(!is.na(Trauma_group_intake)) %>%
  mutate(timepoint.0 = as.factor(timepoint.0)) %>%
  group_by(casenum, timepoint.0) %>%
  arrange(desc(enrollmentDate)) %>%
  slice(1) %>%
  ungroup()


# Research Questions and Analyses ----
## Demographics

# Demographics of the intake sample (based on clients who took CANS_assessment)
full_dat_demo <- full_dat %>%
  dplyr::select(casenum, Trauma_group_intake, timepoint.0, all_of(demo_cols)) %>%
  filter(!is.na(timepoint.0))

full_dat_demo_unique <- full_dat_demo %>% 
  group_by(casenum) %>%
  arrange(timepoint.0) %>%
  slice(n()) # For unique client, select the most recent intake timepoint

factor_cols = c("age_group","Sex","raceeth", "grpdesc", "region_name", "locop", "locday", "locip", "loccs")
full_dat_demo_unique[factor_cols] <- lapply(full_dat_demo_unique[factor_cols], factor) 
demo_unique_client_summary <- as.data.frame(summary(full_dat_demo_unique))


## Client severity at intake ----
### Analyze CANS intake outcomes ----
CANS_outcome_list = c("CB_NEEDS.0", "LD_NEEDS.0", "RB_NEEDS.0", "NEEDS.0", "STRENGTHS.0")
CANS_intake_result_desc_list = list()
CANS_intake_result_stats_list = list()
CANS_intake_result_plot_list = list()

for (i in CANS_outcome_list){
  temp_desc <- Group_summary_function(CANS_dat_intake, "timepoint.0", "Trauma_group_intake",i, i)
  temp_stats <- Group_compare_function(CANS_dat_intake, "timepoint.0", "Trauma_group_intake",i, i)
  temp_plots <- Plot_function(CANS_dat_intake, "timepoint.0", "Trauma_group_intake",i, i)
  
  CANS_intake_result_desc_list[[i]] <- temp_desc
  CANS_intake_result_stats_list[[i]] <- temp_stats
  CANS_intake_result_plot_list[[i]] <- temp_plots
  
}


CANS_intake_result_desc_df <- do.call(rbind, CANS_intake_result_desc_list)
CANS_intake_result_stats_df <- do.call(rbind, CANS_intake_result_stats_list)

### Analyze PSCP intake outcomes ----
PSCP_outcome_list = c("PSC_Score.0", "pscxattn.0", "pscxint.0", "pscxext.0")
PSCP_intake_result_desc_list = list()
PSCP_intake_result_stats_list = list()
PSCP_intake_result_plot_list = list()

for (i in PSCP_outcome_list){
  temp_desc <- Group_summary_function(PSCP_dat_intake, "timepoint.0", "Trauma_group_intake",i, i)
  temp_stats <- Group_compare_function(PSCP_dat_intake, "timepoint.0", "Trauma_group_intake",i, i)
  temp_plots <- Plot_function(PSCP_dat_intake, "timepoint.0", "Trauma_group_intake",i, i)
  
  PSCP_intake_result_desc_list[[i]] <- temp_desc
  PSCP_intake_result_stats_list[[i]] <- temp_stats
  PSCP_intake_result_plot_list[[i]] <- temp_plots
}


PSCP_intake_result_desc_df <- do.call(rbind, PSCP_intake_result_desc_list)
PSCP_intake_result_stats_df <- do.call(rbind, PSCP_intake_result_stats_list)

### Analyze PSCY intake outcomes ----
PSCY_outcome_list = c("PSCY_Score.0", "pscyxattn.0", "pscyxint.0", "pscyxext.0")
PSCY_intake_result_desc_list = list()
PSCY_intake_result_stats_list = list()
PSCY_intake_result_plot_list = list()

for (i in PSCY_outcome_list){
  temp_desc <- Group_summary_function(PSCY_dat_intake, "timepoint.0", "Trauma_group_intake",i, i)
  temp_stats <- Group_compare_function(PSCY_dat_intake, "timepoint.0", "Trauma_group_intake",i, i)
  temp_plots <- Plot_function(PSCY_dat_intake, "timepoint.0", "Trauma_group_intake",i, i)
  
  PSCY_intake_result_desc_list[[i]] <- temp_desc
  PSCY_intake_result_stats_list[[i]] <- temp_stats
  PSCY_intake_result_plot_list[[i]] <- temp_plots
}

PSCY_intake_result_desc_df <- do.call(rbind, PSCY_intake_result_desc_list)
PSCY_intake_result_stats_df <- do.call(rbind, PSCY_intake_result_stats_list)

# Save the results
writexl::write_xlsx(CANS_intake_result_desc_df,"CANS_intake_result_desc_list.xlsx")
writexl::write_xlsx(CANS_intake_result_stats_df,"CANS_intake_result_stats_list.xlsx")

writexl::write_xlsx(PSCP_intake_result_desc_df,"PSCP_intake_result_desc_list.xlsx")
writexl::write_xlsx(PSCP_intake_result_stats_df,"PSCP_intake_result_stats_list.xlsx")

writexl::write_xlsx(PSCY_intake_result_desc_df,"PSCY_intake_result_desc_list.xlsx")
writexl::write_xlsx(PSCY_intake_result_stats_df,"PSCY_intake_result_stats_list.xlsx")
