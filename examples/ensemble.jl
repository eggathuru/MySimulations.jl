using MySimulations
prb = MyBirthDeath(1000, 0.02)

N = 10
e = ensemble_tau!(prb, 700, 0.3, N)

p = plot_solution(e[1])
for i in 2:N
    p = plot_solution!(e[i])
end
p
