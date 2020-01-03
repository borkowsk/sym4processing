// Jednowymiarowy, probabilistyczny automat komórkowy 
//  (najprostrza symulacja CA w postaci funkcyjnej) 
////////////////////////////////////////////////////////////////////////////////////////////
int WorldSize=500;//Ile chcemy elementów w linii?

int[] World=new int[WorldSize];//Tworzenie tablicy - w Processingu zawsze za pomocą alokacji
                               //Tablica jest obiektem o predefiniowanej klasie
                               // - ma swoje metody ;-) i atrybuty dostepne w notacji kropkowej

void setup()
{
size(500,1000);    //Okno bardziej pionowe niż poziome 

//for(int i=0;i<World.length;i++) //Zerowanie tablicy - gdyby było potrzebne.
//    World[i]=0;                 //W tej wersji procesingu nie jest 

World[WorldSize/2]=1; //Zarodek automatu
}


int t=0;//Licznik czasu czyli kroków
void draw()
{
  if(t>999) return; //Poza ekranem - nic już nie ma do narysowania 
  
  for(int i=0;i<World.length;i++)//Wizualizacja czyli "rysowanie na ekranie" 
  {                              //lenght to atrybut aktualnej długości tablicy 
    if(World[i]>0) stroke(255,255,0);//Zółty
    else           stroke(0,0,255);//Niebieski
    point(i,t);                  //Stan automatu w chwili t w t-tej lini okna
  }
  
  int N=World.length/4; //Najwyżej 1/4 komórek zmienia swój stan w kroku czasu
  for(int j=0;j<N;j++)//Zmiana stanu automatu
  {
       int i=int(random(World.length));//Funkcja random() produkuje float, więc trzeba zmienić
                                       // typ wyniku czyli obciąć część ułamkową
       
       //Reguła - jeśli masz żywego sąsiada stajesz się żywy
       //Co zrobić z "brzegami świata"? 
       int right = (i+1) % WorldSize;//Można zrobić liczenie indeksów sąsiadów       
       int left  = (WorldSize+i-1) % WorldSize;//z zawijaniem dzięki reszcie z dzielenia
      
       if(World[left]>0) //Sąsiad nie jest zerem czyli jest "żywy"
       World[i]=1;       //To zmieniana komórka też jest żywa
       
       if(World[right]>0) //Prawy sąsiad nie jest zerem czyli jest "żywy"
       World[i]=1;
   }
   
   t++;//Kolejne pokolenie/krok/rok
}