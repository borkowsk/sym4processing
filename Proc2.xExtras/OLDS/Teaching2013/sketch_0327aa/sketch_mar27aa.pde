//Control parameters for the model
float RatioA=0.50; //How many "reds" in the array
float RatioB=0.33; //How many individualist in the array
int N=50;       //array side

//2D "World" of individuals
int A[][] = new int[N][N];
boolean B[][] = new boolean[N][N];

//for flow and speed control of the program
int StepCounter=0;//!!!
int M=1;         //How often we draw visualization and calculate statistics
int Frames=1;    //How many frames per sec. we would like(!) to call.

//for visualization
int S=13;       //cell width & height
int StatusHeigh=20; //For status line below cells

//For step by step model changing 
//COMMENTED OUT!
//boolean steponclick=false; //Do step on mouse click or automatically
//boolean ready=true;//help for do one step at a time

//Statistics
int  Ones=0;
int  Zeros=0;
int  Dynamics=0;//How many changes?

void setup() //Window and model initialization
{
  noSmooth(); //Fast visualization
  frameRate(Frames); //maximize speed
  textSize(StatusHeigh);
  //size(N*S,N*S+StatusHeigh);//Nie działa w JavaScripcie
  size(660,680);
  DoModelInitialisation();
}

void draw() //Running - visualization, statistics and model dynamics
{
  if(StepCounter%M==0) //Do it every M-th step 
  {
    background(128); //Clear the window
    DoDraw();
    DoStatistics();
  }
 /* COMMENTED OUT!
  if(steponclick)
  {
   if(mousePressed==true)
   {
    if(ready==true)
    {
      DoMonteCarloStep();
      ready=false;
    }
   }
   else ready=true;
  }
  else */  
  DoMonteCarloStep();
}

void exit() //it is called whenever a window is closed. 
{
  noLoop();
  println("Thank You");
  super.exit(); //What library superclass have to do at exit
} 

void DoModelInitialisation()
{
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

void DoMonteCarloStep()
{
   Dynamics=0;//How many changes?
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
      Dynamics++;
      if(A[i][j]==1)
       A[i][j]=0;
       else
       A[i][j]=1;
      }
     }
     else
     if(support<5)
      {
      Dynamics++;
      if(A[i][j]==1)
       A[i][j]=0;
       else
       A[i][j]=1;
      }    
   }
   
   StepCounter++; //Step done
}


void DoDraw() //Visualize the cells or agents
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
}

void Count()
{
  Ones=0;
  Zeros=0;
  for(int i=0;i<N;i++)
   for(int j=0;j<N;j++)
    if(A[i][j]==1)
      Ones++;
      else
      Zeros++;
}

void DoStatistics() //Calculate and print statistics, maybe also into text file
{
  Count();
  String Stats="#\t "+StepCounter+"\t "+Dynamics+"\t "+Zeros+"\t "+Ones+"\t "+frameRate;
  fill(0,0,0);
  text(Stats,2,S*(N+1)+1);
  println(Stats);
}
