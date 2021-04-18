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