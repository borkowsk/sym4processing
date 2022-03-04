//Jednowymiarowy, probabilistyczny automat komórkowy - reguła "nie lubię mieć za dużo sąsiadów"
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int WorldSize=500;//Ile chcemy elementów w linii?
int[] World=new int[WorldSize];//Tworzenie tablicy - w Processingu zawsze za pomocą alokacji

void setup()
{
size(500,1000);    //Okno bardziej pionowe niż poziome 

//for(int i=0;i<World.length;i++) //Zerowanie tablicy - gdyby było potrzebne. Wydruk tablicy pokaże czy jest
//    World[i]=0;

World[WorldSize/2]=1; //Zarodek 1
World[WorldSize/2-1]=1;//Zarodek 2 - po co?
frameRate(100);
}


int t=0;
void draw()
{
  if(t>999) return; //Nic już nie ma do narysowania 
  
  for(int i=0;i<World.length;i++)//Wizualizacja czyli "rysowanie na ekranie" 
  {
    if(World[i]>0) stroke(255,255,0);
    else           stroke(0);
    point(i,t);
  }
  
  int N=World.length/3; //Tylko 1/3 komórek zmienia swój stan
  for(int j=0;j<N;j++)//Zmiana stanu automatu
  {
       int i=int(random(World.length));//Funkcja random() produkuje float, więc trzeba zmienić typ wyniku (i obciąć część ułamkową) 
       
       //Reguła -  "nie lubię mieć za dużo sąsiadów"
       //Zamiast ignorować brzegi można zrobić liczenie indeksów sąsiadów z zawijaniem dzięki reszcie z dzielenia
       int right = (i+1) % WorldSize;      
       int left  = (WorldSize+i-1) % WorldSize;
       int ileich= 0;//Ile żywych sąsiadów?
       
       if(World[left]>0) //Nie jest zerem czyli jest "żywy"
        ileich++;
       
       if(World[right]>0) //Nie jest zerem czyli jest "żywy"
         ileich++;
         
       if(ileich==1) World[i]=1;//Tylko posiadanie jednego sąsiada jest poprawne
       else World[i]=0;//Umiera z samotności albo z tłoku
   }
   
   t++;//Kolejne pokolenie/krok/rok
}