module DN01

using Graphs

struct RedkaMatrika
    V::Vector{Vector{Float64}}  #neničelne vrednosti po vrsticah
    I::Vector{Vector{Int}}      #indeksi neničelnih vrednosti po vrsticah
    n::Int                      #velikost matrike (n x n)
end

"""
    A = RedkaMatrika(n)
Ustvari prazno redko matriko velikosti `n x n`.
Neničelni elementi so shranjeni v dveh tabelah: `V` za vrednosti in `I` za indekse stolpcev.
"""
function RedkaMatrika(n::Int)
    V = [Vector{Float64}() for _ in 1:n]
    I = [Vector{Int}() for _ in 1:n]
    return RedkaMatrika(V, I, n)
end

"""
    size(A)
Vrne velikost redke matrike `A` kot `(n, n)`.
"""
Base.size(A::RedkaMatrika) = (A.n, A.n) #2D

"""
    size(A, d)
Vrne velikost redke matrike `A` kot `n`.
"""
Base.size(A::RedkaMatrika, d::Int) = A.n #1D

"""
    A[i, j]
Vrne element redke matrike `A` na poziciji `(i, j)`.
Če element ni shranjen, vrne `0.0`.
"""
function Base.getindex(A::RedkaMatrika, i::Int, j::Int)
    for k in 1:length(A.I[i])
        if A.I[i][k] == j
            return A.V[i][k]
        end
    end
    return 0.0
end

"""
    A[i, j] = v
Nastavi element redke matrike `A` na poziciji `(i, j)` na vrednost `v`.
Če element še ne obstaja, ga doda.
"""
function Base.setindex!(A::RedkaMatrika, v::Float64, i::Int, j::Int)
    for k in 1:length(A.I[i])
        if A.I[i][k] == j
            A.V[i][k] = v
            return
        end
    end
    #ne obstaja, dodaj nov element (0 -> v)
    push!(A.I[i], j)
    push!(A.V[i], v)
end

"""
    A * x
Pomnoži redko matriko `A` z vektorjem `x`.
"""
function Base.:*(A::RedkaMatrika, x::Vector{Float64})
    n = size(A,1)
    result = zeros(Float64, n)
    for i in 1:n
        for k in 1:length(A.I[i])
            j = A.I[i][k]
            result[i] += A.V[i][k] * x[j]
        end
    end
    return result
end

"""
    x, it = sor(A, b, x0, omega, tol=1e-10)
Reši sistem enačb `Ax = b` z metodo SOR.
Argument `x0` je začetni približek, `omega` je parameter sprostitve,
`tol` je pogoj za ustavitev glede na normo ostanka `||Ax - b||inf`.
Vrne rešitev `x` in število iteracij `it`.
"""
function sor(A::RedkaMatrika, b::Vector{Float64}, x0::Vector{Float64}, omega::Float64, tol=1e-10)
    n = size(A, 1)
    x = copy(x0)
    it = 0

    while true
        for i in 1:n
            sigma = 0.0
            aii = 0.0
            for k in 1:length(A.I[i])
                j = A.I[i][k]
                if j == i
                    aii = A.V[i][k]
                else
                    sigma += A.V[i][k] * x[j]
                end
            end
            x[i] = (1 - omega) * x[i] + (omega / aii) * (b[i] - sigma)
        end
        it += 1

        #preveri kriterij: ||Ax - b||inf < tol
        if maximum(abs.(A * x - b)) < tol
            break
        end
    end

    return x, it
end


"""
    -A
Vrne negacijo redke matrike `A`.
"""
function Base.:-(A::RedkaMatrika)
    V_new = [copy(v) .* -1 for v in A.V]
    I_new = [copy(i) for i in A.I]
    return RedkaMatrika(V_new, I_new, A.n)
end


"""
    G = krožna_lestev(n)
Ustvari graf krožna lestev z `2n` točkami.
"""
function krožna_lestev(n)
    G = SimpleGraph(2 * n)
    # prvi cikel
    for i = 1:n-1
        add_edge!(G, i, i + 1)
    end
    add_edge!(G, 1, n)
    # drugi cikel
    for i = n+1:2n-1
        add_edge!(G, i, i + 1)
    end
    add_edge!(G, n + 1, 2n)
    # povezave med obema cikloma
    for i = 1:n
        add_edge!(G, i, i + n)
    end
    return G
end

"""
    A = matrika(G::AbstractGraph, sprem)
Poišči matriko sistema linearnih enačb za vložitev grafa `G` s fizikalno metodo.
Argument `sprem` je vektor vozlišč grafa, ki nimajo določenih koordinat.
Indeksi v matriki `A` ustrezajo vozliščem v istem vrstnem redu,
kot nastopajo v argumentu `sprem`.
"""
function matrika(G::AbstractGraph, sprem)
    # preslikava med vozlišči in indeksi v matriki
    v_to_i = Dict([sprem[i] => i for i in eachindex(sprem)])
    m = length(sprem)
    A = RedkaMatrika(m) #redka matrika
    for i = 1:m
        vertex = sprem[i]
        sosedi = neighbors(G, vertex)
        for vertex2 in sosedi
            if haskey(v_to_i, vertex2)
                j = v_to_i[vertex2]
                A[i, j] = 1.0 #float
            end
        end
        A[i, i] = float(-length(sosedi)) #flaot
    end
    return A
end

"""
    b = desne_strani(G::AbstractGraph, sprem, koordinate)
Poišči desne strani sistema linearnih enačb za eno koordinato vložitve grafa `G`
s fizikalno metodo. Argument `sprem` je vektor vozlišč grafa, ki nimajo
določenih koordinat. Argument `koordinate` vsebuje eno koordinato za vsa
vozlišča grafa. Metoda uporabi le koordinato vozlišč, ki so pritrjena.
Indeksi v vektorju `b` ustrezajo vozliščem v istem vrstnem redu,
kot nastopajo v argumentu `sprem`.
"""
function desne_strani(G::AbstractGraph, sprem, koordinate)
    set = Set(sprem)
    m = length(sprem)
    b = zeros(m)
    for i = 1:m
        v = sprem[i]
        for v2 in neighbors(G, v)
            if !(v2 in set) # dodamo le točke, ki so fiksirane
                b[i] -= koordinate[v2]
            end
        end
    end
    return b
end

"""
    vloži!(G, fix, točke, omega=1.0)
Poišči vložitev grafa `G` v ravnino ali prostor s fizikalno metodo.
Argument `fix` je seznam fiksnih vozlišč z določenimi koordinatami.
Argument `točke` je matrika koordinat vseh vozlišč. Koordinate
nefiksnih vozlišč so nadomeščene z rešitvijo sistema, dobljeno z metodo SOR.
"""
function vloži!(G::AbstractGraph, fix, točke, omega=1.0)
    sprem = setdiff(vertices(G), fix)
    dim, _ = size(točke)
    A = matrika(G, sprem)
    for k = 1:dim
        b = desne_strani(G, sprem, točke[k, :])
        #A je negativno definitna, -A * x = -b
        x, _ = sor(-A, -b, zeros(length(sprem)), omega) #sor
        točke[k, sprem] = x
    end
end

export RedkaMatrika, size, getindex, setindex!, *, sor, -, krožna_lestev, matrika, desne_strani, vloži!

end # module DN01
