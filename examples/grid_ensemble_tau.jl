using MySimulations, Statistics

# Simulation parameters
n_days = 2000
n_ensemble = 100
μ = 0.02
params = μ, 0.055, 0.07, 0.006, 0.001

# N₀, τ
experiments = [(  100, 0.05),
               (  100, 0.25),
               (  100, 0.99),

               ( 1000, 0.05),
               ( 1000, 0.25),
               ( 1000, 0.99),

               (10000, 0.05),
               (10000, 0.25),
               (10000, 0.99)]

println("Birth Death---------------------------------------")
for (N₀, τ) in experiments
    println()

    # Run simulations
    prb = MyBirthDeath(N₀, μ)
    e = ensemble_tau!(prb, n_days, τ, n_ensemble)

    M = zeros(Int, n_ensemble, n_days)

    reactions = 0
    for i in 1:n_ensemble
        M[i, :] .= e[i].S
        reactions += e[i].total_reactions
    end

    σs = std(M, dims=1)[1, :]
    final_variance = σs[end] / N₀

    println("(N₀=$N₀, τ=$τ)")
    println("Final variance is σₙ/N₀=$final_variance.")

    average_event = reactions * τ / (n_days * n_ensemble)
    println("Average events per time step: $average_event.")
end

println("SEIR----------------------------------------------")
for (N₀, τ) in experiments
    println()

    # Run simulations
    prb = MySEIR(N₀*[0.9, 0, 0.1, 0],
                    params)
    e = ensemble_tau!(prb, n_days, τ, n_ensemble)

    M_I = zeros(Int, n_ensemble, n_days)

    reactions = 0
    for i in 1:n_ensemble
        M_I[i, :] .= e[i].I
        reactions += e[i].total_reactions
    end

    σIs = std(M_I, dims=1)[1, :]
    final_variance = σIs[end] / N₀

    println("(N₀=$N₀, τ=$τ)")
    println("Final variance is σₙ/N₀=$final_variance.")

    average_event = reactions * τ / (n_days * n_ensemble)
    println("Average events per time step: $average_event.")
end
