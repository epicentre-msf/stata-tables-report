// Programs for tables

capture program drop quant
program quant
	version 15
	*Full results write result like N, median (IQR) (min/max)
	*Mean only writes result like - N, mean (SD)
	*Median only writes result like median (IQR) (min/max)
	
	syntax varlist(min=1 numeric) [if] [, FULLresult MEANonly MEDianonly ///
	Form(string) mxsep(string) medsep(string) mxbrack(string)  ///
	medbrack(string)]
	* Number of values previously in the data frame without missing values
	marksample touse, novarlist
	
	if ("`mxsep'" == "") {
		local mxsep = "/"
	}
	
	if ("`medsep'" == "") {
		local medsep = ";"
	}
	
	local mop = "("
	local mcl = ")"

	if ("`mxbrack'" == "b"){
		local  mop = "["
		local mcl  = "]"
	}
		
	local medop = "["
	local medcl = "]"
	
	if ("`medbrack'" == "p"){
		local medop = "("
		local medcl =  ")"
	}
	
	if ("`form'" == ""){
	   local form  "%9.1f"
	}
	
	
	quietly count if `touse'
  *local N = `r(N)'
	foreach v of varlist `varlist'{
		* Working on full result first
		quietly summarize `v' if `touse', detail
		local med = string(`r(p50)', "`form'")
		local p25 = string(`r(p25)', "`form'")
		local p75 =  string(`r(p75)', "`form'")
		local min = string(`r(min)', "`form'")
		local max = string(`r(max)', "`form'")
		local mn = string(`r(mean)', "`form'")
		local sd = string(`r(sd)', "`form'")
		local nobs = `r(N)'	
    
		*if ("`nobs'" != "`N'"){
			local fpart "`nobs', "
		*}
		
		if ("`meanonly'" != "")  {
			gen tab_`v'_mn = "`nobs', `mn' (`sd')"
		} 
		
		if ("`medianonly'" != "") {
			gen tab_`v'_med = "`med'  " + "`medop'" + "`p25' " + "`medsep'" + " `p75'" +  ///
			"`medcl'" + "  " + "`mop'" + "`min' " + "`mxsep'" + " `max'" + "`mcl'"
		}
		
		if ("`fullresult'" != "") {
			gen tab_`v' =  "`fpart' `med' " + "`medop'" + "`p25' " + "`medsep'" + " `p75'" +  ///
			"`medcl'" + "  " + "`mop'" + "`min' " + "`mxsep'" + " `max'" + "`mcl'"
		}
		// Avoid regression with previous code
		if ("`fullresult'" == "") & ("`medianonly'" == "") & ("`meanonly'" == "") {
			gen tab_`v' =  "`fpart' `med'" + " " + " `medop'" + "`p25' " + "`medsep'" + " `p75'" +  ///
			"`medcl'" + "  " + "`mop'" + "`min' " + "`mxsep'" + " `max'" + "`mcl'"
		}
	}
end
