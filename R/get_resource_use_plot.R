# FUNCTION TO PLOT RESULTS

get_resource_use_plot <- function(){
  
  results <- c()
  
  results <- get_mon_resources(envs[[1]])
  
  #add in second to nth model runs.
  for(x in 2:n_iterations){
    results <- rbind(results,
                     get_mon_resources(envs[[x]]) %>% 
                       mutate(replication = x)
    )
  }
  
  # create ggplot
  plot <- ggplot(data = results, 
         aes(x = time/24, y  = server, colour = resource)) +
    geom_step(alpha = 0.6) +
    theme_bw() +
    xlab("Time in days") +
    ylab("Amount of resource being used")
  
  return(plot)
    
}