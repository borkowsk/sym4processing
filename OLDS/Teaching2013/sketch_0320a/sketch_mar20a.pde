//Control parameters
float Ones=0.1; //How many "ones" in the array
int N=10;       //array side

//
int S=20;       //cell width & height
boolean ready=true;//help for do one step at a time

//2D "World" of individuals
int A[][] = new int[N][N];

//Initialisation
void setup()
{
  //size(N*S,N*S); //NIE DZIAŁA W TRUBIE JavaScript!!!
  size(200,200);
  for(int i=0;i<N;i++)
   for(int j=0;j<N;j++)
   if( random(0,1) < Ones )
    A[i][j]=1;
    else
    A[i][j]=0;
}

//Running - visualisation and dynamics
void draw()
{

 for(int i=0;i<N;i++)
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
     if(A[i][j]==1)
       A[i][j]=0;
       else
       A[i][j]=1;    
   }
}
