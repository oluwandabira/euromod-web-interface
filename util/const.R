# Base scenario values
# Read from this file to avoid running EUROMOD again every time
# Run base system simulation

# shell(' C:\\Users\\kr1stine\\git\\euromod-web-interface\\euromod\\EUROMOD\\Executable\\EM_ExecutableCaller.exe  "C:\\Users\\kr1stine\\git\\euromod-web-interface\\euromod\\EUROMOD_WEB" EE_2018 EE_2018_c1')
# base_output_data <- read.csv(file="euromod/EUROMOD_WEB/output/ee_2018_std.txt", header=TRUE, sep="\t", stringsAsFactors = TRUE)
# base_pay_gap <- monthly_gross_pay_gap_ft(base_output_data)
# base_disp_i_gap_ft <- disposable_income_gap_ft(base_output_data)
# base_disp_i_gap <- disposable_income_gap(base_output_data)
# 
# cat(base_pay_gap)
# cat(base_disp_i_gap_ft)
# cat(base_disp_i_gap)

# 2018
GENDER_PAY_GAP_WORKERS <- 21.8715
DISP_INCOME_GAP_WORKERS <- 12.34206
DISP_INCOME_GAP_ALL <- 14.3661

# Absolute poverty lines
ABSOLUTE_POVERTY_LINE_2020 <- 220.36
ABSOLUTE_POVERTY_LINE_2019 <- 221.36
ABSOLUTE_POVERTY_LINE_2018 <- 215.44
ABSOLUTE_POVERTY_LINE_2017 <- 207.23
ABSOLUTE_POVERTY_LINE_2016 <- 200.12
ABSOLUTE_POVERTY_LINE_2015 <- 201.41
ABSOLUTE_POVERTY_LINE_2014 <- 203.44
ABSOLUTE_POVERTY_LINE_2013 <- 205.30
ABSOLUTE_POVERTY_LINE_2012 <- 195.59
ABSOLUTE_POVERTY_LINE_2011 <- 186.26

# Absolute poverty rates
ABSOLUTE_POVERTY_RATE_2020 <- 2.3
ABSOLUTE_POVERTY_RATE_2019 <- 2.3
ABSOLUTE_POVERTY_RATE_2018 <- 2.2
ABSOLUTE_POVERTY_RATE_2017 <- 2.7
ABSOLUTE_POVERTY_RATE_2016 <- 3.2
ABSOLUTE_POVERTY_RATE_2015 <- 4.3
ABSOLUTE_POVERTY_RATE_2014 <- 6.3
ABSOLUTE_POVERTY_RATE_2013 <- 7.6
ABSOLUTE_POVERTY_RATE_2012 <- 8.4
ABSOLUTE_POVERTY_RATE_2011 <- 8.1

# Relative poverty rates
RELATIVE_POVERTY_RATE_2020 <- 20.7
RELATIVE_POVERTY_RATE_2019 <- 20.7
RELATIVE_POVERTY_RATE_2018 <- 21.7
RELATIVE_POVERTY_RATE_2017 <- 21.9
RELATIVE_POVERTY_RATE_2016 <- 21.0
RELATIVE_POVERTY_RATE_2015 <- 21.7
RELATIVE_POVERTY_RATE_2014 <- 21.6
RELATIVE_POVERTY_RATE_2013 <- 21.8
RELATIVE_POVERTY_RATE_2012 <- 20.7
RELATIVE_POVERTY_RATE_2011 <- 17.5