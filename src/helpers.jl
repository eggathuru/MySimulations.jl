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

"""
    c_rand(λ, upper)

Returns a sample from a Poisson distribution
with mean λ but clips values above `upper`.
"""
function c_rand(λ, upper=Inf)
    if !(λ >= zero(λ)) || λ == Inf
        error("Poisson λ has value $λ")
    elseif upper == 0
        return 0
    else
        p = Poisson(λ)
        return min(upper, rand(p))
    end
end

"""
    t_rand(λ, upper)

Returns a sample from a Poisson truncated with upper
bound `upper` distribution with mean `λ`.
"""
function t_rand(λ, upper=Inf)
    if !(λ >= zero(λ)) || λ == Inf
        error("Poisson λ has value $λ")
    elseif upper == 0
        return 0
    else
        d = Poisson(λ)
        p = truncated(d, -Inf, upper) # left point excluded
        return rand(p)
    end
end
