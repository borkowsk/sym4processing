//Control parameters
float Ones=0.5; //How many "ones" in the array
int N=10;       //array side

//For visualisation
int S=20;       //cell width & height
boolean ready=true;//help for do one step at a time

//2D "World" of individuals
int A[][] = new int[N][N];

//Initialisation
void setup()
{
  size(200,200);
  S=width/N;
  
  for(int i=0;i<N;i++)
   for(int j=0;j<N;j++)
   if( random(0,1) < Ones )
    A[i][j]=1;
    else
    A[i][j]=-1;
}

void DoMonteCarloStep()//Implementation of model dynamic
{
   for(int a=0;a<N*N;a++) //as many times as number of cells 
   {
     int i=int(random(N));
     int j=int(random(N));
     
     int impact=0; //Calculate summ of impacts
     for(int m=i-1;m<=i+1;m++)
      for(int n=j-1;n<=j+1;n++)
      {
        int p=(m+N)%N;
        int r=(n+N)%N;
        impact+=A[p][r];
      }
  
     if(impact>=0)//Never 0 for Moore!
       A[i][j]=1;
       else
       A[i][j]=-1;    
   }
}

//Running - visualisation and dynamics
void draw()
{
 for(int i=0;i<N;i++)//visualisation
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
  
  if(mousePressed==true)//if something on input
  {
    if(ready==true)//Is it needed?
    {
      DoMonteCarloStep();//dynamics
      ready=false;
    }
  }
  else
  {
    ready=true;
  }
}
