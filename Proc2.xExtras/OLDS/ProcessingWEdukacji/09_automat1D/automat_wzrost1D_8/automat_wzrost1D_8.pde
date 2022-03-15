//Jednowymiarowy, probabilistyczny automat komórkowy - reguła "ZSUMUJ Z SĄSIADAMI I WEŹ MODULO". Kroki MC
//Zasiewanie tablicy na początku z zadaną gęstością
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int WorldSize=500;//Ile chcemy elementów w linii?
int[] World=new int[WorldSize];//Tworzenie tablicy - w Processingu zawsze za pomocą alokacji
float IDens=0.0;//Początkowa gęstość w tablicy

void setup()
{
size(500,1000);    //Okno bardziej pionowe niż poziome 

if(IDens>0)
{
 for(int i=0;i<World.length;i++) //Zasiewanie tablicy
  if(random(1.0)<IDens)
    World[i]=int(random(3));
}
else
{
  World[0]=1;
}
frameRate(100);
}


int t=0;
void draw()
{
  if(t>999) return; //Nic już nie ma do narysowania 
  
  for(int i=0;i<World.length;i++)//Wizualizacja czyli "rysowanie na ekranie" 
  {
    switch(World[i]){ //Instrukcja wyboru pozwala nam wybrać dowolny kolor w zależności od liczby w konmórce
    case 2:stroke(255,0,0);break;
    case 1:stroke(0,0,255);break;
    case 0:stroke(0,0,0);break;
    default: stroke(0,255,0);//To się pojawiac nie powinno
    break;
    }
    point(i,t);
  }
  
  int N=World.length; //Tyle komórek zmienia swój stan ile jest ale niektóre wcale a niektóre więcej razy są losowane!
  for(int j=0;j<N;j++)//Zmiana stanu automatu
  {
       int i=int(random(World.length));//Funkcja random() produkuje float, więc trzeba zmienić typ wyniku (i obciąć część ułamkową) 
       
       //Reguła -  "ZSUMUJ Z SĄSIADAMI I WEŹ MODULO"
       //Zamiast ignorować brzegi można zrobić liczenie indeksów sąsiadów z zawijaniem dzięki reszcie z dzielenia
       int right = (i+1) % WorldSize;      
       int left  = (WorldSize+i-1) % WorldSize;
       
       int ile = World[i];//suma trzech brana potem modulo 3
       ile+=World[left];
       ile+=World[right];
         
       World[i]=ile % 3;
       //print(World[i],' ');
   }
   
   t++;//Kolejne pokolenie/krok/rok
}