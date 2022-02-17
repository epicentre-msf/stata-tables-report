capture program drop add_perc
program add_perc
  syntax varlist(min = 1) [if] [, DENOMinators(numlist>0 integer) Form(string)]
  marksample touse, novarlist
  
  * fixing the format
  
  if ("`form'" == ""){
	  local form "%9.1f"
	}
  
  *replace the denominators by N
  if("`denominators'" == ""){
    quietly count if `touse'
    local denominators = r(N)
  }
  
  quietly ds
  local allvars r(varlist)
  
  *ensure the denomitors has same length as nvars
  local nbdenom : word count `denominators'
  local nbvar: word count `varlist'
  
  if(`nbdenom' != 1 & (`nbdenom' != `nbvar')){
    display as error "Number of denominators and number of variables does not match"
    exit 3
  }
  else{
    *duplicates the denomiators if required
    if (`nbdenom' == 1){
       local denominators: display _dup(`nbvar') " `denominators'"
    }
    
    tokenize "`denominators'"
    forvalues i=1/`nbvar'{
      local denom`i' =  ``i''
    }
    
    tokenize "`varlist'"
    forvalues i=1/`nbvar'{
      replace ``i'' = 0 if ``i'' == .
      tempvar perc
      gen `perc' = 100 * ``i'' / `denom`i''
      tempvar sperc
      gen `sperc' = string(`perc', "`form'"), before(``i'')
      quietly replace `sperc' =  string(``i'') + " (" + `sperc' + ")" 
      drop ``i''
      rename `sperc'  ``i''
    }
  }
end