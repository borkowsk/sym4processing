//Jednowymiarowy, DETERMINISTYCZNY automat komórkowy - reguła "ZSUMUJ Z SĄSIADAMI I WEŹ MODULO". 
//Kroki synchroniczne i SĄSIEDZTWO MOORE'a !!!
//Zasiewanie tablicy na początku z zadaną gęstością lub pojedynczą komórką
//Przyśpieszony poprzez śledzenie zmian
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int WorldSize=3*171;//Ile chcemy elementów w linii?
int[][] WorldOld=new int[WorldSize][WorldSize];//Tworzenie tablic - w Processingu zawsze za pomocą alokacji
int[][] WorldNew=new int[WorldSize][WorldSize];

float IDens=0.0;//Początkowa gęstość w tablicy
int Div=5; //Jaki dzielnik w regule automatu
boolean self=true;//false albo true

void setup()
{
  size(513,530);    //Okno nie do końca kwadratowe - miejsce na napis
  noSmooth(); //Usprawniwnie 1: tryb noSmooth() jest znacznie szybszy
  frameRate(120);
  println(WorldSize," in ",width,"x",height," window");
    
  if(IDens>0)
  {
   for(int i=0;i<WorldOld.length;i++) //Zasiewanie tablicy
    for(int j=0;j<WorldOld.length;j++) 
    {
      WorldNew[i][j]=-1;//Info że jeszcze nie używane więc nie rysowane
      if(random(1.0)<IDens)
        WorldOld[i][j]=(int)(random(Div));//trzeba zmienić typ, bo tablica przechowuje int a nie float
      else
        WorldOld[i][j]=0;
    }
  }
  else
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
      //case N:stroke( , , );break; //Mozna dodac kolejne kolory
      case 5:stroke(128,128,255);break;
      case 4:stroke(0,128,0);break;
      case 3:stroke(128,128,0);break;
      case 2:stroke(255,0,0);break;
      case 1:stroke(0,0,255);break;
      case 0:stroke(0,0,0);break;
      default: stroke(0,255,0);//To się pojawiac nie powinno
      break;
      }
      //Usprawnienie 2: nie rysujemy gdy...
      if( (WorldOld[i][j] != WorldNew[i][j]) ) //na WorldNew jest stara zawartość 
        point(i,j);//Komórka to punkt na ekranie
    }
  
  for(int i=0;i<WorldOld.length;i++)//Zmiana stanu automatu
  {
       //Reguła - "ZSUMUJ Z SĄSIADAMI I WEŹ MODULO"
       //Zamiast ignorować brzegi można zrobić liczenie indeksów sąsiadów z zawijaniem dzięki reszcie z dzielenia
       int right = (i+1) % WorldSize;         
       int left  = (WorldSize+i-1) % WorldSize;
       
       for(int j=0;j<WorldOld.length;j++) 
       {
         int dw=(j+1) % WorldSize;   
         int up=(WorldSize+j-1) % WorldSize;
         
         int ile =(self?WorldOld[i][j]:0)//Aktualna komórka brana albo nie
                 +WorldOld[left][j]      //w lewo od niej
                 +WorldOld[right][j]     //w prawo
                 +WorldOld[i][up]        //w górę
                 +WorldOld[i][dw]        //w dół    
                 //rogi czyli uzupełnienie do sąsiedzwta Moora
                 +WorldOld[right][dw]
                 +WorldOld[left][dw]
                 +WorldOld[right][up]
                 +WorldOld[left][up]
                 ;//suma z dziewięciu komórek brana potem modulo Div
      
         WorldNew[i][j]=ile % Div;//Nowy stan zapisujemy na drugą tablicę
       }
   }
   
   int[][] WorldTmp=WorldOld;//Zamiana tablic - łatwa bo nie trzeba kopiować tablic
   WorldOld=WorldNew;        //, wystarczy "uchwyty" do nich
   WorldNew=WorldTmp;
   
   t++;//Kolejne pokolenie/krok/rok
   fill(128);
   rect(0,WorldSize,width,height-WorldSize);//Czyszczący prostokąt
   fill(255);
   text("ST: "+t+" Fr: "+frameRate,10,height);
}