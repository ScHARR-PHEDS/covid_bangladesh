# Discrete event simulation of Covid19 response for Bangladeshi hospitals

Super simple to start with:

![PLOT 1](https://github.com/RobertASmith/covid_bangladesh/blob/master/outputs/concept_model.png)

A person arrives at hospital, they are triaged to need either O2 or 'O2 and ventilation'.
 
They remain on their 'treatment' until they either recover or die. Patients who need O2 and receive treatment either recover  or die after m hours. Patients who need O2+Vent and receive treatment either recover or die after n hours. 
 
There are a fixed number of beds with O2, and a fixed number of beds with 'O2 and ventilation'. 
 
A certain number of patients arrive at random intervals throughout the day. If a bed is not available for a patient who needs O2 then they die after a certain number of hours. If a bed is not available for a patient who needs o2+Vent then they die after a certain number of hours.
 
The simulation is run with all beds initially empty. It is run for 100 days.
 
Where possible the values incorporate heterogeneity, so for example length of stay for O2 has a interquartile range of 3-11, so rather than using 7 for everyone we can assign every person going through the simulation a different length of stay to reflect this heterogeneity. At the moment I have assumed uniform distributions, it would be good to change that.


## Paramters
n_pat_day = 20   # number of patients per day

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


## Code

The simmer code can be found in the R folder.

## Results

Preliminary results suggest a large numeber of ventilators are necessary:

![PLOT 1](https://github.com/RobertASmith/covid_bangladesh/blob/master/outputs/resource_use.png)
The cumulative amount of resource used is substantial:

![PLOT 1](https://github.com/RobertASmith/covid_bangladesh/blob/master/outputs/cum_resource_use.png)


### Next steps
  
  - We need more accurate projections of arrivals for the two types of severity.
  
  - Would be better to know arrival times by hour of day.
  
  - Ideally want to know time to transiton between beds (e.g. V -> O2 and O2 -> V)
  
  - Wrap up into Shiny Function and deploy online for hospitals to use.
 
 
Authors:

Robert Smith (University of Sheffield)

Tazeen Tahsina (University of Sheffield)


Reviewed by:
(?) P.S or S.B or M.S. (?)
