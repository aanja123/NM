# DN03 - Numerična matematika

**Avtor:** Anja Abramovič

## Opis naloge
Reševanje diferencialne enačbe matematičnega nihala z metodo DOPRI5 in primerjava
z analitično rešitvijo harmoničnega nihala. Implementirali smo metodo DOPRI5 za
reševanje sistemov diferencialnih enačb ter izračun nihajnega časa in energije nihala.

## Uporaba
```julia
using DN03

# odmik nihala pri t=1s, začetni odmik 0.5 rad, začetna hitrost 0
theta = nihalo(1.0, 0.5, 0.0)

# nihajni čas za začetni odmik 1.0 rad
T = nihajni_cas(1.0)

# energija nihala
E = energija(1.0)
```

## Testi
Teste poženemo v paketnem načinu v Juliji. Najprej aktiviramo okolje v mapi `DN03`:
activate .
test

## Demo
Demo skripto poženemo v Juliji z ukazom:
```julia
include("demo/demo.jl")
```
Demo prikaže primerjavo matematičnega in harmoničnega nihala ter graf odvisnosti
nihajnega časa od energije.

## Poročilo
Poročilo se nahaja v datoteki `porocilo.pdf`.