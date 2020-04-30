# TRAJECTORY O

traj_O <- trajectory(name = "traj_02") %>%
  
  ## add an intake activity 
  seize("O2", 1) %>%
  
  log_("I am in O2") %>%
  
  timeout(function() runif(n = 1,
                           min =  t_O2_q1,
                           max = t_O2_q3)) %>%
  
  log_("I am out of O2") %>% 
  
  release("O2", 1)

