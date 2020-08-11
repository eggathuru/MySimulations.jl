using MySimulations, Plots, Statistics

# Simulation parameters
n_days = 1000
n_ensemble = 30
μ = 0.02 # birth/death

# Independent variables
N = 10
τ = 0.05

# Run simulations
prb = MyBirthDeath(N, μ)
e = ensemble_tau!(prb, n_days, τ, n_ensemble)

# Plot ensemble
p = plot(xlabel = "Time",
         ylabel = "People",
         xlims = (0, n_days),
         # ylims = (0, 2*N),
         legend=false,
         title="Birth Death Ensemble")

A = zeros(Float64, n_ensemble, n_days)
T = e[1].T

for i in 1:n_ensemble
    A[i, :] .= e[i].S
    plot!(p, T, A[i, :])
end

# Plot mean and error
μs = mean(A, dims=1)[1, :]
σs =  std(A, dims=1)[1, :]

plot!(p, T, μs, yerr=σs, alpha=0.1)
