
library(rstan)

data <- read_rdump("Rate_3.data.R")  # to be passed on to Stan

myinits <- list(
  list(theta=0.5))

# parameters to be monitored:  
parameters <- c("theta")

# The following command calls Stan with specific options.
# For a detailed description type "?stan".
samples <- stan(file="Rate_3.stan",   
                data=data, 
                init=myinits,  # If not specified, gives random inits
                pars=parameters,
                iter=20000, 
                chains=1, 
                thin=1,
                # warmup = 100,  # Stands for burn-in; Default = iter/2
                # seed = 123  # Setting seed; Default is random seed
)
print(samples)

theta <- extract(samples)$theta

# Figure
system_info <- Sys.info() # Get system information
os <- system_info["sysname"] # Extract and print the operating system
if (system_info["sysname"] == "Windows") {
  windows(width=6, height=4)
} else {
  # Run a different function or do nothing for non-Windows OS
  # library(grDevices)
  # x11(width=6, height=4)
  
  quartz(width=6, height=4)
}

# Now let's plot a histogram for theta. 
# First, some options to make the plot look better:
par(cex.main = 1.5, mar = c(5, 6, 4, 5) + 0.1, mgp = c(3.5, 1, 0), cex.lab = 1.5,
    font.lab = 2, cex.axis = 1.3, bty = "n", las=1)
Nbreaks <- 80
y       <- hist(theta, Nbreaks, plot=F)
plot(c(y$breaks, max(y$breaks)), c(0,y$density,0), type="S", lwd=2, lty=1,
     xlim=c(0,1), ylim=c(0,10), xlab="Rate", ylab="Posterior Density") 
