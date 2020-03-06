// World is a one of two central class of each ABM model
///////////////////////////////////////////////////////////////
int StepCounter=0;

class World
{
  //int cells[];//One dimensional array of agents
  //int newcells[];//Secondary array for synchronic mode
  //OR
  int cells[][];//Two dimensional array of agents
  int newcells[][];//Secondary array for synchronic mode
  
  World(int side)//Constructor of the World
  {
    //cells=new int[side];
    //if(synchronicMode) newcells=new int[side];
    //OR
    cells=new int[side][side];
    if(synchronicMode) newcells=new int[side][side];
  }
  
  //Swap arrays[]
  void   swap()
  {
    //int[] tmp=cells;
    //OR
    int[][] tmp=cells;
    cells=newcells;
    newcells=tmp;
  }
}

//More alaborated functionalities are defined as stand-alone functions,
//not as methods because of not enought flexible syntax of Processing
///////////////////////////////////////////////////////////////////////////

void initializeModel(World world)
{
  initializeCells(world.cells);
}

void visualizeModel(World world)
{
  visualizeCells(world.cells);
}

void dummyChange(World world)
{
  if(synchronicMode)
  {
    //Implement rules
    synchChangeCells(world.cells,world.newcells);
    //Swap arrays
    world.swap();
  }
  else
    asyncChangeCells(world.cells);
}

void modelStep(World world)
{
   //Dummy part
   dummyChange(world);//Comment out 
   //AND
   //... do real simulation on cells ... THIS PART IS FOR YOU!
   
   StepCounter++;
}

///////////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM: WORLD OF AGENTS FOR FILL UP
///////////////////////////////////////////////////////////////////////////////////////////////
