//Control parameters
float RatioA=0.50; //How many "ones" in the array
float RatioB=0.25;
int N=50;       //array side

//for visualisation
int S=18;       //cell width & height
boolean ready=true;//help for do one step at a time
int step=0;

//2D "World" of individuals
int A[][] = new int[N][N];
boolean B[][] = new boolean[N][N];

//Initialisation
void setup()
{
  size(N*S,N*S);
  smooth();
  frameRate(30); //maximize speed
  
  for(int i=0;i<N;i++)
   for(int j=0;j<N;j++)
    if( random(0,1) < RatioA )
     A[i][j]=1;
    else
     A[i][j]=0;
     
  for(int i=0;i<N;i++)
   for(int j=0;j<N;j++)
    if( random(0,1) < RatioB )
     B[i][j]=true;
    else
     B[i][j]=false;
}

//Running - visualisation and dynamics
void draw()
{
 
 for(int i=0;i<N;i++)
 {
  for(int j=0;j<N;j++)
  {
    if(A[i][j]==1)
      fill(255,0,0);
    else
      fill(255);
         
    rect(i*S,j*S,S,S);
    
    if(B[i][j])
      fill(0,255,0);
    else
      fill(0,0,255);
      
    ellipse(i*S+S/2,j*S+S/2,S/3,S/3);
   }
 }  
  if(step%10==0) println(frameRate+" "+step);
  DoMonteCarloStep();
  /*
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
  */
}


void DoMonteCarloStep()
{
   for(int a=0;a<N*N;a++) //as many times as number of cells 
   {
     int i=int(random(N));
     int j=int(random(N));
     
     int support=0;
     for(int m=i-1;m<=i+1;m++)
      for(int n=j-1;n<=j+1;n++)
      {
        int p=(m+N)%N;
        int r=(n+N)%N;
        if(A[p][r]==A[i][j])
           support++;
      }
  
     if(B[i][j])
     {
      if(support>=5)
      {
      if(A[i][j]==1)
       A[i][j]=0;
       else
       A[i][j]=1;
      }
     }
     else
     if(support<5)
      {
      if(A[i][j]==1)
       A[i][j]=0;
       else
       A[i][j]=1;
      }    
   }
   step++;
}
