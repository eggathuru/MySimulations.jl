using MySimulations

# Simulation parameters
n_days = 100
μ = 0.02 # birth/death
β = 0.055 # exposure
a = 0.07 # onset
γ = 0.006 # recovery
α = 0.001 # infection death

# Independent variables
N = 100 # S₀ E₀ I₀ R₀
τ = 0.05

prb = MySEIR(N*[0.9, 0, 0.1, 0],
                (μ, β, a, γ, α))
tau_leap!(prb, n_days, τ)
direct_ssa!(prb, Int(2e3))

plot_solution(prb.data)
