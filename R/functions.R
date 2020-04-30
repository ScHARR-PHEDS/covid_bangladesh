# FUNCTIONS

# function to determine whether individual needs ventilator
fun_needs_V <- function() {
  
  # Determine the responder status using a random number
  out <- ifelse(test = runif(1) < prop_V,
                yes = 1,
                no = 2)
  
  return(c(out));
  
}
