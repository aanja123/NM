using vaje06
#v pkg samo add ...
using LinearAlgebra
using ForwardDiff

F(x) = [x[1]^3 - 3*x[1]*x[2]^2 - 1; 3*x[1]^2*x[2] - x[2]^3]

JF(x) = [3*x[1]^2 - 3*x[2]^2  -6*x[1]*x[2];
         6*x[1]*x[2]  3*x[1]^2 - 3*x[2]^2]
x0 = [0.5; 0.5]
x, it = newton(F, JF, x0)


box = Box2d(Interval(-2, 2), Interval(-2, 2))
method(x) = newton(F, JF, x; maxit=20, atol=1e-3)

x, y, Z, ničle, koraki = konvergenca(box, method, 200, 200; atol=1e-2)

using Plots
heatmap(x, y, Z)
scatter!(Tuple.(ničle))
print(ničle)
#use automatic differation for Jacobian
jf(x) = ForwardDiff.jacobian(F, x)
jf([1, 1])