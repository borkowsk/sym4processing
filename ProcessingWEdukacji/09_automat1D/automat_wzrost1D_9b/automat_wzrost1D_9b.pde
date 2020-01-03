//Jednowymiarowy, DETERMINISTYCZNY automat komórkowy - reguła "ZSUMUJ Z SĄSIADAMI I WEŹ MODULO". Kroki MC
//Zasiewanie tablicy na początku z zadaną gęstością lub pojedynczą komórką
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int WorldSize=500;//Ile chcemy elementów w linii?
int[] WorldOld=new int[WorldSize];//Tworzenie tablic - w Processingu zawsze za pomocą alokacji
int[] WorldNew=new int[WorldSize];
float IDens=0.0;//Początkowa gęstość w tablicy

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
    WorldOld[WorldSize/2]=1;
  }
  
  frameRate(100);
}

int divider=5; //Przez ile dzielimy
boolean self=true;//Czy wliczamy stan środkowego
int t=0;
void draw()
{
  if(t>994) return; //Nic już nie ma do narysowania 
  
  for(int i=0;i<WorldOld.length;i++)//Wizualizacja czyli "rysowanie na ekranie" 
  {
    switch(WorldOld[i]){ //Instrukcja wyboru pozwala nam wybrać dowolny kolor
    case 4:stroke(255,255,0);break;
    case 3:stroke(0,255,0);break;
    case 2:stroke(255,0,0);break;
    case 1:stroke(0,0,255);break;
    case 0:stroke(0,0,0);break;
    default: stroke(128,255,128);//To się pojawiac nie powinno
    break;
    }
    
    point(i,t);
    line(i,999,i,994);//Odbicie aktualnego stanu na dole
  }
  
  for(int i=0;i<WorldOld.length;i++)//Zmiana stanu automatu
  {
       //Reguła - "ZSUMUJ Z SĄSIADAMI I WEŹ MODULO"
       //Liczenie indeksów sąsiadów z zawijaniem dzięki reszcie z dzielenia
       int right = (i+1) % WorldSize;      
       int morer = (i+2) % WorldSize;     
       int left  = (WorldSize+i-1) % WorldSize;
       int morel = (WorldSize+i-2) % WorldSize;
       int ile = self ? WorldOld[i] : 0 ;
       
       ile+=WorldOld[left]
          +WorldOld[right]
          +WorldOld[morel]
          +WorldOld[morer]              
               ;//suma czterech/pięciu brana potem modulo 3
    
       WorldNew[i]=ile % divider;//Nowy stan zapisujemy na drugą tablicę
   }
   
   //Zamiana tablic
   int[] WorldTmp=WorldOld;
   WorldOld=WorldNew;
   WorldNew=WorldTmp;
   
   t++;//Kolejne pokolenie/krok/rok
}