# _City Of Plague_

## "ABM model of plague on in the organized spatial environment" 
   - agentowy model przebiegu epidemii w przestrzeni zorganizowanej.

W repozytorium znajduje się demonstracyjny prototyp agentowego modelu epidemii 
w mieście jako przestrzeni podzielonej na trzy kategorie obszarów, w których ci 
sami agenci wchodzą ze sobą w kontakty w różnych konfiguracjach.

Program powstał na początku epidemii __COVID19__, i prace rozwojowe zostały 
porzucone, gdy okazało się, że podobnych modeli powstało w tym czasie wiele.
Stanowi jednak dobry przykład kompletnej, acz niezbyt skomplikowanej aplikacji 
symulacyjnej.

Językiem podstawowym jest __Processing__ w wersji 3.x, jednak kod był pisany z 
myślą o automatycznej translacji na język __C++__ za pomoca narzędzia 
__Processing2C++__.

### Podstawowe założenia

1) Główna idea modelu polega na tym, że agenci zarażają się faktycznie przez kontakt 
   w różnych przestrzeniach, w których zdarza im się przebywać. 
   Taka przestrzeń jest inna dla snu i odpoczynku (miejsce zamieszkania w dzielnicy
   mieszkaniowej), inna dla pracy (miejsce pracy), a możliwe są też zdarzenia w 
   przestrzeni specjalnej - np. demonstracje (na głównej ulicy).
2) Zarówno gospodarze jak i wirusy (a właściwie ich szczepy), są agentami z 
   teoretyczną możliwością mutacji.
3) Jeden gospodarz w danej chwili może być żywicielem jednego szczepu wirusa.
4) Miasto podzielone jest fraktalnie siecią ulic i alei o różnej szerokości.

### Dostęp do repozytorium 

Właściwy adres repozytorium to: https://github.com/borkowsk/CityOfPlague-model

Dostęp read-only za pomoca protokołu _https_

```
git clone https://github.com/borkowsk/CityOfPlague-model.git
cd CityOfPlague-model.git
./_check.sh
cd src/cityOfplague/
```

Dostęp z możliwością modyfikacji można uzyskać za pomocą protokołu _ssh_ , 
otrzymując uprzednio odpowiednie prawa od autora projektu.

```
git clone git@github.com:borkowsk/CityOfPlague-model.git
cd CityOfPlague-model.git
./_check.sh
cd src/cityOfplague/
```

UWAGA! Nazwa katalogu z plikami _*.pde_ musi być domyślna czyli taka sama jak 
nazwa głównego pliku źródłowego aplikacji. To jest wymaganie __Processing__u:

**src/cityOfplague/cityOfplague.pde**


## FINANSOWANIE

This project is sponsored by __Centre For Systemic Risk Analisis__. 

* EN: https://cbrs.uw.edu.pl/en/home-page/
* PL: https://cbrs.uw.edu.pl/

## Autorzy (z __ISS UW__)

* Wojciech Tomasz Borkowski - programowanie
* Andrzej Krzysztof Nowak - cześć koncepcji

## Powiązania

* _"Compartmental models in epidemiology"_: https://www.wikiwand.com/en/Compartmental_models_in_epidemiology
* _"The SIR model of an epidemic"_ (April 2021): https://www.researchgate.net/publication/351105280_The_SIR_model_of_an_epidemic
* _"Komórkowy model epidemii"_ : https://github.com/borkowsk/bookProcessingPL/tree/master/15_epidemia
  




