get_params <- function(){
  
  n_pat_day <<- 20  # number of patients per day
  int_arr_mean <<- 24/n_pat_day # mean interval between arrival times (hours)
  
  n_O2 <<- 200       # number of oxygen beds
  n_O2V <<- 100       # number of oxygen and ventilator beds
  
  prop_V <<- 6/20   # proportion of those entering ICU who will need ventilation
  prob_D_O2 <<- 0.79 # prbability of death for those with O2
  prob_D_V <<- 0.86  # probability of death for those with Ventilation
  
  t_V_q1 <<- 3*24   # time in ventilation bed, lower bound
  t_V_q3 <<- 11*24  # time in ventilation bed, upper bound
  t_O2_q1 <<- 3*24   # time in O2 bed, lower bound
  t_O2_q3 <<- 11*24 # time in O2 bed, upper bound
  
  t_nV_D_lb  <<- 1      # time to death for those who don't get ventilator
  t_nV_D_ub  <<- 8      # time to death for those who don't get ventilator
  t_nO2_D_lb <<- 8      # time to death for those who don't get O2
  t_nO2_D_ub <<- 24      # time to death for those who don't get O2
  
}