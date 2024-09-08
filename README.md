
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

### Windows

Windows 10 (builder version: 22H2)
- rstan: 2.26.23
- StanHeaders: 2.26.28
- rtools: 43

The codes work fine in windows.

### MAC (Intel chip)

Mac (OS version: 12.6.8)
- rstan: 2.21.0
- StanHeaders: 2.26.27
- rtools: don't need

In my case, mac which uses old version of rstan was fine to run codes, but windows have an issue about importing rstan. To solve the issue, I installed the latest version of rstan. These lines install specific version of rstan, which versions are latest version of rstan(2.26.23) and StanHeaders(2.26.28) (checked date: 2023.09.25).

```r
install.packages("rstan", repos = c("https://mc-stan.org/r-packages/", getOption("repos")), version = "2.26.23")
install.packages(c("StanHeaders"), type="source", version="2.26.28")
```

### MAC (M-series chip)

- rstan: 2.32.6
- StanHeaders: 2.32.10
- rtools: don't need

The codes work fine in Mac (M-series).

## ComputationalModeling

In order to run the sources in computational modeling sources, you have to install rjags. Following versions are what I checked.

**Checked Configuration**

### Windows
Windows 10 (builder version: 22H2)
- rjags: 4.3.1

In case of windows, I had an error to run the code when I imported rjags library even though I have installed rjags in rstudio. The error is "Failed to locate any version of JAGS version 4". To fix the error, I installed rjags using these website. The first one guides me the way to install rjags and the second is download page for rjags. Install process of rjags is very simple. Just download and execute .exe file. 

1. https://mcmc-jags.sourceforge.io/
2. https://sourceforge.net/projects/mcmc-jags/

### MAC (Intel chip)

Intel chip's mac works fine. You can install rjags using install.packages("rjags") in R.

Mac (version: 12.6.8)
- rjags: 4.3.0

### MAC (M-series chip)

Mac (Apple M3 Pro, OS version: 14.6.1 (23G93))
- rjags: 4.3.1

When I install rjags, I got following error. This error is due to the Mac's chip. 

```
> library(rjags)
Error: package or namespace load failed for ‘rjags’:
 .onLoad failed in loadNamespace() for 'rjags', details:
  call: dyn.load(file, DLLpath = DLLpath, ...)
  error: unable to load shared object '/Library/Frameworks/R.framework/Versions/4.4-arm64/Resources/library/rjags/libs/rjags.so':
  dlopen(/Library/Frameworks/R.framework/Versions/4.4-arm64/Resources/library/rjags/libs/rjags.so, 0x000A): Library not loaded: /usr/local/lib/libjags.4.dylib
  Referenced from: <CAF5E1DC-317A-34FE-988A-FB6F7C73D89E> /Library/Frameworks/R.framework/Versions/4.4-arm64/Resources/library/rjags/libs/rjags.so
  Reason: tried: '/usr/local/lib/libjags.4.dylib' (no such file), '/System/Volumes/Preboot/Cryptexes/OS/usr/local/lib/libjags.4.dylib' (no such file), '/usr/local/lib/libjags.4.dylib' (no such file), '/Library/Frameworks/R.framework/Resources/lib/libjags.4.dylib' (no such file), '/Library/Java/JavaVirtualMachines/jdk-11.0.18+10/Contents/Home/lib/server/libjags.4.dylib' (no such file), '/var/folders/f
```

To fix the error, You have to install JAGS.pkg file in your local computer.

1. Go this website: https://sourceforge.net/projects/mcmc-jags/files/JAGS/4.x/Mac%20OS%20X/
2. Install appropriate JAGS in compatible with your R version
  - JAGS-4.3.2.pkg for compatibility with R version 4.3.0 and later
  - JAGS-4.3.1.pkg for compatibility with R versions 4.0.x to 4.2.x
3. Install rjags in your R.
  - Install.packages("rjags")
  
References
- https://sourceforge.net/p/mcmc-jags/discussion/610037/thread/115edca29d/
  
