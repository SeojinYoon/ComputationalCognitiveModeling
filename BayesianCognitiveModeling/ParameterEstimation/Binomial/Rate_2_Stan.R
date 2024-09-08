
library(rstan)

data <- read_rdump("Rate_2.data.R")  # to be passed on to Stan

myinits <- list(
  list(theta1=0.1, theta2=0.9))

# parameters to be monitored:  
parameters <- c("delta", "theta1", "theta2")

# The following command calls Stan with specific options.
# For a detailed description type "?stan".
samples <- stan(file="Rate_2.stan",   
                data=data, 
                init=myinits,  # If not specified, gives random inits
                pars=parameters,
                iter=20000, 
                chains=1, 
                thin=1,
                # warmup=100,  # Stands for burn-in; Default = iter/2
                # seed=123  # Setting seed; Default is random seed
)
# Now the values for the monitored parameters are in the "samples" object, 
# ready for inspection.

print(samples)

# Collect posterior samples:
delta <- extract(samples)$delta

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

# Now let's plot a histogram for delta. 
# First, some options to make the plot look better:
par(cex.main = 1.5, mar = c(5, 6, 4, 5) + 0.1, mgp = c(3.5, 1, 0), cex.lab = 1.5,
    font.lab = 2, cex.axis = 1.3, bty = "n", las=1)
Nbreaks <- 80
y       <- hist(delta, Nbreaks, plot=F)
plot(c(y$breaks, max(y$breaks)), c(0,y$density,0), type="S", lwd=2, lty=1,
     xlim=c(-1,1), ylim=c(0,10), xlab="Difference in Rates", 
     ylab="Posterior Density") 

# mean of delta:
mean(delta)
# median of delta:
median(delta)
# mode of delta, estimated from the "density" smoother:
density(delta)$x[which(density(delta)$y==max(density(delta)$y))]
# 95% credible interval for delta:
quantile(delta, c(.025,.975))
