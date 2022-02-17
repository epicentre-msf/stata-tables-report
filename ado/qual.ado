// qualitative var

capture program drop qual
program qual
  version 15
	syntax varlist(min=1) [if] [, Form(string)]	
	marksample touse, novarlist
	
	if ("`form'" == ""){
	  local form "%9.1f"
	}
	
	quietly count if `touse'
	local N = `r(N)'
	foreach v of varlist `varlist'{
	  quietly sum `v' if `touse', detail
		local n_m = `r(sum)'
		local nobs = `r(N)'
		*the mean is sometimes empty
		local perc_m = 100 * (`n_m' / `nobs')
		local perc_m = string(`perc_m', "`form'")
    //If you have a dot, replace by 0
    if ("`perc_m'" == "."){
    	local perc_m "0.0"
    }
		
		if ("`nobs'" == "`N'"){
		  local qual = "`n_m' (`perc_m')"
		}
		else{
		  local qual = "`nobs', `n_m' (`perc_m')"
		}
		gen tab_`v' = "`qual'"
	}
end
