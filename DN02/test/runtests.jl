using Test
using DN02

@testset "x(t)" begin
    a, b = 1.0, -11.0/7.0
    @test isapprox(x(0.0), a + 2b)
    @test isapprox(y(0.0), 0.0, atol=1e-10)
end

@testset "y(t)" begin
    a, b = 1.0, -11.0/7.0
    @test isapprox(y(0.0), 0.0, atol=1e-10)
end

@testset "dx(t)" begin
    @test isapprox(dx(0.0), 0.0, atol=1e-10)
end

@testset "dy(t)" begin
    a, b = 1.0, -11.0/7.0
    @test isapprox(dy(0.0), 2*(a+b), atol=1e-10)
end

@testset "perioda" begin
    # krivulja se mora zapreti po 22pi
    @test isapprox(x(0.0),x(22pi), atol=1e-10)
    @test isapprox(y(0.0), y(22pi), atol=1e-10)
end

@testset "simpson" begin
    @test isapprox(simpson(sin, 0.0, pi), 2.0, atol=1e-6)
    @test isapprox(simpson(x -> x^2, 0.0, 1.0), 1/3, atol=1e-6)
end

@testset "najdi_zunanja_presecisca" begin
    presecisca = najdi_zunanja_presecisca()
    # hipotrohoida z b=-11/7 ima 7 zunanjih presecisce
    @test length(presecisca) == 7
    # vsa presecisca naj bodo na priblizno enakem radiju
    radiji = [sqrt(p[3]^2 + p[4]^2) for p in presecisca]
    @test maximum(radiji) - minimum(radiji) < 0.01
end