# GET CUMULATIVE RESOURCE USE

get_cum_resource_plot <- function(path = "outputs/psa_results.rda"){
  
  envs <- readRDS(file = paste(path))
  
  # create results for 1
  dt_results <- get_mon_resources(envs[[1]]) %>% as.data.table()
  #add in second to nth model runs.
  #for(x in 2:n_iterations){
  #  results <- rbind(results,
  #                   get_mon_resources(envs[[x]]) %>% 
  #                     mutate(replication = x))}
  
  
  # analyse results:
  dt_results$duration = c(dt_results$time[1:(length(dt_results$time)-1)],0) - c(0,dt_results$time[1:(length(dt_results$time)-1)]) 
  # quantity
  dt_results$quantity =  c(0,dt_results$server[1:(length(dt_results$time)-1)])
  
  
  dt_results[,CumO2 := cumsum(x = duration * quantity),by = c("resource","replication")]
  
  # PLOT OF CUMULATIVE TIME IN EACH RESOURCE
  out.plot <- dt_results %>% 
    filter(replication == 1 & time<900) %>% 
    mutate(time = time/24) %>% 
    ggplot(aes(x = time, 
               y = CumO2, 
               col = resource))+
    theme_classic()+
    geom_line()+
    ylab(label = "Cumulative hours of resource use")+
    xlab(label = "Time in days") +
    labs(title = "Cumulative time in each resource type")
  
  return(out.plot)
  
}
