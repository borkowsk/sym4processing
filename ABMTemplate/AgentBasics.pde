//* Agent is a one of two central class of each ABM model
//* ABM: BASIC INITIALISATION & EVERY STEP CHANGE
/// Agents need to be initialised & they need logic of change. 
//*//////////////////////////////////////////////////////////////

/// Initialization of agents (2D version).
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
/// Initialization of agents (1D version).
void initializeAgents(Agent[] agents)
{
  for(int a=0;a<agents.length;a++)
  if(random(1)<density)
  {
    Agent curr=new Agent();
    agents[a]=curr;
  }
}

/// Example changes of agents (2D version).
/// Random changes of agents for testing the visualization. 
void  dummyChangeAgents(Agent[][] agents)
{
  int MC=agents.length*agents[0].length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,agents.length);
    int b=(int)random(0,agents[a].length);
    if(agents[a][b]!= null )
      agents[a][b].dummy+=random(-0.1,0.1);
  }
}

//OR 

/// Example changes of agents (1D version).
/// Random changes of agents for testing the visualization.
void  dummyChangeAgents(Agent[] agents)
{
  int MC=agents.length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,agents.length);
    if(agents[a]!= null )
      agents[a].dummy+=random(-0.1,0.1);
  }  
}

//* Implement model rules below
//*///////////////////////////////////////////////

/// Real changes of agents (2D version).
/// Typically agents change over time.
/// User code is needed here.
void  changeAgents(Agent[][] agents)
{
  int MC=agents.length*agents[0].length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,agents.length);
    int b=(int)random(0,agents[a].length);
    if(agents[a][b]!= null )
    {
      //... PLACE FOR YOUR CODE
    }
  }
}
//OR 
/// Real changes of agents (1D version).
/// Typically agents change over time.
/// User code is needed here.
void  changeAgents(Agent[] agents)
{
  int MC=agents.length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,agents.length);
    if(agents[a]!= null )
    {
      //... PLACE FOR YOUR CODE
    }
  }  
}

//*////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
