//Jednowymiarowy, DETERMINISTYCZNY automat komórkowy - reguła "ZSUMUJ Z SĄSIADAMI I WEŹ MODULO". Kroki MC
//Zasiewanie tablicy na początku z zadaną gęstością lub pojedynczą komórką
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int WorldSize=252;//Ile chcemy elementów w linii?
int[][] WorldOld=new int[WorldSize][WorldSize];//Tworzenie tablic - w Processingu zawsze za pomocą alokacji
int[][] WorldNew=new int[WorldSize][WorldSize];
boolean[][] Changed=new boolean[WorldSize][WorldSize];//Flagi zmiany do rysowania

float IDens=0.0;//Początkowa gęstość w tablicy
int Div=6; //Jaki dzielnik w regule automatu
int S=1; //Bok celki
void setup()
{
  size(260,256);    //Okno kwadratowe
  surface.setResizable(true);//https://github.com/processing/processing/wiki/Window-Size-and-Full-Screen
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
  frameRate(20);
}

int t=0;
void draw()
{  
  S=min(width/WorldSize,height/WorldSize);//Min żeby zachować kwadratowość
  //println(S);
  noStroke();
  for(int i=0;i<WorldOld.length;i++)//Wizualizacja czyli "rysowanie na ekranie" 
    for(int j=0;j<WorldOld.length;j++) 
    {
      switch(WorldOld[i][j]){ //Instrukcja wyboru pozwala nam wybrać dowolny kolor w zależności od liczby w komórce
      case 5:fill(128,128,255);break;
      case 4:fill(0,128,0);break;
      case 3:fill(128,128,0);break;
      case 2:fill(255,0,0);break;
      case 1:fill(0,0,255);break;
      case 0:fill(0,0,0);break;
      default: fill(0,255,0);//To się pojawiac nie powinno
      break;
      }
      if(Changed[i][j]) //Na WorldNew jest stara zawartość - czyli ta co na ekranie 
        rect(i*S,j*S,S,S);
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
   
   //Zamiana tablic - łatwa bo nie trzeba kopiować tablic, wystarczy "uchwyty" do nich
   int[][] WorldTmp=WorldOld;
   WorldOld=WorldNew;
   WorldNew=WorldTmp;
   
   t++;//Kolejne pokolenie/krok/rok
   //fill(255);
   //text("ST:"+t+" Fr:"+frameRate,10,WorldSize);
}

//void onResize() ? windowResize() //Jak się nazywa to zdarzenie? Brak w manualu
//{}