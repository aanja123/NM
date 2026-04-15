using Test
using vaje05
using LinearAlgebra

@testset "Function inviter" begin
    @testset "calculate eigenvector and eigenvalue clsoest to 0" begin
        A = [-2 0; 0 3]
        solve(b) = A\b
        x, l = inviter(solve, rand(2); rtol=1e-3)
        cosine = dot(x, [1, 0]) / norm(x)
        @test isapprox(abs(cosine), 1; rtol=1e-6)
        @test isapprox(l, -2; rtol=1e-3)
    end
end