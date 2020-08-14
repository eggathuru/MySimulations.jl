using MySimulations, Test
import Plots.Plot

@testset "MySimulations.jl" begin
    @testset "Distributions" begin
        @testset "c_rand" begin
            try MySimulations.c_rand(-1) catch e
                @test typeof(e) <: ErrorException
            end
            try MySimulations.c_rand(NaN) catch e
                @test typeof(e) <: ErrorException
            end
            try MySimulations.c_rand(Inf) catch e
                @test typeof(e) <: ErrorException
            end
        end
        @testset "t_rand" begin
            try MySimulations.t_rand(-1) catch e
                @test typeof(e) <: ErrorException
            end
            try MySimulations.t_rand(NaN) catch e
                @test typeof(e) <: ErrorException
            end
            try MySimulations.t_rand(Inf) catch e
                @test typeof(e) <: ErrorException
            end
            λ = 0.001
            N = 10_000
            v = [MySimulations.t_rand(0.001, 3) for _ in 1:N]
            @test 2*sum(v) < N # No errors for small λ
        end
    end
    @testset "Birth Death" begin
        prb = MyBirthDeath(1000, 0.02)
        @testset "Initialization" begin
            @test typeof(prb) <: MySimulations.MyProblem
        end
        @testset "Direct SSA" begin
            direct_ssa!(prb, Int(3e4))
            @test all(x -> x >= 0, prb.data.S)
            @test all(x -> x == 0, prb.data.E)
            @test all(x -> x == 0, prb.data.I)
            @test all(x -> x == 0, prb.data.R)
            p = plot_solution(prb.data)
            @test typeof(p) <: Plot
            plot_solution!(p, prb.data)
            @test typeof(p) <: Plot
        end
        @testset "Tau Leap" begin
            tau_leap!(prb, 700, 0.3)
            @test all(x -> x >= 0, prb.data.S)
            @test all(x -> x == 0, prb.data.E)
            @test all(x -> x == 0, prb.data.I)
            @test all(x -> x == 0, prb.data.R)
            p = plot_solution(prb.data)
            @test typeof(p) <: Plot
            plot_solution!(p, prb.data)
            @test typeof(p) <: Plot
        end
        @testset "SSA Ensemble" begin
            N = 10
            e = ensemble_ssa!(prb, Int(3e4), N)
            for i in 1:N
                @test typeof(e[i]) <: MySimulations.MyData
            end
        end
        @testset "Tau Ensemble" begin
            N = 10
            e = ensemble_tau!(prb, 700, 0.3, N)
            for i in 1:N
                @test typeof(e[i]) <: MySimulations.MyData
            end
        end
    end
    @testset "SEIR" begin
        prb = MySEIR((990, 0, 10, 0),
              (0.02, 0.055, 0.07, 0.006, 0.001))
        @testset "Initialization" begin
            @test typeof(prb) <: MySimulations.MyProblem
        end
        @testset "Direct SSA" begin
            direct_ssa!(prb, Int(3e4))
            @test all(x -> x >= 0, prb.data.S)
            @test all(x -> x >= 0, prb.data.E)
            @test all(x -> x >= 0, prb.data.I)
            @test all(x -> x >= 0, prb.data.R)
            p = plot_solution(prb.data)
            @test typeof(p) <: Plot
            plot_solution!(p, prb.data)
            @test typeof(p) <: Plot
        end
        @testset "Tau Leap" begin
            tau_leap!(prb, 700, 0.3)
            @test all(x -> x >= 0, prb.data.S)
            @test all(x -> x >= 0, prb.data.E)
            @test all(x -> x >= 0, prb.data.I)
            @test all(x -> x >= 0, prb.data.R)
            p = plot_solution(prb.data)
            @test typeof(p) <: Plot
            plot_solution!(p, prb.data)
            @test typeof(p) <: Plot
        end
        @testset "SSA Ensemble" begin
            N = 10
            e = ensemble_ssa!(prb, Int(3e4), N)
            for i in 1:N
                @test typeof(e[i]) <: MySimulations.MyData
            end
        end
        @testset "Tau Ensemble" begin
            N = 10
            e = ensemble_tau!(prb, 700, 0.3, N)
            for i in 1:N
                @test typeof(e[i]) <: MySimulations.MyData
            end
        end
    end
end
