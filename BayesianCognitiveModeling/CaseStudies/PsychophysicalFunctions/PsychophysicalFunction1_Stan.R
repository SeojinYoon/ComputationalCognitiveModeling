
library(rstan)

model <- "
// Logistic Psychophysical Function
data { 
  int nsubjs;
  int nstim[nsubjs];
  int n[nsubjs,28];
  int r[nsubjs,28];
  int x[nsubjs,28];
  vector[nsubjs] xmean; 
}
parameters {
  real mua;
  real mub;
  real<lower=0,upper=1000> sigmaa;
  real<lower=0,upper=1000> sigmab;
  vector[nsubjs] alpha;
  vector[nsubjs] beta;
} 
model {
  // Priors
  mua ~ normal(0, inv_sqrt(.001));
  mub ~ normal(0, inv_sqrt(.001));
  
  alpha ~ normal(mua, sigmaa);
  beta ~ normal(mub, sigmab);
  
  for (i in 1:nsubjs) {
    for (j in 1:nstim[i]) {   
      real theta; 
      theta <- inv_logit(alpha[i] + beta[i] * (x[i,j] - xmean[i]));
      r[i,j] ~ binomial(n[i,j], theta);
    }
  }
}"

x <- as.matrix(read.table("data_x.txt", sep="\t"))
x[is.na(x)] = -99  # transforming because Stan won't accept NAs 

n <- as.matrix(read.table("data_n.txt", sep="\t"))
n[is.na(n)] = -99  # transforming because Stan won't accept NAs 

r <- as.matrix(read.table("data_r.txt", sep="\t"))
r[is.na(r)] = -99  # transforming because Stan won't accept NAs 

rprop <- as.matrix(read.table("data_rprop.txt", sep="\t"))

xmean <- c(318.888, 311.0417, 284.4444, 301.5909, 
           296.2000, 305.7692, 294.6429, 280.3571)
nstim <- c(27, 24, 27, 22, 25, 26, 28, 28)
nsubjs <- 8

# to be passed on to Stan
data <- list(x=x, xmean=xmean, n=n, r=r, nsubjs=nsubjs, nstim=nstim) 

myinits <- list( 
  list(alpha=rep(0, nsubjs), beta=rep(0, nsubjs), 
       mua=0, mub=0, sigmaa=1, sigmab=1),
  list(alpha=rep(0, nsubjs), beta=rep(0, nsubjs), 
       mua=0, mub=0, sigmaa=1, sigmab=1))

parameters <- c("alpha", "beta")  # Parameters to be monitored

# The following command calls Stan with specific options.
# For a detailed description type "?rstan".
samples <- stan(model_code=model,
                data=data, 
                init=myinits,
                pars=parameters,
                iter=3000, 
                chains=2, 
                thin=1,
                # warmup = 100,  # Stands for burn-in; Default = iter/2
                # seed = 123  # Setting seed; Default is random seed
)
# Now the values for the monitored parameters are in the "samples" object, 
# ready for inspection.

# Transforming back to NAs
x[x == -99] = NA
n[n == -99] = NA
r[r == -99] = NA

# Extracting the parameters
alpha      = extract(samples)$alpha
beta      = extract(samples)$beta
alphaMAP  = c(rep(0,nsubjs))
betaMAP  = c(rep(0,nsubjs))
alpha_sel = matrix(NA,20,8) 
beta_sel = matrix(NA,20,8) 

# Constructing MAP-estimates and alpha/beta range
for (i in 1:nsubjs)
{
  alphaMAP[i]   <- density(alpha[,i])$x[which(density(alpha[,i])$y ==
                                              max(density(alpha[,i])$y))]
  betaMAP[i]    <- density(beta[,i])$x[which(density(beta[,i])$y ==
                                             max(density(beta[,i])$y))]
  alpha_sel[,i] <- sample(alpha[,i],20)
  beta_sel[,i]  <- sample(beta[,i],20)
}

############################## PSYCHOMETRIC FUNCTIONS ##########################

# only the MAP estimate; use this to plot psychometric functions
F1 <- function(X,s) 
{
  exp(alphaMAP[s] + betaMAP[s]*(X - xmean[s]))/
  (1+exp(alphaMAP[s] + betaMAP[s]*(X - xmean[s])))
}

F1inv <- function(Y,s)
{
  (log(-Y/(Y-1))-alphaMAP[s])/betaMAP[s]
}

# function for all the posterior alpha/beta values; use this to calculate JND 
# posterior
F2 <- function(X,s) 
{
  exp(alpha[,s] + beta[,s]*(X - xmean[s]))/
  (1+exp(alpha[,s] + beta[,s]*(X - xmean[s])))
}
F2inv <- function(Y,s)
{
  (log(-Y/(Y-1))-alpha[,s])/beta[,s]
}

# function for 20 grabbed posterior alpha/beta values; use this to plot 
# overlapping sigmoids to visualize variance
F3 <- function(X,s,g) 
{
  exp(alpha_sel[g,s] + beta_sel[g,s]*(X - xmean[s]))/
  (1+exp(alpha_sel[g,s] + beta_sel[g,s]*(X - xmean[s])))
}

##################################### JND/PSE calculation #####################
JND    <- F2inv(0.84,c(1:nsubjs))-F2inv(0.5,c(1:nsubjs))
JNDmap <- F1inv(0.84,c(1:nsubjs))-F1inv(0.5,c(1:nsubjs))
                                       
PSE    <- F2inv(0.5,c(1:nsubjs))+xmean
PSEmap <- F1inv(0.5,c(1:nsubjs))+xmean
    
################## PLOTS ####################

### Figure 12.2

dev.new(width=10,height=5)
layout(matrix(1:nsubjs,2,4,byrow=T))
par(mar=c(1,2,2,0),oma=c(5,5,1,1))
for (i in 1:nsubjs)
{
  scale <- seq(x[i,1],x[i,nstim[i]], by=.1)
  plot(x[i,],rprop[i,],main=paste("Subject",as.character(i)),xlab="",ylab="",
       pch=15,col="dark grey",ylim=c(0,1),yaxt="n",xaxt="n")
  lines(scale,F1(scale,i),type="l")
  segments(x0=x[i,1],x1=PSEmap[i]+JNDmap[i],y0=0.84,lty=2)
  segments(x0=x[i,1],x1=PSEmap[i],y0=0.5,lty=2)
  segments(y0=0,y1=0.84,x0=PSEmap[i]+JNDmap[i],lty=2)
  segments(y0=0,y1=0.5,x0=PSEmap[i],lty=2)
  if (i==1 | i==5) 
  {
    axis(2,las=1,yaxp=c(0,1,2))
    axis(2,at=0.84,las=1)
  }
  if (i>4) axis(1)
}
mtext("Proportion 'Long' Response",side=2,line=2,outer=T,cex=1.4)
mtext("Test Interval (ms)",side=1,outer=T,line=3,cex=1.4)

### WARNING: Do not close R window.

dev.new(width=10,height=5)
layout(matrix(1:nsubjs,2,4,byrow=T))
par(mar=c(1,2,2,0),oma=c(5,5,1,1))
for (i in 1:nsubjs)
{
  scale <- seq(x[i,1],x[i,nstim[i]], by=.1)
  plot(x[i,],rprop[i,],main=paste("Subject",as.character(i)),xlab="",ylab="",pch=15,col="dark grey",ylim=c(0,1),yaxt="n",xaxt="n")
  for (g in 1:20)
  {
    lines(scale,F3(scale,i,g),type="l",col="light grey")
  }
  lines(scale,F1(scale,i),type="l")
  if (i==1 | i==5) {
    axis(2,las=1,yaxp=c(0,1,2))
    #axis(2,at=0.84,las=1)
  }
  if (i>4) axis(1)
}
mtext("Proportion 'Long' Response",side=2,line=2,outer=T,cex=1.4)
mtext("Test Interval (ms)",side=1,outer=T,line=3,cex=1.4)


#### PLOT FOR EXERCISE 12.1.4 

# Figure
system_info <- Sys.info() # Get system information
os <- system_info["sysname"] # Extract and print the operating system
if (os == "Windows") {
  windows(width=6, height=4)
} else if (os == "Darwin") {  # macOS
  quartz(width=6, height=4)
} else {  # Assume Linux or other Unix-like systems
  x11(width=6, height=4)
}
layout(matrix(1:nsubjs,2,4,byrow=T))
par(mar=c(1,2,2,0),oma=c(5,5,1,1))
for (i in 1:nsubjs)
{
  plot(density(JND[,i]), col="dark grey", type="h", main=paste("Subject",as.character(i)), ylab="", xlab="", xlim=c(10,100), ylim=c(0,0.12), las=1,yaxt="n",xaxt="n")
  par(new=F)
  if (i==1 | i==5) axis(2,las=1, yaxp=c(0,0.12,3))
  if (i>4) axis(1)
}	
mtext("Posterior Density",side=2,line=2,outer=T,cex=1.4)
mtext("JND (ms)",side=1,line=3,outer=T,cex=1.4)




