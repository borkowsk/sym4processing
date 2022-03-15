//Jednowymiarowy, DETERMINISTYCZNY automat komórkowy 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
float IDens=0.950;//Początkowa gęstość w tablicy
int   WorldSize=500;//Ile chcemy elementów w linii?

int[] WorldOld=new int[WorldSize];//Tworzenie tablic - w Processingu zawsze za pomocą alokacji
int[] WorldNew=new int[WorldSize];

void setup()
{
  size(500,1000);    //Okno bardziej pionowe niż poziome 
  
  if(IDens>0)//Zasiewanie tablicy na początku z zadaną gęstością 
  {
   for(int i=0;i<WorldOld.length;i++) //Zasiewanie tablicy
    if(random(1.0)<IDens)
      WorldOld[i]=1;
  }
  else WorldOld[WorldSize/2]=1; //... lub pojedynczą komórką
  
  frameRate(100);
}

int t=0;
void draw()
{
  if(t>999) return; //Nic już nie ma do narysowania 
  
  for(int i=0;i<WorldOld.length;i++)//Wizualizacja czyli "rysowanie na ekranie" 
  {
    if(WorldOld[i]>0) stroke(255,0,100);
    else           stroke(0);
    point(i,t);
  }
  
  for(int i=0;i<WorldOld.length;i++)//Zmiana stanu automatu
  {
       //Reguła - "nie lubię mieć za dużo sąsiadów"
       //Zamiast ignorować brzegi można zrobić liczenie indeksów sąsiadów z zawijaniem 
       int right = (i+1) % WorldSize;//...dzięki reszcie z dzielenia      
       int left  = (WorldSize+i-1) % WorldSize;
       int ileich= 0;//Ile żywych sąsiadów?
       
       if(WorldOld[left]>0) //Nie jest zerem czyli jest "żywy"
         ileich++;
       
       if(WorldOld[right]>0) //Nie jest zerem czyli jest "żywy"
         ileich++;
               
       if(ileich==1) WorldNew[i]=1;//Tylko posiadanie jednego sąsiada jest poprawne
       else WorldNew[i]=0;//Umiera z samotności albo z tłoku
   }
   
   //Zamiana tablic
   int[] WorldTmp=WorldOld;
   WorldOld=WorldNew;
   WorldNew=WorldTmp;
   
   t++;//Kolejne pokolenie/krok/rok
}
