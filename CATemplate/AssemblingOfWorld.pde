/// World is a one of two central class of each CA model.
//*        CA: WORLD OF CELLS FOR FILL UP
//  @date 2024-10-21 (last modification)
//*/////////////////////////////////////////////////////////////

int StepCounter=0; ///< Global variable for caunting real simulation steps.
                   ///< Value may differ from frameCount.


/// The main class of simulation. World is a central class any simulation model.
class World
{
  //int[] cells;    //> One dimensional array of cells
  //int[] newcells; //> Secondary array for synchronic mode
  //OR
  int[][] cells;    //> Two dimensional array of cells
  int[][] newcells; //> Secondary array for synchronic mode
  
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
}  //_EndOfClass World

/// More alaborated functionalities are defined as stand-alone functions,
/// not as methods because of not enought flexible syntax of Processing
//*/////////////////////////////////////////////////////////////////////////

/// World initialisation. Prepares the World class for the first step of the simulation. 
void initializeModel(World world) ///< GLOBAL!
{
  initializeCells(world.cells);
  //... initilise others things
}

/// World visualisation. Draws a representation of the simulation world.
void visualizeModel(World world) ///< GLOBAL!
{
  visualizeCells(world.cells);
  //... visualise others things
}

/// Example of cells dynamic. Example changes of cells for testing the visualization. 
void exampleChange(World world) ///< GLOBAL!
{
  if(synchronicMode)
  {
    /// Call the implemention of rules - synchronous version
    synchChangeCellsModulo(world.cells,world.newcells);
    
    //Swap arrays
    world.swap();
  }
  else /// OR
  {
    /// Call the implemention of rules - asynchronous version
    asyncChangeCellsModulo(world.cells);
  }
}

/// Real dynamic. Your changes of cells! 
void realChange(World world) ///< GLOBAL!
{
  if(synchronicMode)
  {
    /// Call the implemention of rules - synchronous version
    /// synchChangeCells{....MODEL NAME.....}(world.cells,world.newcells);
    
    //Swap arrays
    world.swap();
  }
  else /// OR
  {
    /// Call the implemention of rules - asynchronous version
    /// asyncChangeCells{....MODEL NAME.....}(world.cells);
  }
}

/// Full model step. Change cells and other components if present.
/// Your 'realChange(world)' procedure should be called here!
void modelStep(World world) ///< GLOBAL!
{
   /// Dummy example part
   exampleChange(world);
   /// OR
   /// Do real simulation on cells ... THIS PART IS FOR YOU!
   /// realChange(world);
   
   StepCounter++;
}

//*//////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - CA (Cellular Automaton) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*//////////////////////////////////////////////////////////////////////////////////////////////
