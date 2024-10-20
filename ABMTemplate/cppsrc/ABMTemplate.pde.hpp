/// @file 
/// @brief AGENT BASE MODEL template->It utilizes 1D or 2D discrete geometry. 
///          ABM: MAIN FILE.
/// Designed by:
/// @author  Wojciech Borkowski 
/// @date 2024-10-20 (last modification)
//*///////////////////////////////////////////////////////////////////////////////////////

// Model parameters:
//*/////////////////
String modelName="ABMTemplate"; ///< Name of the model is used for log files.
int side=75;                    ///< side of "world" main table.
float density=0.75;             ///< initial density of agents.

pWorld TheWorld=new World(side); ///< Main "chessboard". It will be initialised inside 'setup()'

// Parameters of visualisation etc...
//*//////////////////////////////////
int EMPTYGRAY=128;  ///< Shade of gray for background of "chessboard".
int cwidth=15;      ///< requested size of cells.
int cstroke=1;      ///< border of cells.
int STATUSHEIGH=40; ///< height of status bar.
int STEPSperVIS=1;  ///< how many model steps beetwen visualisations. 
int FRAMEFREQ=10;   ///< how many model steps per second.

bool    WITH_VIDEO=false;   ///< Make a movie?

bool    simulationRun=true; ///< Start/stop flag.

/// @brief Main function called only once. @details
/// This function encloses things, that should be done at the beginning of run.
/// At least setup() or draw() must be present in animation program
/// @note In C++ translation it is "global" by default.
void processing_window::setup()
{
  //Graphics
  size(750,790);
  setFrameRate(FRAMEFREQ);
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
  println(String("REQUIRED SIZE OF PAINTING AREA IS ")+(cwidth*side)+String("x")+(cwidth*side+STATUSHEIGH));
  cwidth=(height-STATUSHEIGH) / side;
    
  //Optionals:
  //setupMenu(); //ISSUE: Size of MenuBar is not counted by Processing!
  //...
  if(WITH_VIDEO) 
  {
    initVideoExport(SAFE_THIS,modelName+ String(".mp4"),FRAMEFREQ);
    FirstVideoFrame();
  }
  
  //Finishing setup stage
  println(String("CURRENT SIZE OF PAINTING AREA IS ")+width+String("x")+height); //-myMenu->bounds->height???
  visualizeModel(TheWorld); //First time visualisation
  if(!simulationRun)
    println("PRESS 'r' or 'ESC' to start simulation");
  else
    println("PRESS 's' or 'ESC' to pause simulation");
  NextVideoFrame(); //It utilise inside variable to check if is enabled
}

/// @brief Main function called in loop. @details 
/// It means, in will be called many times, to the end of app->run or 'noLoop()' call.
/// At least setup() or draw() must be present in animation program.
/// @note In C++ translation it is "global" by default.
void processing_window::draw()
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

/// Make all content of status bar->Function designed to fill the status 
/// line/lines, typically with simulation statistics.
void writeStatusLine() ///< Must be predeclared!
{
  fill(255);
  if(cstroke>0) stroke(EMPTYGRAY);
  rect(0,side*cwidth,width,STATUSHEIGH);
  fill(0);
  textAlign(LEFT, TOP);
  text(meanDummy+String("  ")+liveCount,0,side*cwidth);
  textAlign(LEFT, BOTTOM);
  text(StepCounter+String(")  Fps:")+ frameRate,0,side*cwidth+STATUSHEIGH-2);
}

//*////////////////////////////////////////////////////////////////////////////////////////////
//*  Partly sponsored by the EU project "GuestXR" (https://guestxr->eu/)
//*  https://www->researchgate->net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github->com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-20 19:45:02 !

