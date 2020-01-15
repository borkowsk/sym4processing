//Dwuwymiarowy, DETERMINISTYCZNY automat komórkowy - reguła "ZSUMUJ Z SĄSIADAMI I WEŹ MODULO". SYNCHRONICZNY
//Zasiewanie tablicy na początku z zadaną gęstością lub pojedynczą komórką
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int WorldSize=255;//Ile chcemy elementów w linii?
int[][] WorldOld=new int[WorldSize][WorldSize];//Tworzenie tablic - w Processingu zawsze za pomocą alokacji
int[][] WorldNew=new int[WorldSize][WorldSize];
float IDens=0.0;//Początkowa gęstość w tablicy
int Div=5; //Jaki dzielnik w regule automatu

void setup()
{
  size(260,256);    //Okno kwadratowe
  noSmooth();
  frameRate(20);
   
  if(IDens>0)
  {
   for(int i=0;i<WorldOld.length;i++) //Zasiewanie tablicy. Odpytujemy tablice 2D ile ma wierszy
    for(int j=0;j<WorldOld[i].length;j++) //A każdy wiersz pytamy ile ma kolumn
      if(random(1.0)<IDens)
        WorldOld[i][j]=1+(int)(random(Div));//trzeba zmienić typ, bo tablica przechowuje int a nie float
  }
  else
  {
    WorldOld[WorldSize/2][WorldSize/2]=1;//Tylko jeden w środku
  }
}


int t=0;
void draw()
{  
  //Najpierw rysujemy - żeby zobaczyć stan początkowy
  for(int i=0;i<WorldOld.length;i++)//Wizualizacja czyli "rysowanie na ekranie" 
    for(int j=0;j<WorldOld[i].length;j++) 
    {
      switch(WorldOld[i][j]){ //Instrukcja wyboru pozwala nam wybrać dowolny kolor w zależności od liczby w komórce
      case 4:stroke(128,0,0);break;
      case 3:stroke(128,128,0);break;
      case 2:stroke(255,0,0);break;
      case 1:stroke(0,0,255);break;
      case 0:stroke(0,0,0);break;
      default: stroke(0,255,0);//To się pojawiac nie powinno
      break;
      }
      point(i,j);//Komórka to punkt na ekranie
    }

  //Po rysowaniu zmiana stanu automatu
  for(int i=0;i<WorldSize;i++)//Wiemy skądinąd że tablica jest kwadratem WolrdSize x WorldSize 
  {
       //Reguła - "ZSUMUJ Z SĄSIADAMI I WEŹ MODULO Div"
       int right = (i+1) % WorldSize;//Zamiast ignorować brzegi można zrobić liczenie indeksów sąsiadów         
       int left  = (WorldSize+i-1) % WorldSize;// ... z zawijaniem dzięki reszcie z dzielenia
       
       for(int j=0;j<WorldSize;j++) //Skoro kwadrat WolrdSize x WorldSize to po co używać .lenght ? 
       {
         int dw=(j+1) % WorldSize;   
         int up=(WorldSize+j-1) % WorldSize;
         
         int ile = WorldOld[i][j]        //Aktualna komórka
                 +WorldOld[left][j]      //w lewo od niej
                 +WorldOld[right][j]     //w prawo
                 +WorldOld[i][up]        //w górę
                 +WorldOld[i][dw]        //w dół      
                 ;//suma z pięciu komórek brana potem modulo Div
   
         WorldNew[i][j]=ile % Div;//Nowy stan zapisujemy na drugą tablicę
       }
   }
   
   //Zamiana tablic - łatwa bo nie trzeba kopiować tablic, wystarczy "uchwyty" do nich
   int[][] WorldTmp=WorldOld;
   WorldOld=WorldNew;
   WorldNew=WorldTmp;
   
   t++;//Kolejne pokolenie/krok/rok
   fill(255);//Kolor napisu
   text("ST:"+t+" Fr:"+frameRate,10,WorldSize);//frameRate podaje realną liczbę klatek na sekundę
}
