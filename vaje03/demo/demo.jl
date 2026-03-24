using vaje03

bvo = BVPRect(
    ((0,pi),(0,1)),
    [sin, x->0, sin, x->0], 
    Laplace()
    )

Z, x, y = discretize(bvo, 0.1)

using Plots

wireframe(x, y, Z')

#preveri, kako izgleda matrika

Z = [1 2 3 4 5;
    5 0 0 0 6;
    7 0 0 0 8;
    7 8 9 10 11]

A, B = vaje03.matrix_rhs(Laplace(), Z)

index = vaje03.index_map(5)

(index(2,2), index(2,3), index(3,2), index(3,3), index(3,4))

Zres, x, y = solve(bvo, DivideDiffMethod(0.1))

wireframe(x, y, Zres')

Zres, x, y = solve(bvo, IteracijkaMetoda(0.1,200))

wireframe(x, y, Zres')