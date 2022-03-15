// Dwuwymiarowy, probalilistyczny (kroki MC) automat komórkowy - reguła SIR
// Zasiewanie tablicy na początku z zadaną gęstością zdrowych oraz pojedynczą komórką zarażona
// LICZBA INTERAKCJI 4, ale prawdopodobieństwo zarażenia nie równe 1 tylko PTransfer 
// CHOROBA trwa u zarażonego w zależności od PRecovery lub PDeath
// ZBIERAMY STATYSTYKI: int kranken,geheilt,starben;
////////////////////////////////////////////////////////////////////////////////////////////////

int WorldSize=400;//Ile chcemy elementów w linii i ile linii (tablica kwadratowa)

int[][] World=new int[WorldSize][WorldSize];//Tworzenie tablicy świata - w Processingu zawsze za pomocą alokacji

float IDens=0.66; //Początkowa gęstość w tablicy - jaka jest gęstość progowa,
                  //przy której epidemia zaatakuje ZAWSZE cały świat? (o ile już się zacznie)
                  //Choć mogą być małe rejony które ominęła

//Coś w rodzaju stałych ;-)
final int Empty=0; 
final int Susceptible=1;
final int Infected=2;
final int Recovered=3;
final float PTransfer=0.50;   //Prawdopodobieństwo zarażenia agenta w pojedynczej interakcji
final float PRecovery=0.10;   //Średnie prawdopodobieństwo wyzdrowienia w danym dniu
final float PDeath=0.03;      //Średnie prawdopodobieństwo śmierci w danym dniu choroby
                              //PDeath + PRecovery < 1  !!!

//STATYSTYKI LICZONE W TRAKCIE SYMULACJI
int kranken=0;//Zachorowanie
int geheilt=0;//Wyzdrowienia
int starben=0;//Ci co umarli

void setup()
{
 assert PDeath + PRecovery < 1 : "Za duże prawdopodobieństwa PDeath + PRecovery";//Asercja - sprawdzenie założeń
 
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
      switch(World[i][j]){ //Instrukcja wyboru pozwala nam wybrać dowolny kolor w zależności od liczby w konmórce
      case 3:stroke(0,255,0);break;
      case 2:stroke(255,0,0);break;
      case 1:stroke(0,0,255);break;
      case 0:stroke(0,0,0);break;
      default: stroke(255);//To się pojawiac nie powinno
      break;
      } 
      point(i,j);
    }
  
  kranken=0;geheilt=0;starben=0;//Zerowanie dla kroku. Jak wykomentowane to zbieramy statystykę całej epidemii
  //Zmiana stanu automatu - krok Monte Carlo
  //STANY: Empty=0; Susceptible=1; Infected=2; Recovered=3;
  for(int a=0;a<World.length*World.length;a++)//Tyle losowań ile komórek
  {
       //Losowanie agenta 
       int i=(int)random(World.length);
       int j=(int)random(World.length);
       
       //Jesli pusty lub zdrowy zdrowy to nic nie robi
       if(World[i][j]!=Infected) continue;
       
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
        {World[left][j]=Infected; kranken++;}
       if(World[right][j]==Susceptible && random(1) < PTransfer) 
        {World[right][j]=Infected; kranken++;}
       if(World[i][up]==Susceptible && random(1) < PTransfer) 
        {World[i][up]=Infected; kranken++;}
       if(World[i][dw]==Susceptible && random(1) < PTransfer) 
        {World[i][dw]=Infected; kranken++;}

       float prob=random(1);//Los na dany dzień
       
       if(prob<PDeath) //Albo tego dnia umiera
        {World[i][j]=Empty;starben++;}
       else if(prob<PRecovery+PDeath)//Albo jest wyleczony
             {World[i][j]=Recovered;geheilt++;}
            //else //NADAL CIERPI!
   }//Koniec petli po wylosowanych agentach
      
   t++;//Kolejne pokolenie/krok/rok
   text("ST:"+t+" Zachorowali:"+kranken+" Wyzdrowieli:"+geheilt+" Umarli:"+starben,0,10);
   println("ST:"+t+"\tZ\t"+kranken+"\tW\t"+geheilt+"\tU\t"+starben);
}

//////////////////////////////////////////////////////////////////////////////////
// Autor: Wojciech T. Borkowski
// Materiały do podręcznika "Processing w edukacji i symulacji
// https://github.com/borkowsk/sym4processing/tree/master/ProcessingWEdukacji
//////////////////////////////////////////////////////////////////////////////////
