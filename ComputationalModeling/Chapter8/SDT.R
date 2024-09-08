library(rjags)
#provide data from experiment
h <- 60         
f <- 11
sigtrials <- noistrials <- 100  

#initialize for JAGS
oneinit <- list(d=0, b=0)   
myinits <- list(oneinit)[rep(1,4)]
myinits <- lapply(myinits,FUN=function(x) lapply(x, FUN=function(y) y+rnorm(1,0,.1)))
sdtj <- jags.model("SDT.j", 
                   data = list("h"=h, "f"=f, 
                               "sigtrials"=sigtrials,"noistrials"=noistrials),
                   inits=myinits,
                   n.chains=4)  
# burnin
update(sdtj,n.iter=1000)  
# perform MCMC
parameters <- c("d", "b", "phih", "phif")
mcmcfin<-coda.samples(sdtj,parameters,5000) 

summary(mcmcfin)

# Get the operating system name
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

# Plot
plot(mcmcfin)
gelman.plot(mcmcfin)