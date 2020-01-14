// Majority vs. minority rule in Ising like model
///////////////////////////////////////////////////////////
//Control parameters
int MajorityRule=1;//If 1 then MajorityRule but if -1 then MinorityRule
int N=50;          //Array side
float Ones=0.50;   //How many "ones" in the array
float Noise=0.01;  //How often change spontanously

//2D "World" of individuals
int A[][] = new int[N][N];

//File "handler" for writing statistics into disk drive
PrintWriter output;

int S=0;       //cell width & height (for visualisation)
void setup()   //Initialisation
{
  size(600,600);
  S=width/N;   //Initilise S depend of window size
  frameRate(5);//Not to fast
  
  //Initialisation of the "World"
  for(int i=0;i<N;i++)
   for(int j=0;j<N;j++)
   if( random(0,1) < Ones )
    A[i][j]=1;
    else
    A[i][j]=-1;
  
  output = createWriter("Statistics.log");//Create a new file in the sketch directory 
}

void exit() //it is called whenever a window is closed. 
{
  noLoop();
  output.flush();  // Writes the remaining data to the file
  output.close();  // Finishes the file
  println("Thank You");
  super.exit(); //What library superclass have to do at exit
} 

//Running - visualisation and dynamics
void draw()
{
 for(int i=0;i<N;i++)//visualisation
  for(int j=0;j<N;j++)
  {
    if(A[i][j]==1)
      fill(255,0,0);
    else
      fill(255);
    rect(i*S,j*S,S,S);
  }  
  
  Count();//Do statistics
  
  println("Step "+Step+" Reds="+Reds+" White="+(N*N-Reds));//window
  output.println("Step\t"+Step+"\tReds\t"+Reds+"\tWhite\t"+(N*N-Reds));//log
  
  DoMonteCarloStep();//Do model dynamics
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
   for(int a=0;a<N*N;a++) //as many times as number of cells (M C step)
   {
     int i=int(random(N));
     int j=int(random(N));
         
     if(random(1.0)<Noise)//NOISE IN USE
     {
       A[i][j]=-A[i][j];//spontanic swith
     }
     else
     {
       int impact=0; //Calculate summ of impacts
       for(int m=i-1;m<=i+1;m++)
        for(int n=j-1;n<=j+1;n++)
        {
          int p=(m+N)%N;
          int r=(n+N)%N;
          impact+=A[p][r];
        }
        
       if(impact>=0) //Variable MajorityRule is equal 1 or -1,
         A[i][j]=1*MajorityRule;// so it can change sign of output
         else
         A[i][j]=-1*MajorityRule;// so it can change sign of output
     }
    }
   Step++;//Counting of steps
}