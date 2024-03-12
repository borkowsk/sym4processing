/// @file 
/// @brief World is a one of two central class of each ABM model.
//*        ABM: WORLD OF AGENTS FOR FILL UP
/// @date 2024-03-12
//*/////////////////////////////////////////////////////////////

int StepCounter=0; ///< Counter of real simulation steps.
                   ///< Value may differ from frameCount.

/// The main class of simulation. World is a one of two central class of each ABM model.
class World
{
  //Agent agents[]; //!< One dimensional array of agents
  //OR
  Agent agents[][]; //!< Two dimensional array of agents
  
  /// Constructor of the World.
  World(int side)
  {
    //agents=new Agent[side];
    //OR
    agents=new Agent[side][side];
  }
} //ENDofCLASS

/// More alaborated functionalities are defined as stand-alone functions,
/// not as methods because of not enought flexible syntax of Processing
//*/////////////////////////////////////////////////////////////////////////

/// Initialisation of simulated world.
/// Prepares the World class for the first step of the simulation.
void initializeModel(World world) ///< GLOBAL!
{
  initializeAgents(world.agents);
  //... initilise others things
}

/// Visualisation of simulated world.
/// Draws a representation of the simulation world.
void visualizeModel(World world) ///< GLOBAL!
{
  visualizeAgents(world.agents);
  //... visualise others things
}


/// Full model step. 
/// Change agents and other world components, if they are present.
void modelStep(World world) ///< GLOBAL!
{
   //Dummy part
   dummyChangeAgents(world.agents); //<>//
   
   //OR
   
   //Real part for YOU!
   //changeAgents(world.agents); //... do real simulation on agents 
   
   StepCounter++;
}


//*////////////////////////////////////////////////////////////////////////////////////////////
//*  Partly sponsored by the EU project "GuestXR" (https://guestxr.eu/)
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
