/// @file 
/// @brief Agents need to be initialised & they need logic of change. 
//*        ABM: BASIC INITIALISATION & EVERY STEP CHANGE
/// @date 2024-10-11 (last modification)
//*//////////////////////////////////////////////////////////////

/// Initialization of agents (2D version).
void initializeAgents(smatrix<pAgent> agents) ///< GLOBAL!
{
   for(int a=0;a<agents->length;a++)
    for(int b=0;b<agents[a]->length;b++)
    if(random(1)<density)
    {
      pAgent curr=new Agent();
      agents[a][b]=curr;
    }
}
//OR 
/// Initialization of agents (1D version).
void initializeAgents(sarray<pAgent> agents) ///< GLOBAL!
{
  for(int a=0;a<agents->length;a++)
  if(random(1)<density)
  {
    pAgent curr=new Agent();
    agents[a]=curr;
  }
}

/// Example changes of agents (2D version).
/// Random changes of agents for testing the visualization. 
void  dummyChangeAgents(smatrix<pAgent> agents) ///< GLOBAL!
{
  int MC=agents->length*agents[0]->length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,agents->length);
    int b=(int)random(0,agents[a]->length);
    if(agents[a][b]!= nullptr )
      agents[a][b]->dummy+=random(-0.1,0.1);
  }
}

//OR 

/// Example changes of agents (1D version).
/// Random changes of agents for testing the visualization.
void  dummyChangeAgents(sarray<pAgent> agents) ///< GLOBAL!
{
  int MC=agents->length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,agents->length);
    if(agents[a]!= nullptr )
      agents[a]->dummy+=random(-0.1,0.1);
  }  
}

//* Implement model rules below
//*///////////////////////////////////////////////

/// Real changes of agents (2D version).
/// Typically agents change over time.
/// User code is needed here.
void  changeAgents(smatrix<pAgent> agents) ///< GLOBAL!
{
  int MC=agents->length*agents[0]->length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,agents->length);
    int b=(int)random(0,agents[a]->length);
    if(agents[a][b]!= nullptr )
    {
      //... PLACE FOR YOUR CODE
    }
  }
}
//OR 
/// Real changes of agents (1D version).
/// Typically agents change over time.
/// User code is needed here.
void  changeAgents(sarray<pAgent> agents) ///< GLOBAL!
{
  int MC=agents->length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,agents->length);
    if(agents[a]!= nullptr )
    {
      //... PLACE FOR YOUR CODE
    }
  }  
}

//*////////////////////////////////////////////////////////////////////////////////////////////
//*  Partly sponsored by the EU project "GuestXR" (https://guestxr->eu/)
//*  https://www->researchgate->net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github->com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
//NOTE! /data/wb/SCC/public/Processing2C/scripts did it 2024-10-11 16:48:39

