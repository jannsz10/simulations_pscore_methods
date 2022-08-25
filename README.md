# Simulation of Different Methods of Adjusting for confounders in a Cox Regression

## Stata files each produce 10000 simulated datasets (N=3605) containing:

- confounder 1 (binary)
- confounder 2 (continuous)
- confounder 3 (binary)
- exposure group 1 (true hazards ratio: 1.5; N=463)
- exposure group 2 (true hazards ratio: 1.5; N=322)
- outcome variable (binary)

*1_simulate_data_unconfounded.do* produces unconfounded datasets, where confounders 1-3 are not associated with exposure groups. 

In each do file, a cox model is run to obtain estimated coefficients for each of the 10000 simulated models. A different method of controlling for confounding is implemented for each:

 - *2_weighted_yoshida.do* - the weighting method described in this paper: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5378668/pdf/nihms845429.pdf 
 - *3_simulation_control_in_model.do* - adjusting for all 3 confounders
 - *4_simulation_pair_wise_matchingl.do* - separate models are run to compare exposure group 1 vs controls, exposure group 2 vs controls. Exposure propensity scores are estimated using logistic regression with the dependent variables as confounder 1-3. Exposed are matched to unexposed controls 1:2 using nearest neighbour matching without replacement. 
 - *5_simulation_pair_wise_andcontrol* - same as previous, except confounders are also controlled for in Cox model. 

# Plotting results
*density_plots_estimates.R* imports the outputs from do files 2, 3 and 4 are imported and plotted
