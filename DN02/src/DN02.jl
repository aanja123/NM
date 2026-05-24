module DN02
using LinearAlgebra

"""
    x(t, a=1.0, b=-11.0/7.0)
Vrne x koordinato hipotrohoide pri parametru `t`.
"""
function x(t, a=1.0, b=-11.0/7.0)
    return (a + b) * cos(t) + b * cos((a + b)/b * t)
end

"""
    y(t, a=1.0, b=-11.0/7.0)
Vrne y koordinato hipotrohoide pri parametru `t`.
"""
function y(t, a=1.0, b=-11.0/7.0)
    return (a + b) * sin(t) + b * sin((a + b)/b * t)
end

"""
    dx(t, a=1.0, b=-11.0/7.0)
Vrne odvod x koordinate hipotrohoide pri parametru `t`.
"""
function dx(t, a=1.0, b=-11.0/7.0)
    return -(a + b) * sin(t) - (a + b) * sin((a + b)/b * t)
end


"""
    dy(t, a=1.0, b=-11.0/7.0)
Vrne odvod y koordinate hipotrohoide pri parametru `t`.
"""
function dy(t, a=1.0, b=-11.0/7.0)
    return (a + b) * cos(t) + (a + b) * cos((a + b)/b * t)
end

"""
    simpson(f, a, b, n=100)
Sestavljeno Simpsonovo pravilo za numerično integracijo funkcije `f` na intervalu `[a, b]`
z `2n` enakomernimi koraki. Vrne približek za integral.
"""
function simpson(f, a, b, n=100)
    h = (b - a) / (2*n)
    result = f(a) + f(b)
    for k in 1:n
        result += 4 * f(a + (2k - 1) * h)
    end
    for j in 1:n-1
        result += 2 * f(a + 2j * h)
    end
    return result * h/3
end

"""
    newton(f, jf, x0, maxit=1000, atol=1e-8)
Newtonova metoda za reševanje sistema f(x) = 0.
`jf` je Jacobijeva matrika sistema, `x0` začetni približek.
Vrže napako če metoda ne konvergira po `maxit` korakih.
"""
function newton(f, jf, x0; maxit=1000, atol=1e-8)
    for i in 1:maxit
        # en korak Newtonove metode
        x = x0 - jf(x0) \ f(x0)
        # preverimo konvergenco z inf normo
        if norm(x - x0, Inf) < atol
            return x, i
        end
        x0 = x
    end
    throw("Metoda ne konvergira po $maxit korakih!")
end

"""
    najdi_presecisca(a, b, T, N=100)
Poišče vsa samopresečišča krivulje z Newtonovo metodo.
Za vsak par začetnih približkov na mreži N×N poišče presečišče
in zbere unikatne rešitve. Vrne seznam četverk (t1, t2, x, y).
"""
function najdi_presecisca(a=1.0, b=-11.0/7.0, T=22π, N=100)
    # sistem enačb: x(t1) = x(t2), y(t1) = y(t2)
    F(tt) = [x(tt[1], a, b) - x(tt[2], a, b),
             y(tt[1], a, b) - y(tt[2], a, b)]
    # Jacobijeva matrika sistema F
    J(tt) = [dx(tt[1], a, b)  -dx(tt[2], a, b);
             dy(tt[1], a, b)  -dy(tt[2], a, b)]

    rezultati = Tuple{Float64,Float64,Float64,Float64}[]
    ts = range(0.0, T, length=N+1)

    for t1 in ts
        for t2 in ts
            # preskočimo če sta t1 in t2 preblizu - ne gre za samopresečišče
            if abs(t1 - t2) < T/N
                continue
            end
            try
                tt, _ = newton(F, J, [t1, t2])
                tt1, tt2 = tt[1], tt[2]
                # preverimo da sta rešitvi znotraj periode [0, T]
                if tt1 < 0 || tt1 > T || tt2 < 0 || tt2 > T
                    continue
                end
                # preverimo da sta parametra res različna
                if abs(tt1 - tt2) < 1e-6
                    continue
                end
                # preverimo da je F res blizu 0 (veljavno presečišče)
                if norm(F([tt1, tt2])) > 1e-6
                    continue
                end

                xi = x(tt1, a, b)
                yi = y(tt1, a, b)
                # preverimo da presečišča še nismo našli
                nov = true
                for r in rezultati
                    if abs(r[3] - xi) < 1e-4 && abs(r[4] - yi) < 1e-4
                        nov = false
                        break
                    end
                end
                # če je presečišče novo, ga dodamo v rezultate
                if nov
                    push!(rezultati, (min(tt1,tt2), max(tt1,tt2), xi, yi))
                end
            catch
                # Newtonova metoda ni konvergirala, preskočimo
                continue
            end
        end
    end
    return rezultati
end

"""
    najdi_zunanja_presecisca(a, b, T, N=100, tol=1e-3)
Poišče zunanja samopresečišča krivulje, urejena po kotu.
"""
function najdi_zunanja_presecisca(a=1.0, b=-11.0/7.0, T=22π, N=100, tol=1e-3)
    vsa = najdi_presecisca(a, b, T, N)
    radiji = [sqrt(p[3]^2 + p[4]^2) for p in vsa]
    r_max = maximum(radiji)
    #ohranimo samo presecisca blizu maksimalnega radija
    zunanja = [(min(p[1],p[2]), max(p[1],p[2]), p[3], p[4]) 
               for (i,p) in enumerate(vsa) if abs(radiji[i] - r_max) < tol]
    #uredimo po kotu
    koti = [atan(p[4], p[3]) for p in zunanja]
    return zunanja[sortperm(koti)]
end


"""
    ploscina_lista(p1, p2, a=1.0, b=-11.0/7.0, T=22π, n=100)
Izračuna ploščino enega lista hipotrohoide med dvema sosednjima 
zunanjima presečiščema `p1` in `p2`.
"""
function ploscina_lista(p1, p2, a=1.0, b=-11.0/7.0, T=22π, n=100)
    f(t) = 0.5 * (x(t, a, b) * dy(t, a, b) - dx(t, a, b) * y(t, a, b))
    # vsako presecisce ima dva parametra t (krivulja pride do njega dvakrat)
    # preizkusimo vse 4 kombinacije in izberemo najkrajsi pozitivni interval
    kombinacije = [(p1[1], p2[1]), (p1[1], p2[2]),
                   (p1[2], p2[1]), (p1[2], p2[2])]
    best = nothing
    for (ta, tb) in kombinacije
        dt = tb - ta
        if dt > 0 && (best === nothing || dt < best[2])
            best = ((ta, tb), dt)
        end
    end
    # za zadnji par presecisce (7->1) so vse vrednosti negativne,
    # resimo tako da drugemu preseciscu pristejemo periodo T
    if best === nothing
        for (ta, tb) in [(ta, tb+T) for (ta, tb) in kombinacije]
            dt = tb - ta
            if dt > 0 && (best === nothing || dt < best[2])
                best = ((ta, tb), dt)
            end
        end
    end
    return abs(simpson(f, best[1][1], best[1][2], n))
end

"""
    ploscina(a=1.0, b=-11.0/7.0, T=22π, N=100, n=100)
Izračuna skupno ploščino hipotrohoide kot vsoto ploščin vseh listov.
"""
function ploscina(a=1.0, b=-11.0/7.0, T=22π, N=100, n=100)
    presecisca = najdi_zunanja_presecisca(a, b, T, N)
    k = length(presecisca)
    total = 0.0
    for i in 1:k
        j = i % k + 1
        p = ploscina_lista(presecisca[i], presecisca[j], a, b, T, n)
        #println("List $i-$j: $p")
        total += p
    end
    return total
end

export x, y, dx, dy, simpson, najdi_presecisca, najdi_zunanja_presecisca, ploscina_lista, ploscina

end # module DN02
