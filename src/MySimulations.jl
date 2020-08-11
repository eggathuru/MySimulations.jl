module MySimulations

using Random, Distributions
import Plots.plot, Plots.plot!

include("events.jl")
include("helpers.jl")
include("propensities.jl")
include("structs.jl")

export MySEIR, MyBirthDeath
export direct_ssa!, tau_leap!
export ensemble_ssa!, ensemble_tau!
export plot_solution, plot_solution!

"""
    MySEIR(init, params)

Returns a `MyProblem` instance with all parameters specified.
"""
function MySEIR(init, params)
    return MyProblem(MyParameters(params...),
                     init,
                     nothing)
end

"""
    MyBirthDeath(init, μ)

Returns a `MyProblem` instance with only the birth/death
parameter specified and all blocks but susceptible `S`
initialized to zero.
"""
function MyBirthDeath(init, μ)
    return MyProblem(MyParameters(μ, 0, 0, 0, 0),
                     (init, 0, 0, 0),
                     nothing)
end

"""
    direct_ssa!(prb::MyProblem, n_iter)

Runs through `n_iter` iterations of the Gillespie algorithm
with the parameters and initial conditions specified by
`prb`.
"""
function direct_ssa!(prb::MyProblem, n_iter)
    # Create data object
    data = MyData([zeros(Int, n_iter) for _ in 1:4]...,
                   zeros(Float64, n_iter))
    data.S[1] = prb.initial_condition[1]
    data.E[1] = prb.initial_condition[2]
    data.I[1] = prb.initial_condition[3]
    data.R[1] = prb.initial_condition[4]
    prb.data = data

    params = prb.parameters
    for i in 2:n_iter
        # Store previous state state
        state = data.S[i-1],
                data.E[i-1],
                data.I[i-1],
                data.R[i-1]

        # Copy previous state into posterior
        data.S[i] = state[1]
        data.E[i] = state[2]
        data.I[i] = state[3]
        data.R[i] = state[4]

        a₀ = ∑a(state, params, 8)

        r₁ = rand(Float64)
        r₂ = rand(Float64)
        τ  = -log(r₁)/a₀

        # birth
        if     r₂*a₀ <= ∑a(state, params, 1)
            birth!(                   data, i )
        # exposure
        elseif r₂*a₀ <= ∑a(state, params, 2)
            susceptible_to_exposed!(  data, i )
        # onset
        elseif r₂*a₀ <= ∑a(state, params, 3)
            exposed_to_infectious!(   data, i )
        # recovery
        elseif r₂*a₀ <= ∑a(state, params, 4)
            infectious_to_resistant!( data, i )
        # natural death (S)
        elseif r₂*a₀ <= ∑a(state, params, 5)
            susceptible_death!(       data, i )
        # natural death (E)
        elseif r₂*a₀ <= ∑a(state, params, 6)
            exposed_death!(           data, i )
        # infected death
        elseif r₂*a₀ <= ∑a(state, params, 7)
            infected_death!(          data, i )
        # natural death (R)
        else
            recovered_death!(         data, i )
        end

        data.T[i] = τ + data.T[i-1]
    end
end

"""
    tau_leap!(prb::MyProblem, n_days, τ)

Simulates `n_days` using explicit tau leaping
with the parameters and initial conditions specified by
`prb`.
"""
function tau_leap!(prb::MyProblem, n_days, τ)
    # Create data object
    data = MyData([zeros(Int, n_days) for _ in 1:4]...,
                   zeros(Float64, n_days))
    data.S[1] = prb.initial_condition[1]
    data.E[1] = prb.initial_condition[2]
    data.I[1] = prb.initial_condition[3]
    data.R[1] = prb.initial_condition[4]
    prb.data = data

    params = prb.parameters

    for n in 1:τ:n_days
        prev = floor(Int, n)
        post = floor(Int, n+τ)

        # Copy previous state into posterior
        if (prev != post)
            data.S[post] = data.S[prev]
            data.E[post] = data.E[prev]
            data.I[post] = data.I[prev]
            data.R[post] = data.R[prev]
        end

        # Draws from Poisson distribution
        λ = τ * a_i([data.S[prev],
                     data.E[prev],
                     data.I[prev],
                     data.R[prev]],
                    params)

        birth!(                   data, post, p_rand(λ[1]              ) )

        susceptible_to_exposed!(  data, post, p_rand(λ[2], data.S[post]) )
        exposed_to_infectious!(   data, post, p_rand(λ[3], data.E[post]) )
        infectious_to_resistant!( data, post, p_rand(λ[4], data.I[post]) )

        susceptible_death!(       data, post, p_rand(λ[5], data.S[post]) )
        exposed_death!(           data, post, p_rand(λ[6], data.E[post]) )
        infected_death!(          data, post, p_rand(λ[7], data.I[post]) )
        recovered_death!(         data, post, p_rand(λ[8], data.R[post]) )

        data.T[post] = τ + data.T[prev]
    end
end

"""
    ensemble_ssa!(prb, n_days, n_ensemble=10)

Runs `n_ensemble` simulations of the problem `prb`
using the Gillespie algorithm.
"""
function ensemble_ssa!(prb, n_days, n_ensemble=10)
    ensemble = []
    for i in 1:n_ensemble
        direct_ssa!(prb, n_days)
        solution = prb.data
        push!(ensemble, solution)
    end
    return ensemble
end

"""
    ensemble_tau!(prb, n_days, τ, n_ensemble=10)

Runs `n_ensemble` simulations of the problem `prb`
using the explicit tau leaping.
"""
function ensemble_tau!(prb, n_days, τ, n_ensemble=10)
    ensemble = []
    for i in 1:n_ensemble
        tau_leap!(prb, n_days, τ)
        solution = prb.data
        push!(ensemble, solution)
    end
    return ensemble
end
end
