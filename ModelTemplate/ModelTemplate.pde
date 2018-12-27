//   Template for model utilized cell geometry
//   implemented by Wojciech Borkowski
/////////////////////////////////////////////////////////////////////////////////////////

int length=50;//side of table
int cwidth=15;//size of cell
int STATUSHEIGH=40;
int STEPSperVIS=1;
boolean simulationRun=true;//Start/stop flag

Agent World[][]=new Agent[length][length];
//Agent World[]=new Agent[length];

void setup()
{
  size(750,790);
  frameRate(10);
  background(255,255,200);
  strokeWeight(2);
  initializeModel(World);
  initializeStats();//World);
  doStatistics();
  cwidth=width/length;
  setupMenu();
}

void draw()
{
  if(simulationRun)
  {
    modelStep(World);
    doStatistics();
  }
  
  if(!simulationRun //When simulation was stopped only visualisation should work
  || StepCounter % STEPSperVIS == 0 ) //But when model is running, visualisation shoud be done from time to time
    visualizeModel(World);
    
  writeStatusLine();
}

void writeStatusLine()
{
  fill(255);rect(0,length*cwidth,width,STATUSHEIGH);
  fill(0);
  text(StepCounter+")  Fps:"+ frameRate,0,length*cwidth+STATUSHEIGH-2);
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - MAIN TEMPLATE
///////////////////////////////////////////////////////////////////////////////////////////
