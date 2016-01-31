source("setup.R")

usePackage("knitr")

domainMapping <- function() {
  domain_code <- c('t','f')
  domain_desc <- c('time domain','frequency domain')
  data.frame(domain_code, domain_desc)
}

variableMapping <- function() {
  variable_code <- c('mean','std')
  variable_desc <- c('mean','standard deviation')
  data.frame(variable_code, variable_desc)
}

domains <- domainMapping()

variables <- variableMapping()

codebook_table <- inner_join(features, domains, c("domain" = "domain_code")) %>% 
                    inner_join(variables, c("variable" = "variable_code")) %>%
                    select(feature_name, domain_desc, signal, variable_desc, direction, original_feature_name)

sink("codebook_table.md")
kable(codebook_table, format = "markdown")
sink()