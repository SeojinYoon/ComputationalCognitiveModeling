# ComputationalCognitiveModeling
This source is for "ComputationalCognitiveModeling" class in Hanyang university. (2023-2) I checked sources on my mac and windows using r-studio(version: 2023.06.2+561).

# Dependency of BayesianCognitiveModeling (Lee, M., & Wagenmakers, E. (2014))

For running codes in BayesianCognitiveModeling, You have to install some libraries (rstan, rtools). I checked these sources using following configuration.

Windows 10 (builder version: 22H2)
- rstan: 2.21.0
- rtools: 43
  
Mac (version: 12.6.8)
- rstan: 2.21.0
- rtools: don't need
  
# Dependency of ComputationalModeling (Farrell & Lewandowsky, S. (2018))

**Some tip to run codes**.

In order to run the sources in computational modeling sources, you have to install rjags. Following version is what i checked version. 

Windows 10 (builder version: 22H2)
- rjags: 4.3.1
  
Mac (version: 12.6.8)
- rjags: 4.3.0

I experienced mac is fine to run codes, but in case of windows, I had an error to run the code like library(rjags) even though I have installed rjags in rstudio. The error is "Failed to locate any version of JAGS version 4". To fix the error, I installed rjags using these website. The first one guides me the way to install rjags and the second is download page for rjags. Install process is very simple. Just download and execute .exe file. 

1. https://mcmc-jags.sourceforge.io/
2. https://sourceforge.net/projects/mcmc-jags/

