# TRAJECTORY V

traj_V <- trajectory(name = "traj_02+V") %>%
  
  seize("O2+V", 1) %>%
  
  log_("I am in O2+V") %>%
  
  timeout(function() runif(n = 1,
                           min = t_V,
                           max = t_V)) %>%
  # note finished
  log_("I am out of O2+V") %>% 
  
  release("O2+V", 1)
