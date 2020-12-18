//Control parameters
float Ratio=0.35; //How many "ones" in the array
int N=20;       //array side

//for visualisation
int S=15;       //cell width & height
boolean ready=true;//help for do one step at a time

//2D "World" of individuals
int A[][] = new int[N][N];

//Initialisation
void setup()
{
  size(N*S,N*S);
  
  for(int i=0;i<N;i++)
   for(int j=0;j<N;j++)
    if( random(0,1) < Ratio )
     A[i][j]=1;
    else
     A[i][j]=0;
}

//Running - visualisation and dynamics
void draw()
{

 for(int i=0;i<N;i++)
 {
  for(int j=0;j<N;j++)
  {
    if(A[i][j]==1)
    {
      fill(255,0,0);
    }
    else
    {
      fill(255);
    }
    rect(i*S,j*S,S,S);
   }
 }  
  
  //DoMonteCarloStep();
  
  if(mousePressed==true)
  {
    if(ready==true)
    {
      DoMonteCarloStep();
      ready=false;
    }
  }
  else
  {
    ready=true;
  }
}


void DoMonteCarloStep()
{
   for(int a=0;a<N*N;a++) //as many times as number of cells 
   {
     int i=int(random(N));
     int j=int(random(N));
     
     int impact=0;
     for(int m=i-1;m<=i+1;m++)
      for(int n=j-1;n<=j+1;n++)
      {
        int p=(m+N)%N;
        int r=(n+N)%N;
        impact+=A[p][r];
      }
  
     if(impact>=5)
       A[i][j]=1;
       else
       A[i][j]=0;    
   }
}
