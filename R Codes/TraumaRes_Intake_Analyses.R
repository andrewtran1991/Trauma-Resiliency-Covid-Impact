# 2. Data Analyses ----
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
library(emmeans)
library(psych)
library(effects)
library(MVN)
library(rlang)

source("TraumaAnalysis_Functions.R")
options(dplyr.print_max = 1e9)

data_path <- "M:\\SPH\\SOCE_STUDIES\\Trauma and Resiliency\\Data"

# Read in the cleaned outcome dataset for CANS, PSCP and PSCY
CANS_dat <- read.xlsx(paste0(data_path, "/TraumaRes_datasets_clean.xlsx"), sheet = "CANS_dat")
PSCY_dat <- read.xlsx(paste0(data_path, "/TraumaRes_datasets_clean.xlsx"), sheet = "PSCY_dat")
PSCP_dat <- read.xlsx(paste0(data_path, "/TraumaRes_datasets_clean.xlsx"), sheet = "PSCP_dat")

# Excluding Year 4
CANS_dat <- CANS_dat %>% filter(PI_period != "Year 4")
PSCY_dat <- PSCY_dat %>% filter(PI_period != "Year 4")
PSCP_dat <- PSCP_dat %>% filter(PI_period != "Year 4")

# Demographics based on CANS sample
CANS_dat$PI_period <- factor(CANS_dat$PI_period, levels = c("Year Pre", "Year 1", "Year 2", "Year 3", "Year 4"))
Dems_Total_N <- CANS_dat %>% group_by(TraumaRes_group, PI_period) %>% count() %>%
  pivot_wider(names_from = c(TraumaRes_group, PI_period), values_from = n) %>%
  mutate(category = "Total N")

Dems_Mean_Age <- CANS_dat %>% group_by(TraumaRes_group, PI_period) %>% summarise(average = mean(age))%>%
  pivot_wider(names_from = c(TraumaRes_group, PI_period), values_from = average) %>%
  mutate(category = "Mean Age")

Dems_Sex <- CANS_dat %>% group_by(TraumaRes_group, PI_period, sex_id) %>% count() %>%
  pivot_wider(names_from = c(TraumaRes_group, PI_period), values_from = n) %>%
  rename(category = sex_id)
  
Dems_Race <- CANS_dat %>% group_by(TraumaRes_group, PI_period, race_multi) %>% count() %>%
  pivot_wider(names_from = c(TraumaRes_group, PI_period), values_from = n) %>%
  rename(category = race_multi)

Dems_Dx <- CANS_dat %>% group_by(TraumaRes_group, PI_period, dx_group) %>% count() %>%
  pivot_wider(names_from = c(TraumaRes_group, PI_period), values_from = n) %>%
  rename(category = dx_group)

Dems_locop <- CANS_dat %>% group_by(TraumaRes_group, PI_period, locop) %>% count() %>%
  pivot_wider(names_from = c(TraumaRes_group, PI_period), values_from = n) %>%
  rename(category = locop) %>%
  mutate(category = case_when(
    category == 0 ~ "No_locop",
    category == 1 ~ "Yes_locop",
    TRUE ~ as.character(category)  # Handle any unexpected values
  ))

Dems_locip <- CANS_dat %>% group_by(TraumaRes_group, PI_period, locip) %>% count() %>%
  pivot_wider(names_from = c(TraumaRes_group, PI_period), values_from = n) %>%
  rename(category = locip) %>%
  mutate(category = case_when(
    category == 0 ~ "No_locip",
    category == 1 ~ "Yes_locip",
    TRUE ~ as.character(category)  # Handle any unexpected values
  ))

Dems_loccs <- CANS_dat %>% group_by(TraumaRes_group, PI_period, loccs) %>% count() %>%
  pivot_wider(names_from = c(TraumaRes_group, PI_period), values_from = n) %>%
  rename(category = loccs) %>%
  mutate(category = case_when(
    category == 0 ~ "No_loccs",
    category == 1 ~ "Yes_loccs",
    TRUE ~ as.character(category)  # Handle any unexpected values
  ))

Dems_locday <- CANS_dat %>% group_by(TraumaRes_group, PI_period, locday) %>% count() %>%
  pivot_wider(names_from = c(TraumaRes_group, PI_period), values_from = n) %>%
  rename(category = locday) %>%
  mutate(category = case_when(
    category == 0 ~ "No_locday",
    category == 1 ~ "Yes_locday",
    TRUE ~ as.character(category)  # Handle any unexpected values
  ))
 
Dems_Mean_svccount <- CANS_dat %>% group_by(TraumaRes_group, PI_period) %>% 
  summarise(average = mean(svccount)) %>%
  pivot_wider(names_from = c(TraumaRes_group, PI_period), values_from = average) %>%
  mutate(category = "Mean Service Count")

Dems_Output <- bind_rows(Dems_Total_N, Dems_Mean_Age, Dems_Sex, Dems_Race, Dems_Dx,
                         Dems_locop, Dems_locip, Dems_loccs, Dems_locday, Dems_Mean_svccount)

write.xlsx(Dems_Output, "TraumaRes_Demographics_output.xlsx")

# Demographics based on CANS sample (unique cient at each timepoint)
CANS_dat_unique <- CANS_dat %>%
  group_by(PI_period, clientUsername) %>%
  arrange(enrollmentDate) %>%
  dplyr::slice(n())

Dems_Total_N <- CANS_dat_unique %>% group_by(TraumaRes_group, PI_period) %>% count() %>%
  pivot_wider(names_from = c(TraumaRes_group, PI_period), values_from = n) %>%
  mutate(category = "Total N")

Dems_Mean_Age <- CANS_dat_unique %>% group_by(TraumaRes_group, PI_period) %>% summarise(average = mean(age))%>%
  pivot_wider(names_from = c(TraumaRes_group, PI_period), values_from = average) %>%
  mutate(category = "Mean Age")

Dems_Sex <- CANS_dat_unique %>% group_by(TraumaRes_group, PI_period, sex_id) %>% count() %>%
  pivot_wider(names_from = c(TraumaRes_group, PI_period), values_from = n) %>%
  rename(category = sex_id)

Dems_Race <- CANS_dat_unique %>% group_by(TraumaRes_group, PI_period, race_multi) %>% count() %>%
  pivot_wider(names_from = c(TraumaRes_group, PI_period), values_from = n) %>%
  rename(category = race_multi)

Dems_Dx <- CANS_dat_unique %>% group_by(TraumaRes_group, PI_period, dx_group) %>% count() %>%
  pivot_wider(names_from = c(TraumaRes_group, PI_period), values_from = n) %>%
  rename(category = dx_group)

Dems_locop <- CANS_dat_unique %>% group_by(TraumaRes_group, PI_period, locop) %>% count() %>%
  pivot_wider(names_from = c(TraumaRes_group, PI_period), values_from = n) %>%
  rename(category = locop) %>%
  mutate(category = case_when(
    category == 0 ~ "No_locop",
    category == 1 ~ "Yes_locop",
    TRUE ~ as.character(category)  # Handle any unexpected values
  ))

Dems_locip <- CANS_dat_unique %>% group_by(TraumaRes_group, PI_period, locip) %>% count() %>%
  pivot_wider(names_from = c(TraumaRes_group, PI_period), values_from = n) %>%
  rename(category = locip) %>%
  mutate(category = case_when(
    category == 0 ~ "No_locip",
    category == 1 ~ "Yes_locip",
    TRUE ~ as.character(category)  # Handle any unexpected values
  ))

Dems_loccs <- CANS_dat_unique %>% group_by(TraumaRes_group, PI_period, loccs) %>% count() %>%
  pivot_wider(names_from = c(TraumaRes_group, PI_period), values_from = n) %>%
  rename(category = loccs) %>%
  mutate(category = case_when(
    category == 0 ~ "No_loccs",
    category == 1 ~ "Yes_loccs",
    TRUE ~ as.character(category)  # Handle any unexpected values
  ))

Dems_locday <- CANS_dat_unique %>% group_by(TraumaRes_group, PI_period, locday) %>% count() %>%
  pivot_wider(names_from = c(TraumaRes_group, PI_period), values_from = n) %>%
  rename(category = locday) %>%
  mutate(category = case_when(
    category == 0 ~ "No_locday",
    category == 1 ~ "Yes_locday",
    TRUE ~ as.character(category)  # Handle any unexpected values
  ))

Dems_Mean_svccount <- CANS_dat_unique %>% group_by(TraumaRes_group, PI_period) %>% 
  summarise(average = mean(svccount)) %>%
  pivot_wider(names_from = c(TraumaRes_group, PI_period), values_from = average) %>%
  mutate(category = "Mean Service Count")

Dems_Output <- bind_rows(Dems_Total_N, Dems_Mean_Age, Dems_Sex, Dems_Race, Dems_Dx,
                         Dems_locop, Dems_locip, Dems_loccs, Dems_locday, Dems_Mean_svccount)

write.xlsx(Dems_Output, "TraumaRes_Demographics_Unique_output.xlsx")

# CANS
attach(CANS_dat)
nrow(CANS_dat)
CANS_dat %>% group_by(PI_period) %>% count()
CANS_dat %>% group_by(PI_period, TraumaRes_group) %>% count()

outcome_cans <- cbind(CB_NEEDS, LD_NEEDS, RB_NEEDS)
TraumaRes_group <- factor(TraumaRes_group)
PI_period <- factor(PI_period)
sex_id <- factor(sex_id)
race_multi <- factor(race_multi)
dx_group <- factor(dx_group)

# Define the MANCOVA model and run it
mancova_model <- lm(outcome_cans ~ TraumaRes_group * PI_period + age + sex_id + race_multi + dx_group, data = CANS_dat)
mancova_results <- Manova(mancova_model)
residuals <- residuals(mancova_model)

# Summary of MANCOVA results
summary(mancova_results)

# Check assumptions
# Multivariate normality
#mvn_test <- mvn(data = residuals, mvnTest = "mardia", univariateTest = "SW", multivariatePlot = "qq")
#mvn(CANS_dat[, c("CB_NEEDS", "LD_NEEDS", "RB_NEEDS","NEEDS", "STRENGTHS")])

# Homogeneity of variances:
leveneTest(CB_NEEDS ~ TraumaRes_group * PI_period, data = CANS_dat)
leveneTest(LD_NEEDS ~ TraumaRes_group * PI_period, data = CANS_dat)
leveneTest(RB_NEEDS ~ TraumaRes_group * PI_period, data = CANS_dat)
leveneTest(NEEDS ~ TraumaRes_group * PI_period, data = CANS_dat)
leveneTest(STRENGTHS ~ TraumaRes_group * PI_period, data = CANS_dat)

# Multicollinearity:
vif_results <- vif(mancova_model, type = "predictor")
vif_results

# Post-hoc Tests
emmeans_trauma <- emmeans(mancova_model, pairwise ~ TraumaRes_group)
summary(emmeans_trauma )

emmeans_time <- emmeans(mancova_model, pairwise ~ PI_period)
summary(emmeans_time )

interaction_effects <- emmeans(mancova_model, pairwise ~ TraumaRes_group* PI_period)
summary(interaction_effects )


### Analyze CANS intake outcomes ----
CANS_outcome_list = c("CB_NEEDS", "LD_NEEDS", "RB_NEEDS", "NEEDS", "STRENGTHS")
CANS_intake_result_desc_list = list()
CANS_intake_result_plot_list = list()
CANS_intake_result_stats_list = list()

for (i in CANS_outcome_list){
  temp_desc <- Group_summary_function(CANS_dat, "PI_period", "TraumaRes_group",i, i)
  temp_plots <- Plot_function(CANS_dat, "PI_period", "TraumaRes_group",i, i)
  temp_stats <- Group_compare_function(CANS_dat, "PI_period", "TraumaRes_group",i, i)
  
  CANS_intake_result_desc_list[[i]] <- temp_desc
  CANS_intake_result_plot_list[[i]] <- temp_plots
  CANS_intake_result_stats_list[[i]] <- temp_stats
  
}


CANS_intake_result_desc_df <- do.call(rbind, CANS_intake_result_desc_list)
CANS_intake_result_stats_df <- do.call(rbind, CANS_intake_result_stats_list)
write.xlsx(CANS_intake_result_desc_df, "CANS_intake_result_desc_df.xlsx")
write.xlsx(CANS_intake_result_stats_df, "CANS_intake_result_stats_df.xlsx")

CANS_intake_result_plot_list[[1]]
CANS_intake_result_plot_list[[2]]
CANS_intake_result_plot_list[[3]]
CANS_intake_result_plot_list[[4]]
CANS_intake_result_plot_list[[5]]

detach(CANS_dat)

###################
attach(PSCY_dat)
nrow(PSCY_dat)
PSCY_dat$PI_period <- factor(PSCY_dat$PI_period, levels=c("Year Pre", "Year 1", "Year 2", "Year 3", "Year 4"))
PSCY_dat %>% group_by(PI_period) %>% count()
PSCY_dat %>% group_by(PI_period, TraumaRes_group) %>% count()

outcome_PSCY <- cbind(PSCY_Score, pscyxattn, pscyxint, pscyxext)
TraumaRes_group <- factor(TraumaRes_group)
PI_period <- factor(PI_period)
sex_id <- factor(sex_id)
race_multi <- factor(race_multi)
dx_group <- factor(dx_group)

# Define the MANCOVA model and run it
mancova_model <- lm(outcome_PSCY ~ TraumaRes_group * PI_period + age + sex_id + race_multi + dx_group, data = PSCY_dat)
mancova_results <- Manova(mancova_model)
residuals <- residuals(mancova_model)

# Summary of MANCOVA results
summary(mancova_results)

# Check assumptions
# Multivariate normality
mvn_test <- mvn(data = residuals, mvnTest = "mardia", univariateTest = "SW", multivariatePlot = "qq")
mvn(PSCY_dat[, c("PSCY_Score", "pscyxattn", "pscyxint","pscyxext")])

# Homogeneity of variances:
leveneTest(CB_NEEDS ~ TraumaRes_group * PI_period, data = PSCY_dat)
leveneTest(LD_NEEDS ~ TraumaRes_group * PI_period, data = PSCY_dat)
leveneTest(RB_NEEDS ~ TraumaRes_group * PI_period, data = PSCY_dat)
leveneTest(NEEDS ~ TraumaRes_group * PI_period, data = PSCY_dat)
leveneTest(STRENGTHS ~ TraumaRes_group * PI_period, data = PSCY_dat)

# Multicollinearity:
vif_results <- vif(mancova_model, type = "predictor")
vif_results

# Post-hoc Tests
emmeans_trauma <- emmeans(mancova_model, pairwise ~ TraumaRes_group)
summary(emmeans_trauma )

emmeans_time <- emmeans(mancova_model, pairwise ~ PI_period)
summary(emmeans_time )

interaction_effects <- emmeans(mancova_model, pairwise ~ TraumaRes_group* PI_period)
summary(interaction_effects )



### Analyze PSCY intake outcomes ----
PSCY_outcome_list = c("PSCY_Score", "pscyxattn", "pscyxint","pscyxext")
PSCY_intake_result_desc_list = list()
PSCY_intake_result_plot_list = list()
PSCY_dat$PI_period <- factor(PSCY_dat$PI_period, levels = c("Year Pre", "Year 1", "Year 2", "Year 3", "Year 4"))
PSCY_intake_result_stats_list = list()

for (i in PSCY_outcome_list){
  temp_desc <- Group_summary_function(PSCY_dat, "PI_period", "TraumaRes_group",i, i)
  temp_plots <- Plot_function(PSCY_dat, "PI_period", "TraumaRes_group",i, i)
  temp_stats <- Group_compare_function(PSCY_dat, "PI_period", "TraumaRes_group",i, i)
  
  PSCY_intake_result_desc_list[[i]] <- temp_desc
  PSCY_intake_result_plot_list[[i]] <- temp_plots
  PSCY_intake_result_stats_list[[i]] <- temp_stats
  
}


PSCY_intake_result_desc_df <- do.call(rbind, PSCY_intake_result_desc_list)
PSCY_intake_result_stats_df <- do.call(rbind, PSCY_intake_result_stats_list)
write.xlsx(PSCY_intake_result_desc_df, "PSCY_intake_result_desc_df.xlsx")
write.xlsx(PSCY_intake_result_stats_df, "PSCY_intake_result_stats_df.xlsx")

PSCY_intake_result_plot_list[[1]]
PSCY_intake_result_plot_list[[2]]
PSCY_intake_result_plot_list[[3]]
PSCY_intake_result_plot_list[[4]]

detach(PSCY_dat)

####################
attach(PSCP_dat)
nrow(PSCP_dat)
PSCP_dat$PI_period <- factor(PSCP_dat$PI_period, levels=c("Year Pre", "Year 1", "Year 2", "Year 3", "Year 4"))
PSCP_dat %>% group_by(PI_period) %>% count()
PSCP_dat %>% group_by(PI_period, TraumaRes_group) %>% count()

outcome_PSCP <- cbind(PSC_Score, pscxattn, pscxint, pscxext)
TraumaRes_group <- factor(TraumaRes_group)
PI_period <- factor(PI_period)
sex_id <- factor(sex_id)
race_multi <- factor(race_multi)
dx_group <- factor(dx_group)

# Define the MANCOVA model and run it
mancova_model <- lm(outcome_PSCP ~ TraumaRes_group * PI_period + age + sex_id + race_multi + dx_group, data = PSCP_dat)
mancova_results <- Manova(mancova_model)
residuals <- residuals(mancova_model)

# Summary of MANCOVA results
summary(mancova_results)

# Check assumptions
# Multivariate normality
mvn_test <- mvn(data = residuals, mvnTest = "mardia", univariateTest = "SW", multivariatePlot = "qq")
mvn(PSCP_dat[, c("PSC_Score", "pscxattn", "pscxint","pscxext")])

# Homogeneity of variances:
leveneTest(CB_NEEDS ~ TraumaRes_group * PI_period, data = PSCP_dat)
leveneTest(LD_NEEDS ~ TraumaRes_group * PI_period, data = PSCP_dat)
leveneTest(RB_NEEDS ~ TraumaRes_group * PI_period, data = PSCP_dat)
leveneTest(NEEDS ~ TraumaRes_group * PI_period, data = PSCP_dat)
leveneTest(STRENGTHS ~ TraumaRes_group * PI_period, data = PSCP_dat)

# Multicollinearity:
vif_results <- vif(mancova_model, type = "predictor")
vif_results

# Post-hoc Tests
emmeans_trauma <- emmeans(mancova_model, pairwise ~ TraumaRes_group)
summary(emmeans_trauma )

emmeans_time <- emmeans(mancova_model, pairwise ~ PI_period)
summary(emmeans_time )

interaction_effects <- emmeans(mancova_model, pairwise ~ TraumaRes_group* PI_period)
summary(interaction_effects )



### Analyze PSCP intake outcomes ----
PSCP_outcome_list = c("PSC_Score", "pscxattn", "pscxint","pscxext")
PSCP_intake_result_desc_list = list()
PSCP_intake_result_plot_list = list()
PSCP_dat$PI_period <- factor(PSCP_dat$PI_period, levels = c("Year Pre", "Year 1", "Year 2", "Year 3", "Year 4"))
PSCP_intake_result_stats_list = list()

for (i in PSCP_outcome_list){
  temp_desc <- Group_summary_function(PSCP_dat, "PI_period", "TraumaRes_group",i, i)
  temp_plots <- Plot_function(PSCP_dat, "PI_period", "TraumaRes_group",i, i)
  temp_stats <- Group_compare_function(PSCP_dat, "PI_period", "TraumaRes_group",i, i)
  
  PSCP_intake_result_desc_list[[i]] <- temp_desc
  PSCP_intake_result_plot_list[[i]] <- temp_plots
  PSCP_intake_result_stats_list[[i]] <- temp_stats
  
}


PSCP_intake_result_desc_df <- do.call(rbind, PSCP_intake_result_desc_list)
PSCP_intake_result_stats_df <- do.call(rbind, PSCP_intake_result_stats_list)
write.xlsx(PSCP_intake_result_desc_df, "PSCP_intake_result_desc_df.xlsx")
write.xlsx(PSCP_intake_result_stats_df, "PSCP_intake_result_stats_df.xlsx")

PSCP_intake_result_plot_list[[1]]
PSCP_intake_result_plot_list[[2]]
PSCP_intake_result_plot_list[[3]]
PSCP_intake_result_plot_list[[4]]

detach(PSCP_dat)