# Parallel Function

#--------------------------#
#       PARALLELIZE        #
#--------------------------#

library(parallel)

# make cluster
cl <- makeCluster(detectCores() - 1 )

# load packages
clusterEvalQ(cl,{
  
  # all packages
  library(simmer)      # R simmer package
  library(dplyr)       # allowing pipes
  library(miceadds)    # this library has the source all function in (should be in base-R really)
  library(truncnorm)   # loads the truncnorm package
  library(simmer.plot) # produces plots using ggplot
  library(ggplot2)     # for plots
  
})





clusterExport(cl = cl,
              varlist = (list(ls()) %>% unlist)[2:34])


# run in parallel
envs <- parLapply(cl = cl,
                  X = 1:n_iterations,
                  fun =  
                    
                    function(i) {
                      
                      # create an environment
                      env <- simmer("SuperDuperSim") %>%
                        # number of O2 is fixed
                        add_resource("O2", n_O2) %>%
                        # number of ventilators is fixed
                        add_resource("O2+V", n_O2V) %>%
                        # patients enter based on truncnormal distribution - could be changed to poisson.
                        add_generator("patient",
                                      traj_Patient,
                                      function()
                                        rtruncnorm(
                                          a = 1,
                                          b = 10,
                                          n = 1,
                                          mean = int_arr_mean,
                                          sd = int_arr_mean / 10
                                        ))
                      
                      env %>%
                        #make sure the model is reset to start:
                        reset() %>%
                        # run the simulation until 100 days:
                        run(1000)
                      
                      
                    })

stopCluster(cl)