
library(rstan)

model <- "
// One-Sample Order Restricted Comparsion of Means
data { 
  int<lower=0> ndata;
  vector[ndata] x;
}
parameters {
  real sigmatmp;
  real<upper=0> delta;
} 
transformed parameters {
  real<lower=0> sigma;
  real mu;

  sigma <- fabs(sigmatmp);
  mu <- delta * sigma;
}
model {
  // Delta and sigma Come From (Half) Cauchy Distributions
  sigmatmp ~ cauchy(0, 1);
  delta ~ cauchy(0, 1)T[,0];

  // Data
  x ~ normal(mu, sigma);
}"

# Read data Dr. Smith
Winter <- c(-0.05,0.41,0.17,-0.13,0.00,-0.05,0.00,0.17,0.29,0.04,0.21,0.08,0.37,
            0.17,0.08,-0.04,-0.04,0.04,-0.13,-0.12,0.04,0.21,0.17,0.17,0.17,
            0.33,0.04,0.04,0.04,0.00,0.21,0.13,0.25,-0.05,0.29,0.42,-0.05,0.12,
            0.04,0.25,0.12)

Summer <- c(0.00,0.38,-0.12,0.12,0.25,0.12,0.13,0.37,0.00,0.50,0.00,0.00,-0.13,
            -0.37,-0.25,-0.12,0.50,0.25,0.13,0.25,0.25,0.38,0.25,0.12,0.00,0.00,
            0.00,0.00,0.25,0.13,-0.25,-0.38,-0.13,-0.25,0.00,0.00,-0.12,0.25,
            0.00,0.50,0.00)

x <- Winter - Summer  # allowed because it is a within-subjects design
x <- x / sd(x)        # standardize
ndata <- length(Winter)  # number of subjects

data <- list(x=x, ndata=ndata)  # to be passed on to Stan

myinits <- list(
  list(delta=-abs(rnorm(1,0,1)), deltaprior=-abs(rnorm(1,0,1)), sigmatmp=.1),
  list(delta=-abs(rnorm(1,0,1)), deltaprior=-abs(rnorm(1,0,1)), sigmatmp=.2),
  list(delta=-abs(rnorm(1,0,1)), deltaprior=-abs(rnorm(1,0,1)), sigmatmp=.3))

# Parameters to be monitored
parameters <- c("delta")

# The following command calls Stan with specific options.
# For a detailed description type "?rstan".
samples <- stan(model_code=model,   
                data=data, 
                init=myinits,  # If not specified, gives random inits
                pars=parameters,
                iter=30000, 
                chains=3, 
                thin=1,
                # warmup=100,  # Stands for burn-in; Default = iter/2
                # seed=123  # Setting seed; Default is random seed
)
# Now the values for the monitored parameters are in the "samples" object, 
# ready for inspection.

plot(samples)

# Collect posterior samples across all chains:
delta.posterior <- extract(samples)$delta

#============ BFs based on logspline fit ===========================
library(polspline) # this package can be installed from within R
fit.posterior <- logspline(delta.posterior)

#============ BFs based on logspline fit ===========================
fit.posterior <- logspline(delta.posterior,ubound=0) # NB. note the bound

# 95% confidence interval:
x0 <- qlogspline(0.025,fit.posterior)
x1 <- qlogspline(0.975,fit.posterior)

posterior <- dlogspline(0, fit.posterior) # this gives the pdf at point delta = 0
prior     <- 2*dcauchy(0)       # height of order--restricted prior at delta = 0
BF01      <- posterior/prior
BF01

#============ Plot Prior and Posterior  ===========================
par(cex.main = 1.5, mar = c(5, 6, 4, 5) + 0.1, mgp = c(3.5, 1, 0), cex.lab = 1.5,
    font.lab = 2, cex.axis = 1.3, bty = "n", las=1)
xlow  <- -3
xhigh <- 0
yhigh <- 12
Nbreaks <- 80
y       <- hist(delta.posterior, Nbreaks, plot=F)

system_info <- Sys.info() # Get system information
os <- system_info["sysname"] # Extract and print the operating system
if (system_info["sysname"] == "Windows") {
  windows() #this command works only under Windows!
} else {
  # Run a different function or do nothing for non-Windows OS
  # library(grDevices)
  # x11(width = 10, height = 5)
  quartz()
}

plot(c(y$breaks, max(y$breaks)), c(0,y$density,0), type="S", lwd=2, lty=2,
     xlim=c(xlow,xhigh), ylim=c(0,yhigh), xlab=" ", ylab="Density", axes=F) 
axis(1, at = c(-3,-2,-1,0), lab=c("-3","-2","-1","0"))
axis(2)
mtext(expression(delta), side=1, line = 2.8, cex=2)
#now bring in log spline density estimation:
par(new=T)
plot(fit.posterior, ylim=c(0,yhigh), xlim=c(xlow,xhigh), lty=1, lwd=1, axes=F)
points(0, dlogspline(0, fit.posterior),pch=19, cex=2)
# plot the prior:
par(new=T)
plot ( function( x ) 2*dcauchy( x, 0, 1 ), xlow, xhigh, ylim=c(0,yhigh),
       xlim=c(xlow,xhigh), lwd=2, lty=1, ylab=" ", xlab = " ", axes=F) 
axis(1, at = c(-3,-2,-1,0), lab=c("-3","-2","-1","0"))
axis(2)
points(0, 2*dcauchy(0), pch=19, cex=2)
