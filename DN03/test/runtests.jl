using Test
using DN03

@testset "dopri5" begin
    # y' = y, y(0) = 1 -> resitev je e^t
    f(t, y) = y
    ts, ys = dopri5(f, 0.0, [1.0], 1.0)
    @test isapprox(ys[end][1], exp(1.0), atol=1e-10)
end

@testset "nihalo_harmonicno" begin
    # pri t=0 mora biti theta0
    @test isapprox(nihalo_harmonicno(0.0, 0.5, 0.0), 0.5, atol=1e-10)
    # pri t=T mora biti spet theta0 (ena perioda)
    T = 2π * sqrt(1.0/9.81)
    @test isapprox(nihalo_harmonicno(T, 0.5, 0.0), 0.5, atol=1e-10)
end

@testset "nihalo" begin
    # za majhen odmik mora biti blizu harmonicnemu
    t = 1.0
    theta0 = 0.1
    @test isapprox(nihalo(t, theta0, 0.0), nihalo_harmonicno(t, theta0, 0.0), atol=1e-4)
    # pri t=0 mora biti theta0
    @test isapprox(nihalo(0.0, 0.5, 0.0), 0.5, atol=1e-10)
end

@testset "nihajni_cas" begin
    # za majhen odmik mora biti blizu harmonicnemu nihajnemu casu
    T_harm = 2π * sqrt(1.0/9.81)
    T_mat = nihajni_cas(0.1)
    @test isapprox(T_mat, T_harm, atol=1e-2)
    # nihajni cas mora narascati z odmikom
    T1 = nihajni_cas(0.1)
    T2 = nihajni_cas(1.0)
    @test T2 > T1
end

@testset "energija" begin
    # pri omega0=0 in theta0=0 je energija 0
    @test isapprox(energija(0.0, 0.0), 0.0, atol=1e-10)
    # energija mora narascati z odmikom
    @test energija(1.0) > energija(0.5)
end