using Test
using vaje02

@testset "Data Structure TridiagonalMatrix" begin
    T = TridiagonalMatrix([1, 2, 3], [4, 5, 6], [7, 8, 9])
    @test T.ld == [1, 2, 3]
    @test T.d == [4, 5, 6]
    @test T.ud == [7, 8, 9]
end

@testset "Elements of TridiagonalMatrix" begin
    T = TridiagonalMatrix([1, 2, 3], [4, 5, 6, 7], [8, 9, 10])
    @test T[1, 1] == 4
    @test T[1, 4] == 0
    @test T[2, 1] == 1
    @test T[2, 3] == 9
end

@testset "Elements of TridiagonalMatrix can be set to a new value" begin
    T = TridiagonalMatrix([1, 2, 3], [4, 5, 6, 7], [8, 9, 10])
    T[1, 1] = 5
    @test T[1, 1] == 5
    T[2, 1] = 11
    @test T[2, 1] == 11
    T[2, 3] = 12
    @test T[2, 3] == 12
    @test_throws ErrorException T[2, 4] = 13

end

@testset "TridiagonalMatrix can be multiplied with vector" begin
    T = TridiagonalMatrix([1, 2], [3,4, 5,], [6,7])
    A = [3 6 0;
         1 4 7;
         0 2 5]
    x = [1, 2, 3]
    b = T*x
    rezultat = T*x
    pravi = A*x
    @test isapprox(rezultat, pravi, rtol=1e-8)
end

@testset "System Ax=b can be solved by A\b" begin
    T = TridiagonalMatrix([1, 2], [3,4, 5,], [6,7])
    prava_resitev = [1, 2, 3]
    b = T * [1, 2, 3]
    x = T\b
    @test isapprox(x, prava_resitev, rtol=1e-8)
end
