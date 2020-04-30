# TRAJECTORY O

traj_O <- trajectory(name = "traj_02") %>%
  
  renege_in(function() get_t_nV_D(),
            
            out = trajectory("Dead") %>%
              
              log_(function() {
                
                paste("Died waiting", now(env) - get_attribute(env, "start_time"), "Patient Died")
                
              })) %>% 
  
  ## use O2 
  seize("O2", 1) %>%
  
  # Stay if patient is seen in time
  renege_abort() %>% #
  
  # log that the patient is in this group
  log_("I am in O2") %>%
  
  # length of time which patient uses O2+V for
  timeout(function() runif(n = 1,
                           min =  t_O2_q1,
                           max = t_O2_q3)) %>%
  
  # set attibute as to whether the individual has died or not.
  set_attribute(keys = "dead_or_recovered", 
                values = function() fun_dora(ventilated = get_attribute(env, "needs_V"))) %>% 
  
  # note finished
  log_("I am out of O2") %>% 
  
  # O2+V no longer needed
  release("O2", 1)

