//Jednowymiarowy, probabilistyczny automat komórkowy - reguła "nie lubię mieć za dużo sąsiadów"
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//UWAGA! Gdy populacja jest jeszcze mała może łatwo dojść do jej całkowitego wymarcia
int MC=8;//Jaka część kroku Monte Carlo na krok czasu (t)
int WorldSize=500;//Ile chcemy elementów w linii?
int[] World=new int[WorldSize];//Tworzenie tablicy - w Processingu zawsze za pomocą alokacji

void setup()
{
size(500,1000);    //Okno bardziej pionowe niż poziome 
World[WorldSize/2]=1; //Zarodek 
frameRate(150);
}


int t=0;
void draw()
{
  if(t>999) return; //Nic już nie ma do narysowania 
  
  for(int i=0;i<World.length;i++)//Wizualizacja czyli "rysowanie na ekranie" 
  {
    if(World[i]>0) stroke(255,255,0);
    else           stroke(0,0,25);
    point(i,t);
  }
  
  int N=World.length/MC; //Tylko 1/MC komórek zmienia swój stan
  for(int j=0;j<N;j++)//Zmiana stanu automatu
  {
       int i=int(random(World.length));//Funkcja random() produkuje float, 
                                     //więc trzeba zmienić typ wyniku (i obciąć część ułamkową) 
       
       //Reguła -  "nie lubię mieć za dużo sąsiadów"
       int right = (i+1) % WorldSize; //liczenie indeksów sąsiadów z zawijaniem 
       int left  = (WorldSize+i-1) % WorldSize; //dzięki reszcie z dzielenia (modulo)
       int ileich= 0;//Ile żywych sąsiadów?
       
       if(World[left]>0) //Nie jest zerem czyli jest "żywy"
        ileich++;
       
       if(World[right]>0) //Nie jest zerem czyli jest "żywy"
         ileich++;
         
       if(ileich==1) 
         World[i]=1;//Tylko posiadanie jednego sąsiada zapewnia życie
       else 
         World[i]=0;//Umiera z samotności albo z tłoku
   }
   
   t++;//Kolejne pokolenie/krok/rok
}