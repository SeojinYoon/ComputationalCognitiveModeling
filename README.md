
# ComputationalCognitiveModeling

This repository is for "ComputationalCognitiveModeling" class in Hanyang university. There are two kinds of directory the one is BayesianCognitiveModeling(Lee, M., & Wagenmakers, E. (2014)) and the other is ComputationalModeling(Farrell & Lewandowsky, S. (2018)).  

I checked the sources on my mac and windows computer using r-studio(version: 2023.06.2+561). 

# Library version

Some Sources in this repository are sensitive to library version. Following lines are methods to check version of library. After importing a library, You can check library version using sessionInfo().

```r
library(rstan)  
sessionInfo()  
```

# Dependency

## BayesianCognitiveModeling

For running codes in BayesianCognitiveModeling, You have to install some libraries (rstan, rtools). Following configuration are library version of what I checked.

**Checked Configuration**

Windows 10 (builder version: 22H2)
- rstan: 2.26.23
- StanHeaders: 2.26.28
- rtools: 43
  
Mac (version: 12.6.8)
- rstan: 2.21.0
- StanHeaders: 2.26.27
- rtools: don't need

In my case, mac which uses old version of rstan was fine to run codes, but windows have an issue about importing rstan. To solve the issue, I installed the latest version of rstan. These lines install specific version of rstan, which versions are latest version of rstan(2.26.23) and StanHeaders(2.26.28) (checked date: 2023.09.25).

```r
install.packages("rstan", repos = c("https://mc-stan.org/r-packages/", getOption("repos")), version = "2.26.23")
install.packages(c("StanHeaders"), type="source", version="2.26.28")
```
  
## ComputationalModeling

In order to run the sources in computational modeling sources, you have to install rjags. Following versions are what I checked.

Windows 10 (builder version: 22H2)
- rjags: 4.3.1
  
Mac (version: 12.6.8)
- rjags: 4.3.0

I experienced mac is fine to run codes, but in case of windows, I had an error to run the code when I imported rjags library even though I have installed rjags in rstudio. The error is "Failed to locate any version of JAGS version 4". To fix the error, I installed rjags using these website. The first one guides me the way to install rjags and the second is download page for rjags. Install process of rjags is very simple. Just download and execute .exe file. 

1. https://mcmc-jags.sourceforge.io/
2. https://sourceforge.net/projects/mcmc-jags/

