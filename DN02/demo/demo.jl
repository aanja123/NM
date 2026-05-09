using DN02
using Plots
#b = -p/q T=lcm(p,q)/q * 2pi
#77/7 * 2pi = 22pi
#Primer 1

# parametri
t = range(0, 22pi, length=10000)
# izracun krivulje
xs = x.(t)
ys = y.(t)
# slika
p = plot(xs, ys,
    aspect_ratio=:equal,
    title="Hipotrohoida (a=1, b=-11/7)",
    xlabel="x",
    ylabel="y",
    legend=false,
    color=:blue)
display(p)
#savefig(p, "demo/hipotrohoida.png")
# izracun ploscine
P = ploscina(22pi)
println("Ploščina hipotrohoide (a=1, b=-11/7): $P")

#Primer 2 5/5 * 2pi = 2pi
a=1.0
b=-1.0/5.0
P2 = ploscina(2pi, a, b)
println("Ploščina hipotrohoide (a=1, b=-1/5): $P2")
t2 = range(0, 2pi, length=10000)
p2 = plot(x.(t2, a, b), y.(t2, a, b),
    aspect_ratio=:equal,
    title="Hipotrohoida (a=1, b=-1/5)",
    legend=false, color=:red)
display(p2)
#savefig(p2, "demo/hipotrohoida2.png")

#Primer 3 10/5 * 2pi = 4pi
a=1.0
b=-2.0/5.0
P3 = ploscina(4pi, a, b)
println("Ploščina hipotrohoide (a=1, b=-2/5): $P3")
t3 = range(0, 4pi, length=10000)
p3 = plot(x.(t3, a, b), y.(t3, a, b),
    aspect_ratio=:equal,
    title="Hipotrohoida (a=1, b=-2/5)",
    legend=false, color=:red)
display(p3)

#Primer 4 85/17 * 2pi = 10pi
a=1.0
b=-5.0/17.0
P4 = ploscina(10pi, a, b)
println("Ploščina hipotrohoide (a=1, b=-5/17): $P4")
t4 = range(0, 10pi, length=10000)
p4 = plot(x.(t4, a, b), y.(t4, a, b),
    aspect_ratio=:equal,
    title="Hipotrohoida (a=1, b=-5/17)",
    legend=false, color=:red)
display(p4)

#Primer 5 4/4 * 2pi = 2pi
a=1.0
b=-1.0/4.0
P5 = ploscina(2pi, a, b) #mora bit 3*pi*a^2 / 8 = 1.17
println("Ploščina hipotrohoide (a=1, b=-1/4): $P5")
t5 = range(0, 2pi, length=10000)
p5 = plot(x.(t5, a, b), y.(t5, a, b),
    aspect_ratio=:equal,
    title="Hipotrohoida (a=4, b=-1/4)",
    legend=false, color=:red)
display(p5)


