//Jednowymiarowy, probabilistyczny automat komórkowy - reguła "nie lubię mieć za dużo sąsiadów". Kroki MC
//Zasiewanie tablicy na początku z zadaną gęstością
//////////////////////////////////////////////////////////////////////////////////////////////////////////
float IDens=0.1333;//Początkowa gęstość w tablicy

int WorldSize=500;//Ile chcemy elementów w linii?
int[] World=new int[WorldSize];//Tworzenie tablicy - w Processingu zawsze za pomocą alokacji

void setup()
{
size(500,1000);    //Okno bardziej pionowe niż poziome 

for(int i=0;i<World.length;i++) //Zasiewanie tablicy
 if(random(1.0)<IDens)
    World[i]=1;

frameRate(100);
}

int t=0;
void draw()
{
  if(t>999) return; //Nic już nie ma do narysowania 
  
  for(int i=0;i<World.length;i++)//Wizualizacja czyli "rysowanie na ekranie" 
  {
    if(World[i]>0) stroke(255,0,100);
    else           stroke(0);
    point(i,t);
  }
  
  int N=World.length; //Tyle komórek zmienia swój stan ile jest 
                      //ale niektóre wcale a niektóre więcej razy są losowane!
  for(int j=0;j<N;j++)//Zmiana stanu automatu
  {
       int i=int(random(World.length));//Funkcja random() produkuje float, więc trzeba zmienić typ wyniku 
                                       //(i obciąć część ułamkową) 
       
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