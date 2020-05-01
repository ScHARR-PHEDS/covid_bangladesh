# function to get the time can survive without ventilation (in hours)
get_t_nV_D <- function(){
  
  out <- runif(n = 1,
               min = t_nV_D_lb,
               max = t_nV_D_ub)
  
  return(c(out))
}
