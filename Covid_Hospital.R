# setup #
rm(list = ls())
set.seed(100)

library(simmer)   # R simmer package
library(dplyr)    # allowing pipes
library(miceadds) # this library has the source all function in (should be in base-R really)
library(truncnorm)

# source all R files.
source.all("R")

# set parameters
n_pat_day = 20
n_O2 = 10       # number of oxygen beds
n_O2V = 5       # number of oxygen and ventilator beds
prop_V = 6/20   # proportion of those entering ICU who will need ventilation
int_arr_mean = 24/n_pat_day # mean interval between arrival times (hours)
t_V_q1 = 3*24   # time in ventilation bed, lower bound
t_V_q3 = 11*24  # time in ventilation bed, upper bound
t_O2_q1= 3*24   # time in O2 bed, lower bound
t_O2_q3 = 11*24 # time in O2 bed, upper bound

# create an environment
env <- simmer("SuperDuperSim")

#-------------------------------#
#   CREATE PATIENT TRAJECTORY   #
#-------------------------------#

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
    
  
#--------------------------#
#    UPDATE ENVIRONMENT    #
#--------------------------#

env %>%
  add_resource("O2", n_O2) %>%
  add_resource("O2+V", n_O2V) %>%
  add_generator("patient",
                patient,
                function() rtruncnorm(a = 0,
                                      b = 10, 
                                      n = 1,
                                      mean = int_arr_mean,
                                      sd = int_arr_mean/10))

#--------------------------#
#       RUN SIMULATION     #
#--------------------------#

env %>%
  reset() %>%
  run(until = 300) %>%
  now()

#--------------------------#
#     ANALYSE RESULTS      #
#--------------------------#

df_results <- env %>% get_mon_arrivals(ongoing = T)

df_results %>% arrange(start_time)
