using DN03
using Plots


#Primer 1: Primerjava nihala z harmoničnim ---
t_range = range(0.0, 10.0, length=1000)

# majhen odmik - nihali sta podobni
theta0_majhen = pi/8
ys_mat = nihalo.(t_range, theta0_majhen, 0.0)
ys_harm = nihalo_harmonicno.(t_range, theta0_majhen, 0.0)

p2 = plot(t_range, ys_mat, label="Matematično", linewidth=2)
plot!(t_range, ys_harm, label="Harmonično", linewidth=2, linestyle=:dash)
title!("Primerjava nihala pri θ₀ = π/8 rad")
xlabel!("t [s]")
ylabel!("θ [rad]")
display(p2)
savefig(p2, "demo/primerjava_pi8.png")

# velik odmik - nihali se razlikujeta
theta0_velik = pi/2
ys_mat2 = nihalo.(t_range, theta0_velik, 0.0)
ys_harm2 = nihalo_harmonicno.(t_range, theta0_velik, 0.0)

p3 = plot(t_range, ys_mat2, label="Matematično", linewidth=2)
plot!(t_range, ys_harm2, label="Harmonično", linewidth=2, linestyle=:dash)
title!("Primerjava nihala pri θ₀ = π/2 rad")
xlabel!("t [s]")
ylabel!("θ [rad]")
display(p3)
savefig(p3, "demo/primerjava_pi2.png")

#Primer 2: Nihajni čas
T_mat = nihajni_cas(0.1)
T_harm = 2π * sqrt(1.0/9.81)
println("\nNihajni čas pri theta0=0.1:")
println("  Matematično: $T_mat")
println("  Harmonično:  $T_harm")

#Primer 3: Graf odvisnosti nihajnega časa od energije
thetas = range(0.01, 3.0, length=50)
Es = energija.(thetas)
Ts = nihajni_cas.(thetas)
p = plot(Es, Ts,
    xlabel="Energija",
    ylabel="Nihajni čas [s]",
    label="Matematično nihalo",
    title="Odvisnost nihajnega časa od energije",
    linewidth=2)
hline!([T_harm],
    label="Harmonično nihalo",
    linewidth=2)
display(p)
savefig(p, "demo/nihajni_cas.png")