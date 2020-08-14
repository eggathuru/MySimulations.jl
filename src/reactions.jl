function birth!(data, i, v = 1)
    data.S[i] += v
    if v > 0 data.total_reactions += 1 end
end

function susceptible_to_exposed!(data, i, v = 1)
    data.S[i] -= v
    data.E[i] += v
    if v > 0 data.total_reactions += 1 end
end

function exposed_to_infectious!(data, i, v = 1)
    data.E[i] -= v
    data.I[i] += v
    if v > 0 data.total_reactions += 1 end
end

function infectious_to_resistant!(data, i, v = 1)
    data.I[i] -= v
    data.R[i] += v
    if v > 0 data.total_reactions += 1 end
end

# Death events
function susceptible_death!(data, i, v = 1)
    data.S[i] -= v
    if v > 0 data.total_reactions += 1 end
end

function exposed_death!(data, i, v = 1)
    data.E[i] -= v
    if v > 0 data.total_reactions += 1 end
end

function infected_death!(data, i, v = 1)
    data.I[i] -= v
    if v > 0 data.total_reactions += 1 end
end

function recovered_death!(data, i, v = 1)
    data.R[i] -= v
    if v > 0 data.total_reactions += 1 end
end
