//Dwuwymiarowy, DETERMINISTYCZNY automat komórkowy - reguła Life
//Kroki synchroniczne i SĄSIEDZTWO MOORE'a !!!
//Zasiewanie tablicy na początku z zadaną gęstością lub pojedynczą komórką
//Przyśpieszony poprzez śledzenie zmian
/////////////////////////////////////////////////////////////////////////////////////////
int WorldSize=2*3*171;//Ile chcemy elementów w linii? (dobrze jak wielokrotność 3)
int[][] WorldOld=new int[WorldSize][WorldSize];//Tworzenie tablic "świata"
int[][] WorldNew=new int[WorldSize][WorldSize];

float IDens=0.33;//Początkowa gęstość w tablicy
int     birdt=3;//Ile potrzeba do zrodzenia nowej komórki
int     minim=2;//Najmniej liczne sąsiedzwtwo pozwalające na przeżycie
int     maxim=3;//Najbardziej liczne sąsiedztwo pozwalające na przeżycie

void setup()
{
  size(1026,1040); //Okno nie do końca kwadratowe - miejsce na napis
  noSmooth(); //Usprawnienie 1: tryb noSmooth() jest znacznie szybszy
  frameRate(120);
  println(WorldSize," in ",width,"x",height," window");
    
  if(IDens>0)
  {
   for(int i=0;i<WorldOld.length;i++) //Zasiewanie tablicy
    for(int j=0;j<WorldOld.length;j++) 
    {
      WorldNew[i][j]=-1;//Info że jeszcze nie używane więc nie rysowane
      if(random(1.0)<IDens)
        WorldOld[i][j]=1; //Albo 1 albo nic
      else
        WorldOld[i][j]=0;
    }
  }
  else //Start od 1 może nie mieć sensu, zwłaszcza dla reguły Conway'a
  {
    for(int i=0;i<WorldOld.length;i++) //Zasiewanie tablicy
     for(int j=0;j<WorldOld.length;j++) 
      WorldNew[i][j]=-1;//Info że jeszcze nie używane więc nie rysowane
      
    WorldOld[WorldSize/2][WorldSize/2]=1;//Tylko jeden w środku
  }
}


int t=0;
void draw()
{  
  for(int i=0;i<WorldOld.length;i++)//Wizualizacja czyli "rysowanie na ekranie" 
    for(int j=0;j<WorldOld.length;j++) 
    {
      switch(WorldOld[i][j]){ //Instrukcja wyboru pozwala nam wybrać dowolny kolor w zależności od liczby w komórce
      //case N:stroke( , , );break; //w Life Conwaya potrzebne tylko dwa kolory, ale może jeszcze przydać się poźniej
      case 1:stroke(255,255,0);break;//Normalnie tylko to
      case 0:stroke(0,0,0);break;//Lub to
      default: stroke(255,0,0);//To się pojawiac nie powinno - jest po to żeby wychwywytywac błędy w implementacji
      break;
      }
      if( (WorldOld[i][j] != WorldNew[i][j]) ) //na WorldNew jest stara zawartość 
        point(i,j);//Rysujemy tylko nową (Usprawnienie 2.)
    }
  
  for(int i=0;i<WorldOld.length;i++)//Zmiana stanu automatu
  {
       //Reguła - "LIFE"
       //Zamiast ignorować brzegi można zrobić liczenie indeksów sąsiadów z zawijaniem dzięki reszcie z dzielenia
       int right = (i+1) % WorldSize;         
       int left  = (WorldSize+i-1) % WorldSize;
       
       for(int j=0;j<WorldOld.length;j++) 
       {
         int dw=(j+1) % WorldSize;   
         int up=(WorldSize+j-1) % WorldSize;
         
         int ile =WorldOld[left][j]      //w lewo od niej
                 +WorldOld[right][j]     //w prawo
                 +WorldOld[i][up]        //w górę
                 +WorldOld[i][dw]        //w dół    
                 //rogi czyli uzupełnienie do sąsiedzwta Moora
                 +WorldOld[right][dw]
                 +WorldOld[left][dw]
                 +WorldOld[right][up]
                 +WorldOld[left][up]
                 ;//suma z dziewięciu komórek brana potem modulo Div
      
        if(WorldOld[i][j]==0)//Nowourodzenie
        {
          if(ile==birdt)
             WorldNew[i][j]=1;//Nowy stan zapisujemy na drugą tablicę
          else
             WorldNew[i][j]=0;//Stary stan zapisujemy na drugą tablicę
        }
        else
        if(minim<=ile && ile<=maxim) //Przeżycie
          WorldNew[i][j]=1;//Stary stan zapisujemy na drugą tablicę
          else
          WorldNew[i][j]=0;//Nowy stan zapisujemy na drugą tablicę
       }
   }
   
   int[][] WorldTmp=WorldOld;//Zamiana tablic
   WorldOld=WorldNew;
   WorldNew=WorldTmp;
   
   t++;//Kolejne pokolenie/krok/rok
   fill(128);rect(0,WorldSize,width,height-WorldSize);//Czyszczący prostokąt
   fill(255);text("ST: "+t+" Fr: "+frameRate,10,height);
}
