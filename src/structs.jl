struct MyParameters
    μ::Union{Nothing,Float64}
    β::Union{Nothing,Float64}
    a::Union{Nothing,Float64}
    γ::Union{Nothing,Float64}
    α::Union{Nothing,Float64}
end

mutable struct MyData
    S::Union{Nothing,Vector{Int}}
    E::Union{Nothing,Vector{Int}}
    I::Union{Nothing,Vector{Int}}
    R::Union{Nothing,Vector{Int}}
    T::Union{Nothing,Vector{Float64}}
end

mutable struct MyProblem
    parameters::MyParameters
    initial_condition
    total_reactions::Int
    data::Union{Nothing,MyData}
end
