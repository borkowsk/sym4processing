//Jednowymiarowy, DETERMINISTYCZNY automat komórkowy - reguła "ZSUMUJ Z SĄSIADAMI I WEŹ MODULO". Kroki MC
//Zasiewanie tablicy na początku z zadaną gęstością lub pojedynczą komórką
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int WorldSize=500;//Ile chcemy elementów w linii?
int[] WorldOld=new int[WorldSize];//Tworzenie tablic - w Processingu zawsze za pomocą alokacji
int[] WorldNew=new int[WorldSize];
float IDens=0.05;//Początkowa gęstość w tablicy

void setup()
{
size(500,1000);    //Okno bardziej pionowe niż poziome 

if(IDens>0)
{
 for(int i=0;i<WorldOld.length;i++) //Zasiewanie tablicy
  if(random(1.0)<IDens)
    WorldOld[i]=int(random(3));
}
else
{
  WorldOld[0]=1;
}
frameRate(100);
}


int t=0;
void draw()
{
  if(t>999) return; //Nic już nie ma do narysowania 
  
  for(int i=0;i<WorldOld.length;i++)//Wizualizacja czyli "rysowanie na ekranie" 
  {
    switch(WorldOld[i]){ //Instrukcja wyboru pozwala nam wybrać dowolny kolor w zależności od liczby w konmórce
    case 2:stroke(255,0,0);break;
    case 1:stroke(0,0,255);break;
    case 0:stroke(0,0,0);break;
    default: stroke(0,255,0);//To się pojawiac nie powinno
    break;
    }
    point(i,t);
  }
  
  for(int i=0;i<WorldOld.length;i++)//Zmiana stanu automatu
  {
       //Reguła - "ZSUMUJ Z SĄSIADAMI I WEŹ MODULO"
       //Zamiast ignorować brzegi można zrobić liczenie indeksów sąsiadów z zawijaniem dzięki reszcie z dzielenia
       int right = (i+1) % WorldSize;      
       int left  = (WorldSize+i-1) % WorldSize;
       
       int ile = WorldOld[i];//suma trzech brana potem modulo 3
       ile+=WorldOld[left];
       ile+=WorldOld[right];
         
       WorldNew[i]=ile % 3;//Nowy stan zapisujemy na drugą tablicę
   }
   
   //Zamiana tablic
   int[] WorldTmp=WorldOld;
   WorldOld=WorldNew;
   WorldNew=WorldTmp;
   
   t++;//Kolejne pokolenie/krok/rok
}