using MySimulations, Plots, Statistics

# Simulation parameters
n_days = 1000
n_ensemble = 20
μ = 0.02 # birth/death

# Independent variables
N₀ = 100
τ = 0.05

# Run simulations
prb = MyBirthDeath(N₀, μ)
e = ensemble_tau!(prb, n_days, τ, n_ensemble)

# Plot ensemble
p = plot(xlabel = "Days",
         ylabel = "People",
         xlims = (0, n_days),
         legend=false,
         title="Birth Death ($n_ensemble runs, N₀=$N₀, τ=$τ)")

M = zeros(Int, n_ensemble, n_days)
T = e[1].T

# Plot runs
for i in 1:n_ensemble
    M[i, :] .= e[i].S
    plot!(p, T, M[i, :])
end
ylims!(p, 0, maximum(M))
savefig(p, "./images/bd_N$(N₀)_t$(τ)_ens.png")

# Plot mean and error with runs
μs = mean(M, dims=1)[1, :]
σs =  std(M, dims=1)[1, :]

plot!(p, T, μs, yerr=σs, alpha=0.1)
savefig(p, "./images/bd_N$(N₀)_t$(τ)_var.png")

# Plot mean and error
p = plot(T, μs, yerr=σs, alpha=0.1,
         xlabel = "Days",
         ylabel = "People",
         xlims = (0, n_days),
         legend=false,
         title="Birth Death ($n_ensemble runs, N₀=$N₀, τ=$τ)")
savefig(p, "./images/bd_N$(N₀)_t$(τ)_mean.png")
