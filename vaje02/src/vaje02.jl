module vaje02
"""
    T = TridiagonalMatrix(ld, d, ud)
    Create a tridiagonal matrix with lower diagonal `ld`, diagonal `d` and upper diagonal `ud`.

    #Example
    ```julia
    T = TridiagonalMatrix([1, 2, 3], [4, 5, 6], [7, 8, 9])
    ```
"""
struct TridiagonalMatrix
    ld #lower diagonal
    d #diagonal
    ud #upper diagonal
end

import Base: getindex, setindex!, *,size, \, copy


function copy(T::TridiagonalMatrix)
    return TridiagonalMatrix(copy(T.ld), copy(T.d), copy(T.ud))
end

function setindex!(T::TridiagonalMatrix, v, i, j)
    if i == j
        T.d[i] = v
    elseif i == j + 1
        T.ld[j] = v
    elseif i + 1 == j
        T.ud[i] = v
    else
        throw(ErrorException("Cannot set value at position ($i, $j)"))
    end
end

function getindex(T::TridiagonalMatrix, i::Int, j::Int)
    if i == j
        return T.d[i]
    elseif i == j + 1
        return T.ld[j]
    elseif i + 1 == j
        return T.ud[i]
    else
        return 0
    end
end

function size(T::TridiagonalMatrix)
    n = length(T.d)
    return (n, n)
end

function *(T::TridiagonalMatrix, x::Vector)
    y = copy(x)
    n,m = size(T)
    y[1] = T[1, 1]*x[1] + T[1, 2]*x[2]
    for i in 2:n-1
        y[i] = T[i, i-1]*x[i-1] + T[i, i]*x[i] + T[i, i+1]*x[i+1]
    end
    y[n] = T[n, n-1]*x[n-1] + T[n, n]*x[n]
    return y
end

function \(T::TridiagonalMatrix, b::Vector)
    b = copy(b)
    T = copy(T)
    #eliminate
    n, _m = size(T)
    for k in 2:n
        l = T[k, k-1] / T[k-1, k-1]
        #T[k, k-1] = 0 dont bother to set it to zero, we will not use it anymore
        T[k,k] -=  l*T[k-1, k]
        b[k] -= l * b[k-1]
    end
    #back substitution
    x = copy(b)
    x[n] = b[n] / T[n, n]
    for k in n-1:-1:1
        x[k] = (b[k] - T[k, k+1]*x[k+1]) / T[k, k]
    end
    return x
end

export TridiagonalMatrix
end # module vaje02
