using MySimulations
using Test

@testset "MySimulations.jl" begin
    # Write your tests here.
    @testset "Initialization" begin
        prb = MySimulations.MySEIR((990, 0, 10, 0),
                 (0.02, 0.055, 0.07, 0.006, 0.001))
        @test typeof(prb) == MySimulations.MyProblem
    end
    @testset "Direct SSA" begin
        MySimulations.direct_ssa!(prb, Int(3e4))
        @test all(x -> x >= 0, prb.data.S)
        @test all(x -> x >= 0, prb.data.E)
        @test all(x -> x >= 0, prb.data.I)
        @test all(x -> x >= 0, prb.data.R)
        @test typeof(MySimulations.plot_solution(prb)) <: Plots.Plot
    end
    @testset "Tau Leap" begin
        MySimulations.tau_leap!(prb, 700, 0.3)
        @test all(x -> x >= 0, prb.data.S)
        @test all(x -> x >= 0, prb.data.E)
        @test all(x -> x >= 0, prb.data.I)
        @test all(x -> x >= 0, prb.data.R)
        @test typeof(MySimulations.plot_solution(prb)) <: Plots.Plot
    end
end
