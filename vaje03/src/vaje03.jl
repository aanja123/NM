module vaje03

"""
    bvp = BVPRect(rect, bc, op)

Create data for Boundary value problem on rectangle `rect=((a,b),(c,d))` with boundary conditions `bc=[fb, fr, ft, fl] f(x,c)=fb(x), f(b,y)=fr(y), f(x,d)=ft(x), f(a,y)=fl(y)` and operator `op`.
"""
struct BVPRect
    rect # rectangle
    bc   # boundary conditions
    op   # differential operator
end

"""
Abstract type that represent Laplace differential operator.
"""
struct Laplace end


"""
    Z, x, y = discretize(bvp::BVPRect, h::float64)

Construct a matrix of values Z and vectors of points x and y that are aproxemately h distance appart.
"""
function discretize(bvp::BVPRect, h)
    ((a,b),(c,d)) = bvp.rect
    #calculate the number of points in x
    n = Int(round((b-a)/h))
    #calculate the number of points in y
    m = Int(round((d-c)/h))
    x = range(a, b, length=n+1)
    y = range(c, d, length=m+1)
    Z = zeros(n+1, m+1)
    #fill the boundary conditions into Z
    (fb, fr, ft, fl) = bvp.bc
    Z[1,:] = fl.(y)
    Z[n+1,:] = fr.(y)
    Z[:,1] = fb.(x)
    Z[:,m+1] = ft.(x)
    return Z, x, y

end

struct DivideDiffMethod
    h
end

function matrix_rhs(op::Laplace, Z)
    n,m = size(Z) #n+1 and m+1
    N=(n-2)*(m-2)
    index(i,j) = index_map(n,m)(i,j) 
    A = zeros(N,N)
    b = zeros(N)
    for i = 2:n-1, j = 2:m-1
        #calculate index of the row
        k = index(i,j)
        # Z[i+1,j] + Z[i-1,j] + Z[i,j+1] + Z[i,j-1] - 4*Z[i,j] = 0
        A[k,k] = -4
        for delta_i in (-1,1), delta_j in (-1,1)
            ii = i + delta_i
            jj = j + delta_j
            if (ii < 2 ) || (ii > n-1) || (jj < 2) || (jj > m-1)
                b[k] -= Z[ii,jj]
            else
                l = index(ii,jj)
                A[k,l] = 1
            end
end

index_map(n,m) = (i,j) -> (i-1)+(j-2)*(n-1)
index_map_inv(n,m) = k -> (k%(n-2)+1, k÷(n-2)+1)

function solve(bvp::BVPRect, m::DivideDiffMethod)
    h = m.h
    Z, x, y = discretize(bvp, h)
    #create a matrix and RHS of the systme
    A,b = matrix_rhs(bvp.op, Z)
    u = A\b
    #reshape u to z
    Z[2:end-1, 2:end-1] = reshape(u, n-1, m-1)
    return Z, x, y

end

export BVPRect, Laplace, discretize, solve, DivideDiffMethod

end # module vaje03
