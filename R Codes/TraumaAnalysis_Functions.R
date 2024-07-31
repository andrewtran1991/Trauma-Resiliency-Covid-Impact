# Pandemic Year setup
PI_period_setup <- function(dat, assessment_date) {
  dat <- dat %>%
    mutate(PI_period = case_when(assessment_date >= '2019-03-01' & assessment_date < '2020-03-01' ~ "Year Pre",
                                 assessment_date >= '2020-03-01' & assessment_date < '2021-03-01' ~ "Year 1",
                                 assessment_date >= '2021-03-01' & assessment_date < '2022-03-01' ~ "Year 2",
                                 assessment_date >= '2022-03-01' & assessment_date < '2023-03-01' ~ "Year 3",
                                 assessment_date >= '2023-03-01' & assessment_date < '2024-03-01' ~ "Year 4"))
}


# Find NA columns
na_columns <- function(df) {
  col_names <- colnames(df)
  na_cols <- col_names[sapply(df, function(x) any(is.na(x)))]
  return(na_cols)
}

# Summarize data by groups
Group_summary_function <- function(data, time_var, group_var, outcome_var, outcome_name) {
  time_var <- sym(time_var)
  group_var <- sym(group_var)
  outcome_var <- sym(outcome_var)
  
  summary_table_desc<- data %>% 
    group_by(!!time_var, !!group_var) %>%
    dplyr::summarise(n = n(),
                     Mean = mean(!!outcome_var, na.rm=T),
                     Median = median(!!outcome_var, na.rm=T),
                     Stdv = sd(!!outcome_var, na.rm=T),
                     Min = min(!!outcome_var, na.rm=T),
                     Max = max(!!outcome_var, na.rm=T)) %>%
    mutate(outcome = outcome_name) 
    
  return(summary_table_desc)
}

# Statistical tests by groups
Group_compare_function <- function(data, time_var, group_var, outcome_var, outcome_name){
  time_var <- sym(time_var)
  group_var <- sym(group_var)
  outcome_var <- sym(outcome_var)
  

  # ANCOVA (among years)
  exp1 <- rlang::expr(!!outcome_var~!!group_var + age + sex_id + race_multi + dx_group)
  
  # Pre covid
  res.aov.0 <- aov(eval(exp1),data=data %>% filter(!!time_var=="Year Pre"))
  res.aov.0.result <- unlist(summary(res.aov.0))
  a0a <- unname(res.aov.0.result["Df1"])
  a0b <- unname(res.aov.0.result["F value1"])
  a0c <- unname(res.aov.0.result["Pr(>F)1"])
  
  tukey.0.result <- unlist(TukeyHSD(res.aov.0, which =  as.character(rlang::quo_name(group_var))))
  h0a <- unname(tukey.0.result["TraumaRes_group10"])
  h0b <- unname(tukey.0.result["TraumaRes_group11"])
  h0c <- unname(tukey.0.result["TraumaRes_group12"])
  
  
  # During covid 2020
  res.aov.1 <- aov(eval(exp1),data=data %>% filter(!!time_var=="Year 1"))
  res.aov.1.result <- unlist(summary(res.aov.1))
  a1a <- unname(res.aov.1.result["Df1"])
  a1b <- unname(res.aov.1.result["F value1"])
  a1c <- unname(res.aov.1.result["Pr(>F)1"])

  tukey.1.result <- unlist(TukeyHSD(res.aov.1, which =  as.character(rlang::quo_name(group_var))))
  h1a <- unname(tukey.1.result["TraumaRes_group10"])
  h1b <- unname(tukey.1.result["TraumaRes_group11"])
  h1c <- unname(tukey.1.result["TraumaRes_group12"])
  
  # During covid 2021
  res.aov.2 <- aov(eval(exp1),data=data %>% filter(!!time_var=="Year 2"))
  res.aov.2.result <- unlist(summary(res.aov.2))
  a2a <- unname(res.aov.2.result["Df1"])
  a2b <- unname(res.aov.2.result["F value1"])
  a2c <- unname(res.aov.2.result["Pr(>F)1"])
  
  tukey.2.result <- unlist(TukeyHSD(res.aov.2, which = as.character(rlang::quo_name(group_var))))
  h2a <- unname(tukey.2.result["TraumaRes_group10"])
  h2b <- unname(tukey.2.result["TraumaRes_group11"])
  h2c <- unname(tukey.2.result["TraumaRes_group12"])
  
  # During covid 2022
  res.aov.3 <- aov(eval(exp1),data=data %>% filter(!!time_var=="Year 3"))
  res.aov.3.result <- unlist(summary(res.aov.3))
  a3a <- unname(res.aov.3.result["Df1"])
  a3b <- unname(res.aov.3.result["F value1"])
  a3c <- unname(res.aov.3.result["Pr(>F)1"])
  
  tukey.3.result <- unlist(TukeyHSD(res.aov.3, which = as.character(rlang::quo_name(group_var))))
  h3a <- unname(tukey.3.result["TraumaRes_group10"])
  h3b <- unname(tukey.3.result["TraumaRes_group11"])
  h3c <- unname(tukey.3.result["TraumaRes_group12"])
  
  
  summary_table_aov_among_group <- data.frame(cohort = c("Year Pre", "Year 1", "Year 2", "Year 3"),
                                              df=c(a0a, a1a, a2a, a3a),
                                              F_value=c(a0b, a1b,a2b, a3b),
                                              p_value=c(a0c, a1c,a2c, a3c),
                                              p_value_Low_High=c(h0a, h1a, h2a, h3a),
                                              p_value_No_High=c(h0b, h1b, h2b, h3b),
                                              p_value_No_Low=c(h0c, h1c, h2c, h3c))
  summary_table_aov_among_group$compare <- "Among groups"
  
  # ANCOVA (among groups)
  exp2 <- rlang::expr(!!outcome_var~!!time_var + age + sex_id + race_multi + dx_group)
  # No Impact
  res.aov.0 <- aov(eval(exp2),data=data %>% filter(!!group_var=="No Trauma"))
  res.aov.0.result <- unlist(summary(res.aov.0))
  a0a <- unname(res.aov.0.result["Df1"])
  a0b <- unname(res.aov.0.result["F value1"])
  a0c <- unname(res.aov.0.result["Pr(>F)1"])
  
  tukey.0.result <- unlist(TukeyHSD(res.aov.0, which = as.character(rlang::quo_name(time_var))))
  h0a <- unname(tukey.0.result["PI_period19"])
  h0b <- unname(tukey.0.result["PI_period20"])
  h0c <- unname(tukey.0.result["PI_period21"])
  h0d <- unname(tukey.0.result["PI_period22"])
  h0e <- unname(tukey.0.result["PI_period23"])
  h0f <- unname(tukey.0.result["PI_period24"])
  
  # Low Impact
  res.aov.1 <- aov(eval(exp2),data=data %>% filter(!!group_var=="Low Impact"))
  res.aov.1.result <- unlist(summary(res.aov.1))
  a1a <- unname(res.aov.1.result["Df1"])
  a1b <- unname(res.aov.1.result["F value1"])
  a1c <- unname(res.aov.1.result["Pr(>F)1"])
  
  tukey.1.result <- unlist(TukeyHSD(res.aov.1, which = as.character(rlang::quo_name(time_var))))
  h1a <- unname(tukey.1.result["PI_period19"])
  h1b <- unname(tukey.1.result["PI_period20"])
  h1c <- unname(tukey.1.result["PI_period21"])
  h1d <- unname(tukey.1.result["PI_period22"])
  h1e <- unname(tukey.1.result["PI_period23"])
  h1f <- unname(tukey.1.result["PI_period24"])
  
  # High Impact
  res.aov.2 <- aov(eval(exp2),data=data %>% filter(!!group_var=="High Impact"))
  res.aov.2.result <- unlist(summary(res.aov.2))
  a2a <- unname(res.aov.2.result["Df1"])
  a2b <- unname(res.aov.2.result["F value1"])
  a2c <- unname(res.aov.2.result["Pr(>F)1"])
  
  tukey.2.result <- unlist(TukeyHSD(res.aov.2, which = as.character(rlang::quo_name(time_var))))
  h2a <- unname(tukey.2.result["PI_period19"])
  h2b <- unname(tukey.2.result["PI_period20"])
  h2c <- unname(tukey.2.result["PI_period21"])
  h2d <- unname(tukey.2.result["PI_period22"])
  h2e <- unname(tukey.2.result["PI_period23"])
  h2f <- unname(tukey.2.result["PI_period24"])
  
  summary_table_aov_among_time <- data.frame(cohort = c("No Trauma", "Low Impact", "High Impact"),
                                             df=c(a0a, a1a, a2a),
                                             F_value=c(a0b,a1b, a2b),
                                             p_value=c(a0c,a1c, a2c),
                                             p_value_Y1_Y0=c(h0a, h1a, h2a),
                                             p_value_Y2_Y0=c(h0b, h1b, h2b),
                                             p_value_Y3_Y0=c(h0c, h1c, h2c),
                                             p_value_Y2_Y1=c(h0d, h1d, h2d),
                                             p_value_Y3_Y1=c(h0e, h1e, h2e),
                                             p_value_Y3_Y2=c(h0f, h1f, h2f))
  summary_table_aov_among_time$compare <- "Among time points"
  
  
  # ANCOVA (Interaction)
  exp3 <- rlang::expr(!!outcome_var~!!group_var*!!time_var + age + sex_id + race_multi + dx_group)
  
  interaction.aov <- aov(eval(exp3), data = data)
  interaction.aov.result <- unlist(summary(interaction.aov))
  d1 <- unname(interaction.aov.result["Df1"])
  d2 <- unname(interaction.aov.result["Df2"])
  d3 <- unname(interaction.aov.result["Df7"])
  
  f1 <-unname(interaction.aov.result["F value1"])
  f2 <-unname(interaction.aov.result["F value2"])
  f3 <-unname(interaction.aov.result["F value7"])
  
  p1 <- unname(interaction.aov.result["Pr(>F)1"])
  p2 <- unname(interaction.aov.result["Pr(>F)2"])
  p3 <- unname(interaction.aov.result["Pr(>F)7"])
  
  summary_table_interaction <- data.frame(cohort = c('By Group', 'By Time', 'Group x Time'),
                                          df=c(d1,d2,d3),
                                          F_value=c(f1,f2,f3),
                                          p_value=c(p1,p2,p3))
  summary_table_interaction$compare <- "Interaction"
  
  # Combine the tests
  summary_table_stats = bind_rows(summary_table_aov_among_group, summary_table_aov_among_time, summary_table_interaction) %>% mutate(outcome = outcome_name)
}

# Plot
Plot_function <- function(data, time_var, group_var, outcome_var, outcome_name){
  ggline(data, x = time_var , y = outcome_var, color = group_var,
         add = c("mean_se"),
         palette = c("#00AFBB", "#E7B800", "#00FF00"),
         title = outcome_name)
}


### Discharge
# Functions
Group_summary_discharge_function <- function(data, time_var, group_var, outcome_var, outcome_name) {
  time_var <- sym(time_var)
  group_var <- sym(group_var)
  outcome_var <- sym(outcome_var)
  
  
  summary_table_desc<- data %>% 
    group_by(!!time_var, !!group_var) %>%
    dplyr::summarise(n = sum(!!outcome_var, na.rm=T),
                     N = n() - sum(is.na(!!outcome_var)),
                     prop=n/N) %>%
    mutate(outcome = outcome_name)
  return(summary_table_desc)
}

Group_compare_discharge_function <- function(data, time_var, group_var, outcome_var, outcome_name) {
  time_var <- sym(time_var)
  group_var <- sym(group_var)
  outcome_var <- sym(outcome_var)
  
  # Chi-square at each timepoint
  # Pre covid
  data2 <- data %>% filter(!!time_var==1)  
  chisq_test_time.1 <- chisq.test(data2[[group_var]],data2[[outcome_var]], correct=F)
  ch1a <- chisq_test_time.1$statistic
  ch1b <- chisq_test_time.1$parameter
  ch1c <- chisq_test_time.1$p.value
  
  # Covid Year 1
  data2 <- data %>% filter(!!time_var==2)  
  chisq_test_time.2 <- chisq.test(data2[[group_var]],data2[[outcome_var]], correct=F)
  ch2a <- chisq_test_time.2$statistic
  ch2b <- chisq_test_time.2$parameter
  ch2c <- chisq_test_time.2$p.value
  
  # Covid Year 2
  data2 <- data %>% filter(!!time_var==3)  
  chisq_test_time.3 <- chisq.test(data2[[group_var]],data2[[outcome_var]], correct=F)
  ch3a <- chisq_test_time.3$statistic
  ch3b <- chisq_test_time.3$parameter
  ch3c <- chisq_test_time.3$p.value
  
  summary_table_chisq <- data.frame(cohort = c("Pre Covid", "Covid Year 1", "Covid Year 2"),
                                    Stats_value=c(ch1a,ch2a,ch3a),
                                    df=c(ch1b,ch2b,ch3b),
                                    p_value=c(ch1c,ch2c,ch3c)) %>%
    mutate(outcome = outcome_name)
  summary_table_chisq$compare <- "Between groups"
  
  
  # Chi-square at each group
  # Low Impact
  data2 <- data %>% filter(!!group_var=="Low Impact")  
  chisq_test_group.1 <- chisq.test(data2[[time_var]],data2[[outcome_var]], correct=F)
  ch1a <- chisq_test_group.1$statistic
  ch1b <- chisq_test_group.1$parameter
  ch1c <- chisq_test_group.1$p.value
  
  # High Impact
  data2 <- data %>% filter(!!group_var=="High Impact")  
  chisq_test_group.2 <- chisq.test(data2[[time_var]],data2[[outcome_var]], correct=F)
  ch2a <- chisq_test_group.2$statistic
  ch2b <- chisq_test_group.2$parameter
  ch2c <- chisq_test_group.2$p.value
  
  # No Trauma
  data2 <- data %>% filter(!!group_var=="No Trauma")  
  chisq_test_group.3 <- chisq.test(data2[[time_var]],data2[[outcome_var]], correct=F)
  ch3a <- chisq_test_group.3$statistic
  ch3b <- chisq_test_group.3$parameter
  ch3c <- chisq_test_group.3$p.value
  
  summary_table_chisq2 <- data.frame(cohort = c("Low Impact", "High Impact", "No Trauma"),
                                     Stats_value=c(ch1a,ch2a,ch3a),
                                     df=c(ch1b,ch2b,ch3b),
                                     p_value=c(ch1c,ch2c,ch3c)) %>%
    mutate(outcome = outcome_name)
  summary_table_chisq2$compare <- "Among time points"
  
  summary_table_stats = bind_rows(summary_table_chisq, summary_table_chisq2)
  return(summary_table_stats)
}

# Function for ordinal data
Group_summary_discharge_function2 <- function(data, time_var, group_var, outcome_var, outcome_name) {
  time_var <- sym(time_var)
  group_var <- sym(group_var)
  outcome_var <- sym(outcome_var)
  
  summary_table_desc<- data %>% 
    group_by(!!time_var, !!group_var) %>%
    dplyr::summarise(N = n() - sum(is.na(!!outcome_var)),
                     median = median(!!outcome_var, na.rm = T),
                     IQR = IQR(!!outcome_var, na.rm = T),
                     value_neg1 = sum(!!outcome_var==-1, na.rm = T),
                     value_0 = sum(!!outcome_var==0, na.rm = T),
                     value_pos1 = sum(!!outcome_var==1, na.rm = T)
    ) %>%
    mutate(outcome = outcome_name)
  return(summary_table_desc)
}

Group_compare_discharge_function2 <- function(data, time_var, group_var, outcome_var, outcome_name){
  time_var <- sym(time_var)
  group_var <- sym(group_var)
  outcome_var <- sym(outcome_var)
  
  # Kruskal-Wallis test
  exp1 <- rlang::expr(!!outcome_var~!!group_var)
  
  # Pre covid
  t_test_time.1 <- kruskal.test(eval(exp1),data=data %>% filter(!!time_var==1))
  t1a <- t_test_time.1$statistic
  t1b <- t_test_time.1$parameter
  t1c <- t_test_time.1$p.value
  
  # During covid 2020
  t_test_time.2 <- kruskal.test(eval(exp1),data=data %>% filter(!!time_var==2))
  t2a <- t_test_time.2$statistic
  t2b <- t_test_time.2$parameter
  t2c <- t_test_time.2$p.value
  
  # During covid 2021
  t_test_time.3 <- kruskal.test(eval(exp1),data=data %>% filter(!!time_var==3))
  t3a <- t_test_time.3$statistic
  t3b <- t_test_time.3$parameter
  t3c <- t_test_time.3$p.value
  
  summary_table_ttest <- data.frame(cohort = c("Pre Covid", "Covid Year 1", "Covid Year 2"),
                                    stats_value=c(t1a,t2a,t3a),
                                    p_value=c(t1c,t2c,t3c))
  summary_table_ttest$compare <- "Between groups"
  
  # Kruskal-Wallis test
  exp2 <- rlang::expr(!!outcome_var~!!time_var)
  # Low Impact
  res.aov.0 <- kruskal.test(eval(exp2),data=data %>% filter(!!group_var=="Low Impact"))
  a0a <- res.aov.0$statistic
  a0b <- res.aov.0$parameter
  a0c <- res.aov.0$p.value
  
  # High Impact
  res.aov.1 <- kruskal.test(eval(exp2),data=data %>% filter(!!group_var=="High Impact"))
  a1a <- res.aov.1$statistic
  a1b <- res.aov.1$parameter
  a1c <- res.aov.1$p.value
  
  # No Trauma
  res.aov.2 <- kruskal.test(eval(exp2),data=data %>% filter(!!group_var=="No Trauma"))
  a2a <- res.aov.2$statistic
  a2b <- res.aov.2$parameter
  a2c <- res.aov.2$p.value
  
  summary_table_aov <- data.frame(cohort = c("Low Impact", "High Impact", "No Trauma"),
                                  stats_value=c(a0a, a1a, a2a),
                                  p_value=c(a0c,a1c, a2c))
  summary_table_aov$compare <- "Among time points"
  
  # Combine the tests
  summary_table_stats = bind_rows(summary_table_ttest, summary_table_aov) %>% mutate(outcome = outcome_name)
  return(summary_table_stats)
}