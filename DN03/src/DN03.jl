module DN03

const a21 = 1/5
const a31, a32 = 3/40, 9/40
const a41, a42, a43 = 44/45, -56/15, 32/9
const a51, a52, a53, a54 = 19372/6561, -25360/2187, 64448/6561, -212/729
const a61, a62, a63, a64, a65 = 9017/3168, -355/33, 46732/5247, 49/176, -5103/18656

# uteži za rešitev reda 5
const b1, b3, b4, b5, b6 = 35/384, 500/1113, 125/192, -2187/6784, 11/84

# uteži za oceno napake (razlika med redom 4 in 5)
const e1, e3, e4, e5, e6, e7 = 71/57600, -71/16695, 71/1920, -17253/339200, 22/525, -1/40

"""
    dopri5(f, t0, y0, t_end, atol=1e-10, rtol=1e-10)
Reši sistem diferencialnih enačb y' = f(t, y) z metodo DOPRI5.
Vrne vektorja časov `ts` in stanj `ys`.
"""
function dopri5(f, t0, y0, t_end, atol=1e-10, rtol=1e-10)
    t = t0
    y = copy(y0)
    h = (t_end - t0) / 100  # začetni korak
    ts = [t]
    ys = [copy(y)]

    while t < t_end
        # prilagodimo zadnji korak
        if t + h > t_end
            h = t_end - t
        end

        # 7 vmesnih vrednosti
        k1 = f(t, y)
        k2 = f(t + h/5, y + h*a21*k1)
        k3 = f(t + 3h/10, y + h*(a31*k1 + a32*k2))
        k4 = f(t + 4h/5, y + h*(a41*k1 + a42*k2 + a43*k3))
        k5 = f(t + 8h/9, y + h*(a51*k1 + a52*k2 + a53*k3 + a54*k4))
        k6 = f(t + h, y + h*(a61*k1 + a62*k2 + a63*k3 + a64*k4 + a65*k5))

        # rešitev reda 5
        y_new = y + h*(b1*k1 + b3*k3 + b4*k4 + b5*k5 + b6*k6)

        k7 = f(t + h, y_new)

        # ocena napake
        err = h*(e1*k1 + e3*k3 + e4*k4 + e5*k5 + e6*k6 + e7*k7)
        err_norm = sqrt(sum((err ./ (atol .+ rtol .* abs.(y_new))).^2) / length(y))

        if err_norm <= 1.0
            # korak sprejet
            t = t + h
            y = y_new
            push!(ts, t)
            push!(ys, copy(y))
        end

        # prilagodimo korak
        h = h * min(5.0, max(0.2, 0.9 / err_norm^0.2))
    end

    return ts, ys
end

"""
    nihalo(t, theta0, omega0, g=9.81, l=1.0, atol=1e-10, rtol=1e-10)
Izračuna odmik matematičnega nihala ob času `t`.
`theta0` je začetni odmik, `omega0` začetna kotna hitrost,
`g` težni pospešek in `l` dolžina nihala.
"""
function nihalo(t, theta0, omega0, g=9.81, l=1.0)
    # sistem prvega reda: [theta, omega]' = [omega, -g/l * sin(theta)]
    f(t, y) = [y[2], -(g/l) * sin(y[1])]
    ts, ys = dopri5(f, 0.0, [theta0, omega0], t)
    return ys[end][1]  # vrnemo theta(t)
end

"""
    nihalo_harmonicno(t, theta0, omega0, g=9.81, l=1.0)
Izračuna odmik harmoničnega nihala ob času `t` z analitično rešitvijo.
"""
function nihalo_harmonicno(t, theta0, omega0, g=9.81, l=1.0)
    omega = sqrt(g/l)
    return theta0 * cos(omega * t) + (omega0/omega) * sin(omega * t)
end

"""
    nihajni_cas(theta0, g=9.81, l=1.0)
Izračuna nihajni čas matematičnega nihala z bisekcijo.
`theta0` je začetni odmik,
"""
function nihajni_cas(theta0, g=9.81, l=1.0)
    omega0 = 0.0
    f(t, y) = [y[2], -(g/l) * sin(y[1])]
    # ocena periode - malce vec kot harmonicno nihalo
    T_harm = 2π * sqrt(l/g)
    # resimo do malo cez eno periodo
    ts, ys = dopri5(f, 0.0, [theta0, omega0], 2*T_harm)
    thetas = [y[1] for y in ys]
    # iscemo cas ko se theta vrne blizu zacetne vrednosti (en poln obhod)
    for i in eachindex(thetas)[2:end]
        if thetas[i-1] * thetas[i] < 0 && ts[i] > T_harm/4
            # bisekcija za natancen prehod skozi 0
            ta, tb = ts[i-1], ts[i]
            for _ in 1:50
                tc = (ta + tb) / 2
                if nihalo(tc, theta0, omega0, g, l) * nihalo(ta, theta0, omega0, g, l) < 0
                    tb = tc
                else
                    ta = tc
                end
            end
            return 4 * (ta + tb) / 2
        end
    end
end

"""
    energija(theta0, omega0=0.0, g=9.81, l=1.0)
Izračuna energijo matematičnega nihala.
"""
function energija(theta0, omega0=0.0, g=9.81, l=1.0)
    return 0.5 * omega0^2 + (g/l) * (1 - cos(theta0))
end

export dopri5, nihalo, nihalo_harmonicno, nihajni_cas, energija

end # module DN03
