class Clustering
{
  boolean UseMoore=true;
  boolean Visualise=false;
  int[][] K; 
  int[][] Bak;
  int N,M;

  Clustering(int[][] P)
  {
    Bak=P;              //Zapamiętaj gdzie jest tablica źródłowa
    N=P.length;
    M=P[0].length;
    K = new int[N][M];  //Stwórz miejsce na kopie
  }
  
  void Seed8(int i,int j,int oldcol,int newcol)
  {
    if(K[i][j]!=oldcol) return; //Warunek stopu
    K[i][j]=newcol;
    
    Seed8((i-1+N)%N,(j-1+M)%M,oldcol,newcol);
    Seed8((i-1+N)%N,   j    ,oldcol,newcol);
    Seed8((i-1+N)%N,(j+1)%M,oldcol,newcol);
  
    Seed8( i  ,(j-1+M)%M ,oldcol,newcol);
    Seed8( i  ,(j+1)%M   ,oldcol,newcol);
    
    Seed8((i+1)%N,(j-1+M)%M,oldcol,newcol);
    Seed8((i+1)%N,     j  ,oldcol,newcol);
    Seed8((i+1)%N,(j+1)%M,oldcol,newcol);
  }
  
  void Seed4(int i,int j,int oldcol,int newcol)
  {
    if(K[i][j]!=oldcol) return; //Warunek stopu
    K[i][j]=newcol;
    
    Seed4((i-1+N)%N,   j  ,oldcol,newcol);
    Seed4( i  , (j-1+M)%M ,oldcol,newcol);
    Seed4( i  , (j+1)%M   ,oldcol,newcol);
    Seed4((i+1)%N,     j  ,oldcol,newcol);
  }
  
  void Calculate()
  { //Kopiowanie
    for(int i=0;i<K.length;i++)
      for(int j=0;j<K[i].length;j++)
         K[i][j]=Bak[i][j];
         
    //Wypełnianie     
    int Kolor=1;
    for(int i=0;i<K.length;i++)
      for(int j=0;j<K[i].length;j++)   
      if(K[i][j]>=0) //Jak jeszcze nie jest wypełniony
      {
         Kolor=(Kolor+1235711)%0xFFFFFF;
         if(UseMoore) //Wypełnia ujemną wersją wybranego koloru 
           Seed8(i,j,K[i][j],-Kolor);
         else
           Seed4(i,j,K[i][j],-Kolor);
      }
         
    //Wizualizacja
    if(Visualise)
     for(int i=0;i<K.length;i++)
      for(int j=0;j<K[i].length;j++)
      {
         int pom=-K[i][j];
         fill(pom & 0x000000FF, (pom & 0x0000FF00)>>8, (pom & 0x00FF0000)>>16,128);
         rect(i*S,j*S,S,S);
      }
  }
}
