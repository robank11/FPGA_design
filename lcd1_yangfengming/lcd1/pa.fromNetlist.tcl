
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name lcd1 -dir "C:/Users/123/lcd1/planAhead_run_1" -part xc3s100ecp132-5
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/123/lcd1/lcd1.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/123/lcd1} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "lcd1.ucf" [current_fileset -constrset]
add_files [list {lcd1.ucf}] -fileset [get_property constrset [current_run]]
link_design
