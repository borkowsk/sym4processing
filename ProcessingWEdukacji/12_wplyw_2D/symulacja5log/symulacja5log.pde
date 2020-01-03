//Control parameters
float Ones=0.55; //How many "ones" in the array
int N=50;       //array side

//For visualisation
int S=20;       //cell width & height

//For writing statistics into disk drive
PrintWriter output;

//2D "World" of individuals
int A[][] = new int[N][N];

//Initialisation
void setup()
{
  size(505,505);
  S=width/N;
  frameRate(10);//Nie za szybko
  // Create a new file in the sketch directory
  output = createWriter("Statistics.log"); 
  for(int i=0;i<N;i++)
   for(int j=0;j<N;j++)
   if( random(0,1) < Ones )
    A[i][j]=1;
    else
    A[i][j]=-1;
}

void exit() //it is called whenever a window is closed. 
{
  noLoop();
  output.flush();  // Writes the remaining data to the file
  output.close();  // Finishes the file
  println("Thank You");
  super.exit(); //What library superclass have to do at exit
} 

int Reds=0;
void Count()
{
  Reds=0;
  for(int i=0;i<N;i++)
   for(int j=0;j<N;j++)
     if(A[i][j]==1)
       Reds++;
}

int Step=0;
void DoMonteCarloStep()//Implementation of dynamic
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
  
     if(impact>=0)//Majority rule
       A[i][j]=1;
       else
       A[i][j]=-1;    
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
  
  Count();//Statistics
  println("Step "+Step+" Reds="+Reds+" White="+(N*N-Reds));
  output.println("Step\t"+Step+"\tReds\t"+Reds+"\tWhite\t"+(N*N-Reds));
  DoMonteCarloStep();//dynamics
 /*  
  if(mousePressed==true)//if something on input
  {
      DoMonteCarloStep();//dynamics
      mousePressed=false;//A jakby to wykomentować?
  } */
}