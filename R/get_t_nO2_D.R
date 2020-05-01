# function to get the time can survive without O2 (in hours)
get_t_nO2_D <- function(){
  
  out <- runif(n = 1,
               min = t_nO2_D_lb,
               max = t_nO2_D_ub)
  
  return(c(out))
}