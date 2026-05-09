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
    @test isapprox(simpson(sin, 0.0, pi), 2.0, atol=1e-10)
    @test isapprox(simpson(x -> x^2, 0.0, 1.0), 1/3, atol=1e-10)
end

@testset "ploscina" begin
    p1 = ploscina(22pi, 1.0, -11.0/7.0, 100)
    p2 = ploscina(22pi, 1.0, -11.0/7.0, 1000)
    p3 = ploscina(22pi, 1.0, -11.0/7.0, 10000)
    @test isapprox(p1, p2, atol=1e-4)
    @test isapprox(p2, p3, atol=1e-6)
    #preverimo z znano formulo za astroido (3*pi*a^2 / 8)
    p_astroida = ploscina(2pi, 1.0, -1.0/4.0)
    @test isapprox(p_astroida, 3*pi/8, atol=1e-6)
end

