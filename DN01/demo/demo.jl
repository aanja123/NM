using DN01
using Graphs
using Plots

#Primer 1: krožna_lestev
G = krožna_lestev(8)

t = range(0, 2pi, 9)[1:end-1]
x = cos.(t)
y = sin.(t)
točke = hcat(hcat(x, y)', zeros(2, 8))
fix = 1:8

vloži!(G, fix, točke)

p1 = plot(title="Krožna lestev")
for e in edges(G)
    plot!([točke[1, src(e)], točke[1, dst(e)]],
          [točke[2, src(e)], točke[2, dst(e)]],
          color=:blue, legend=false)
end
scatter!(točke[1, :], točke[2, :], color=:red)
display(p1)

#Primer 2: mreža z fiksiranimi vogali
m, n = 6, 6
G2 = Graphs.grid((m, n), periodic=false)
vogali = filter(v -> degree(G2, v) <= 2, vertices(G2))
točke2 = zeros(2, n * m)
točke2[:, vogali] = [0.0 0.0 1.0 1.0; 0.0 1.0 0.0 1.0]

vloži!(G2, vogali, točke2)

p2 = plot(title="Mreža - vogali fiksirani")
for e in edges(G2)
    plot!([točke2[1, src(e)], točke2[1, dst(e)]],
          [točke2[2, src(e)], točke2[2, dst(e)]],
          color=:blue, legend=false)
end
scatter!(točke2[1, :], točke2[2, :], color=:red)
display(p2)

#Primer 3: Iskanje optimalneg omege
#uporabimo krozno lestev za testiranje
G3 = krožna_lestev(8)
t3 = range(0, 2pi, 9)[1:end-1]
x = cos.(t3)
y = sin.(t3)
točke3 = hcat(hcat(x, y)', zeros(2, 8))
fix3 = 1:8
#nastavimo matriko pred for loopom
sprem = setdiff(vertices(G3), fix3)
A3 = matrika(G3, sprem)
b3 = desne_strani(G3, sprem, točke3[1, :])

#testiramo od 0.01 do 1.99
omegas = range(0.01, 1.99, length=10000)
iters = Int[]

for omega in omegas
    _, it = sor(-A3, -b3, zeros(length(sprem)), Float64(omega))
    push!(iters, it)
end

p3 = plot(omegas, iters,
    xlabel="ω",
    ylabel="število iteracij",
    title="Konvergenca SOR v odvisnosti od ω",
    legend=false)
display(p3)

best_omega = omegas[argmin(iters)]
println("Optimalni omega: $best_omega")
println("Število iteracij: $(minimum(iters))")