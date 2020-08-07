module MySimulations

# Write your package code here.
using Random, Distributions
import Plots.plot

include("events.jl")
include("helpers.jl")
include("propensities.jl")
include("structs.jl")

function MySEIR(init, params)
    return MyProblem(MyParameters(params...),
                     init,
                     nothing)
end

function direct_ssa!(prb::MyProblem, n_iter)
    # Create data object
    data = MyData([zeros(Float64, n_iter) for _ in 1:5]...)
    data.S[1] = prb.initial_condition[1]
    data.E[1] = prb.initial_condition[2]
    data.I[1] = prb.initial_condition[3]
    data.R[1] = prb.initial_condition[4]
    prb.data = data

    params = prb.parameters
    for i in 2:n_iter
        # Store previous state state
        state = prb.data.S[i-1],
                prb.data.E[i-1],
                prb.data.I[i-1],
                prb.data.R[i-1]

        # Copy previous state into posterior
        prb.data.S[i] = state[1]
        prb.data.E[i] = state[2]
        prb.data.I[i] = state[3]
        prb.data.R[i] = state[4]

        a₀ = ∑a(state, params, 8)

        r₁ = rand(Float64)
        r₂ = rand(Float64)
        τ  = -log(r₁)/a₀

        # birth
        if     r₂*a₀ <= ∑a(state, params, 1)
            birth!(                    prb.data, i )
        # exposure
        elseif r₂*a₀ <= ∑a(state, params, 2)
            susceptible_to_exposed!(   prb.data, i )
        # onset
        elseif r₂*a₀ <= ∑a(state, params, 3)
            exposed_to_infectious!(    prb.data, i )
        # recovery
        elseif r₂*a₀ <= ∑a(state, params, 4)
            infectious_to_resistant!(  prb.data, i )
        # natural death (S)
        elseif r₂*a₀ <= ∑a(state, params, 5)
            susceptible_death!(        prb.data, i )
        # natural death (E)
        elseif r₂*a₀ <= ∑a(state, params, 6)
            exposed_death!(            prb.data, i )
        # infected death
        elseif r₂*a₀ <= ∑a(state, params, 7)
            infected_death!(           prb.data, i )
        # natural death (R)
        else
            recovered_death!(          prb.data, i )
        end

        prb.data.T[i] = τ + prb.data.T[i-1]
    end
end

function tau_leap!(prb::MyProblem, n_days, τ)
    # Create data object
    data = MyData([zeros(Float64, n_days) for _ in 1:5]...)
    data.S[1] = prb.initial_condition[1]
    data.E[1] = prb.initial_condition[2]
    data.I[1] = prb.initial_condition[3]
    data.R[1] = prb.initial_condition[4]
    prb.data = data

    params = prb.parameters
    state = prb.initial_condition

    for n in 1:τ:n_days
        prev = floor(Int, n)
        post = floor(Int, n+τ)

        # Store previous state state
        state = prb.data.S[prev],
                prb.data.E[prev],
                prb.data.I[prev],
                prb.data.R[prev]

        # Copy previous state into posterior
        if (prev != post)
            prb.data.S[post] = state[1]
            prb.data.E[post] = state[2]
            prb.data.I[post] = state[3]
            prb.data.R[post] = state[4]
        end

        a_t = a_i(state, params)
        p = [p_rand(τ*a_t[i]) for i in 1:8]

        birth!(                     prb.data, post, p[1]   )

        susceptible_to_exposed!(    prb.data, post, p[2]   )
        exposed_to_infectious!(     prb.data, post, p[3]   )
        infectious_to_resistant!(   prb.data, post, p[4]   )

        susceptible_death!(         prb.data, post, p[5]   )
        exposed_death!(             prb.data, post, p[6]   )
        infected_death!(            prb.data, post, p[7]   )
        recovered_death!(           prb.data, post, p[8]   )

        prb.data.T[post] = τ + prb.data.T[prev]
    end
end

end
