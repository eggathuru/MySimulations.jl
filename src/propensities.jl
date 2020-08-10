birth_rate(state, parameters) = parameters.μ * sum(state[1:4])

function exposure_rate(state, parameters)
    Σ = sum(state[1:4])
    M = parameters.β * state[1] * state[3]
    if Σ == M == 0 return 0 else return M/Σ end # prevents 0/0
end
infection_rate(state, parameters) = parameters.a * state[2]
recovery_rate(state, parameters) = parameters.γ * state[3]

susceptible_death_rate(state, parameters) = parameters.μ * state[1]
exposed_death_rate(state, parameters) = parameters.μ * state[2]
infected_death_rate(state, parameters) = (parameters.α+parameters.μ) * state[3]
recovered_death_rate(state, parameters) = parameters.μ * state[4]

function a_i(state, parameters)
    return [
        birth_rate(state, parameters),

        exposure_rate(state, parameters),
        infection_rate(state, parameters),
        recovery_rate(state, parameters),

        susceptible_death_rate(state, parameters),
        exposed_death_rate(state, parameters),
        infected_death_rate(state, parameters),
        recovered_death_rate(state, parameters),
    ]
end

function ∑a(state, parameters, i)
    a_t = a_i(state, parameters)
    return sum(a_t[1:i])
end
