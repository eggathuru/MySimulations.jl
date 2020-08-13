using MySimulations: p_rand, alt_rand
using Plots, Distributions

λ = 0.003

v1 = [p_rand(λ, 3) for _ in 1:10_000]
v2 = [alt_rand(λ, 3) for _ in 1:10_000]

p1 = histogram(v1, bins=0:1:30)
p2 = histogram(v2, bins=0:1:30)

plot(p1, p2)
