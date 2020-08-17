# MySimulations

[![Build Status](https://travis-ci.com/eggathuru/MySimulations.jl.svg?branch=master)](https://travis-ci.com/eggathuru/MySimulations.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/eggathuru/MySimulations.jl?svg=true)](https://ci.appveyor.com/project/eggathuru/MySimulations-jl)
[![Coverage](https://codecov.io/gh/eggathuru/MySimulations.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/eggathuru/MySimulations.jl)
[![Coverage](https://coveralls.io/repos/github/eggathuru/MySimulations.jl/badge.svg?branch=master)](https://coveralls.io/github/eggathuru/MySimulations.jl?branch=master)

## Purpose
This package provides a set of tools for comparing how a tau leaping simulation varies according to population size and choice of tau.

## Abstract
Stochastic simulation of epidemics through tau-leaping

SEIR epidemic models divide a population into discrete subpopulations and derive the rates at which individual transition across subpopulations. One may solve a system of differential equations to predict how the disease will spread over time. In reality, these rates are not solely determined by the density of susceptible and infected populations. There are innumerable micro-dynamics that add up to noise. One way to incorporate random processes to model this noise is to use the Gillespie algorithm. This algorithm generates population trajectories given function describing the propensity of exposure, infection, recovery, and death events as a function of current population levels. Since the algorithm simulates every single event, tau leaping is used as an efficient approximation method. Tau leaping takes fixed time-steps instead of the randomly generated time-steps of the Gillespie model. This approximation better approximates Gillespie when small time-steps are used but is only efficient for sufficiently large time-steps. For fixed parameters, the variance of the trajectories is independent of the choice of tau and the average number of events per time period has a linear relationship with tau. For large tau (greater than 1/μ or 1/β for birth-death or SEIR respectively) extinction of large populations in a single time-period is likely.
