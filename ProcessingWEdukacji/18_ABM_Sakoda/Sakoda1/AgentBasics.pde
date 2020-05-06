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
      agents[a][b]=curr;
    }
}
//OR
void initializeAgents(Agent[] agents)
{
  for(int a=0;a<agents.length;a++)
  if(random(1)<density)
  {
    Agent curr=new Agent();
    agents[a]=curr;
  }
}

void  changeAgents(Agent[] agents)
{
  int MC=agents.length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,agents.length);
    if(agents[a]!= null )
    {
      //Sprawdzenie stresu
      int strangers=0;
      if(0<a-1 && agents[a-1]!=null 
      && agents[a-1].identity!=agents[a].identity)
        strangers++;
      if(a+1<agents.length && agents[a+1]!=null 
      && agents[a+1].identity!=agents[a].identity)
        strangers++;  
      agents[a].stress=strangers/2.0;  
      
      //Próba migracji gdy stres doskwiera
      if(agents[a].stress>0 
      && random(1)<agents[a].stress)
      {
        int target=(int)random(0,agents.length);
        if(agents[target]==null)//Jest miejsce
        {
          agents[target]=agents[a];//Przeprowadzka
          agents[a]=null;//Wymeldowanie ze starego miejsca
        }
      }
    }
  }  
}
//OR
void  changeAgents(Agent[][] agents)
{
  int MC=agents.length*agents[0].length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,agents.length);
    int b=(int)random(0,agents[a].length);
    if(agents[a][b]!= null )
    {
      //...
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM: BASIC INITIALISATION & EVERY STEP CHANGE
////////////////////////////////////////////////////////////////////////////////////////////////////////////
