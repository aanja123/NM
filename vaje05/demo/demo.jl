using vaje05
using LinearAlgebra

A=[-2 0; 0 3]
F = lu(A)
solve(b) = F\b
v, l = inviter(solve, rand(2))

F_3 = lu(A-3.01I)
v, l = inviter(b -> F_3\b, rand(2))
l + 3.01

# find the smallest k eigenvalues of a symetric matrix
A = rand(100, 100)
A = A + A' #symetric matrix
F = lu(A)
X, L = inviterqr(b -> F\b, rand(100, 10); maxit=10000, rtol=1e-3)
(A * X)'*X
