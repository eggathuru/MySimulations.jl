using MySimulations, Statistics

# Simulation parameters
n_days = 10_000
n_ensemble = 100
μ = 0.02
params = μ, 0.055, 0.07, 0.006, 0.001

# N₀, τ
experiments = [(  100,   0.1),
               (  100,   1.0),
               (  100,   5.0),
               (  100,  10.0),
               (  100,  50.0),
               (  100, 100.0),

               ( 1000,   0.1),
               ( 1000,   1.0),
               ( 1000,   5.0),
               ( 1000,  10.0),
               ( 1000,  50.0),
               ( 1000, 100.0),

               (10000,   0.1),
               (10000,   1.0),
               (10000,   5.0),
               (10000,  10.0),
               (10000,  50.0),
               (10000, 100.0)]

BD_STD = zeros(6, 3)
BD_AVG = zeros(6, 3)
for (i, experiment) in enumerate(experiments)
    N₀, τ = experiment

    # Run simulations
    prb = MyBirthDeath(N₀, μ)
    e = ensemble_tau!(prb, n_days, τ, n_ensemble)

    M = zeros(Int, n_ensemble, length(e[i].S))

    reactions = 0
    for i in 1:n_ensemble
        M[i, :] .= e[i].S
        reactions += e[i].total_reactions
    end

    σs = std(M, dims=1)[1, :]
    BD_STD[i] = σs[end] / N₀
    BD_AVG[i] = reactions * τ / (n_days * n_ensemble)
end

SI_STD = zeros(6, 3)
SI_AVG = zeros(6, 3)
for (i, experiment) in enumerate(experiments)
    N₀, τ = experiment
    # Run simulations
    prb = MySEIR(N₀*[0.95, 0, 0.05, 0],
                    params)
    e = ensemble_tau!(prb, n_days, τ, n_ensemble)

    M_I = zeros(Int, n_ensemble, length(e[i].S))

    reactions = 0
    for i in 1:n_ensemble
        M_I[i, :] .= e[i].I
        reactions += e[i].total_reactions
    end

    σIs = std(M_I, dims=1)[1, :]
    SI_STD[i] = σIs[end] / N₀
    SI_AVG[i] = reactions * τ / (n_days * n_ensemble)
end
