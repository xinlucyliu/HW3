insheet using ~/Dropbox/sports-and-education.csv
label variable academicquality "Academic Quality"
label variable athleticquality "Athletic Quality"
label variable nearbigmarket "Near Big Market"
label variable alumnidonations2018 "Alumni Donation"

* Create Balance Tables after t-test
. global balanceopts "bf(%15.3gc) sfmt(%15.3gc) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01)"

. estpost ttest academicquality athleticquality nearbigmarket, by(ranked2017) unequal welch
esttab . using balance_table.rtf, cell("mu_1(f(3)) mu_2(f(3)) b(f(3) star)") wide collabels("Control" "Treatment" "Difference") noobs $balanceopts mlabels(none) eqlabels(none) legend replace mgroups(none)

* Predict the probability of treatment
 reg ranked2017 athleticquality nearbigmarket alumnidonations2018 
 eststo regression_one 
 global tableoptions "bf(%15.2gc) sfmt(%15.2gc) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"
esttab regression_one using predict_treatment.rtf, $tableoptions keep(academicquality athleticquality nearbigmarket alumnidonations2018) 

* Use stacked histograms to show overlap in the between ranked and unranked school
sort propoensity_score
. gen block = floor(_n/4)

* Analyze the treatment effect
reg alumnidonations2018 ranked2017 athleticquality nearbigmarket i.block
