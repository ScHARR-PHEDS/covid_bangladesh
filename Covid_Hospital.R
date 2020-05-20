# setup #
rm(list = ls())

# load packages
pacman::p_load(simmer,simmer.plot,dplyr,miceadds,
               truncnorm,ggplot2,parallel,data.table, DiagrammeR)

# source all R files.
source.all("R")

# get necessary parameters
get_params()

# create visualisation
plot_concept_model()

#-------------------------------#
#   CREATE PATIENT TRAJECTORY   #
#-------------------------------#

traj_Patient <- trajectory("patients' path") %>%
  
  # set the start time the patient arrived at
  set_attribute("start_time", function() {now(env)}) %>%
  #
  # set whether the patient is a patient that needs a ventilator
  set_attribute(keys = "needs_V", 
                values = function() fun_needs_V()
  ) %>%
  
  branch(option = function() fun_needs_V(), 
         
         continue = c(TRUE,TRUE),
         
         #  if patient needs ventilator, goes down Ventilator route    
         traj_V,
         
         # if patient needs Oxygen only, goes down this route
         traj_O)

#--------------------------#
#    CREATE ENVIRONMENT    #
#--------------------------#

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

#--------------------------#
#    RUN SIMULATION ONCE   #
#--------------------------#

n_iterations <- 100

# one run
env %>%
  #make sure the model is reset to start:
  reset() %>%
  # run the simulation until 100 days:
  run(until = 2400)

saveRDS(object = env,
        file = "outputs/single_result.rda")

#--------------------------#
#         RUN PSA          #
#--------------------------#

envs <- mclapply(
  X = 1:n_iterations,
  FUN = function(i) {
    env %>%
      #make sure the model is reset to start:
      reset() %>%
      # run the simulation until 100 days:
      run(1000) %>%
      wrap()
  }
)

saveRDS(object = envs,
        file = "outputs/psa_results.rda")

# end of model
# rm(list = ls())


#--------------------------#
#     ANALYSE RESULTS      #
#--------------------------#
ggsave(plot = get_cum_resource_plot(path = "outputs/psa_results.rda"),
       device = "png",
       width = 7,
       height = 7,
       filename = "outputs/cum_resource_use.png")

 
# GET SINGLE RESOURCE USE PLOT
env <- readRDS(file = "outputs/single_result.rda")
plot(x = get_mon_resources(env), 
       metric = "usage", 
       names = c("O2", "O2+V"), 
       items = "server")

# PLOT TIME SPENT IN SYSTEM - REMEMBER PEOPLE DIE IF NOT SEEN
envs <- readRDS(file = "outputs/psa_results.rda")
ggsave(plot = get_duration(),
       device = "png",
       width = 7,
       height = 7,
       filename = "outputs/duration.png")


# PLOT THE QUEUE - REMEMBER PEOPLE DIE IF NOT SEEN
ggsave(plot = get_resource_use_plot(),
       device = "png",
       width = 7,
       height = 7,
       filename = "outputs/resource_use.png")
