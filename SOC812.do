clear

use "\\Client\E$\CovidOECDDataset.dta"

//Make new dichotomous variable for whether a country has a job retention scheme or not
gen jr_scheme = 0
replace jr_scheme = 1 if stw_scheme == 1 | ws_scheme == 1

//Generate summary statistics and frequency distributions for each variable
summarize q2_gdpcap q2_gdicap delta_ur q4_gdpcap q4_gdicap stim_size wr_rate jr_scheme u_transfer economy covid lockdown

hist q2_gdpcap, freq
hist q2_gdicap, freq
hist q4_gdpcap, freq
hist q4_gdicap, freq
hist delta_ur, freq
hist stim_size, freq
hist wr_rate, freq
hist jr_scheme, freq
hist u_transfer, freq
hist economy, freq
hist covid, freq
hist lockdown, freq

//Test each model for multicollinearity, heteroskedasticity, omitted variables, and normality of residuals
reg q2_gdpcap q4_gdpcap stim_size wr_rate jr_scheme u_transfer economy covid lockdown

vif
estat hettest
estat ovtest
predict resid, resid
swilk resid
kdensity resid
drop resid

reg q2_gdicap q4_gdicap stim_size wr_rate jr_scheme u_transfer economy covid lockdown

vif
estat hettest
estat ovtest
predict resid, resid
swilk resid
kdensity resid
drop resid

//This model failed to pass the omitted variables test so make new interaction variable between stim_size and q4_gdicap
gen stim_gdi = stim_size * q4_gdicap
reg q2_gdicap q4_gdicap stim_size stim_gdi wr_rate jr_scheme u_transfer economy covid lockdown
estat ovtest

reg delta_ur stim_size wr_rate jr_scheme u_transfer economy covid lockdown

vif
estat hettest
estat ovtest
predict resid, resid
swilk resid
kdensity resid

//Many predictor variables in the models lack significance so remove additional independent variables from each model that could be collinear and run the models
reg q2_gdpcap q4_gdpcap stim_size economy covid lockdown
estimates store m1, title(MODEL1)
reg q2_gdpcap q4_gdpcap wr_rate economy covid lockdown
estimates store m2, title(MODEL2)
reg q2_gdpcap q4_gdpcap jr_scheme economy covid lockdown
estimates store m3, title(MODEL3)
reg q2_gdpcap q4_gdpcap u_transfer economy covid lockdown
estimates store m4, title(MODEL4)

reg q2_gdicap q4_gdicap stim_size stim_gdi economy covid lockdown
estimates store m5, title(MODEL5)
reg q2_gdicap q4_gdicap wr_rate economy covid lockdown
estimates store m6, title(MODEL6)
reg q2_gdicap q4_gdicap jr_scheme economy covid lockdown
estimates store m7, title(MODEL7)
reg q2_gdicap q4_gdicap u_transfer economy covid lockdown
estimates store m8, title(MODEL8)

reg delta_ur stim_size economy covid lockdown
estimates store m9, title(MODEL9)
reg delta_ur wr_rate economy covid lockdown
estimates store m10, title(MODEL10)
reg delta_ur jr_scheme economy covid lockdown
estimates store m11, title(MODEL11)
reg delta_ur u_transfer economy covid lockdown
estimates store m12, title(MODEL12)

//Output table of all regression coefficients
estout m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12

//Output bar graphs of each independent variable by economy type
graph bar q2_gdicap, over(economy)
graph bar q2_gdpcap, over(economy)
graph bar delta_ur, over(economy)
