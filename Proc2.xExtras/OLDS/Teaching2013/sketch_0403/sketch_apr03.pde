//Control parameters for the model
float RatioA=0.5; //How many "reds" in the array
float RatioB=0.5; //How many individualist in the array
int N=50;       //array side

//2D "World" of individuals
int A[][] = new int[N][N];
boolean B[][] = new boolean[N][N];

//for flow and speed control of the program
int StepCounter=0;//!!!
int M=1;         //How often we draw visualization and calculate statistics
int Frames=10;    //How many frames per sec. we would like(!) to call.
boolean Running=true;

//for visualization
int S=13;       //cell width & height
int StatusHeigh=13; //For status line below cells

//For step by step model changing 
//COMMENTED OUT!
//boolean steponclick=false; //Do step on mouse click or automatically
boolean ready=true;//help for do one step at a time

//Statistics
int  Ones=0;
int  Zeros=0;
int  Conformist=0;
int  Nonconformist=0;

float Stress=0;
float ConfStress=0;
float NConStress=0;

float  Dynamics=0;//How many changes?
float  ConfDynamics=0;
float  NConDynamics=0;

Clustering ClStat;

PrintWriter output;//For writing statistics into disk drive

void setup() //Window and model initialization
{
  noSmooth(); //Fast visualization
  frameRate(Frames); //maximize speed
  textSize(StatusHeigh);
  size(N*S,N*S+StatusHeigh);
  ClStat= new Clustering(A);
  
  output = createWriter("Statistics.log"); // Create a new file in the sketch directory
  
  DoModelInitialisation();
}

void exit() //it is called whenever a window is closed. 
{
  noLoop();        //For to be sure...
  delay(100);      // it is possible to close window when draw() is still working!
  output.flush();  // Writes the remaining data to the file
  output.close();  // Finishes the file
  println("Thank You");
  super.exit(); //What library superclass have to do at exit
} 

void draw() //Running - visualization, statistics and model dynamics
{
  if(StepCounter%M==0 || !Running ) //Do it every M-th step 
  {
    background(128); //Clear the window
    DoDraw();
    DoStatistics();
  }
  if(keyPressed)
  {
    if(ready)
    {
     switch(key){
     case '8': ClStat.UseMoore=true; break;
     case '4': ClStat.UseMoore=false; break;  
     case 'C':
     case 'c': ClStat.Visualise=! ClStat.Visualise; break;
     case 'S':
     case 's': Running=false; break;
     case 'R': 
     case 'r': Running=true; break;
     }
     ready=false;
    } 
  }
  else ready=true;
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
  if(Running) 
    DoMonteCarloStep();
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
    {
     B[i][j]=true;
     Nonconformist++;
    }
    else
    {
     B[i][j]=false;
     Conformist++;
    } 
}

void DoMonteCarloStep()
{
   Dynamics=0;//How many changes?
   ConfDynamics=0;
   NConDynamics=0;
   
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
      NConDynamics++;
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
      ConfDynamics++;
      if(A[i][j]==1)
       A[i][j]=0;
       else
       A[i][j]=1;
      }    
   }
   
   Dynamics/=(N*N);
   NConDynamics/=Nonconformist;
   ConfDynamics/=Conformist;   
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
      
    ellipse(i*S+S/2,j*S+S/2,S/2,S/2);
   }
 }  
}

void Count()
{
  Ones=0;
  Zeros=0;
  Stress=0;
  ConfStress=0;
  NConStress=0;
  
  for(int i=0;i<N;i++)
   for(int j=0;j<N;j++)
   {
    if(A[i][j]==1)
      Ones++;
      else
      Zeros++;
    
     int LStress=0;
     for(int m=i-1;m<=i+1;m++)
      for(int n=j-1;n<=j+1;n++)
      {
        int p=(m+N)%N;
        int r=(n+N)%N;
        if(A[p][r]!=A[i][j])
           LStress++;
      }  
      
      Stress+=LStress/8.0;  
      
      if(B[i][j])
          NConStress+=LStress/8.0;
          else
          ConfStress+=LStress/8.0;
   }
   
   Stress/=(N*N);
   NConStress/=Nonconformist;
   ConfStress/=Conformist;
}

void DoStatistics() //Calculate and print statistics, maybe also into text file
{ 
  if(StepCounter==0)// Write the headers to the file only once
     output.println("StepCounter \t Dynamics  \t ConfDynamics \t NConDynamics \t  Zeros \t  Ones \t Stress \t ConfStress \t NConStress \t frameRate"); 

  Count(); //Calculate the after step statistics 
  ClStat.Calculate(); //Calculate quite complicate cluster statistics
  String  Stats=StepCounter+"\t "+Dynamics+"\t "+ConfDynamics+"\t "+NConDynamics+"\t "+Zeros+"\t "+Ones+"\t "+Stress+"\t "+ConfStress+"\t "+NConStress+"\t "+frameRate;
  fill(0,0,0);            //Color of text (!) on the window
  text(Stats,1,S*(N+1)+1);//Print the statistics on the window
  if(Running)
  {
    println(Stats);        // Write the statistics to the console
    output.println(Stats); // Write the statistics to the file
  }
}
