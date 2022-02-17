/*
Create the report directory for the report generating process.
*/

capture program drop create_report_dir

program create_report_dir
    syntax, in(string) project_name(string)

    local project_path "`in'/`project_name'"

    // Checking if the folder can be create
    capture mkdir "`project_path'"
    if(rc){
        display as error "Unable to create the project, check path names"
        exist 3
    }

    // You can proceed once you create the folder

    local folders "do_files input_md input_tables output_figures"
    local folders "output_md output_tables output_word"
    if(!rc){
        foreach v of local folder{
            mkdir "`project_path'/`v'"
        }
    }

    // save file in memory before manipulations
    tempfile previous_data
    save `previous_data'
    // Copying files to the different repositories
    add_labels "`project_path'/input_tables"
    add_do_files "`project_path'/do_files"
    add_final_headers "`project_path'/input_md"
// return back data in memory
    use "`previous_data'", clear
end


// Adding the labels on the input_label directory
capture program drop add_labels
program add_labels

    // input_folder is the folder where you want to add your new data
    args input_folder

    //------- create the excel table for labelling purposes
    tempfile table_label
    tempvar myf
    capture file close `myf'
    file open `myf' using "`table_label'", write replace
    file write `myf' "Section,Subsection,DisplayMode,InputID,InputNumber,Caption,Figure,Footnote" _n
    file write `myf' "First Section,Introduction auto,Portrait,auto,1,An example of caption,No,You can add footnote"_n
    file write `myf' "Another subsection,Landscape,a landscape table, auto2,2,You can let the figure column empty if you to input a table" _n
    file write `myf' "Figure Section,A figure subsection,Portrait,fist_fig,3,,Yes,You can also add figures" _n
    file close `myf'
    import delimited using "`table_label'", case(preserve) clear delim(",")

    export excel using "`input_folder'/tables_labels.xlsx", sheet("Label") firstrow(variables)

    //------ input the table for the shift graphs
    tempfile shift_graphs
    capture file close `myf'
    file open `myf' using "`shift_graphs'", write replace
    file write `myf' "name,lln,uln,units,parameters" _n
    file close `myf'
    import delimited using "`shift_graphs'", case(preserve) clear delim(",")
    export excel using "`input_folder'/shift_graph_input.xlsx", firstrow(variables)
end

// Adding the final-dofile.do file
capture program drop add_do_files
program add_do_files

    // using the args
    args input_folder

    // The only do-file to add is the final_do_file.
    


end



