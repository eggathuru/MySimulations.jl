function birth!(data, i, v = 1)
    data.S[i] += v
end

function susceptible_to_exposed!(data, i, v = 1)
    # v = min(v, data.S[i]) # hack solution
    data.S[i] -= v
    data.E[i] += v
end

function exposed_to_infectious!(data, i, v = 1)
    # v = min(v, data.E[i]) # hack solution
    data.E[i] -= v
    data.I[i] += v
end

function infectious_to_resistant!(data, i, v = 1)
    # v = min(v, data.I[i]) # hack solution
    data.I[i] -= v
    data.R[i] += v
end

# Death events
function susceptible_death!(data, i, v = 1)
    # v = min(v, data.S[i]) # hack solution
    data.S[i] -= v
end

function exposed_death!(data, i, v = 1)
    # v = min(v, data.E[i]) # hack solution
    data.E[i] -= v
end

function infected_death!(data, i, v = 1)
    # v = min(v, data.I[i]) # hack solution
    data.I[i] -= v
end

function recovered_death!(data, i, v = 1)
    # v = min(v, data.R[i]) # hack solution
    data.R[i] -= v
end
