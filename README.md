Discrete event simulation of Covid19 response for Bangladeshi hospitals

Currently the model is a very simple R-simmer model in which patients enter at fixed inter-arrival times, 
and then are triaged to O2 beds or O2+Ventilator (O2+V) beds based on severity. 

They stay in these beds for a fixed amount of time (differs between O2 and Ventilators).

Next steps
  
  - Add in probability of death and recovery from each of the bed times (O2/V). Tazeen to add in prob of death in each.
  - Also length of time currently estimated as 5 days and 7 days, but is this right?
  - We need accurate projections of arrivals for the two types of severity.
  - Rob to adapt interarrival times so approx right number but at random times throughout the day!
  - Ideally want to know time to transiton between beds (e.g. V -> O2 and O2 -> V)
  - Wrap up into Shiny Function and deploy online for hospitals to use.
 
 
Authors:
Tazeen Tahsina (University of Sheffield)
Robert Smith (University of Sheffield)

Reviewed by:
(?) P.S or S.B or M.S. (?)
