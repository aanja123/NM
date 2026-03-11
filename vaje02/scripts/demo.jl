#Random walk simulation
"""
x = random_walk(n, p)
Simulate n step random walk with transition probabilities p.
"""
function random_walk(n,p)
    x = zeros(n+1)
    for i in 1:n
        x[i+1] = x[i] + ((rand()<p ? 1 : -1))
    end
    return x
end


using Plots
using vaje02

x = random_walk(10, 0.5)
scatter(x)

"""
N = inv_fund_matrix(N,p)
Calculate the inverse of the fundamental matrix for a random walk with N states and transition probabilities p.
"""
function inv_fund_matrix(n,p)
    d = ones(2*n-1)
    ld = ones(2*n-2)*(p-1)
    ud = ones(2*n-2)*(-p)
    return TridiagonalMatrix(ld, d, ud)
end

"""
    expected_num_steps(n, p)
Calculate the expected number of steps for a random walk with N states and transition probabilities p to reach
"""
function expected_num_steps(n, p)
    T = inv_fund_matrix(n, p)
    return T\ones(2*n-1)
end

e_steps = expected_num_steps(200, 0.5)
scatter(-199:199,e_steps)

A=zeros(50000,50000)
T = inv_fund_matrix(10000000, 0.5)
