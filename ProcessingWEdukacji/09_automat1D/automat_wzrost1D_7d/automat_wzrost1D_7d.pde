//Jednowymiarowy, DETERMINISTYCZNY automat komórkowy - reguła "ZSUMUJ Z SĄSIADAMI I WEŹ MODULO". Kroki MC
//Zasiewanie tablicy na początku z zadaną gęstością lub pojedynczą komórką
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
float IDens=0.0;//Początkowa gęstość w tablicy
int WorldSize=500;//Ile chcemy elementów w linii?
int[] WorldOld=new int[WorldSize];//Tworzenie tablic - w Processingu zawsze za pomocą alokacji
int[] WorldNew=new int[WorldSize];

void setup()
{
size(500,1000);    //Okno bardziej pionowe niż poziome 

if(IDens>0)
{
 for(int i=0;i<WorldOld.length;i++) //Zasiewanie tablicy
  if(random(1.0)<IDens)
    WorldOld[i]=1;
}
else
{
  WorldOld[WorldSize/2]=1;
}

frameRate(100);
noSmooth();
}


int t=0;
void draw()
{
  if(t>994) return; //Nic już nie ma do narysowania 
  
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
    line(i,999,i,994);//Odbicie aktualnego stanu na dole
  }
  
  for(int i=0;i<WorldOld.length;i++)//Zmiana stanu automatu
  {
       //Reguła -  "nie lubię mieć za dużo sąsiadów"
       //Zamiast ignorować brzegi można zrobić liczenie indeksów sąsiadów z zawijaniem dzięki reszcie z dzielenia
       int right = (i+1) % WorldSize;      
       int morer = (i+2) % WorldSize;     
       int left  = (WorldSize+i-1) % WorldSize;
       int morel = (WorldSize+i-2) % WorldSize;
       int ileich= 0;//Ile żywych sąsiadów?
       
       //Zawsze doliczamy CAŁY stan, nieważne czy jest zerem czyli jest "żywy"
         ileich+=WorldOld[left];
         ileich+=WorldOld[right];
         ileich+=WorldOld[morel];
         ileich+=WorldOld[morer];
         ileich+=WorldOld[i];
             
        WorldNew[i]=ileich % 4;  //Reguła "ZSUMUJ STANY Z SĄSIADAMI I WEŹ MODULO"
   }
   
   //Zamiana tablic
   int[] WorldTmp=WorldOld;
   WorldOld=WorldNew;
   WorldNew=WorldTmp;
   
   t++;//Kolejne pokolenie/krok/rok
}