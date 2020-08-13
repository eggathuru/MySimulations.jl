using MySimulations, Plots, Statistics

# Simulation parameters
n_days = 1000
n_ensemble = 100
μ = 0.02 # birth/death

# Independent variables
N₀ = 10
τ = 0.05

# Run simulations
prb = MyBirthDeath(N₀, μ)
e = ensemble_tau!(prb, n_days, τ, n_ensemble)

# Plot ensemble
p = plot(xlabel = "Days",
         ylabel = "People",
         xlims = (0, n_days),
         # ylims = (0, 2*N),
         legend=false,
         title="Birth Death ($n_ensemble runs, N₀=$N₀, τ=$τ)")

A = zeros(Int, n_ensemble, n_days)
T = e[1].T

for i in 1:n_ensemble
    global A[i, :] .= e[i].S
    plot!(p, T, A[i, :])
end

ylims!(p, 0, maximum(A))

# Plot mean and error
μs = mean(A, dims=1)[1, :]
σs =  std(A, dims=1)[1, :]

plot!(p, T, μs, yerr=σs, alpha=0.1)
savefig(p, "./images/bd_N$(N₀)_t$(τ).png")
