"""
    y = koren(x)
    Izračunaj kvadratni koren števila 'x'
"""
function koren(x)
    y0=x
    for i=1:100
        y = (y0 + x/y0) /2
        if(isapprox(y,y0; rtol= 1e-10))
            @info "Newtonova iteracija Konvergira v $i korakih"
            return y
        end
        y0=y
    end
    throw("Metoda ne konvergira")
end

using Pkg;
Pkg.add("Plots");
using Plots

plot(sqrt, 0, 10, label="koren")
plot!(x -> x, 0, 10, label="začetni približek")