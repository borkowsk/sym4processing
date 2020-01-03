//Jednowymiarowy, DETERMINISTYCZNY automat komórkowy - reguła "ZSUMUJ Z SĄSIADAMI I WEŹ MODULO". Kroki MC
//Zasiewanie tablicy na początku z zadaną gęstością lub pojedynczą komórką
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int WorldSize=200;//Ile chcemy elementów w linii?
int[][] WorldOld=new int[WorldSize][WorldSize];//Tworzenie tablic - w Processingu zawsze za pomocą alokacji
int[][] WorldNew=new int[WorldSize][WorldSize];
float IDens=0.0;//Początkowa gęstość w tablicy

void setup()
{
size(200,200);    //Okno kwadratowe
 noSmooth();
if(IDens>0)
{
 for(int i=0;i<WorldOld.length;i++) //Zasiewanie tablicy
  for(int j=0;j<WorldOld.length;j++) 
  if(random(1.0)<IDens)
    WorldOld[i][j]=int(random(3));
}
else
{
  WorldOld[WorldSize/2][WorldSize/2]=1;
}
 frameRate(20);
}


int t=0;
void draw()
{  
  for(int i=0;i<WorldOld.length;i++)//Wizualizacja czyli "rysowanie na ekranie" 
  for(int j=0;j<WorldOld.length;j++) 
  {
    switch(WorldOld[i][j]){ //Instrukcja wyboru pozwala nam wybrać dowolny kolor w zależności od liczby w konmórce
    case 2:stroke(255,0,0);break;
    case 1:stroke(0,0,255);break;
    case 0:stroke(0,0,0);break;
    default: stroke(0,255,0);//To się pojawiac nie powinno
    break;
    }
    
    point(i,j);
  }
  
  for(int i=0;i<WorldOld.length;i++)//Zmiana stanu automatu
  {
       //Reguła - "ZSUMUJ Z SĄSIADAMI I WEŹ MODULO"
       //Zamiast ignorować brzegi można zrobić liczenie indeksów sąsiadów z zawijaniem dzięki reszcie z dzielenia
       int right = (i+1) % WorldSize;      
       //int morer = (i+2) % WorldSize;     
       int left  = (WorldSize+i-1) % WorldSize;
       //int morel = (WorldSize+i-2) % WorldSize;
       
       for(int j=0;j<WorldOld.length;j++) 
       {
       int dw=(j+1) % WorldSize;   
       int up=(WorldSize+j-1) % WorldSize;
       int ile = WorldOld[i][j]
               +WorldOld[left][j]
               +WorldOld[right][j]
               +WorldOld[i][up]
               +WorldOld[i][dw]              
               ;//suma pięciu brana potem modulo 3
    
       WorldNew[i][j]=ile % 3;//Nowy stan zapisujemy na drugą tablicę
       }
   }
   
   //Zamiana tablic
   int[][] WorldTmp=WorldOld;
   WorldOld=WorldNew;
   WorldNew=WorldTmp;
   
   t++;//Kolejne pokolenie/krok/rok
   text("ST:"+t,0,10);
}