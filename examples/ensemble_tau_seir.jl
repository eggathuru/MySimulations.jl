using MySimulations, Plots, Statistics

# Simulation parameters
n_days = 2000
n_ensemble = 30
μ = 0.02 # birth/death
β = 0.055 # exposure
a = 0.07 # onset
γ = 0.006 # recovery
α = 0.001 # infection death

# Independent variables
N = 100 # S₀ E₀ I₀ R₀
τ = 0.05

# Run simulations
prb = MySEIR(N*[0.9, 0, 0.1, 0],
                (μ, β, a, γ, α))
e = ensemble_tau!(prb, n_days, τ, n_ensemble)

# Plot ensemble
p1 = plot(xlabel = "Time",
          ylabel = "Susceptables",
          xlims = (0, n_days),
          legend=false,
          title="Susceptable population")
p2 = plot(xlabel = "Time",
          ylabel = "Infecteds",
          xlims = (0, n_days),
          legend=false,
          title="Infected population")

M_S = zeros(Float64, n_ensemble, n_days)
M_I = zeros(Float64, n_ensemble, n_days)
M_R = zeros(Float64, n_ensemble, n_days)
T = e[1].T

for i in 1:n_ensemble
    M_S[i, :] .= e[i].S
    M_I[i, :] .= e[i].I
    M_R[i, :] .= e[i].R
    plot!(p1, T, M_S[i, :])
    plot!(p2, T, M_I[i, :])
end

plot(p1, p2)


# Plot mean and error
μSs = mean(M_S, dims=1)[1, :]
σSs =  std(M_S, dims=1)[1, :]

μIs = mean(M_I, dims=1)[1, :]
σIs =  std(M_I, dims=1)[1, :]

μRs = mean(M_R, dims=1)[1, :]
σRs =  std(M_R, dims=1)[1, :]

pS = plot(T, μSs, yerr=σSs,
                  alpha=0.1,
                  label='S')
pI = plot(T, μIs, yerr=σIs,
                  alpha=0.1,
                  label='I')
pR = plot(T, μRs, yerr=σRs,
                  alpha=0.1,
                  label='R')
plot(pS, pI, pR)


# Plot means on one plot
plot(T, [μSs μIs μRs],
     label=['S' 'I' 'R'],
     xlabel = "Time",
     ylabel = "People",
     title="SEIR Stochastic Simulation",
     linetype=:steppost)

# savefig("./images/plot.png")
