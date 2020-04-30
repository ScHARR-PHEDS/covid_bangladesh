# setup #
rm(list = ls())
set.seed(100)

library(simmer)   # R simmer package
library(dplyr)    # allowing pipes
library(miceadds) # this library has the source all function in (should be in base-R really)
library(truncnorm) # loads the truncnorm package
library(simmer.plot) # produces plots using ggplot
library(ggplot2) # for plots

# source all R files.
source.all("R")

# set parameters
n_pat_day = 20  # number of patients per day
int_arr_mean = 24/n_pat_day # mean interval between arrival times (hours)

n_O2 = 10       # number of oxygen beds
n_O2V = 5       # number of oxygen and ventilator beds

prop_V = 6/20   # proportion of those entering ICU who will need ventilation

t_V_q1 = 3*24   # time in ventilation bed, lower bound
t_V_q3 = 11*24  # time in ventilation bed, upper bound
t_O2_q1= 3*24   # time in O2 bed, lower bound
t_O2_q3 = 11*24 # time in O2 bed, upper bound

t_nV_D = 1      # time to death for those who don't get ventilator
t_nO2_D = 1     # time to death for those who don't get O2

# create an environment
env <- simmer("SuperDuperSim")

#-------------------------------#
#   CREATE PATIENT TRAJECTORY   #
#-------------------------------#

patient <- trajectory("patients' path") %>%
  
  # set the start time the patient arrived at
  set_attribute("start_time", function() {now(env)}) %>%
  #
  # set whether the patient is a patient that needs a ventilator
  set_attribute(keys = "needs_V", 
                values = function() fun_needs_V()
                ) %>%
  
  branch(option = function() fun_needs_V(), 
         
         continue = c(TRUE,TRUE),
         
   traj_V,
   
   traj_O)
    
  
#--------------------------#
#    UPDATE ENVIRONMENT    #
#--------------------------#

env %>%
  # number of O2 is fixed
  add_resource("O2", n_O2) %>%
  # number of ventilators is fixed
  add_resource("O2+V", n_O2V) %>%
  # patients enter based on truncnormal distribution - could be changed to poisson.
  add_generator("patient",
                patient,
                function() rtruncnorm(a = 1,
                                      b = 10, 
                                      n = 1,
                                      mean = int_arr_mean,
                                      sd = int_arr_mean/10))

#--------------------------#
#       RUN SIMULATION     #
#--------------------------#

env %>%
  # reset the model
  reset() %>%
  # run until 30 days
  run(until = 30*24) 

#--------------------------#
#     ANALYSE RESULTS      #
#--------------------------#

env %>% 
  get_mon_arrivals(ongoing = T,
                   per_resource=TRUE) %>% 
  ggplot(aes(end_time - start_time)) +
  geom_histogram() +
  xlab("Time spent in the system") +
  ylab("Number of customers")+
  facet_grid(~resource)

#df_results %>% arrange(start_time) %>% transform(waiting_time = end_time - start_time - activity_time)

get_mon_resources(env)
