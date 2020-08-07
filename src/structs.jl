struct MyParameters
    μ::Union{Nothing,Float64}
    β::Union{Nothing,Float64}
    a::Union{Nothing,Float64}
    γ::Union{Nothing,Float64}
    α::Union{Nothing,Float64}
end

mutable struct MyData
    S::Union{Nothing,Vector{Float64}}
    E::Union{Nothing,Vector{Float64}}
    I::Union{Nothing,Vector{Float64}}
    R::Union{Nothing,Vector{Float64}}
    T::Union{Nothing,Vector{Float64}}
end

mutable struct MyProblem
    parameters::MyParameters
    initial_condition
    data::Union{Nothing,MyData}
end
