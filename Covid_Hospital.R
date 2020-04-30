# setup #
rm(list = ls())
set.seed(1000)

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

n_O2 = 200       # number of oxygen beds
n_O2V = 100       # number of oxygen and ventilator beds

prop_V = 6/20   # proportion of those entering ICU who will need ventilation
prob_D_O2 = 0.79 # prbability of death for those with O2
prob_D_V = 0.86  # probability of death for those with Ventilation

t_V_q1 = 3*24   # time in ventilation bed, lower bound
t_V_q3 = 11*24  # time in ventilation bed, upper bound
t_O2_q1= 3*24   # time in O2 bed, lower bound
t_O2_q3 = 11*24 # time in O2 bed, upper bound

t_nV_D_lb  = 1      # time to death for those who don't get ventilator
t_nV_D_ub  = 8      # time to death for those who don't get ventilator
t_nO2_D_lb = 8      # time to death for those who don't get O2
t_nO2_D_ub = 24      # time to death for those who don't get O2

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
   
   #  if patient needs ventilator, goes down Ventilator route    
   traj_V,
   
   # if patient needs Oxygen only, goes down this route
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
  run(until = 2400 )

#--------------------------#
#     ANALYSE RESULTS      #
#--------------------------#

# PLOT TIME SPENT IN SYSTEM - REMEMBER PEOPLE DIE IF NOT SEEN
env %>% 
  get_mon_arrivals(ongoing = T,
                   per_resource=TRUE) %>% 
  ggplot(aes(end_time - start_time)) +
  geom_histogram(binwidth = 10) +
  xlab("Time spent in the system") +
  ylab("Number of customers")+
  facet_grid(~resource)

# PLOT THE QUEUE - REMEMBER PEOPLE DIE IF NOT SEEN
ggsave(plot = get_resource_use_plot(),
       device = "png",
       width = 7,
       height = 7,
       filename = "outputs/resource_use.png")
