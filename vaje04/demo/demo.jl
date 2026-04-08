using vaje04

A = [2 0; 0 -3]
x, it = power(A, rand(2))

#Demo Markov chain
P = [
    0 1/3 0 1/3 0 1/3;
    0 0 1/2 1/2 0 0;
    0 0 0 1/2 1/2 0;
    1/2 0 0 1/2 0 0;
    0 0 0 0 0 1;
    0 1 0 0 0 0
    ]

P*ones(6)

x, it = power(P', rand(6))
p = x / sum(x) #normalize the eigenvector

k = Knight(3, 4)
P = transition_matrix(k)
x, it = power(P', rand(12))
x = x / sum(x) #normalize
p = reshape(x, 3, 4) #reshape the vector into the board
x - P'*x #its not zero

#use shift to move eigenvalue
x, it = power(P' + I, rand(12))
x - P'x #its zero now
x = x / sum(x) #normalize
p = reshape(x, 3, 4) #reshape the vector into the board

#Use LinearAlgebra.eigen to verify the result
using LinearAlgebra
eigen(P')