using Test
using vaje04
using LinearAlgebra

@testset "Function power(A, x0)" begin
    @testset "It calculates eigenvector for largest eigenvalue" begin
        A = [2 0; 0 3]
        x0 = [1, 1]
        x, it = power(A, x0)
        @test norm(x) > 1e-3 #verify that the vector is nonzero
        @test isapprox(3x, A * x) #Ax = 3x verify is x is an eigenvector
    end
    @testset "It calcualtes eigenvector if eigenvalue is negative" begin
        A = [2 0; 0 -3]
        x0 = [1, 1]
        x, it = power(A, x0)
        @test norm(x) > 1e-3 #verify that the vector is nonzero
        @test isapprox(-3x, A * x) #Ax = -3x verify is x is an eigenvector
    end
end