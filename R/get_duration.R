get_duration <- function(){

env %>% 
  get_mon_arrivals(ongoing = T,
                   per_resource=TRUE) %>% 
  ggplot(aes(activity_time/24)) +
  geom_histogram(na.rm = T, binwidth = 1) +
  xlab("Time Spent in Hospital in Days") +
  ylab("Number of Patients")+
  facet_grid(~resource)
  
}