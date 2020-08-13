function birth!(prb, i, v = 1)
    prb.data.S[i] += v
    if v > 0 prb.total_reactions += 1 end
end

function susceptible_to_exposed!(prb, i, v = 1)
    prb.data.S[i] -= v
    prb.data.E[i] += v
    if v > 0 prb.total_reactions += 1 end
end

function exposed_to_infectious!(prb, i, v = 1)
    prb.data.E[i] -= v
    prb.data.I[i] += v
    if v > 0 prb.total_reactions += 1 end
end

function infectious_to_resistant!(prb, i, v = 1)
    prb.data.I[i] -= v
    prb.data.R[i] += v
    if v > 0 prb.total_reactions += 1 end
end

# Death events
function susceptible_death!(prb, i, v = 1)
    prb.data.S[i] -= v
    if v > 0 prb.total_reactions += 1 end
end

function exposed_death!(prb, i, v = 1)
    prb.data.E[i] -= v
    if v > 0 prb.total_reactions += 1 end
end

function infected_death!(prb, i, v = 1)
    prb.data.I[i] -= v
    if v > 0 prb.total_reactions += 1 end
end

function recovered_death!(prb, i, v = 1)
    prb.data.R[i] -= v
    if v > 0 prb.total_reactions += 1 end
end
