# TRAJECTORY V

traj_V <- trajectory(name = "traj_V") %>%
  
  renege_in(function() get_t_nO2_D(),
            
            out = trajectory("Dead") %>%
              
              log_(function() {
                
                paste("Died waiting", now(env) - get_attribute(env, "start_time"), "Patient Died")
                
              })) %>% 
  
  ## use O2 + Ventilator
  seize("O2+V", 1) %>%
  
  # Stay if patient is seen in time
  renege_abort() %>% 
  
  # log that the patient is in this group
  log_("I am in O2+V") %>%
  
  # length of time which patient uses O2+V for
  timeout(function() runif(n = 1,
                           min = t_V_q1,
                           max = t_V_q3)) %>%
  # note finished
  log_("I am out of O2+V") %>% 
  
  # O2+V no longer needed
  release("O2+V", 1)
