//* World is a one of two central class of each ABM model
//* ABM: WORLD OF AGENTS FOR FILL UP
//*/////////////////////////////////////////////////////////////
int StepCounter=0;

class World
{
  //Agent agents[];//One dimensional array of agents
  //OR
  Agent agents[][];//Two dimensional array of agents
  
  World(int side)//Constructor of the World
  {
    //agents=new Agent[side];
    //OR
    agents=new Agent[side][side];
  }
}

//* More alaborated functionalities are defined as stand-alone functions,
//* not as methods because of not enought flexible syntax of Processing
//*/////////////////////////////////////////////////////////////////////////

void initializeModel(World world)
{
  initializeAgents(world.agents);
  //... initilise others things
}

void visualizeModel(World world)
{
  visualizeAgents(world.agents);
  //... visualise others things
}

void dummyChange(World world)
{
  dummyChangeAgents(world.agents);
}

void modelStep(World world)
{
   //Dummy part
   dummyChange(world);
   //OR
   //... do real simulation on agents ... THIS PART IS FOR YOU!
   
   StepCounter++;
}


//*////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
