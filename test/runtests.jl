using MySimulations, Test
import Plots.Plot

@testset "MySimulations.jl" begin
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
            @test typeof(plot_solution(prb.data)) <: Plot
        end
        @testset "Tau Leap" begin
            tau_leap!(prb, 700, 0.3)
            @test all(x -> x >= 0, prb.data.S)
            @test all(x -> x == 0, prb.data.E)
            @test all(x -> x == 0, prb.data.I)
            @test all(x -> x == 0, prb.data.R)
            @test typeof(plot_solution(prb.data)) <: Plot
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
            @test typeof(plot_solution(prb.data)) <: Plot
        end
        @testset "Tau Leap" begin
            tau_leap!(prb, 700, 0.3)
            @test all(x -> x >= 0, prb.data.S)
            @test all(x -> x >= 0, prb.data.E)
            @test all(x -> x >= 0, prb.data.I)
            @test all(x -> x >= 0, prb.data.R)
            @test typeof(plot_solution(prb.data)) <: Plot
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
