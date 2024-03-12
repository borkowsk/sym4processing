/// @file
/// @brief Template for CA MODEL utilized 1D or 2D discrete geometry
/// @author Implemented by Wojciech Borkowski @date 2023-03-12
//*////////////////////////////////////////////////////////////////////////////

//Model parameters
String   modelName="CATemplate";///< Name of the model is used for log files
int      side=201;              ///< side of "world" main table
float    density=0.0000;        ///< initial density of live cells
boolean  synchronicMode=true;   ///< if false, then Monte Carlo mode is used

World TheWorld=new World(side); ///<Main table will be initialised inside setup()

//Parameters of visualisation etc...
int cwidth=3;                   ///< requested size of cell
int STATUSHEIGH=40;             ///< height of status bar
int STEPSperVIS=1;              ///< how many model steps beetwen visualisations 

int FRAMEFREQ= 16;              ///< how many model steps per second

boolean WITH_VIDEO=false;       ///< Need the application make a movie?

boolean simulationRun=true;     ///< Start/stop flag

/// Main function called only once. This function encloses things, 
/// that should be done at the beginning of run.
/// NOTE: At least setup() or draw() must be present in animation program.
void setup()
{
  //Graphics
  size(604,644);
  noSmooth();
  frameRate(FRAMEFREQ);
  background(255,255,200);
  strokeWeight(2);
  
  //Model
  initializeModel(TheWorld);
  //initializeStats();
  doStatistics(TheWorld);
  
  //Window 
  println("REQUIRED SIZE OF PAINTING AREA IS "+(cwidth*side)+"x"+(cwidth*side+STATUSHEIGH));
  cwidth=(height-STATUSHEIGH)/side;
    
  //Optionals:
  //setupMenu();//ISSUE: Size of MenuBar is not counted by Processing!
  //...
  if(WITH_VIDEO) 
  {
    initVideoExport(this,modelName+".mp4",FRAMEFREQ);
    FirstVideoFrame();
  }
  
  //Finishing setup stage
  println("CURRENT SIZE OF PAINTING AREA IS "+width+"x"+height);//-myMenu.bounds.height???
  visualizeModel(TheWorld);//First time visualisation
  if(!simulationRun)
    println("PRESS 'r' or 'ESC' to start simulation");
  else
    println("PRESS 's' or 'ESC' to pause simulation");
  NextVideoFrame();//It utilise inside variable to check if is enabled
}

/// Main function called in loop. It means, in will be called many times,
/// to the end of app. run or 'noLoop()' call.
/// NOTE: At least setup() or draw() must be present in animation program.
void draw()
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

/// Make all content of status bar. Function designed to fill the status 
/// line/lines, typically with simulation statistics.
void writeStatusLine()
{
  fill(255);rect(0,side*cwidth,width,STATUSHEIGH);
  fill(0);noStroke();
  textAlign(LEFT, TOP);
  text(meanDummy+"  "+liveCount,0,side*cwidth);
  textAlign(LEFT, BOTTOM);
  text(StepCounter+")  Fps:"+ frameRate,0,side*cwidth+STATUSHEIGH-2);
}

//*//////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - CA (Cellular Automaton) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*//////////////////////////////////////////////////////////////////////////////////////////////
