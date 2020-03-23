//   ABM minimum template - using template for AGENT BASE MODEL in 2D dicrete geometry
//   >>>>   only necessary modules <<<<
//   implemented by Wojciech Borkowski
/////////////////////////////////////////////////////////////////////////////////////////

//Model parameters
int side=75;//side of main table
String modelName="ABMTemplateMin";
float density=0.75;

World TheWorld=new World(side);//... but also will be initialised inside setup()

//Parameters of visualisation etc...
int cwidth=15;//size of cell
int STATUSHEIGH=40;
int STEPSperVIS=1;
int FRAMEFREQ=10;
boolean WITH_VIDEO=false;
boolean simulationRun=true;//Start/stop flag

void setup()
{
  //Graphics
  size(750,790);
  frameRate(FRAMEFREQ);
  background(255,255,200);
  strokeWeight(2);
  
  //Model
  initializeModel(TheWorld);
  //initializeStats();
  //doStatistics(TheWorld);
  
  //Window 
  println("REQUIRED SIZE OF PAINTING AREA IS "+(cwidth*side)+"x"+(cwidth*side+STATUSHEIGH));
  cwidth=width/side;
    
  if(WITH_VIDEO) 
  {
    //initVideoExport(this,modelName+".mp4",FRAMEFREQ);
    //FirstVideoFrame();
  }
  
  //Finishing setup stage
  println("CURRENT SIZE OF PAINTING AREA IS "+width+"x"+height);//-myMenu.bounds.height???
  visualizeModel(TheWorld);//First time visualisation
  if(!simulationRun)
    println("PRESS 'r' or 'ESC' to start simulation");
  else
    println("PRESS 's' or 'ESC' to pause simulation");
  //NextVideoFrame();//It utilise inside variable to check if is enabled
}

void draw()
{
  if(simulationRun)
  {
    modelStep(TheWorld);
    //doStatistics(TheWorld);
  }
  
  writeStatusLine();
  
  if(!simulationRun //When simulation was stopped only visualisation should work
  || StepCounter % STEPSperVIS == 0 ) //But when model is running, visualisation shoud be done from time to time
  {
    visualizeModel(TheWorld);
    //NextVideoFrame();//It utilise inside variable to check if is enabled
  }

}

void writeStatusLine()
{
  fill(255);rect(0,side*cwidth,width,STATUSHEIGH);
  fill(0);noStroke();
  textAlign(LEFT, TOP);
  //text(meanDummy+"  "+liveCount,0,side*cwidth);//FROM STATs
  textAlign(LEFT, BOTTOM);
  text(StepCounter+")  Fps:"+ frameRate,0,side*cwidth+STATUSHEIGH-2);
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM MAIN TEMPLATE
///////////////////////////////////////////////////////////////////////////////////////////
