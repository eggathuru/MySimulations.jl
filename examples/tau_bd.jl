using MySimulations

# Simulation parameters
n_days = 1000
μ = 0.01 # birth/death

# Independent variables
N = 100 # S₀ E₀ I₀ R₀
τ = 0.5

prb = MyBirthDeath(N, μ)
tau_leap!(prb, n_days, τ)
direct_ssa!(prb, Int(2e3))

plot_solution(prb.data)
