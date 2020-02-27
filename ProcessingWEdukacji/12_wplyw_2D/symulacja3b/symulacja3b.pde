//Control parameters
float Ones=0.5; //How many "ones" in the array
int N=41;       //array side

//For visualisation
int S=20;       //cell width & height

//2D "World" of individuals
int A[][] = new int[N][N];

//Initialisation
void setup()
{
  size(505,505);
  S=width/N;
  frameRate(100);//Nie za szybko
  for(int i=0;i<N;i++)
   for(int j=0;j<N;j++)
   if( random(0,1) < Ones )
    A[i][j]=1;
    else
    A[i][j]=-1;
}

int Step=0;
void DoMonteCarloStep()//Implementation of dynamic
{
   println("Step "+Step);
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
  
     if(impact>=0)//Minority rule -> Reversed reaction!!!
       A[i][j]=-1;
       else
       A[i][j]=1;    
   }
   Step++;//Counting of steps
}

//Running - visualisation and dynamics
int frame=0;
void draw()
{
 //print((frame++)+" ");//Counting of frames
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
  
  DoMonteCarloStep();//dynamics
 /*  
  if(mousePressed==true)//if something on input
  {
      DoMonteCarloStep();//dynamics
      mousePressed=false;//A jakby to wykomentować?
  } */
}
