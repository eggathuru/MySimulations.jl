function birth!(data, i, v = 1)
    data.S[i] += v
    data.total_reactions += v
end

function susceptible_to_exposed!(data, i, v = 1)
    data.S[i] -= v
    data.E[i] += v
    data.total_reactions += v
end

function exposed_to_infectious!(data, i, v = 1)
    data.E[i] -= v
    data.I[i] += v
    data.total_reactions += v
end

function infectious_to_resistant!(data, i, v = 1)
    data.I[i] -= v
    data.R[i] += v
    data.total_reactions += v
end

# Death events
function susceptible_death!(data, i, v = 1)
    data.S[i] -= v
    data.total_reactions += v
end

function exposed_death!(data, i, v = 1)
    data.E[i] -= v
    data.total_reactions += v
end

function infected_death!(data, i, v = 1)
    data.I[i] -= v
    data.total_reactions += v
end

function recovered_death!(data, i, v = 1)
    data.R[i] -= v
    data.total_reactions += v
end
