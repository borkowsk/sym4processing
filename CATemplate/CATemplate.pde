/// Template for CA MODEL utilized 1D or 2D discrete geometry
//*   implemented by Wojciech Borkowski
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
int FRAMEFREQ= 50;              ///< how many model steps per second
boolean WITH_VIDEO=false;       ///< Need the application make a movie?

boolean simulationRun=true;     ///< Start/stop flag

/// Function setup() is called only once, at the beginning of run
/// At least setup() or draw() must be present in animation program
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

/// Function draw() is called many times, to the end of run or noLoop() call.
/// At least setup() or draw() must be present in animation program
void draw()
{
  if(simulationRun)
  {
    modelStep(TheWorld);
    doStatistics(TheWorld);
  }
  
  writeStatusLine();
  
  if(!simulationRun //When simulation was stopped only visualisation should work
  || StepCounter % STEPSperVIS == 0 ) //But when model is running, visualisation shoud be done from time to time
  {
    visualizeModel(TheWorld);
    NextVideoFrame();//It utilise inside variable to check if is enabled
  }

}

/// Function designed to fill the status bar with simulation statistics.
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
