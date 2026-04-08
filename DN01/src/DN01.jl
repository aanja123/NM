module DN01

greet() = print("Hello World!")

struct RedkaMatrika
    V::Vector{Vector{Float64}}  #nonzero values per row
    I::Vector{Vector{Int}}      #column indixes per row
    n::Int                      #matrix size (n x n)
end

#create an empty n x n sparse matrix
function RedkaMatrika(n::Int)
    V = [Vector{Float64}() for _ in 1:n]
    I = [Vector{Int}() for _ in 1:n]
    return RedkaMatrika(V, I, n)
end

#size
Base.size(A::RedkaMatrika) = (A.n, A.n) #2D size
Base.size(A::RedkaMatrika, d::Int) = A.n #1D size

#getindex: A[i, j]
function Base.getindex(A::RedkaMatrika, i::Int, j::Int)
    for k in 1:length(A.I[i])
        if A.I[i][k] == j
            return A.V[i][k]
        end
    end
    return 0.0
end

#setindex!: A[i, j] = v
function Base.setindex!(A::RedkaMatrika, v::Float64, i::Int, j::Int)
    for k in 1:length(A.I[i])
        if A.I[i][k] == j
            A.V[i][k] = v
            return
        end
    end
    #not found, add new value (zero)
    push!(A.I[i], j)
    push!(A.V[i], v)
end

#multiplication A * x
function Base.:*(A::RedkaMatrika, x::Vector{Float64})
    n = A.n
    result = zeros(Float64, n)
    for i in 1:n
        for k in 1:length(A.I[i])
            j = A.I[i][k]
            result[i] += A.V[i][k] * x[j]
        end
    end
    return result
end

end # module DN01
