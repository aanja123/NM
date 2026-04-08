using Test
using DN01

@testset "DN01" begin
    DN01.greet()
end

@testset "setindex!" begin
    A = DN01.RedkaMatrika(3)
    A[1, 1] = 4.0
    A[1, 3] = 2.0
    A[2, 2] = 5.0
    @test A.V[1] == [4.0, 2.0]
    @test A.I[1] == [1, 3]
    @test A.V[2] == [5.0]
    @test A.I[2] == [2]
end

@testset "getindex" begin
    A = DN01.RedkaMatrika(3)
    A[1, 1] = 4.0
    A[1, 2] = 2.0
    A[2, 3] = 5.0
    @test A[1, 1] == 4.0
    @test A[1, 2] == 2.0
    @test A[2, 3] == 5.0
    @test A[1, 3] == 0.0  #zero element
end

@testset "size" begin
    A = DN01.RedkaMatrika(3)
    @test size(A) == (3, 3)
    @test size(A, 1) == 3
    @test size(A, 2) == 3
end

@testset "multiplication" begin
    A = DN01.RedkaMatrika(3)
    A[1, 1] = 1.0
    A[1, 3] = 2.0
    A[2, 2] = 3.0
    A[3, 1] = 4.0
    A[3, 3] = 5.0

    x = [1.0, 2.0, 3.0]
    result = A * x

    @test result == [7.0, 6.0, 19.0]
end
