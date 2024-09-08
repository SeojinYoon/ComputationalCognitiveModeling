library(rjags)
#provide data from experiment
h <- 60          
f <- 11
sigtrials <- noistrials <- 100   

#define JAGS model
onehtj <- jags.model("1HT.j", 
                   data = list("h"=h, "f"=f, 
                               "sigtrials"=sigtrials,
                               "noistrials"=noistrials),
                    n.chains=4)  
# burnin
update(onehtj,n.iter=1000)  
# perform MCMC
parameters <- c("th1", "th2", "predh", "predf")
mcmcfin<-coda.samples(onehtj,parameters,5000)  

summary(mcmcfin)

system_info <- Sys.info() # Get system information
os <- system_info["sysname"] # Extract and print the operating system
if (system_info["sysname"] == "Windows") {
  windows()
} else {
  # Run a different function or do nothing for non-Windows OS
  # library(grDevices)
  # x11()
  
  quartz()
}
plot(mcmcfin)
if (system_info["sysname"] == "Windows") {
  windows()
} else {
  # Run a different function or do nothing for non-Windows OS
  # library(grDevices)
  # x11()
  
  quartz()
}
acfplot(mcmcfin)
gelman.plot(mcmcfin)






