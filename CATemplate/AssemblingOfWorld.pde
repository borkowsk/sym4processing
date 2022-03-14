/// World is a one of two central class of each CA model
//* CA: WORLD OF CELLS FOR FILL UP
//*/////////////////////////////////////////////////////////////

int StepCounter=0;///< Global variable for caunting real simulation steps.
                  ///< Value may differ from frameCount.


/// The main class of simulation
class World
{
  //int cells[];   //> One dimensional array of cells
  //int newcells[];//> Secondary array for synchronic mode
  //OR
  int cells[][];   //> Two dimensional array of cells
  int newcells[][];//> Secondary array for synchronic mode
  
  /// Constructor of the World
  World(int side)
  {
    //cells=new int[side];
    //if(synchronicMode) newcells=new int[side];
    //OR
    cells=new int[side][side];
    if(synchronicMode) newcells=new int[side][side];
  }
  
  /// Swap the cell arrays in synchronic mode
  void   swap()
  {
    //int[] tmp=cells;
    //OR
    int[][] tmp=cells;
    cells=newcells;
    newcells=tmp;
  }
}//ENDofCLASS

/// More alaborated functionalities are defined as stand-alone functions,
/// not as methods because of not enought flexible syntax of Processing
//*/////////////////////////////////////////////////////////////////////////

/// Prepares the World class for the first step of the simulation 
void initializeModel(World world)
{
  initializeCells(world.cells);
  //... initilise others things
}

/// Draws a representation of the simulation world
void visualizeModel(World world)
{
  visualizeCells(world.cells);
  //... visualise others things
}

/// Example changes of cells for testing the visualization 
void exampleChange(World world)
{
  if(synchronicMode)
  {
    //Implement rules
    synchChangeCellsModulo(world.cells,world.newcells);
    //Swap arrays
    world.swap();
  }
  else
    asyncChangeCellsModulo(world.cells);
}

///Full model step. Change cells and other components if present.
void modelStep(World world)
{
   //Dummy example part
   exampleChange(world);
   //OR
   //... do real simulation on cells ... THIS PART IS FOR YOU!
   
   StepCounter++;
}

//*//////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - CA (Cellular Automaton) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*//////////////////////////////////////////////////////////////////////////////////////////////
