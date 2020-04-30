# FUNCTION TO PLOT RESULTS

get_resource_use_plot <- function(){
  
env %>% 
  get_mon_resources() %>% 
  ggplot(aes(x = time/24, y = server, col = resource)) +
  theme_bw()+
  geom_line() +
  xlab("Time in days") +
  ylab("Amount of resource used")
  
}