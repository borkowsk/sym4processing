/// @file
/// @brief World is a one of two central class of each CA model
//*        CA: WORLD OF CELLS FOR FILL UP
//  @date 2024-10-20 (last modification)
//*/////////////////////////////////////////////////////////////

int StepCounter=0; ///< Global variable for caunting real simulation steps.
                   ///< Value may differ from frameCount.


/// The main class of simulation->World is a central class any simulation model.
class World: public virtual Object{
  public:
  //sarray<int> cells;    //> One dimensional array of cells
  //sarray<int> newcells; //> Secondary array for synchronic mode
  //OR
  smatrix<int> cells;    //> Two dimensional array of cells
  smatrix<int> newcells; //> Secondary array for synchronic mode
  
  /// Constructor of the World
  World(int side)
  {
    //cells=new array<int>(side);
    //if(synchronicMode) newcells=new array<int>(side);
    //OR
    cells=new matrix<int>(side,side);
    if(synchronicMode) newcells=new matrix<int>(side,side);
  }
  
  /// Swap the cell arrays in synchronic mode
  void   swap()
  {
    //sarray<int> tmp=cells;
    //OR
    smatrix<int> tmp=cells;
    cells=newcells;
    newcells=tmp;
  }
}  ; //_EndOfClass_


/// More alaborated functionalities are defined as stand-alone functions,
/// not as methods because of not enought flexible syntax of Processing
//*/////////////////////////////////////////////////////////////////////////

/// World initialisation->Prepares the World class for the first step of the simulation. 
void initializeModel(pWorld world) ///< GLOBAL!
{
  initializeCells(world->cells);
  //... initilise others things
}

/// World visualisation->Draws a representation of the simulation world.
void visualizeModel(pWorld world) ///< GLOBAL!
{
  visualizeCells(world->cells);
  //... visualise others things
}

/// Example of cells dynamic->Example changes of cells for testing the visualization. 
void exampleChange(pWorld world) ///< GLOBAL!
{
  if(synchronicMode)
  {
    /// Call the implemention of rules - synchronous version
    synchChangeCellsModulo(world->cells,world->newcells);
    
    //Swap arrays
    world->swap();
  }
  else /// OR
  {
    /// Call the implemention of rules - asynchronous version
    asyncChangeCellsModulo(world->cells);
  }
}

/// Real dynamic->Your changes of cells! 
void realChange(pWorld world) ///< GLOBAL!
{
  if(synchronicMode)
  {
    /// Call the implemention of rules - synchronous version
    /// synchChangeCells{....MODEL NAME.....}(world->cells,world->newcells);
    
    //Swap arrays
    world->swap();
  }
  else /// OR
  {
    /// Call the implemention of rules - asynchronous version
    /// asyncChangeCells{....MODEL NAME.....}(world->cells);
  }
}

/// Full model step->Change cells and other components if present.
/// Your 'realChange(world)' procedure should be called here!
void modelStep(pWorld world) ///< GLOBAL!
{
   /// Dummy example part
   exampleChange(world);
   /// OR
   /// Do real simulation on cells ... THIS PART IS FOR YOU!
   /// realChange(world);
   
   StepCounter++;
}

//*//////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www->researchgate->net/profile/WOJCIECH_BORKOWSKI - CA (Cellular Automaton) TEMPLATE
//*  https://github->com/borkowsk/sym4processing
//*//////////////////////////////////////////////////////////////////////////////////////////////
//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-20 19:47:09 !

