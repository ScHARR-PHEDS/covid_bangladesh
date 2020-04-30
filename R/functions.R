# FUNCTIONS

# function to determine whether individual needs ventilator
fun_needs_V <- function() {
  
  # Determine the responder status using a random number
  out <- ifelse(test = runif(1) < prop_V,
                yes = 1,
                no = 2)
  
  return(c(out));
  
}

# function to get the time can survive without ventilation (in hours)
get_t_nV_D <- function(){
  
  out <- runif(n = 1,
               min = t_nV_D_lb,
               max = t_nV_D_ub)
  
  return(c(out))
}

# function to get the time can survive without O2 (in hours)
get_t_nO2_D <- function(){
  
  out <- runif(n = 1,
               min = t_nO2_D_lb,
               max = t_nO2_D_ub)
  
  return(c(out))
}

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



