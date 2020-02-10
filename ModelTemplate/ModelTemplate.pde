//   Template for model utilized cell geometry
//   implemented by Wojciech Borkowski
/////////////////////////////////////////////////////////////////////////////////////////

int side=50;//side of main table
int cwidth=15;//size of cell
int STATUSHEIGH=40;
int STEPSperVIS=1;
boolean simulationRun=true;//Start/stop flag

World TheWorld=new World(side);

void setup()
{
  //Graphics
  size(750,790);
  frameRate(10);
  background(255,255,200);
  strokeWeight(2);
  
  //Model
  initializeModel(TheWorld);
  initializeStats();
  doStatistics(TheWorld);
  
  //Window 
  println("REQUIRED SIZE OF PAINTING AREA IS "+(cwidth*side)+"x"+(cwidth*side+STATUSHEIGH));
  cwidth=width/side;
    
  //Optionals:
  //setupMenu();//ISSUE: Size of MenuBar is not counted by Processing!
  //initVideoExport(...);
  
  //Finishing setup stage
  println("CURRENT SIZE OF PAINTING AREA IS "+width+"x"+height);//-myMenu.bounds.height???
  if(!simulationRun)
    println("PRESS 'r' or 'ESC' to start simulation");
  else
    println("PRESS 's' or 'ESC' to pause simulation");
}

void draw()
{
  if(simulationRun)
  {
    modelStep(TheWorld);
    doStatistics(TheWorld);
  }
  
  if(!simulationRun //When simulation was stopped only visualisation should work
  || StepCounter % STEPSperVIS == 0 ) //But when model is running, visualisation shoud be done from time to time
    visualizeModel(TheWorld);
    
  writeStatusLine();
}

void writeStatusLine()
{
  fill(255);rect(0,side*cwidth,width,STATUSHEIGH);
  fill(0);noStroke();
  text(StepCounter+")  Fps:"+ frameRate,0,side*cwidth+STATUSHEIGH-2);
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - MAIN TEMPLATE
///////////////////////////////////////////////////////////////////////////////////////////
