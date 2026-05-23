module DN02

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
    najdi_presecisca(a, b, T, N=2000)
Poišče samopresečišča krivulje. Vrne seznam četverk (t1, t2, x, y).
"""
function najdi_presecisca(a=1.0, b=-11.0/7.0, T=22π, N=2000)
    ts = collect(range(0.0, T, length=N+1))
    pts = [(x(t,a,b), y(t,a,b)) for t in ts]
    result = Tuple{Float64,Float64,Float64,Float64}[]
    gap = max(5, div(N, 100)) # gap prepreci da najdemo presecisca med sosednjimi segmenti
    for i in 1:N
        for j in i+gap:N
            # preverimo ali se segmenta i in j sekata
            d1 = (pts[i+1][1]-pts[i][1], pts[i+1][2]-pts[i][2])
            d2 = (pts[j+1][1]-pts[j][1], pts[j+1][2]-pts[j][2])
            cross = d1[1]*d2[2] - d1[2]*d2[1]
            # ce je cross blizu 0 sta segmenta vzporedna
            if abs(cross) < 1e-12
                continue
            end
            ddx = pts[j][1]-pts[i][1]
            ddy = pts[j][2]-pts[i][2]
            # alpha, beta sta relativni poziciji presecisca na segmentih
            alpha = (ddx*d2[2] - ddy*d2[1]) / cross
            beta  = (ddx*d1[2] - ddy*d1[1]) / cross
            if 0 < alpha < 1 && 0 < beta < 1
                # interpoliramo tocne vrednosti t in koordinat
                t1 = ts[i] + alpha*(ts[i+1]-ts[i])
                t2 = ts[j] + beta*(ts[j+1]-ts[j])
                xi = pts[i][1] + alpha*(pts[i+1][1]-pts[i][1])
                yi = pts[i][2] + alpha*(pts[i+1][2]-pts[i][2])
                push!(result, (t1, t2, xi, yi))
            end
        end
    end
    return result
end

"""
    najdi_zunanja_presecisca(a, b, T, N=2000, tol=1e-3)
Poišče zunanja samopresečišča krivulje, urejena po kotu.
"""
function najdi_zunanja_presecisca(a=1.0, b=-11.0/7.0, T=22π, N=2000, tol=1e-3)
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
    ploscina(a=1.0, b=-11.0/7.0, T=22π, N=2000, n=100)
Izračuna skupno ploščino hipotrohoide kot vsoto ploščin vseh listov.
"""
function ploscina(a=1.0, b=-11.0/7.0, T=22π, N=2000, n=100)
    presecisca = najdi_zunanja_presecisca(a, b, T, N)
    k = length(presecisca)
    total = 0.0
    # gremo cez vse sosednje pare presecisce (vkljucno z zadnjim 7->1)
    for i in 1:k
        j = i % k + 1
        total += ploscina_lista(presecisca[i], presecisca[j], a, b, T, n)
    end
    return total
end

export x, y, dx, dy, simpson, najdi_presecisca, najdi_zunanja_presecisca, ploscina_lista, ploscina

end # module DN02
