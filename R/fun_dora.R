# function to get the death/recovered state of the individual
fun_dora <- function(ventilated){
  
  rand = runif(n = 1,
               min = 0,
               max = 1)
  
  prob = if_else(condition = (ventilated == 1),
                 true = prob_D_O2,
                 false = prob_D_V)
  
  dora = if_else(condition = rand < prob,
                 true = 1,
                 false = 0)
  
  return(c(dora))
}