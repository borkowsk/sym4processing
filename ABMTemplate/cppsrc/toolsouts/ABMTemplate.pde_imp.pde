///   @file 
///   @brief AGENT BASE MODEL template. It utilizes 1D or 2D discrete geometry. 
///          ABM: MAIN FILE.
///   Designed by:
///   @author  Wojciech Borkowski 
///   @date 2024-10-11 (last modification)
//*///////////////////////////////////////////////////////////////////////////////////////

// Model parameters:
//*/////////////////
String modelName="ABMTemplate"; ///< Name of the model is used for log files.
int side=75;                    ///< side of "world" main table.
float density=0.75;             ///< initial density of agents.

World TheWorld=new World(side); ///< Main "chessboard". It will be initialised inside 'setup()'

// Parameters of visualisation etc...
//*//////////////////////////////////
int EMPTYGRAY=128;  ///< Shade of gray for background of "chessboard".
int cwidth=15;      ///< requested size of cells.
int cstroke=1;      ///< border of cells.
int STATUSHEIGH=40; ///< height of status bar.
int STEPSperVIS=1;  ///< how many model steps beetwen visualisations. 
int FRAMEFREQ=10;   ///< how many model steps per second.

boolean WITH_VIDEO=false;   ///< Make a movie?

boolean simulationRun=true; ///< Start/stop flag.

/// @brief Main function called only once. @details
/// This function encloses things, that should be done at the beginning of run.
/// At least setup() or draw() must be present in animation program
/// @note In C++ translation it is "global" by default.
void setup()
{
  //Graphics
  size(750,790);
  frameRate(FRAMEFREQ);
  background(255,255,200);
  
  if(cstroke>0)
    strokeWeight(cstroke);
  else
    noStroke();
  
  //Model
  initializeModel(TheWorld);
  initializeStats();
  doStatistics(TheWorld);
  
  //Window 
  println("REQUIRED SIZE OF PAINTING AREA IS "+(cwidth*side)+"x"+(cwidth*side+STATUSHEIGH));
  cwidth=(height-STATUSHEIGH) / side;
    
  //Optionals:
  //setupMenu(); //ISSUE: Size of MenuBar is not counted by Processing!
  //...
  if(WITH_VIDEO) 
  {
    initVideoExport(this,modelName+".mp4",FRAMEFREQ);
    FirstVideoFrame();
  }
  
  //Finishing setup stage
  println("CURRENT SIZE OF PAINTING AREA IS "+width+"x"+height); //-myMenu.bounds.height???
  visualizeModel(TheWorld); //First time visualisation
  if(!simulationRun)
    println("PRESS 'r' or 'ESC' to start simulation");
  else
    println("PRESS 's' or 'ESC' to pause simulation");
  NextVideoFrame(); //It utilise inside variable to check if is enabled
}

/// @brief Main function called in loop. @details 
/// It means, in will be called many times, to the end of app. run or 'noLoop()' call.
/// At least setup() or draw() must be present in animation program.
/// @note In C++ translation it is "global" by default.
void draw()
{
  // Back to default settings, if needed:
  //if(cstroke>0) strokeWeight(cstroke); else noStroke(); //<>//
      
  if(!simulationRun //When simulation was stopped only visualisation should work
  || StepCounter % STEPSperVIS == 0 ) //But when model is running, visualisation shoud be done from time to time
  {
    visualizeModel(TheWorld);
    NextVideoFrame(); //It utilise inside variable to check if is enabled
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
void writeStatusLine() ///< Must be predeclared!
{
  fill(255);
  if(cstroke>0) stroke(EMPTYGRAY);
  rect(0,side*cwidth,width,STATUSHEIGH);
  fill(0);
  textAlign(LEFT, TOP);
  text(meanDummy+"  "+liveCount,0,side*cwidth);
  textAlign(LEFT, BOTTOM);
  text(StepCounter+")  Fps:"+ frameRate,0,side*cwidth+STATUSHEIGH-2);
}

//*////////////////////////////////////////////////////////////////////////////////////////////
//*  Partly sponsored by the EU project "GuestXR" (https://guestxr.eu/)
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
