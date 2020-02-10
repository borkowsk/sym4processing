String modelName="ModelTemplate";


void initializeAgents(Agent[][] agents)
{
   for(int a=0;a<agents.length;a++)
    for(int b=0;b<agents[a].length;b++)
    {
      Agent curr=new Agent();
      agents[a][b]=curr;
    }
}
//OR
void initializeAgents(Agent[] agents)
{
  for(int a=0;a<agents.length;a++)
  {
    Agent curr=new Agent();
    agents[a]=curr;
  }
}

void  dummyChangeAgents(Agent[] agents)
{
  
}

void  dummyChangeAgents(Agent[][] agents)
{
  
}

void visualizeAgents(Agent[][] agents)
{
  Agent curra;
  for(int a=0;a<agents.length;a++)
   for(int b=0;b<agents[a].length;b++)
   {
    if( (curra=agents[a][b]) != null )
    {
      fill(curra.dummy*255,0,curra.dummy*255);
    }
    else
    {
      fill(0);
    }
    rect(a*cwidth,b*cwidth,cwidth,cwidth);
   }
}
//OR
void visualizeAgents(Agent[] agents)
{
  
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - MODEL TEMPLATE
///////////////////////////////////////////////////////////////////////////////////////////
