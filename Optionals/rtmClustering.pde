/// Class for discovering clustering and calculating its statistical parameters. (rtmClustering.pde)
/// @date 2024-11-22 (last modification)
/// @note This file shoud be COPIED into the project directory and modified when needed.
//-/////////////////////////////////////////////////////////////////////////////////////////////////

/// @defgroup Statistic tools and functions
/// @{
//-////////////////////////////////////////

/// @brief Klasa służąca do odnajdywania klasteringu i obliczania jego parametrów statystycznych.
/// @details Zakładamy że agent ma pole `A` które okresla jego przynalezność.
///          Zrobienie tego bardziej ogólnie jest oczywiście możliwe, ale trzeba by użyć intefejsu
///          z funkcją, którego wywołanie kosztuje, lub jakiegoś zaawansowanej konstrukcji szablonu
///          języka JAVA.
class Clustering
{
  /*_extern*/ float CellSide=10; //!< Side of the cell nedde for clustering vizualisation.
  
  // Parametry sterujące wizualizacją badań klastrów:
  //*////////////////////////////////////////////////
  boolean UseMoore=false;
  boolean VisualClust=false;
  boolean VisualBorders=false;
  boolean VisualDiameters=false;
  
  ///Zmienne zbierajace dane statystyczne i określające ich nazwy w pliku wyjściowym.
  ///UWAGA! Za KLASTER uznawana jest grupa co najmniej 2 komórek w tym samym kolorze!
  String  NofClustersHead="NofClusters";         //!< Liczba KLASTRÓW. Nagłówek.
  int     NofClusters=0;                         //!< Liczba KLASTRÓW. Wartość.
  
  String  MnClustersSizeHead="MnClustersSize";   //!< Powierzchnia klastrów. Nagłówek.
  double  MnClustersSize=0;                      //!< Wartość średnia może być z istotną częścią ułamkową.
  
  String  MaxClustersSizeHead="MaxClustersSize"; //!<  Nagłówek.
  int     MaxClustersSize=0;                     //!<  Wartość.
  
  String  MinClustersSizeHead="MinClustersSize"; //!<  Nagłówek.
  int     MinClustersSize=111111111;             //!< Rozmiar klastrów. Wartość. Na początek dziwna liczba żeby było podejrzane jak zostanie.
  
  String  MnClustersDiamHead="MnClustersDiam";   //!< Średnica klastrów. Nagłówek.
  double  MnClustersDiam=0;                      //!< Średnica klastrów. Wartość.
  
  String  MaxClustersDiamHead="MaxClustersDiam"; //!<  Nagłówek.
  float   MaxClustersDiam=0;                     //!<  Wartość.
  
  String  MinClustersDiamHead="MinClustersDiam"; //!<  Nagłówek.
  float   MinClustersDiam=111111111;             //!<  Wartość. Dziwna liczba żeby było podejrzane jak zostanie.
  
  String  MnClustersBRatHead="MnClustersBRat";   //!< Udział brzegu w całości powierzchi klastra. Nagłówek.
  double  MnClustersBRat=0;                      //!< Udział brzegu w całości powierzchi klastra. Wartość.
  
  String  MaxClustersBRatHead="MaxClustersBRat"; //!<  Nagłówek.
  float   MaxClustersBRat=0;                     //!<  Wartość.
  
  String  MinClustersBRatHead="MinClustersBRat"; //!<  Nagłówek.
  float   MinClustersBRat=111111111;             //!<  Wartość. Dziwna liczba żeby było podejrzane jak zostanie;
  
  /// Generator nagłówka danych klastrowych.
  String  HeaderStr(String T/*Separator*/)
  {
    return NofClustersHead+T
    +MnClustersSizeHead+T
    +MaxClustersSizeHead+T
    +MinClustersSizeHead+T
    +MnClustersDiamHead+T
    +MaxClustersDiamHead+T
    +MinClustersDiamHead+T
    +MnClustersBRatHead+T
    +MaxClustersBRatHead+T
    +MinClustersBRatHead;
  }
  
  /// Generator wiersza danych klastrowych.
  String  StatsStr(String T/*Separator*/)
  {
    return NofClusters+T
    +MnClustersSize+T
    +MaxClustersSize+T
    +MinClustersSize+T
    +MnClustersDiam+T
    +MaxClustersDiam+T
    +MinClustersDiam+T
    +MnClustersBRat+T
    +MaxClustersBRat+T
    +MinClustersBRat;
  }
    
  // Zmienne służące rejestracji itd.:
  //*/////////////////////////////////
  
  Agent[][] Bak;         //!< Kopia tablicy agentów.
  int[][]   K;           //!< ???
  int       N,M;         //!< ???
  
  int LastClusterSize=0; //!< Ile komórek w ostatnio zbadanym klastrze.
  int LastClBorderReg=0; //!< Ile komórek obrzeża w ostatnio zbadanym klastrze.
  
  int RegX[];            //!< Współrzędne X zarejestrowanych komórek
  int RegY[];            //!< Współrzędne Y zarejestrowanych komórek
  
  /// This is used to test whether the cell has a "color" DIFFERENT from the specified one.
  boolean Allien(int ix, int iy,int col)
  {
      return Bak[ix][iy].A != col; //or return true; ???
  }
  
  /// Constructing a cluster observation tool.
  Clustering(Agent[][] arrayOfAgents)
  {
    Bak=arrayOfAgents;               // Zapamiętaj gdzie jest tablica źródłowa agentów. //<>// //<>//
    N=arrayOfAgents.length;
    M=arrayOfAgents[0].length;
    
    K = new int[N][M];   // Stwórz miejsce na kopie.
    
    RegX = new int[M*N]; // I miejsce na rejestr współrzednych punktów. Trochę duże.
    RegY = new int[M*N];
    
    println("Clustering calculator for "+N+"x"+M+" is ready.");
  }

  /// It simply cleans cell registry. 
  void ResetRegistry()
  {
    LastClusterSize=0;
    LastClBorderReg=0;
  }
       
  /// Registry particular cell into a cluster.     
  void RegistryCell(int x, int y,int col,boolean eight)
  {      
    boolean border=false;
    LastClusterSize++; //TODO HERE???
    
    if(Allien((x-1+N)%N,   y ,col)
    || Allien( x  ,(y-1+M)%M ,col)
    || Allien( x  ,(y+1)%M   ,col)
    || Allien((x+1)%N,     y ,col) )
    border=true;
    
    if(!border && eight)
    if(Allien((x-1+N)%N,(y-1+M)%M,col)
    || Allien((x-1+N)%N,(y+1)%M  ,col)
    || Allien((x+1)%N,(y-1+M)%M  ,col)
    || Allien((x+1)%N,(y+1)%M   ,col) )
    border=true;
    
    if(border)
    {
      RegX[LastClBorderReg]=x;
      RegY[LastClBorderReg]=y;
      LastClBorderReg++;
    }
  }
  
  /// Eight-connected recursion over clusters.
  void Seed8(int i,int j,int oldcol,int newcol)
  {
    if(K[i][j]!=oldcol) return; // Warunek stopu.
    
    K[i][j]=newcol;
    RegistryCell(i,j,oldcol,true);
    
    Seed8((i-1+N)%N,(j-1+M)%M,oldcol,newcol);
    Seed8((i-1+N)%N,   j    ,oldcol,newcol);
    Seed8((i-1+N)%N,(j+1)%M,oldcol,newcol);
  
    Seed8( i  ,(j-1+M)%M ,oldcol,newcol);
    Seed8( i  ,(j+1)%M   ,oldcol,newcol);
    
    Seed8((i+1)%N,(j-1+M)%M,oldcol,newcol);
    Seed8((i+1)%N,     j  ,oldcol,newcol);
    Seed8((i+1)%N,(j+1)%M,oldcol,newcol);
  }
  
  /// Four-connected recursion over clusters.
  void Seed4(int i,int j,int oldcol,int newcol)
  {
    if(K[i][j]!=oldcol) return; // Warunek stopu
    
    K[i][j]=newcol;
    RegistryCell(i,j,oldcol,false);
    
    Seed4((i-1+N)%N,   j  ,oldcol,newcol);
    Seed4( i  , (j-1+M)%M ,oldcol,newcol);
    Seed4( i  , (j+1)%M   ,oldcol,newcol);
    Seed4((i+1)%N,     j  ,oldcol,newcol);
  }
  
  /// Marking the boundary of the most recently found cluster.
  void LastClDrawBorder()
  {
    if(LastClBorderReg<=1) return;
    
    fill(128,128,0,100);
    stroke(0,0);
    //println(LastClBorderReg);
    for(int i=0;i<LastClBorderReg;i++)
    {
      rect(RegX[i]*CellSide,RegY[i]*CellSide,CellSide,CellSide);
    }
    stroke(0,255);
  }
  
  float LastClDiameter()
  {
    boolean ThrTorus=false;
    float max=0; // Maksymalna "średnica"
    int imax=-1; // od którego
    int jmax=-1; // do którego agenta
   
   // za sprytna podwójna pętla: 
   // for(int i=0;i<LastClBorderReg-1;i++)
   // for(int j=i+1;j<LastClBorderReg;j++)
   
   // mniej sprytna podwójna pętla.
    for(int i=0;i<LastClBorderReg;i++)
     for(int j=0;j<LastClBorderReg;j++)
     if(i!=j)
    {
      boolean LocalThrTorus=false;
      float X,Y;
      if(RegX[i]>RegX[j])
        X=RegX[i]-RegX[j];
      else
        X=RegX[j]-RegX[i];
        
      if(RegY[i]>RegY[j])  
        Y=RegY[i]-RegY[j];
      else
        Y=RegY[j]-RegY[i];
      
      // Uwzględnienie torusa w liczeniu odległości
      if(X>float(N)/2.0) 
          {X=N-X;LocalThrTorus=true;}
      if(Y>float(M)/2.0) 
          {Y=M-Y;LocalThrTorus=true;} //println("!"+M+" Y:"+Y);
      float pom=X*X+Y*Y;
      if(pom>0)
      {
        pom=sqrt(pom);
        if(pom>max)
        {
            max=pom;
            imax=i;
            jmax=j; 
            ThrTorus=LocalThrTorus;
        }
      } 
    }
    
    if(VisualDiameters && imax!=-1 && jmax!=-1 )
    {
      if(ThrTorus)
       { stroke(0,255,255);fill(0,255,255);}
      else
       { stroke(0,0,0); fill(0,0,0);}
      //println("D:"+max+" X:"+X+" Y:"+Y+" T:"+ThrTorus);
      line(RegX[imax]*CellSide+CellSide/2,RegY[imax]*CellSide+CellSide/2,RegX[jmax]*CellSide+CellSide/2,RegY[jmax]*CellSide+CellSide/2);
      text("d="+max,int(RegX[imax]*CellSide+RegX[jmax]*CellSide)/2,int(RegY[imax]*CellSide+RegY[jmax]*CellSide)/2);
    }
    
    fill(0,0,0); 
    stroke(0,0,0);
    return max;
  }
  
  /// Calculates statistics and visualizes clusters, their edges and diameters as needed.
  void Calculate()
  { 
    // Liczba KLASTRÓW
    NofClusters=0;
    
    // Powierzchnia klastrów
    MnClustersSize=0;
    MaxClustersSize=0;
    MinClustersSize=99999999; // Dziwna liczba żeby było podejrzane jak zostanie.
    
    // Średnica klastrów
    MnClustersDiam=0;
    MaxClustersDiam=0;
    MinClustersDiam=99999999; // Dziwna liczba żeby było podejrzane jak zostanie.
    
    // Udział brzegu w całości powierzchi klastra.
    MnClustersBRat=0;
    MaxClustersBRat=0;
    MinClustersBRat=99999999; // Dziwna liczba żeby było podejrzane jak zostanie.
    
    // Kopiowanie danych.
    for(int i=0;i<K.length;i++)
      for(int j=0;j<K[i].length;j++)
         K[i][j]=(int)Bak[i][j].A;
         
    // Szukanie klastrów, liczenie statystyk i automatycznie wypełnianie mapy klastrów.     
    int Kolor=1;
    for(int i=0;i<K.length;i++)
      for(int j=0;j<K[i].length;j++)   
      if(K[i][j]>=0) // Jak jeszcze nie jest wypełniony.
      {
         ResetRegistry();
         Kolor=(Kolor+1235711)%0xFFFFFF;
         if(UseMoore) // Wypełnia ujemną wersją wybranego koloru .
           Seed8(i,j,K[i][j],-Kolor);
         else
           Seed4(i,j,K[i][j],-Kolor);
         if(VisualBorders) LastClDrawBorder();
         if(LastClusterSize<=1) //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                 continue;      // "Klastry" jednoelelementowe nas nie interesują!
                                //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
         float Diam=LastClDiameter();
         
         // Liczba KLASTRÓW.
         NofClusters++;
         
         // Powierzchnia klastrów.
         MnClustersSize+=LastClusterSize;
         if(MaxClustersSize<LastClusterSize) MaxClustersSize=LastClusterSize;
         if(MinClustersSize>LastClusterSize) MinClustersSize=LastClusterSize;
         
         // Średnica klastrów.
         MnClustersDiam+=Diam;
         if(MaxClustersDiam<Diam) MaxClustersDiam=Diam;
         if(MinClustersDiam>Diam) MinClustersDiam=Diam;
         
         // Udział brzegu w całości powierzchi klastra.
         float Ratio=float(LastClBorderReg)/float(LastClusterSize);
         MnClustersBRat+=Ratio;
         if(MaxClustersBRat<Ratio) MaxClustersBRat=Ratio;
         if(MinClustersBRat>Ratio) MinClustersBRat=Ratio;
      }
    
    // Uśrednianie dotychczasowych sum.     
    MnClustersSize/=NofClusters;
    MnClustersDiam/=NofClusters;
    MnClustersBRat/=NofClusters;
    
    // Wizualizacja:
    if(VisualClust)
     for(int i=0;i<K.length;i++)
      for(int j=0;j<K[i].length;j++)
      {
         int pom=-K[i][j];
         fill(pom & 0x000000FF, (pom & 0x0000FF00)>>8, (pom & 0x00FF0000)>>16,128);
         rect(i*CellSide,j*CellSide,CellSide,CellSide);
      }
  }
}

//*////////////////////////////////////////////////////////////////////////////////
//* 2013,2017,2022 (c) Wojciech Tomasz Borkowski  http://borkowski.iss.uw.edu.pl
/// @}
//*////////////////////////////////////////////////////////////////////////////////
