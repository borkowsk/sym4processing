//Dwuwymiarowy, DETERMINISTYCZNY automat komórkowy - reguła zsumuj z sąsiadami i zrób modulo
//zasiewamy tablicę na początku z zadaną gęstością lub pojedynczą komórką
//Do 16 różnych kolorów
//////////////////////////////////////////////////////////////////////////////////////////////////

int WorldSize=513; //ile chcemy elementów w linii
int[][] WorldOld=new int[WorldSize][WorldSize];//tworzenie tablic w Processingu zawsze
int[][] WorldNew=new int[WorldSize][WorldSize];
int Div=16; //jaki dzielnik w regule automatu (ilość kolorów)
float IDens=0.0; //początkowa gęstość tablicy


void setup()
{
  size(514,514); //okno kwadratowe
  noSmooth();
  if(IDens>0)
  {
    for(int i=0;i<WorldOld.length;i++) //zasiewanie tablicy
      for (int j=0;j<WorldOld.length;j++)
      if(random(1.0)<IDens)
      WorldOld[i][j]=int(random(3));
  }
  else
  {
    WorldOld[WorldSize/2][WorldSize/2]=1;
  }
  frameRate(30);
}

int t=0;
void draw()
{
  for (int i=0;i<WorldSize;i++) //wizualizacja czyli "rysowanie na ekranie"
  for (int j=0;j<WorldSize;j++)
  {
    switch(WorldOld[i][j]){ //instrukcja wyboru pozwala nam wybrać dowolny kolor w zalezności
    case 15:stroke(0,0,16);break;
    case 14:stroke(0,16,0);break;
    case 13:stroke(16,0,0);break;
    case 12:stroke(0,0,32);break;
    case 11:stroke(32,0,0);break;
    case 10:stroke(0,32,0);break;
    case 9:stroke(0,0,64);break;
    case 8:stroke(64,0,0);break;
    case 7:stroke(0,64,0);break;
    case 6:stroke(0,0,128);break;
    case 5:stroke(128,0,0);break;
    case 4:stroke(0,128,0);break;
    case 3:stroke(128,128,0);break;
    case 2:stroke(255,0,0);break;
    case 1:stroke(0,0,255);break;
    case 0:stroke(0,0,0);break;
    default: stroke(0,255,0); //to się pojawić nie powinno
    break;
    }
    
    point (i,j);
  }
  //zmiana stanu automatu
  for(int i=0;i<WorldSize;i++) //reguła - zsumuj z sąsiadami i weż modulo
  {
      //zamiast ignorować brzegi można zrobić liczneie indeksów sąsiadów z zawijaniem
      int right = (i+1) %WorldSize;
      int left = (WorldSize+i-1) % WorldSize;
    
      for(int j=0;j<WorldSize;j++)
      {
        int dw=(j+1) % WorldSize;
        int up=(WorldSize+j-1) % WorldSize;
        int ile = WorldOld[i][j]
                +WorldOld[left][j]
                +WorldOld[right][j]
                +WorldOld[i][up]
                +WorldOld[i][dw]
                ;//suma pięciu brana potem modulo 3
        WorldNew[i][j]=ile % Div; //nowy stan zapisujemy na drugą tablicę
      }
  }

  //zamiana tablic
  int[][] WorldTmp=WorldOld;
  WorldOld=WorldNew;
  WorldNew=WorldTmp;

  t++;//kolejne pokolenie/krok/krok
  fill(255);
  text("ST:"+t+" Fr:"+frameRate,10,30);
}

//////////////////////////////////////////////////////////////////////////////////
// Autor: Wojciech T. Borkowski
// Materiały do podręcznika "Processing w edukacji i symulacji
// https://github.com/borkowsk/sym4processing/tree/master/ProcessingWEdukacji
//////////////////////////////////////////////////////////////////////////////////
