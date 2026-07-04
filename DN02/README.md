# DN02 - Numerična matematika

**Avtor:** Anja Abramovič

## Opis naloge
Izračun ploščine območja, ki ga omejuje hipotrohoida podana parametrično z enačbama:

$$x(t) = (a+b)\cos(t) + b\cos\left(\frac{a+b}{b}t\right)$$
$$y(t) = (a+b)\sin(t) + b\sin\left(\frac{a+b}{b}t\right)$$

za parametra `a = 1` in `b = -11/7`. Ploščino izračunamo z iskanjem zunanjih samopresečišč krivulje in numerično integracijo s sestavljenim Simpsonovim pravilom med sosednjimi presečišči.

## Uporaba
```julia
using DN02

# izračun ploščine hipotrohoide z a=1, b=-11/7
P = ploscina()
println("Ploščina: $P")

# koordinate točke na krivulji
x(1.0)
y(1.0)
```

## Testi
Teste poženemo v paketnem načinu v Juliji. Najprej aktiviramo okolje v mapi `DN02`:

```
activate .
test
```

## Demo
Demo skripto poženemo v Juliji z ukazom (ali uporabimo shift enter kar v `demo\demo.jl` ):

```
activate .
include("demo\demo.jl")
```
Demo prikaže hipotrohoido, zunanja samopresečišča in izpiše izračunano ploščino.

## Poročilo
Poročilo se nahaja v datoteki `porocilo.pdf`.