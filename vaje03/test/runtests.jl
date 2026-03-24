using vaje03
using Test

@testset "Desne strani matrike sistema so pravilne za Laplaceov operator" begin
    Z = [1 2 3 4 5;
        5 0 0 0 6;
        7 0 0 0 8;
        7 8 9 10 11]
    A, b = vaje03.matrix_rhs(Laplace(), Z)
    @test b = [-7, -3, -10, -15, -9, -18]
end