//Model dynamicznego wpływu społecznego Nowaka-Latane 
// - wersja "komórkowa" ze zróżnicowaniem sił
//////////////////////////////////////////////////////
//Control parameters
int N=200;       //array side
float init=0.010; //How many starts in the array
float SeedsPerSt=0.005;

//For visualisation
int S=20;       //cell width & height

//2D "World" of individuals
int A[][] = new int[N][N];
int P[][] = new int[N][N];

//Variables for initialisation
int initcounter=0;//Ile juz wylosowano
int initnakrok=0;//Ile w jednym kroku

//Initialisation
void setup()
{
  size(805,805);
  S=width/N; //Agent side size
 
  for(int i=0;i<N;i++)
   for(int j=0;j<N;j++)
   {
    A[i][j]=0;
    P[i][j]=(int)random(256);
   }
  
  initcounter=int(N*N*init);//Ile będzie w ogóle nasion?  
  initnakrok=int(N*N*SeedsPerSt);//A ile nasion w jednym kroku
  
  frameRate(2);//Nie za szybko
}

void exit() //it is called whenever a window is closed. 
{
  noLoop(); //To be sure / dla pewności ;-)
  println("Thank You");
  super.exit(); //What library superclass have to do at exit
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
        impact+=A[p][r]*P[p][r];
      }
  
     if(impact!=0)//Nothing to do when 0
     {
      if(impact>=0)//Majority rule
       A[i][j]=1;
       else
       A[i][j]=-1;
     }
   }
   Step++;//Counting of steps
}

int Reds=0,Black=0,White=0;
void Count()
{
  Reds=0;White=0;Black=0;
  for(int i=0;i<N;i++)
   for(int j=0;j<N;j++)
     if(A[i][j]==0)
       Black++;
     else
     if(A[i][j]==1)
       Reds++;
     else
       White++;
}

//Running - visualisation, stats and dynamics
void draw()
{
 for(int i=0;i<N;i++)//visualisation
  for(int j=0;j<N;j++)
  {
    int power=P[i][j];
    if(A[i][j]==0)
    {
      fill(power,power,0);
    }
    else
    if(A[i][j]==1)
    {
      fill(power,0,0);
    }
    else
    {
      fill(power);
    }
    rect(i*S,j*S,S,S);
  }  
  
  Count();//Statistics
  println("Step "+Step+" Reds="+Reds+" White="+White+" Black="+Black);
  DoMonteCarloStep();//dynamics
  
  //Losowanie nasion
  for(int c=0;c<initnakrok;c++)
  if(initcounter>0)
  {
    int i=int(random(N));
    int j=int(random(N));
    if(initcounter%2==0) //Dla parzystych -1
     A[i][j]=-1;
    else
     A[i][j]=1;
    initcounter--; 
  }
}
