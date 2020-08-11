function unpack(data)
    S = data.S
    E = data.E
    I = data.I
    R = data.R
    t = data.T
    return t, S, E, I, R
end

function plot_solution(data)
    t, S, E, I, R = unpack(data)
    return plot(t, [S E I R],
                label=['S' 'E' 'I' 'R'],
                xlabel = "Time",
                ylabel = "People",
                title="SEIR Stochastic Simulation",
                linetype=:steppost)
end

function plot_solution!(p, data)
    t, S, E, I, R = unpack(data)
    return plot!(p, t, [S E I R],
                 label=['S' 'E' 'I' 'R'],
                 xlabel = "Time",
                 ylabel = "People",
                 title="SEIR Stochastic Simulation",
                 linetype=:steppost)
end

function p_rand(λ, max=Inf)
    if !(λ >= zero(λ)) || λ == Inf
        error("Poisson λ has value $λ")
    elseif max == 0
        return 0
    else
        d = Poisson(λ)
        p = truncated(d, 0, max)
        return rand(p)
    end
end
