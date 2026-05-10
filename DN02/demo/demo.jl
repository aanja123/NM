using DN02
using Plots
#b = -p/q T=lcm(p,q)/q * 2pi
#77/7 * 2pi = 22pi
#Primer 1
P1 = ploscina(22pi)
println("Ploščina hipotrohoide (a=1, b=-11/7): $P1")
t1 = range(0, 22pi, length=10000)
xs = x.(t1)
ys = y.(t1)
p1 = plot(xs, ys,
    aspect_ratio=:equal,
    title="Hipotrohoida (a=1, b=-11/7)",
    xlabel="x",
    ylabel="y",
    legend=false,
    color=:blue)
display(p1)
savefig(p1, "demo/hipotrohoida.png")

#Primer 2 4/4 * 2pi = 2pi
a=1.0
b=-1.0/4.0
P2 = ploscina(2pi, a, b) #mora bit 3*pi*a^2 / 8 = 1.17
println("Ploščina hipotrohoide (a=1, b=-1/4): $P2")
t2 = range(0, 2pi, length=10000)
p2 = plot(x.(t2, a, b), y.(t2, a, b),
    aspect_ratio=:equal,
    title="Hipotrohoida (a=1, b=-1/4)",
    legend=false, color=:magenta)
display(p2)
savefig(p2, "demo/hipotrohoida2.png")

#Primer 3 5/5 * 2pi = 2pi
a=1.0
b=-1.0/5.0
P3 = ploscina(2pi, a, b)
println("Ploščina hipotrohoide (a=1, b=-1/5): $P3")
t3 = range(0, 2pi, length=10000)
p3 = plot(x.(t3, a, b), y.(t3, a, b),
    aspect_ratio=:equal,
    title="Hipotrohoida (a=1, b=-1/5)",
    legend=false, color=:red)
display(p3)
savefig(p3, "demo/hipotrohoida3.png")

#Primer 4 10/5 * 2pi = 4pi
a=1.0
b=-2.0/5.0
P4 = ploscina(4pi, a, b)
println("Ploščina hipotrohoide (a=1, b=-2/5): $P4")
t4 = range(0, 4pi, length=10000)
p4 = plot(x.(t4, a, b), y.(t4, a, b),
    aspect_ratio=:equal,
    title="Hipotrohoida (a=1, b=-2/5)",
    legend=false, color=:green)
display(p4)
savefig(p4, "demo/hipotrohoida4.png")

#Primer 5 85/17 * 2pi = 10pi
a=1.0
b=-5.0/17.0
P5 = ploscina(10pi, a, b)
println("Ploščina hipotrohoide (a=1, b=-5/17): $P5")
t5 = range(0, 10pi, length=10000)
p5 = plot(x.(t5, a, b), y.(t5, a, b),
    aspect_ratio=:equal,
    title="Hipotrohoida (a=1, b=-5/17)",
    legend=false, color=:black)
display(p5)
savefig(p5, "demo/hipotrohoida5.png")

#Konvergenca n
n = 1
p_old = ploscina(22pi, 1.0, -11.0/7.0, n)
for i in 1:10
    n *= 2
    p_new = ploscina(22pi, 1.0, -11.0/7.0, n)
    println("n=$n: $p_new, razlika: $(abs(p_new - p_old))")
    if abs(p_new - p_old) < 1e-10
        println("Konvergenca dosežena!")
        break
    end
    p_old = p_new
end

# Konvergenca
n = 1
p_old = ploscina(2pi, 1.0, -1.0/4.0, n)
p_exact = 3*pi/8
for i in 1:10
    n *= 2
    p_new = ploscina(2pi, 1.0, -1.0/4.0, n)
    napaka = abs(p_new - p_exact)
    println("n=$n: $p_new, napaka: $napaka")
    if napaka < 1e-10
        println("Konvergenca dosežena!")
        break
    end
    p_old = p_new
end