rm(list = ls())

library(simmer)

set.seed(101)

# function to determine whether individual needs ventilator
fun_needs_V <- function() {
  
  # Determine the responder status using a random number
  out <- ifelse(test = runif(1) < prop_V,
                    yes = 1,
                    no = 2)
  
  return(c(out));
  
}

# TRAJECTORY O

traj_O <- trajectory(name = "traj_02") %>%
  
  ## add an intake activity 
  seize("O2", 1) %>%
  
  log_("I am in O2") %>%
  
  timeout(function() runif(n = 1,
                           min =  t_O2,
                           max = t_O2)) %>%
  
  log_("I am out of O2") %>% 
  
  release("O2", 1)




# TRAJECTORY v

traj_V <- trajectory(name = "traj_02+V") %>%
  
  seize("O2+V", 1) %>%
  
  log_("I am in O2+V") %>%
  
  timeout(function() runif(n = 1,
                           min = t_V,
                           max = t_V)) %>%
  # note finished
  log_("I am out of O2+V") %>% 
  
  release("O2+V", 1)



# set parameters
n_O2 = 10  # number of oxygen beds
n_O2V = 5  # number of oxygen and ventilator beds
prop_V = 6/20 # proportion of those entering ICU who will need ventilation
int_arr = 24/20 # interval between arrival times (hours)
t_V = 5*24 # time in ventilation bed
t_O2 = 3*24 # time in O2 bed


# create an environment
env <- simmer("SuperDuperSim")

# create a patient trajectory
patient <- trajectory("patients' path") %>%
  
  # set the start time the patient arrived at
  #set_attribute("start_time", function() {now(env)}) %>%
  #
  # set whether the patient is a patient that needs a ventilator
  set_attribute(keys = "needs_V", 
                values = function() fun_needs_V()
                ) %>%
  
  branch(option = function() fun_needs_V(), 
    
   # get_attribute(.env = env,keys = "needs_V"), 
         continue = c(TRUE,TRUE),
         
   traj_V,
   
   traj_O)
    
  

  
env %>%
  add_resource("O2", n_O2) %>%
  add_resource("O2+V", n_O2V) %>%
  add_generator("patient",
                patient,
                function() runif(n = 1,
                                 min = int_arr,
                                 max = int_arr))


env %>%
  reset() %>%
  run(until = 240) %>%
  now()
