module DN02

"""
    x(t, a=1.0, b=-11.0/7.0)
Vrne x koordinato hipotrohoide pri parametru `t`.
"""
function x(t, a=1.0, b=-11.0/7.0)
    return (a + b) * cos(t) + b * cos((a + b)/b * t)
end

"""
    y(t, a=1.0, b=-11.0/7.0)
Vrne y koordinato hipotrohoide pri parametru `t`.
"""
function y(t, a=1.0, b=-11.0/7.0)
    return (a + b) * sin(t) + b * sin((a + b)/b * t)
end

"""
    dx(t, a=1.0, b=-11.0/7.0)
Vrne odvod x koordinate hipotrohoide pri parametru `t`.
"""
function dx(t, a=1.0, b=-11.0/7.0)
    return -(a + b) * sin(t) - (a + b) * sin((a + b)/b * t)
end


"""
    dy(t, a=1.0, b=-11.0/7.0)
Vrne odvod y koordinate hipotrohoide pri parametru `t`.
"""
function dy(t, a=1.0, b=-11.0/7.0)
    return (a + b) * cos(t) + (a + b) * cos((a + b)/b * t)
end

"""
    simpson(f, a, b, n=100)
Sestavljeno Simpsonovo pravilo za numerično integracijo funkcije `f` na intervalu `[a, b]`
z `2n` enakomernimi koraki. Vrne približek za integral.
"""
function simpson(f, a, b, n=100)
    h = (b - a) / (2*n)
    result = f(a) + f(b)
    for k in 1:n
        result += 4 * f(a + (2k - 1) * h)
    end
    for j in 1:n-1
        result += 2 * f(a + 2j * h)
    end
    return result * h/3
end


"""
    ploscina(T, a=1.0, b=-11.0/7.0, n=100)
Izračuna ploščino hipotrohoide z parametroma `a` in `b`
s sestavljenim Simpsonovim pravilom z `2n` koraki.
Argument `T` je perioda krivulje.
"""
function ploscina(T, a=1.0, b=-11.0/7.0, n=100)
    f(t) = 0.5 * (x(t, a, b) * dy(t, a, b) - dx(t, a, b) * y(t, a, b))
    return abs(simpson(f, 0.0, T, n))
end

export x, y, dx, dy, simpson, ploscina

end # module DN02
