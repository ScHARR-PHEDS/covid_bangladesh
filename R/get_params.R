get_params <- function(){
  
  n_pat_day <<- 20  # number of patients per day
  int_arr_mean <<- 24/n_pat_day # mean interval between arrival times (hours)
  
  n_O2 <<- 200        # number of oxygen beds
  n_O2V <<- 100       # number of oxygen and ventilator beds
  
  prop_V <<- 0.3     # proportion of those entering ICU who will need ventilation
  
  # Dying from lack of resource
  t_nV_D_lb  <<- 1      # time to death for those who don't get ventilator they need
  t_nV_D_ub  <<- 8      # time to death for those who don't get ventilator they need
  t_nO2_D_lb <<- 8      # time to death for those who don't get O2 they need
  t_nO2_D_ub <<- 24     # time to death for those who don't get O2 they need
  
  # Time in oxygen beds
  t_O2_q1 <<- 5*24   # time in O2 bed, lower bound
  t_O2_q3 <<- 19*24  # time in O2 bed, upper bound
  t_O2_pV_q1 <<- 5*24   # time in O2 bed post ventilation, lower bound
  t_O2_pV_q3 <<- 19*24  # time in O2 bed post ventilation, upper bound
  prob_D_O2  <<- 0.79     # probability of death for those in O2 (Lancet China paper)
  prob_D_O2_pV <<- 0     # probability of death for those in O2 post ventilation (Lancet China paper)
  
  # O2 to Vent
  prob_O2_t_V <<- 0.5 # probability of moving to vent once triaged to O2.
  t_O2_t_V_lb <<- 2*24   # time until move to vent once triaged to O2. Lower bound
  t_O2_t_V_ub <<- 5*24   # time until move to vent once triaged to O2. Upper bound
  
  # Time in ventilation beds.
  t_V_q1 <<- 5*24   # time in ventilation bed, lower bound
  t_V_q3 <<- 19*24  # time in ventilation bed, upper bound
  prob_D_V <<- 0.86  # probability of death for those with Ventilation (Lancet China paper)
  
  
}