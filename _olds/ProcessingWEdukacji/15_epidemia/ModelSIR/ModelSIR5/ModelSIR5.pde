// Dwuwymiarowy, probalilistyczny (kroki MC) automat komórkowy - reguła SIR
// Zasiewanie tablicy na początku z zadaną gęstością zdrowych oraz pojedynczą komórką zarażona
// LICZBA INTERAKCJI 4, ale prawdopodobieństwo zarażenia nie równe 1 tylko PTransfer 
// CHOROBA trwa u zarażonego Duration kroków chyba ze umrze (PDeath)
// ZBIERAMY STATYSTYKI SUMARYCZNE Z CAŁEJ EPIDEMI: int sumInfected,sumRecovered,sumDeath;
////////////////////////////////////////////////////////////////////////////////////////////////

int WorldSize=400;//Ile chcemy elementów w linii i ile linii (tablica kwadratowa)

int[][] World=new int[WorldSize][WorldSize];//Tworzenie tablicy świata - w Processingu zawsze za pomocą alokacji

float IDens=0.66; //Początkowa gęstość w tablicy - jaka jest gęstość progowa,
                  //przy której epidemia zaatakuje ZAWSZE cały świat? (o ile już się zacznie)
                  //Choć mogą być małe rejony które ominęła

//Coś w rodzaju stałych ;-)
final int Duration=7;//Czas trwania infekcji!
final int Empty=0; 
final int Susceptible=1;
final int Infected=2;
final int Recovered=Infected+Duration;
final float PTransfer=0.75;   //Prawdopodobieństwo zarażenia agenta w pojedynczej interakcji
final float PDeath=0.01;      //Średnie prawdopodobieństwo śmierci w danym dniu choroby

//STATYSTYKI LICZONE W TRAKCIE SYMULACJI
int sumInfected=0;//Zachorowanie
int sumRecovered=0;//Wyzdrowienia
int sumDeath=0;//Ci co umarli

void setup()
{ 
 size(400,400);    //Okno kwadratowe
 noSmooth();       //Znacząco przyśpiesza wizualizacje
 
 if(IDens>0)
  {
   for(int i=0;i<World.length;i++) //Zasiewanie tablicy
    for(int j=0;j<World.length;j++) 
      if(random(1.0)<IDens)
        World[i][j]=Susceptible;
      else
        World[i][j]=Empty;//Dla pewności, gdyby Empty nie było zero.
  }
 
 World[WorldSize/2][WorldSize/2]=Infected;
  
 frameRate(100);
}

int t=0;

void draw()
{  
  for(int i=0;i<World.length;i++)//Wizualizacja czyli "rysowanie na ekranie" 
    for(int j=0;j<World.length;j++) 
    {
      switch(World[i][j]){ //Instrukcja wyboru pozwala nam wybrać dowolny kolor
      case Recovered:  stroke(0,255,0);break;//Wyleczony
      case Infected:   stroke(255,0,0);break;//Zachorował
      case Susceptible:stroke(0,0,255);break;//Podatny
      case Empty:      stroke(0,0,0);break;//Pusty
      default:         stroke(random(255),0,random(255));//Chory
      break;
      } 
      point(i,j);
    }
  
  //Zmiana stanu automatu - krok Monte Carlo
  //STANY: Empty=0; Susceptible=1; Infected=2; Recovered=Infected+Duration;
  for(int a=0;a<World.length*World.length;a++)//Tyle losowań ile komórek
  {
       //Losowanie agenta 
       int i=(int)random(World.length);
       int j=(int)random(World.length);
       
       //Jesli pusty lub zdrowy to nic nie robimy
       if(World[i][j]<Infected || Recovered<=World[i][j]) continue;
       
       //Wyliczenie lokalizacji sąsiadów
       int right = (i+1) % WorldSize;      
       int left  = (WorldSize+i-1) % WorldSize;
       int dw=(j+1) % WorldSize;   
       int up=(WorldSize+j-1) % WorldSize;
       
       //PTransfer - Prawdopodobieństwo zarażenia agenta w pojedynczej interakcji
       //PRecovery - Prawdopodobieństwo wyzdrowienia w danym dniu
       //PDeath    - Prawdopodobieństwo śmierci w danym dniu choroby
       //PDeath + PRecovery < 1  !!!

       if(World[left] [j]==Susceptible && random(1) < PTransfer) 
        {World[left][j]=Infected; sumInfected++;}
       if(World[right][j]==Susceptible && random(1) < PTransfer) 
        {World[right][j]=Infected; sumInfected++;}
       if(World[i][up]==Susceptible && random(1) < PTransfer) 
        {World[i][up]=Infected; sumInfected++;}
       if(World[i][dw]==Susceptible && random(1) < PTransfer) 
        {World[i][dw]=Infected; sumInfected++;}

       float prob=random(1);//Los na dany dzień
       
       if(prob<PDeath) //Albo tego dnia umiera
        {World[i][j]=Empty;sumDeath++;}
        else
        {
          //Albo jest wyleczony
          if(++World[i][j]==Recovered)
              sumRecovered++;
          //else //NADAL CIERPI!
        }
   }
      
   t++;//Kolejne pokolenie/krok/rok
   text("ST:"+t+" Zachorowali:"+sumInfected+" Wyzdrowieli:"+sumRecovered+" Umarli:"+sumDeath
         ,0,10);
   println("ST:"+t+"\tZ\t"+sumInfected+"\tW\t"+sumRecovered+"\tU\t"+sumDeath);
}

//////////////////////////////////////////////////////////////////////////////////
// Autor: Wojciech T. Borkowski
// Materiały do podręcznika "Processing w edukacji i symulacji
// https://github.com/borkowsk/sym4processing/tree/master/ProcessingWEdukacji
//////////////////////////////////////////////////////////////////////////////////
