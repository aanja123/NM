module vaje05
using LinearAlgebra
"""
    v, l = inviter(solve, x0)

    FInd the igenvalue and eigenvector closest to 0 with inverse power method. 
    The matrix is give implicetely with the function x = solve(b) that solves 
    the system of linear equations Ax = b for any given b. 
"""
function inviter(solve, x0; maxit=1000, rtol=1e-8)
    for i = 1:maxit
        x = solve(x0)# x = A^-1 x0
        _,idx = findmax(abs, x)
        l = 1 / x[idx]
        x = l*x #normalize with maximal element
        if norm(x - x0, Inf) < rtol
            @info "The inverse power method converged after $i iterations"
            return x, l
        end
        x0 = x
    end
    throw(ErrorException("inviter did not converge after $maxit iterations"))
end
"""
    V, L = inviterqr(solve, X0)
Find the smallest k eigenvlaues of the amtrix A. The number k 
is determined by dimesnion of the amtrix X0
"""
function inviterqr(solve, X0; maxit=1000, rtol=1e-8)
    for i = 1:maxit
        X = solve(X0)# X = A^-1 X0
        F = qr(X) #orthogonalization of columns in X
        X = Matrix(F.Q)
        if norm(X - X0, Inf) < rtol
            @info "The inverse power method converged after $i iterations"
            return X, 1 ./ diag(F.R)
        end
        X0 = X
    end
    throw(ErrorException("inviter did not converge after $maxit iterations"))
end

export inviter, inviterqr

end # module vaje05
