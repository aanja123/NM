using DN02
using Plots

# narisi krivuljo s zunanjimi presecisci
zunanja = najdi_zunanja_presecisca()
t1 = range(0, 22pi, length=10000)
p = plot(x.(t1), y.(t1),
    aspect_ratio=:equal, legend=false, color=:blue)
for (i, pr) in enumerate(zunanja)
    scatter!([pr[3]], [pr[4]], color=:red, markersize=5)
    annotate!(pr[3], pr[4], text("$i", 10, :black))
end
display(p)


#narise lok med preseciscem 1 in 2
t_start = zunanja[1][2]
t_end = zunanja[2][1]    

t_list = range(t_start, t_end, length=1000)
xs_list = x.(t_list)
ys_list = y.(t_list)

t_all = range(0, 22pi, length=10000)
p = plot(x.(t_all), y.(t_all),
    aspect_ratio=:equal, legend=false, color=:lightblue)
plot!(xs_list, ys_list, color=:red, linewidth=3)
scatter!([zunanja[1][3], zunanja[2][3]], 
         [zunanja[1][4], zunanja[2][4]], 
         color=:green, markersize=8)
display(p)

#Izracuna ploscino
P = ploscina()
println("Skupna ploščina: $P")



