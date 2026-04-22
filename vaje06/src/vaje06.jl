module vaje06
using LinearAlgebra

"Podatkovna struktura za interval"
struct Interval
    min
    max
end
"Ali interval `I` vsebuje točko `x`?"
vsebuje(x, I::Interval) = x >= I.min && x <= I.max
"""
Podatkovna struktura za pravokotnik, vzporeden s koordinatnimi osmi (škatla).
Pravokotnik je podan kot produkt dveh intervalov za spremenljivki `x` in `y`.
"""
struct Box2d
    int_x
    int_y
end
"Ali škatla `b` vsebuje dano točko `x`?"
vsebuje(x, b::Box2d) = vsebuje(x[1], b.int_x) && vsebuje(x[2], b.int_y)
"""
x = diskretiziraj(I, n)
Razdeli interval `I` na `n` enakih podintervalov. Vrni seznam krajišč
podintervalov.
"""
diskretiziraj(I::Interval, n) = range(I.min, I.max, n)
"""
x = diskretiziraj(b, m, n)
Razdeli škatlo `b` na manjše škatle. Vrni seznama krajišč
podintervalov v smereh `x` in `y`.
"""
diskretiziraj(b::Box2d, m, n) = (
diskretiziraj(b.int_x, m), diskretiziraj(b.int_y, n))

function konvergenca(območje::Box2d, metoda, m=50, n=50; atol=1e-3)
    Z = zeros(m, n)
    koraki = zeros(m, n)
    x, y = diskretiziraj(območje, n, m)
    ničle = []
    for i = 1:n, j = 1:m
        z = [x[i], y[j]]
        it = 0
        try
            z, it = metoda(z)
        catch
            continue
        end
        k = findfirst([norm(z - z0, Inf) < 2atol for z0 in ničle])
        if isnothing(k)
            if vsebuje(z, območje)
                push!(ničle, z)
                k = length(ničle)
            else
                continue
            end
        end
        Z[j, i] = k # vrednost elementa je enaka indeksu ničle
        koraki[j, i] = it # število korakov metode
    end
    return x, y, Z, ničle, koraki
end

function newton(f, jf, x0; maxit=1000, atol=1e-8)
    for i = 1:maxit
        x = x0 - jf(x0) \ f(x0)
        if norm(x - x0, Inf) < atol
            return x, i
        end
        x0 = x
    end
    throw("Metoda ne konvergira po $maxit korakih!")
end

export newton, konvergenca, Box2d, Interval, vsebuje, diskretiziraj

end # module vaje06

