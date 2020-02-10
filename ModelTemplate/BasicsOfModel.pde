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

void visualizeAgents(Agent[][] agents)
{
  
}
//OR
void visualizeAgents(Agent[] agents)
{
  
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - MODEL TEMPLATE
///////////////////////////////////////////////////////////////////////////////////////////
