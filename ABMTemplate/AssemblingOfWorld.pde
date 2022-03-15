/// World is a one of two central class of each ABM model
//* ABM: WORLD OF AGENTS FOR FILL UP
//*/////////////////////////////////////////////////////////////
int StepCounter=0; ///< Global variable for caunting real simulation steps.
                   ///< Value may differ from frameCount.

/// The main class of simulation
class World
{
  //Agent agents[];//> One dimensional array of agents
  //OR
  Agent agents[][];//> Two dimensional array of agents
  
  /// Constructor of the World
  World(int side)
  {
    //agents=new Agent[side];
    //OR
    agents=new Agent[side][side];
  }
}//ENDofCLASS

/// More alaborated functionalities are defined as stand-alone functions,
/// not as methods because of not enought flexible syntax of Processing
//*/////////////////////////////////////////////////////////////////////////

/// Prepares the World class for the first step of the simulation 
void initializeModel(World world)
{
  initializeAgents(world.agents);
  //... initilise others things
}

/// Draws a representation of the simulation world
void visualizeModel(World world)
{
  visualizeAgents(world.agents);
  //... visualise others things
}

/// Dummy changes for testing of whole class World
void dummyChange(World world)
{
  dummyChangeAgents(world.agents);
  //... dummy change of other things
}

///Full model step. Change agents and other components if present.
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
