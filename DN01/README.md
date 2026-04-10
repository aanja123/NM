# DN01 - Numerična matematika

**Avtor:** Anja Abramovič

## Opis naloge
Implementacija redke matrike `RedkaMatrika` in reševanje sistema linearnih enačb z metodo SOR. Metodo uporabimo za vložitev grafov v ravnino s fizikalno metodo.

## Uporaba
```julia
using DN01

# Ustvari redko matriko
A = RedkaMatrika(3)
A[1, 1] = 4.0
A[1, 2] = 1.0

# Reši sistem Ax = b z metodo SOR
x, it = sor(A, b, zeros(3), 1.2)

# Vložitev grafa v ravnino
G = krožna_lestev(8)
vloži!(G, fix, točke)
```


## Testi
Teste poženemo v paketnem načinu v Juliji. Najprej aktiviramo okolje v mapi `DN01`:

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
Demo prikaže vložitev krožne lestve in pravokotne mreže v ravnino ter odvisnost hitrosti konvergence SOR od parametra ω.

## Poročilo
Poročilo se nahaja v datoteki `porocilo.pdf`.