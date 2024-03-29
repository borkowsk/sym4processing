//Dwuwymiarowy, DETERMINISTYCZNY automat komórkowy - reguła "ZSUMUJ Z SĄSIADAMI I WEŹ MODULO". SYNCHRONUCZNY!
//Zasiewanie tablicy na początku z zadaną gęstością lub pojedynczą komórką
//Alternatywny sposób przyśpieszania - z dodatkową tablicą
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int WorldSize=252;//Ile chcemy elementów w linii?
int[][] WorldOld=new int[WorldSize][WorldSize];//Tworzenie tablic - w Processingu zawsze za pomocą alokacji
int[][] WorldNew=new int[WorldSize][WorldSize];
boolean[][] Changed=new boolean[WorldSize][WorldSize];//Flagi zmiany do rysowania

float IDens=0.0;//Początkowa gęstość w tablicy
int Div=5; //Jaki dzielnik w regule automatu

void setup()
{
  size(253,270);    //Okno nie do końca kwadratowe - miejsce na napis
  noSmooth();
  if(IDens>0)
  {
   for(int i=0;i<WorldOld.length;i++) //Zasiewanie tablicy
    for(int j=0;j<WorldOld.length;j++) 
    {
      Changed[i][j]=true;
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
     {
      Changed[i][j]=true;
      WorldOld[i][j]=0;
     }
      
    WorldOld[WorldSize/2][WorldSize/2]=1;//Tylko jeden w środku
  }
  
  frameRate(120);
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
      if(Changed[i][j]) //Czy na WorldNew jest stara zawartość - czyli ta co na ekranie
        point(i,j);// czy nowa? Tylko jak nowa to rysujemy
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
         
         int ile = WorldOld[i][j]
                 +WorldOld[left][j]
                 +WorldOld[right][j]
                 +WorldOld[i][up]
                 +WorldOld[i][dw]              
                 ;//suma z pięciu komórek brana potem modulo 3
      
         WorldNew[i][j]=ile % Div;//Nowy stan zapisujemy na drugą tablicę
         Changed[i][j]=(WorldNew[i][j] !=0 || WorldOld[i][j]!=0);//Czy trzeba odrysować? point() jest kosztowne wbrew pozorom
       }
   }
   
   //Zamiana tablic - nie trzeba kopiować tablic, wystarczy "uchwyty" do nich
   int[][] WorldTmp=WorldOld;
   WorldOld=WorldNew;
   WorldNew=WorldTmp;
   
   t++;//Kolejne pokolenie/krok/rok
   fill(128);
   rect(0,WorldSize,width,height-WorldSize);//Czyszczący prostokąt
   fill(255);
   text("ST: "+t+" Fr: "+frameRate,10,height);
}

//////////////////////////////////////////////////////////////////////////////////
// Autor: Wojciech T. Borkowski
// Materiały do podręcznika "Processing w edukacji i symulacji
// https://github.com/borkowsk/sym4processing/tree/master/ProcessingWEdukacji
//////////////////////////////////////////////////////////////////////////////////
