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
  
  out <- t_nV_D
  
  return(c(out))
}

# function to get the time can survive without O2 (in hours)

get_t_nO2_D <- function(){
  
  out <- t_nO2_D
  
  return(c(out))
}