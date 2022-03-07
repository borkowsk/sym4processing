import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import com.hamoid.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ABMTemplate extends PApplet {

///   Template for AGENT BASE MODEL utilized 1D or 2D discrete geometry
//*   implemented by Wojciech Borkowski
//*///////////////////////////////////////////////////////////////////////////////////////

//Model parameters
String modelName="ABMTemplate";///> Name of the model is used for log files
int side=75;      ///> side of "world" main table
float density=0.75f;///> initial density of agents

World TheWorld=new World(side);///>Main table will be initialised inside setup()

//Parameters of visualisation etc...
int cwidth=15;     ///> requested size of cell
int STATUSHEIGH=40;///> height of status bar
int STEPSperVIS=1; ///> how many model steps beetwen visualisations 
int FRAMEFREQ=10;  ///> how many model steps per second
boolean WITH_VIDEO=false;///> Make a movie?

boolean simulationRun=false;///> Start/stop flag

/// Function setup() is called only once, at the beginning of run
/// At least setup() or draw() must be present in animation program
public void setup()
{
  //Graphics
  
  frameRate(FRAMEFREQ);
  background(255,255,200);
  strokeWeight(2);
  
  //Model
  initializeModel(TheWorld);
  initializeStats();
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
public void draw()
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
public void writeStatusLine()
{
  fill(255);rect(0,side*cwidth,width,STATUSHEIGH);
  fill(0);noStroke();
  textAlign(LEFT, TOP);
  text(meanDummy+"  "+liveCount,0,side*cwidth);
  textAlign(LEFT, BOTTOM);
  text(StepCounter+")  Fps:"+ frameRate,0,side*cwidth+STATUSHEIGH-2);
}

//*////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
/// Agent is a one of two central class of each ABM model
//* FILL IT UP!
//*/////////////////////////////////////////////////////////////

/// Agent class
class Agent
{
  float dummy;//> Dummy field. Only for demonstration.
  //... PLACE FOR YOUR CODE
  
  /// Constructor of the Agent
  Agent()
  {
    dummy=0;//random(0.1);
    //... PLACE FOR YOUR CODE
  }
}//ENDofCLASS

//*////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
//* Agent is a one of two central class of each ABM model
/// Agents need to be initialised & they need logic of change 
/// ABM: BASIC INITIALISATION & EVERY STEP CHANGE
//*//////////////////////////////////////////////////////////////

/// Initialization of agents (2D version)
public void initializeAgents(Agent[][] agents)
{
   for(int a=0;a<agents.length;a++)
    for(int b=0;b<agents[a].length;b++)
    if(random(1)<density)
    {
      Agent curr=new Agent();
      agents[a][b]=curr;
    }
}
//OR 
/// Initialization of agents (1D version)
public void initializeAgents(Agent[] agents)
{
  for(int a=0;a<agents.length;a++)
  if(random(1)<density)
  {
    Agent curr=new Agent();
    agents[a]=curr;
  }
}

/// Random changes of agents for testing the visualization (2D version)
public void  dummyChangeAgents(Agent[][] agents)
{
  int MC=agents.length*agents[0].length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,agents.length);
    int b=(int)random(0,agents[a].length);
    if(agents[a][b]!= null )
      agents[a][b].dummy+=random(-0.1f,0.1f);
  }
}
//OR 
/// Random changes of agents for testing the visualization (1D version)
public void  dummyChangeAgents(Agent[] agents)
{
  int MC=agents.length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,agents.length);
    if(agents[a]!= null )
      agents[a].dummy+=random(-0.1f,0.1f);
  }  
}

//* Implement model rules below
//*///////////////////////////////////////////////

/// Your agents change over time (2D version)
public void  changeAgents(Agent[][] agents)
{
  int MC=agents.length*agents[0].length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,agents.length);
    int b=(int)random(0,agents[a].length);
    if(agents[a][b]!= null )
    {
      //... PLACE FOR YOUR CODE
    }
  }
}
//OR 
/// Your agents change over time (1D version)
public void  changeAgents(Agent[] agents)
{
  int MC=agents.length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,agents.length);
    if(agents[a]!= null )
    {
      //... PLACE FOR YOUR CODE
    }
  }  
}

//*////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
/// World is a one of two central class of each ABM model
//* ABM: WORLD OF AGENTS FOR FILL UP
//*/////////////////////////////////////////////////////////////
int StepCounter=0; ///> Global variable for caunting real simulation steps.
                   ///> Value may differ from frameCount.

/// The main class of simulation
class World
{
  //Agent agents[];//> One dimensional array of agents
  //OR
  Agent agents[][];//> Two dimensional array of agents
  
  /// Constructor of the World
  World(int side)
  {
    //agents=new Agent[side];
    //OR
    agents=new Agent[side][side];
  }
}//ENDofCLASS

/// More alaborated functionalities are defined as stand-alone functions,
/// not as methods because of not enought flexible syntax of Processing
//*/////////////////////////////////////////////////////////////////////////

/// Prepares the World class for the first step of the simulation 
public void initializeModel(World world)
{
  initializeAgents(world.agents);
  //... initilise others things
}

/// Draws a representation of the simulation world
public void visualizeModel(World world)
{
  visualizeAgents(world.agents);
  //... visualise others things
}

/// Dummy changes for testing of whole class World
public void dummyChange(World world)
{
  dummyChangeAgents(world.agents);
  //... dummy change of other things
}

///Full model step. Change agents and other components if present.
public void modelStep(World world)
{
   //Dummy part
   dummyChange(world);
   //OR
   //... do real simulation on agents ... THIS PART IS FOR YOU!
   
   StepCounter++;
}


//*////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
/// Simulation have to collect and write down statistics from every step
//* ABM: STATISTICS LOG TEMPLATE
//*/////////////////////////////////////////////////////////////////////////////////////

PrintWriter outstat;///> Handle to the text file with the record of model statistics

/// It prepares a unique statistics file name, opens the file 
/// and enters the header line.
public void initializeStats()
{
  String FileName=modelName+="_"+year()+'.'+nf(month(),2)+'.'+nf(day(),2)+'.'
                           +nf(hour(),2)+'.'+nf(minute(),2)+'.'+nf(second(),2)+'.'+millis();
  outstat=createWriter(FileName+".out");
  //HEADER LINE:
  outstat.println("$STEP\tAlive\t.....");//<-- complete the header fields!
}

float meanDummy=0;///> average value for the dummy field
int   liveCount=0;///> number of living agents

/// The function calculates all world statistics after the simulation step
public void doStatistics(World world)
{
  doStatisticsOnAgents(world.agents);
  /// ... statistics of other things
}

/// Agent statistics. One-dimensional version
/// File outstat should be closed in exit() --> see Exit.pde
public void doStatisticsOnAgents(Agent[] agents)
{  
  Agent curra;
  double summ=0;
  liveCount=0;
  
  for(int a=0;a<agents.length;a++)
    if( (curra=agents[a]) != null )
    {
      //Dummy statistic
      summ+=curra.dummy;
     
      //.....THIS PART IS FOR YOU!
      
      liveCount++;
    }
  
   if(outstat!=null)
      outstat.println(StepCounter+"\t"+liveCount+"\t"+(summ/liveCount));
   
   meanDummy=(float)(summ/liveCount);
}

/// Agent statistics. Two-dimensional version
/// File outstat should be closed in exit() --> see Exit.pde
public void doStatisticsOnAgents(Agent[][] agents)
{  
  Agent curra;
  double summ=0;
  liveCount=0;
  
  for(int a=0;a<agents.length;a++)
   for(int b=0;b<agents[a].length;b++)
    if( (curra=agents[a][b]) != null )
    {
      //Dummy statistic
      summ+=curra.dummy;
     
      //.....THIS PART IS FOR YOU!
      
      liveCount++;
    }
  
   if(outstat!=null)
      outstat.println(StepCounter+"\t"+liveCount+"\t"+(summ/liveCount));
   
   meanDummy=(float)(summ/liveCount);
}


//*////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
/// World full of agents need method of visualisation on screen/window
//* ABM: BASIC VISUALISATION
//*//////////////////////////////////////////////////////////////////////////

/// Visualization of agents. Two-dimensional version
public void visualizeAgents(Agent[][] agents)
{
  Agent curra;
  for(int a=0;a<agents.length;a++)
   for(int b=0;b<agents[a].length;b++)
   {
    //Colorisation
    if( (curra=agents[a][b]) != null )
    {
      if(curra.dummy>=0)
        fill(curra.dummy*255,0,curra.dummy*255);
      else
        fill(-curra.dummy*255,-curra.dummy*255,0);
    }
    else
    {
      fill(128);
    }
    
    rect(b*cwidth,a*cwidth,cwidth,cwidth);//a is vertical!
   }
}
//OR
/// Visualization of agents. One-dimensional version
public void visualizeAgents(Agent[] agents)
{
   Agent curra;
   for(int a=0;a<agents.length;a++)
   {
    //Colorisation    
    if( (curra=agents[a]) != null )
    {
      if(curra.dummy>=0)
        fill(curra.dummy*255,0,curra.dummy*255);
      else
        fill(-curra.dummy*255,-curra.dummy*255,0);
    }
    else
    {
      fill(128);
    }
    
    int t=(StepCounter/STEPSperVIS)%side;//Uwzględniamy różne częstości wizualizacji
    noStroke();
    rect(a*cwidth,t*cwidth,cwidth,cwidth);
    stroke(255);
    line(0,(t+1)*cwidth+1,width,(t+1)*cwidth+1);
   }
}

//*////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
/// Model-specific event handler. 
/// Of course, the creator of a specific application has to match actions.
//* ABM: EVENTS TEMPLATE
//*///////////////////////////////////////////////////////////////////////

/// Automatically run by Processing when any key on the 
/// keyboard is pressed. Inside, you can use the variables 
/// 'key' and 'keyCode'.
public void keyPressed()
{
  println("RECIVED:'",key,"\' CODE:",PApplet.parseInt(key)); 
  switch(key)
  {
  case '1': STEPSperVIS=1;println("StPerV: "+STEPSperVIS);break;
  case '2': STEPSperVIS=2;println("StPerV: "+STEPSperVIS);break;
  case '3': STEPSperVIS=5;println("StPerV: "+STEPSperVIS);break;
  case '4': STEPSperVIS=10;println("StPerV: "+STEPSperVIS);break;
  case '5': STEPSperVIS=25;println("StPerV: "+STEPSperVIS);break;
  case '6': STEPSperVIS=50;println("StPerV: "+STEPSperVIS);break;
  case '7': STEPSperVIS=100;println("StPerV: "+STEPSperVIS);break;
  case '8': STEPSperVIS=150;println("StPerV: "+STEPSperVIS);break;
  case '9': STEPSperVIS=200;println("StPerV: "+STEPSperVIS);break;
//  case '0': STEPSperVIS=1;DeltaMC=0.2;println("DeltaMC: "+DeltaMC);break;
  case ' ': save(modelName+"."+nf((float)StepCounter,6,5)+".PNG");// // Save the contents of the simulation window!
            //write(world,modelName+"."+nf((float)StepCounter,6,5));// Save the current model state!
            break;
  case ESC: simulationRun=!simulationRun; break;
  case 's': simulationRun=false; break;
  case 'r': simulationRun=true; break;
  case 'q': exit(); break;
  default:println("Command '"+key+"' unknown");
          println("USE:");
          println("1-9 for less frequent visualisation");
          println("  0 for most frequent visualisation");
          println("ESC,r,s for pause/run simulation");
          println("SPACE for dump the current screen\n"); //... "and state\n); 
  break;
  }
  
  if (key == ESC) 
  {
    key = 0;  // Fools! don't let them escape!
  }
}


//*////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
/// Everything that needs to be done when the application is terminated.
//* ABM: EXIT HANDLIG TEMPLATE
//*//////////////////////////////////////////////////////////////////////

/// It is called whenever a window is closed.
public void exit()          //it is called whenever a window is closed. 
{
  noLoop();          //For to be sure...
  delay(100);        // it is possible to close window when draw() is still working!
  //write(world,modelName+"."+nf((float)StepCounter,5,5));//end state of the system
  
  if(outstat!=null)
  {
    outstat.flush();  // Writes the remaining data to the file
    outstat.close();  // Finishes the file
  }
  
  if(WITH_VIDEO) CloseVideo();    //Finalise of Video export
  
  println(modelName,"said: Thank You!");
  
  super.exit();       // What library superclass have to do at exit() !!!
} 


//*////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
/// Supports agent search on a mouse click, and possible inspection.
//* ABM: MOUSE EVENTS TEMPLATE
//*/////////////////////////////////////////////////////////////////////

// Last read mouse data
int searchedX=-1; ///> The horizontal coordinate of the mouse cursor
int searchedY=-1; ///> The vertical coordinate of the mouse cursor
boolean Clicked=false; ///> Was there a click too?

// Last selection
int selectedX=-1; ///> Converted into "world" indices, the agent's horizontal coordinate
int selectedY=-1; ///> Converted into "world" indices, the agent's vertical coordinate
Agent selected=null; //> Most recently selected agent

/// Simple version of Pair containing a pair of integers
class PairOfInt
{
    public final int a;
    public final int b;

    public PairOfInt(int a,int b) 
    {
        this.a = a;
        this.b = b;
    }
};

/// This function is automatically run by Processing when 
/// any mouse button is pressed. 
/// Inside, you can use the variables 'mouseX' and 'mouseY'.
public void mouseClicked()
{
  println("Mouse clicked at ",mouseX,mouseY);//DEBUG
  Clicked=true;
  searchedX=mouseX;
  searchedY=mouseY; 
  
  PairOfInt result=findCell(TheWorld.agents);//But 1D searching is belong to you!
  if(result!=null)//Znaleziono
  {
    selectedX=result.a;
    selectedY=result.b;
    if((selected=TheWorld.agents[selectedY][selectedX])!=null)
    {
      println("Cell",selectedX,selectedY,"belong to",TheWorld.agents[selectedY][selectedX]);
      //... more info about the cell & the agent
    }
    else
      println("Cell",selectedX,selectedY,"is empty");
  }
}

/// Convert mouse coordinates to cell coordinates
/// The parameter is only for checking type and SIZES
/// Works as long as the agents visualization starts at point 0,0
public PairOfInt findCell(Agent[][] agents)
{ 
  int x=mouseX/cwidth;
  int y=mouseY/cwidth;
  if(0<=y && y<agents.length
  && 0<=x && x<agents[y].length)
      return new PairOfInt(x,y);
  else
      return null;
}

//*////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
/// Tool for made video from simulation 
//* PL: Narzędzie do tworzenia wideo z symulacji
//*////////////////////////////////////////////////////////////////////////////////////
/// --> http://funprogramming.org/VideoExport-for-Processing/examples/basic/basic.pde
//*
/// Apart from the "hamoid" library, you also need to install the ffmpeg program to make it work !!! 

// Here we import the necessary library containing the VideoExport class

/// USAGE/UŻYCIE:
/// This initVideoExport function call must be in setup() for the Video module to work:
//  PL: To wywołanie funkcji initVideoExport musi być w setup(), aby moduł Video zadziałał:
///
///  initVideoExport(this,FileName,Frames)); // The VideoExport class must have access to
///                                          // the Processing application object
///                                          // It's best to run at the end of the setup().
///                                          // NOTE !!!: The window must be EVEN sizes
//
//                                          // Klasa VideoExport musi mieć dostęp do 
//                                          // obiektu aplikacji Processingu
//                                          // Najlepiej wywołać na koncu setupu. 
//                                          // UWAGA!!!: Okno musi mieć PARZYSTE rozmiary
///  
/// We call Next Video Frame for each frame of the movie, most often in the draw () function:
//  PL: NextVideoFrame wywołujemy dla każdej klatki filmu, najczęściej w funkcji draw():
///
///  NextVideoFrame();//Video frame
///
///     ... and at the end of the video we call CloseVideo:
//  PL: ... a na koniec filmu wywołujemy CloseVideo:
///
///  CloseVideo();// Ideally in exit ()
//                // PL: Najlepiej w exit()


VideoExport        videoExport; ///> CLASS object from additional library - must be installed
                                //   PL: Obiekt KLASY z dodatkowej biblioteki - trzeba zainstalować
                                 
static int         videoFramesFreq=0;///> How many frames per second for the movie. It doesn't have to be the same as in frameRate!
                                     //   PL: Ile klatek w sekundzie filmu. Nie musi być to samo co w frameRate!   

static boolean     videoExportEnabled=false;///> Has film making been initiated?
                                            //   PL: Czy tworzenie filmu zostało zainicjowane?
  
///> Copyright of your movie  
///> Change it to your copyright. Best in setup() function.
//   PL: Zawartość zmień na swój copyright. Najlepiej w funkcji setup().                                   
String copyrightNote="(c) W.Borkowski @ ISS University of Warsaw";

/// Make the beginning of the movie file!
//  PL: Zrób początek pliku filmowego!
public void initVideoExport(processing.core.PApplet parent, String Name,int Frames)
{
  videoFramesFreq=Frames;
  videoExport = new VideoExport(parent,Name); //Klasa VideoExport musi mieć dostep do obiektu aplikacji Processingu
  videoExport.setFrameRate(Frames);//Nie za szybko
  videoExport.startMovie();
  fill(0,128,255);text(Name,1,20);
  videoExportEnabled=true;
}
                
/// Initial second sequence for title and copyright
//  PL: Początkowa sekundowa sekwencja na tytuł i copyright
public void FirstVideoFrame()
{
  if(videoExportEnabled)
  {  
     fill(0,128,255);text(copyrightNote,1,height); 
     //text(videoExport.VERSION,width/2,height);
     delay(200);
     for(int i=0;i<videoFramesFreq;i++)// Must be a second or something ...
       videoExport.saveFrame();//Video frame
  }
}

/// Each subsequent frame of the movie
//  PL: Każda kolejna klatka filmu
public void NextVideoFrame()
{  
   if(videoExportEnabled)
     videoExport.saveFrame();//Video frame
}
                     
/// This is what we call when we want to close the movie file.
/// This function adds an ending second sequence with an author's note
//  PL: To wołamy gdy chcemy zamknąć plik filmu.
//  PL: Funkcja dodaje kończącą sekundową sekwencje z notą autorską.
/// NOTE: there should be some "force screen update", but not found :-(
///       So, if you x-click the window while drawing, the last frame
///       will probably be incomplete
// PL: UWAGA! 
//     Powinno być jakieś "force screen update", ale nie znalazłem
//     Jeśli kliknięcie x okna nastąpi w trakcie rysowania to ostatnia klatka
//     będzie prawdopodobnie niekompletna
public void CloseVideo() 
{
  if(videoExport!=null)
  { 
   fill(0);
   text(copyrightNote,1,height);

   for(int i=0;i<videoFramesFreq;i++)//Have to last about one second
       videoExport.saveFrame();//Video frames for final freeze
   videoExport.saveFrame();//Video frame - LAST
   videoExport.endMovie();//Koniec filma
  }
}

//*//////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - MODELING TEMPLATES
//*  https://github.com/borkowsk/sym4processing
//*//////////////////////////////////////////////////////////////////////////////////////////////
  public void settings() {  size(750,790); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ABMTemplate" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
