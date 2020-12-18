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
    default: stroke(255,255,0);//To się pojawiac nie powinno
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
       
       if(WorldOld[left]>0) //Nie jest zerem czyli jest "żywy"
         ileich++;
       
       if(WorldOld[right]>0) //Nie jest zerem czyli jest "żywy"
         ileich++;
        
       if(WorldOld[morel]>0) //Nie jest zerem czyli jest "żywy"
         ileich++;
       
       if(WorldOld[morer]>0) //Nie jest zerem czyli jest "żywy"
         ileich++; 
         
       //Jeśli wliczamy stan komórki i-tej
       //if(WorldOld[i]>0) ileich++; //Czy sam nie jest zerem czyli jest "żywy"
             
        WorldNew[i]=ileich % 3;  //Reguła MODULO
      
      // POPRZEDNIA REGUŁA    
      // if(ileich==1) WorldNew[i]=1;else WorldNew[i]=0;//Tylko posiadanie jednego sąsiada jest poprawne
                                                        // więc umiera z samotności albo z tłoku
   }
   
   //Zamiana tablic
   int[] WorldTmp=WorldOld;
   WorldOld=WorldNew;
   WorldNew=WorldTmp;
   
   t++;//Kolejne pokolenie/krok/rok
}
