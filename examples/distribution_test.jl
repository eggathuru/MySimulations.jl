using MySimulations: c_rand, t_rand
using Plots, Distributions

λ = 5

v1 = [c_rand(λ, 3) for _ in 1:10_000]
v2 = [t_rand(λ, 3) for _ in 1:10_000]

p1 = histogram(v1, bins=0:1:30)
p2 = histogram(v2, bins=0:1:30)

plot(p1, p2)
