module vaje04
using LinearAlgebra

"""
    x, it = power(A, x0)
Calculates the eigenvector x for the greatest eigenvalue of the matrix A using the power iteration method. 
The initial guess is given by x0. The function returns the eigenvector x and the number of iterations it taken to converge.
"""
function power(A, x0; maxit=1000, rtol=1e-8)
    for i=1:maxit
        AAx0 = A * (A * x0)
        x=AAx0 / norm(AAx0, Inf)
        if isapprox(x, x0, rtol=rtol)
            return x, i
        end
        x0=x
    end
    throw(ErrorException("Power iteration did not converge within $maxit iterations"))
end

"""
Markov chain of knight jumping ....
"""
struct Knight
    m
    n
end

function transition_matrix(k::Knight)
    N = k.m * k.n
    P = zeros(N, N)
    indeks(i,j) = i + (j-1)*k.m
    for i=1:k.m, j=1:k.n
        row = indeks(i,j)
        for jump in [(-2, 1), (-2, -1), (-1, 2), (-1, -2), (1, 2), (1, -2), (2, 1), (2, -1)]
            ii = i + jump[1]
            jj = j + jump[2]
            #if the jump is insode th board
            if ii >= 1 && ii <= k.m && jj >= 1 && jj <= k.n
                column = indeks(ii, jj)
                P[row, column] = 1
            end
        end
        P[row, :] = P[row, :] / sum(P[row, :]) #normalize the row
    end
    return P
end

export power, transition_matrix, Knight

end # module vaje04
