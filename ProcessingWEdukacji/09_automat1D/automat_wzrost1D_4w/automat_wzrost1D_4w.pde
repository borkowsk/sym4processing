// Jednowymiarowy, probabilistyczny automat komórkowy 
//  (najprostrza symulacja CA w postaci funkcyjnej) 
////////////////////////////////////////////////////////////////////////////////////////////
float Mutat=0.2; //Poziom mutacji koloru
int WorldSize=500;//Ile chcemy elementów w linii?

int[] World=new int[WorldSize];//Tworzenie tablicy - w Processingu zawsze za pomocą alokacji
                               //Tablica jest obiektem o predefiniowanej klasie
                               // - ma swoje metody ;-) i atrybuty dostepne w notacji kropkowej

void setup()
{
size(500,1000);    //Okno bardziej pionowe niż poziome 
noSmooth();
//for(int i=0;i<World.length;i++) //Zerowanie tablicy - gdyby było potrzebne.
//    World[i]=0;                 //W tej wersji procesingu nie jest 

World[WorldSize/2]=128; //Zarodek automatu
}


int t=0;//Licznik czasu czyli kroków
void draw()
{
  if(t>999) return; //Poza ekranem - nic już nie ma do narysowania 
  
  for(int i=0;i<World.length;i++)//Wizualizacja czyli "rysowanie na ekranie" 
  {                              //lenght to atrybut aktualnej długości tablicy 
    if(World[i]>0) stroke(255,World[i],0);//Zółtawy
    else           stroke(0,0,-World[i]);//Niebieski
    point(i,t);                  //Stan automatu w chwili t w t-tej lini okna
  }
  
  int N=World.length/3; //Najwyżej 1/n komórek zmienia swój stan w kroku czasu
  for(int j=0;j<N;j++)//Zmiana stanu automatu
  {
       int i=int(random(World.length));//Funkcja random() produkuje float, więc trzeba zmienić
                                       // typ wyniku czyli obciąć część ułamkową
       if( World[i]==0 )
       {
          //Reguła - jeśli masz żywego sąsiada stajesz się żywy
          //Co zrobić z "brzegami świata"? 
          int right = (i+1) % WorldSize;//Można zrobić liczenie indeksów sąsiadów       
          int left  = (WorldSize+i-1) % WorldSize;//z zawijaniem dzięki reszcie z dzielenia
          World[i]=( random(2)<1 ? World[right] : World[left] ); //Jak wylosuje 0 to się nic nie zmienia 
          if(  World[i]>0 && random(1.0) < Mutat ) //Jak już jest żywy to może zmutować
               World[i]+=int(random(21))-10;//Symetrycznie
       }
   }
   
   t++;//Kolejne pokolenie/krok/rok
}
