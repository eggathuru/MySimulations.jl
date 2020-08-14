using MySimulations, Plots, Statistics

# Simulation parameters
n_days = 2000
n_ensemble = 20
μ = 0.02 # birth/death
β = 0.055 # exposure
a = 0.07 # onset
γ = 0.006 # recovery
α = 0.001 # infection death

# Independent variables
N = 100 # S₀ E₀ I₀ R₀
τ = 0.1

# Run simulations
prb = MySEIR(N*[0.9, 0, 0.1, 0],
                (μ, β, a, γ, α))
e = ensemble_tau!(prb, n_days, τ, n_ensemble)

# Plot ensemble
p1 = plot(xlabel = "Days",
          ylabel = "Susceptables",
          xlims = (0, n_days),
          legend=false,
          title="Susceptable population")
p2 = plot(xlabel = "Days",
          ylabel = "Infecteds",
          xlims = (0, n_days),
          legend=false,
          title="Infected population")

T = e[1].T
n_iter = length(T)
M_S = zeros(Int, n_ensemble, n_iter)
M_E = zeros(Int, n_ensemble, n_iter)
M_I = zeros(Int, n_ensemble, n_iter)
M_R = zeros(Int, n_ensemble, n_iter)


for i in 1:n_ensemble
    M_S[i, :] .= e[i].S
    M_E[i, :] .= e[i].E
    M_I[i, :] .= e[i].I
    M_R[i, :] .= e[i].R
    plot!(p1, T, M_S[i, :])
    plot!(p2, T, M_I[i, :])
end

y_max = max(maximum(M_S),
            maximum(M_I))
ylims!(p1, 0, y_max)
ylims!(p2, 0, y_max)

p_ens = plot(p1, p2)
# Save plot
savefig(p_ens, "./images/seir_N$(N)_t$(τ)_ens.png")

# Plot mean and error
μSs = mean(M_S, dims=1)[1, :]
σSs =  std(M_S, dims=1)[1, :]

μEs = mean(M_E, dims=1)[1, :]
σEs =  std(M_E, dims=1)[1, :]

μIs = mean(M_I, dims=1)[1, :]
σIs =  std(M_I, dims=1)[1, :]

μRs = mean(M_R, dims=1)[1, :]
σRs =  std(M_R, dims=1)[1, :]

y_max = max(maximum(μSs+σSs),
            maximum(μEs+σEs),
            maximum(μIs+σIs),
            maximum(μRs+σRs))
pS = plot(T, μSs, yerr=σSs,
                  alpha=0.1,
                  label='S',
                  ylims=(0, y_max))
pE = plot(T, μEs, yerr=σEs,
                  alpha=0.1,
                  label='E',
                  ylims=(0, y_max))
pI = plot(T, μIs, yerr=σIs,
                  alpha=0.1,
                  label='I',
                  ylims=(0, y_max))
pR = plot(T, μRs, yerr=σRs,
                  alpha=0.1,
                  label='R',
                  ylims=(0, y_max))
p_var = plot(pS, pE, pI, pR)

# Save plot
# savefig(p_var, "./images/seir_N$(N)_t$(τ)_var.png")

# Plot means on one plot
p_mean = plot(T, [μSs μEs μIs μRs],
              label=['S' 'E' 'I' 'R'],
              xlabel = "Time",
              ylabel = "People",
              title="SEIR Stochastic Simulation",
              linetype=:steppost)

# Save plot
savefig(p_mean, "./images/seir_N$(N)_t$(τ)_mean.png")
