using vaje03

bvo = BVPRect(
    ((0,pi),(0,1)),
    [sin, x->0, sin, x->0], 
    Laplace()
    )

Z, x, y = discretize(bvo, 0.1)

using Plots

wireframe(x, y, Z')