// Agent is a one of two central class of each ABM model
// Agent need to be initialised & they need logic of change 
///////////////////////////////////////////////////////////////

void initializeAgents(Agent[][] agents)
{
   for(int a=0;a<agents.length;a++)
    for(int b=0;b<agents[a].length;b++)
      if(random(1)<density)
      {
        Agent curr=new Agent();
        //DODATKOWY KOD INICJALIZACJI AGENTÓW, np. curr.initialise();
        liveCount++;
        agents[a][b]=curr;
      }
      
   //Inicjowanie infekcji od środka
   if(agents[agents.length/2][agents.length/2]==null)//Gdyby go nie było
   {
      agents[agents.length/2][agents.length/2]=new Agent();
      liveCount++;
   }
   agents[agents.length/2][agents.length/2].state=Infected;
}
//OR
void initializeAgents(Agent[] agents)
{
  for(int a=0;a<agents.length;a++)
    if(random(1)<density)
    {
      Agent curr=new Agent();
      //DODATKOWY KOD INICJALIZACJI AGENTÓW, np. curr.initialise();
      liveCount++;
      agents[a]=curr;
    }
   
   //Inicjowanie infekcji od środka
   if(agents[agents.length/2]==null)//Gdyby go nie było
   {
      agents[agents.length/2]=new Agent();
      liveCount++;
   }
   
   //Inicjowanie infekcji od środka
   if(agents[agents.length/2]==null)//Gdyby go nie było
   {
      agents[agents.length/2]=new Agent();
      liveCount++;
   }
   agents[agents.length/2].state=Infected;
}

void  agentsChange(Agent[] agents)//przerobiona z dummyChangeAgents()
{
  int MC=agents.length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,agents.length);
    if(agents[a]!= null )
    {
      //agents[a].dummy+=random(-0.1,0.1);//PRZYKŁADOWA ZMIANA
    }
  }  
}

//OR

void  agentsChange(Agent[][] agents)//przerobiona z dummyChangeAgents()
{
  int MC=agents.length*agents[0].length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,agents.length);//agents[a].lenght na wypadek gdyby nam przyszło
    int b=(int)random(0,agents[a].length);// do głowy zrobić prostokąt
    if(agents[a][b]!= null )
    {
       //Jesli pusty lub zdrowy to nic nie robimy
       if(agents[a][b].state<Infected || Recovered<=agents[a][b].state) 
          continue;
       
       //Wyliczenie lokalizacji sąsiadów
       int dw=(a+1) % agents.length;   
       int up=(agents.length+a-1) % agents.length;
       int right = (b+1) % agents[a].length;//MOŻE BYĆ INNE NIŻ agents.lenght      
       int left  = (agents[a].length+b-1) % agents[a].length;//JEŚLI PROSTOKĄT

       if(agents[a][left]!=null
       && agents[a][left].state==Susceptible && random(1) < PTransfer) 
         {agents[a][left].state=Infected; sumInfected++;}
        
       if(agents[a][right]!=null
       && agents[a][right].state==Susceptible && random(1) < PTransfer) 
         {agents[a][right].state=Infected; sumInfected++;}
        
       if(agents[up][b]!=null
       && agents[up][b].state==Susceptible && random(1) < PTransfer) 
         {agents[up][b].state=Infected; sumInfected++;}
        
       if(agents[dw][b]!=null
       && agents[dw][b].state==Susceptible && random(1) < PTransfer) 
         {agents[dw][b].state=Infected; sumInfected++;}

       float prob=random(1);//Los na dany dzień
       
       if(prob<PDeath) //Albo tego dnia umiera
        {agents[a][b]=null;sumDeath++;liveCount--;}
        else
        {
          //Albo jest wyleczony
          if(++(agents[a][b].state)==Recovered)
              sumRecovered++;
          //else //NADAL CIERPI!
        }
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM: BASIC INITIALISATION & EVERY STEP CHANGE
////////////////////////////////////////////////////////////////////////////////////////////////////////////
