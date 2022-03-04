//Jednowymiarowy, probabilistyczny automat komórkowy - szkielet i najprostrza symulacja w postaci "bez funkcyjnej" 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Tu jest już "przyzwoite" losowanie Monte-Carlo 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int WorldSize=500;//Ile chcemy elementów w linii?
size(500,1000);    //Okno bardziej pionowe niż poziome 

int[] World=new int[WorldSize];//Tworzenie tablicy - w Processingu zawsze za pomocą alokacji

//for(int i=0;i<World.length;i++) //Zerowanie tablicy - gdyby było potrzebne. Wydruk tablicy pokaże czy jest
//    World[i]=0;

World[WorldSize/2]=1; //Zarodek 

println("table:");
for(int i=0;i<World.length;i++) //Wypisywanie tablicy na konsole
    print(World[i],' ');
    
for(int t=0;t<1000;t++)//Ile pokoleń?
{
  for(int i=0;i<World.length;i++)//Wizualizacja czyli "rysowanie na ekranie" 
  {
    if(World[i]>0) stroke(255);
    else           stroke(0);
    point(i,t);
  }
  
  int N=World.length/4; //Tylko 1/4 komórek zmienia swój stan
  for(int j=0;j<N;j++)//Zmiana stanu automatu
  {
       int i=int(random(World.length));//Funkcja random() produkuje float, więc trzeba zmienić typ wyniku (i obciąć część ułamkową) 
       
       //Reguła - jeśli masz żywego sąsiada stajesz się żywy
       int left=i-1; //Indeksy sąsiadów
       int right=i+1;
      
       if(left>=0   //Jeśli lewy indeks jest w tablicy (tablica ma indeksy od 0)
       && World[left]>0) //I nie jest zerem czyli jest "żywy"
       World[i]=1;
       
       if(right<WorldSize //Jesli prawy indeks jest w tablicy (tablica ma indeksy do WorldSize-1)
       && World[right]>0) //I nie jest zerem czyli jest "żywy"
       World[i]=1;
   }
}

println("\ntable:");// \n oznacza konie wiersza. //print("\ntable:\n");//Czyli zamiast println można by tak...
for(int i=0;i<World.length;i++) //Wypisywanie tablicy na konsole
    print(World[i],' ');

//Końcowy wynik prawie zawsze będzie taki sam - same jedynki. 
//Teraz już nie ma przewagi prawego brzegu nad lewym - dlaczego?


//Zamiast ignorować brzegi można by tak:
//Liczenie indeksów sąsiadów z zawijaniem dzięki reszcie z dzielenia
//    int right = (i+1) % WorldSize;  
//    int left  = (WorldSize+i-1) % WorldSize;