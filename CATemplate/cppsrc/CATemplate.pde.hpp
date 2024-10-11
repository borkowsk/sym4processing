/// @file
/// @brief Template for CA MODEL utilized 1D or 2D discrete geometry
/// @author Implemented by Wojciech Borkowski 
/// @date 2024-10-11 (last modification)
//*////////////////////////////////////////////////////////////////////////////

//Model parameters
String   modelName="CATemplate"; ///< Name of the model is used for log files
int      side=201;               ///< side of "world" main table
float    density=0.0000;         ///< initial density of live cells
bool     synchronicMode=true;    ///< if false, then Monte Carlo mode is used

pWorld TheWorld=new World(side);  ///<Main table will be initialised inside setup()

//Parameters of visualisation etc...
int cwidth=3;                    ///< requested size of cell
int STATUSHEIGH=40;              ///< height of status bar
int STEPSperVIS=1;               ///< how many model steps beetwen visualisations 

int FRAMEFREQ= 16;               ///< how many model steps per second

bool    WITH_VIDEO=false;        ///< Need the application make a movie?

bool    simulationRun=true;      ///< Start/stop flag

/// Main function called only once->This function encloses things, 
/// that should be done at the beginning of run.
/// NOTE: At least setup() or draw() must be present in animation program.
void processing_window::setup()
{
  //Graphics
  size(604,644);
  noSmooth();
  setFrameRate(FRAMEFREQ);
  background(255,255,200);
  strokeWeight(2);
  
  //Model
  initializeModel(TheWorld);
  //initializeStats();
  doStatistics(TheWorld);
  
  //Window 
  println(String("REQUIRED SIZE OF PAINTING AREA IS ")+(cwidth*side)+String("x")+(cwidth*side+STATUSHEIGH));
  cwidth=(height-STATUSHEIGH)/side;
    
  //Optionals:
  //setupMenu();//ISSUE: Size of MenuBar is not counted by Processing!
  //...
  if(WITH_VIDEO) 
  {
    initVideoExport(SAFE_THIS,modelName+ String(".mp4"),FRAMEFREQ);
    FirstVideoFrame();
  }
  
  //Finishing setup stage
  println(String("CURRENT SIZE OF PAINTING AREA IS ")+width+String("x")+height);//-myMenu->bounds->height???
  visualizeModel(TheWorld);//First time visualisation
  if(!simulationRun)
    println("PRESS 'r' or 'ESC' to start simulation");
  else
    println("PRESS 's' or 'ESC' to pause simulation");
  NextVideoFrame();//It utilise inside variable to check if is enabled
}

/// Main function called in loop->It means, in will be called many times,
/// to the end of app->run or 'noLoop()' call.
/// NOTE: At least setup() or draw() must be present in animation program.
void processing_window::draw()
{    
  if(!simulationRun //When simulation was stopped only visualisation should work
  || StepCounter % STEPSperVIS == 0 ) //But when model is running, visualisation shoud be done from time to time
  {
    visualizeModel(TheWorld);
    NextVideoFrame();//It utilise inside variable to check if is enabled
  }
  
  writeStatusLine();
    
  if(simulationRun)
  {
    modelStep(TheWorld);
    doStatistics(TheWorld);
  }
}

/// Make all content of status bar->Function designed to fill the status 
/// line/lines, typically with simulation statistics.
void writeStatusLine() ///< Must be predeclared for C++
{
  fill(255);rect(0,side*cwidth,width,STATUSHEIGH);
  fill(0);noStroke();
  textAlign(LEFT, TOP);
  text(meanDummy+String("  ")+liveCount,0,side*cwidth);
  textAlign(LEFT, BOTTOM);
  text(StepCounter+String(")  Fps:")+ frameRate,0,side*cwidth+STATUSHEIGH-2);
}

//*//////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www->researchgate->net/profile/WOJCIECH_BORKOWSKI - CA (Cellular Automaton) TEMPLATE
//*  https://github->com/borkowsk/sym4processing
//*//////////////////////////////////////////////////////////////////////////////////////////////
//NOTE! /data/wb/SCC/public/Processing2C/scripts did it 2024-10-11 17:07:02

