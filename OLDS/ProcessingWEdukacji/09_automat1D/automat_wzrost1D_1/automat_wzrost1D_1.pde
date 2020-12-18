//Jednowymiarowy, probabilistyczny automat komórkowy - szkielet i najprostrza symulacja w postaci "bez funkcyjnej" 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Przykład pokazuje też zastosowanie tablic w Processingu - niestety nie takie proste jak w Pascalu
//bo tu tablice nie są prostymi typami jak int czy char czy float...
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
  
  for(int i=0;i<World.length;i++)//Zmiana stanu automatu
    if(random(1.0)>0.75) //Tylko 1/4 komórek zmienia swój stan
    {
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

println("\ntable:");// \n oznacza konie wiersza. 
//print("\ntable:\n");//Czyli zamiast println można by tak...
for(int i=0;i<World.length;i++) //Wypisywanie tablicy na konsole
    print(World[i],' ');

//Końcowy wynik prawie zawsze będzie taki sam - same jedynki. 
//Jednak do prawego brzegu białe docierają szybciej niż do lewego - dlaczego?


//Zamiast ignorować brzegi można by tak:
//Liczenie indeksów sąsiadów z zawijaniem dzięki reszcie z dzielenia
//    int right = (i+1) % WorldSize;  
//    int left  = (WorldSize+i-1) % WorldSize;