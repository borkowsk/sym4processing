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
  {
      if(World[i]>0 && random(1.0)<0.005)       //Jeśli komórka żywa to może umrzeć
        World[i]=0;
      if(World[i]==0 && random(1.0)<0.007)       //Jeśli komórka martwa to może się ożywić
        World[i]=1;
  }
}

println("table:");
for(int i=0;i<World.length;i++) //Wypisywanie tablicy na konsole
    print(World[i],' ');
    
//Liczenie indeksów sąsiadów z zawijaniem dzięki reszcie z dzielenia
//    int post1=(i+1)%WorldSize;  
//    int pre1=(WorldSize+i-1)%WorldSize;