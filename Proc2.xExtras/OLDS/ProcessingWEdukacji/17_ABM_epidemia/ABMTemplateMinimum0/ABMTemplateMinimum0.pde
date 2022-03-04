//   ABM minimum template - using template for AGENT BASE MODEL in 2D discrete geometry
//   >>>>   only necessary modules <<<<
//   implemented by Wojciech Borkowski
/////////////////////////////////////////////////////////////////////////////////////////

//Model parameters
int side=75;//side of main table
String modelName="ABMTemplateMin";
float density=0.75;

World TheWorld=new World(side);//... but will be fully initialised inside setup()

//Parameters of visualisation etc...
int cwidth=15;//size of cell
int STATUSHEIGH=40;

int STEPSperVIS=1;//How offten visualise
int FRAMEFREQ=10; //Less or more frequent update
//boolean WITH_VIDEO=false;//Make a movie from simulation?
boolean simulationRun=true;//Start/stop flag

void setup()
{
  //Graphics
  size(750,790);
  frameRate(FRAMEFREQ);
  background(255,255,200);
  strokeWeight(2);
  
  //Model
  initializeModel(TheWorld);// Complete initialisation
  //initializeStats(); //For statistics
  //doStatistics(TheWorld);
  
  //Window size calculation
  println("REQUIRED SIZE OF PAINTING AREA IS "+(cwidth*side)+"x"+(cwidth*side+STATUSHEIGH));
  cwidth=(height-STATUSHEIGH)/side;
  
  //FOR RTMVideo.pde UNIT
  //if(WITH_VIDEO) {initVideoExport(this,modelName+".mp4",FRAMEFREQ);FirstVideoFrame();}
  
  //Finishing setup stage
  println("CURRENT SIZE OF PAINTING AREA IS "+width+"x"+height);//-myMenu.bounds.height???
  visualizeModel(TheWorld);//FOR RTMVideo.pde UNIT - First time visualisation
  
  //if(!simulationRun) //FOR RTMEvents.pde UNIT
  //  println("PRESS 'r' or 'ESC' to start simulation");
  //else
  //  println("PRESS 's' or 'ESC' to pause simulation");
  
  //NextVideoFrame();//FOR RTMVideo.pde - It utilise inside variable to check if is enabled
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
  || StepCounter % STEPSperVIS == 0 ) //But when model is running, visualisation should be done from time to time
  {
    visualizeModel(TheWorld);
    //NextVideoFrame();//FOR RTMVideo.pde UNIT - It utilise inside variable to check if is enabled
  }

}

void writeStatusLine()
{
  fill(255);rect(0,side*cwidth,width,STATUSHEIGH);
  fill(0);noStroke();
  //textAlign(LEFT, TOP);
  //text(meanDummy+"  "+liveCount,0,side*cwidth);//MOST IMPORTANT STATISTICS
  textAlign(LEFT, BOTTOM);
  text(StepCounter+")  Fps:"+ frameRate,0,side*cwidth+STATUSHEIGH-2);
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM MAIN TEMPLATE
///////////////////////////////////////////////////////////////////////////////////////////
