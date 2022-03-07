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

public class CATemplate extends PApplet {

/// Template for CA MODEL utilized 1D or 2D discrete geometry
//*   implemented by Wojciech Borkowski
//*////////////////////////////////////////////////////////////////////////////

//Model parameters
String   modelName="CATemplate";///> Name of the model is used for log files
int      side=201;              ///> side of "world" main table
float    density=0.0000f;        ///> initial density of live cells
boolean  synchronicMode=true;   ///> if false, then Monte Carlo mode is used

World TheWorld=new World(side); ///>Main table will be initialised inside setup()

//Parameters of visualisation etc...
int cwidth=3;                   ///> requested size of cell
int STATUSHEIGH=40;             ///> height of status bar
int STEPSperVIS=1;              ///> how many model steps beetwen visualisations 
int FRAMEFREQ= 50;              ///> how many model steps per second
boolean WITH_VIDEO=false;       ///> Need the application make a movie?

boolean simulationRun=true;     ///> Start/stop flag

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

//*//////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - CA (Cellular Automaton) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*//////////////////////////////////////////////////////////////////////////////////////////////
/// World is a one of two central class of each CA model
//* CA: WORLD OF CELLS FOR FILL UP
//*/////////////////////////////////////////////////////////////

int StepCounter=0;///> Global variable for caunting real simulation steps.
                  ///> Value may differ from frameCount.


/// The main class of simulation
class World
{
  //int cells[];   //> One dimensional array of cells
  //int newcells[];//> Secondary array for synchronic mode
  //OR
  int cells[][];   //> Two dimensional array of cells
  int newcells[][];//> Secondary array for synchronic mode
  
  /// Constructor of the World
  World(int side)
  {
    //cells=new int[side];
    //if(synchronicMode) newcells=new int[side];
    //OR
    cells=new int[side][side];
    if(synchronicMode) newcells=new int[side][side];
  }
  
  /// Swap the cell arrays in synchronic mode
  public void   swap()
  {
    //int[] tmp=cells;
    //OR
    int[][] tmp=cells;
    cells=newcells;
    newcells=tmp;
  }
}//ENDofCLASS

/// More alaborated functionalities are defined as stand-alone functions,
/// not as methods because of not enought flexible syntax of Processing
//*/////////////////////////////////////////////////////////////////////////

/// Prepares the World class for the first step of the simulation 
public void initializeModel(World world)
{
  initializeCells(world.cells);
  //... initilise others things
}

/// Draws a representation of the simulation world
public void visualizeModel(World world)
{
  visualizeCells(world.cells);
  //... visualise others things
}

/// Example changes of cells for testing the visualization 
public void exampleChange(World world)
{
  if(synchronicMode)
  {
    //Implement rules
    synchChangeCellsModulo(world.cells,world.newcells);
    //Swap arrays
    world.swap();
  }
  else
    asyncChangeCellsModulo(world.cells);
}

///Full model step. Change cells and other components if present.
public void modelStep(World world)
{
   //Dummy example part
   exampleChange(world);
   //OR
   //... do real simulation on cells ... THIS PART IS FOR YOU!
   
   StepCounter++;
}

//*//////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - CA (Cellular Automaton) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*//////////////////////////////////////////////////////////////////////////////////////////////
/// Cell is a one of two central types (typicaly char or int) of each CA model
/// Cells need to be initialised & they need rules of change 
//*////////////////////////////////////////////////////////////////////////////////

/// Initialization of cells (2D version)
public void initializeCells(int[][] cells)
{
   for(int a=0;a<cells.length;a++)
    for(int b=0;b<cells[a].length;b++)
      if(density>0 && random(1)<density)
        cells[a][b]=1;
      else
        cells[a][b]=0;
   
   if(density==0) 
       cells[cells.length/2][cells.length/2]=1;
}
//OR 
/// Initialization of cells (1D version)
public void initializeCells(int[] cells)
{
  for(int a=0;a<cells.length;a++)
  if(density>0 && random(1)<density)
    cells[a]=1;
  else
    cells[a]=0;
    
  if(density==0) 
       cells[cells.length/2]=1;
}

//* Example model rules implemented below
//*///////////////////////////////////////////////

/// Your cells change over time (SYNCHRONIC 2D version)
/// (Example "modulo 5" model)
public void synchChangeCellsModulo(int[][] cells,int[][] newcells)
{
  int N=cells.length;
  for(int a=0;a<N;a++)
  for(int b=0;b<cells[a].length;b++)
  {
    int l=(a+cells.length-1)%cells.length;
    int r=(a+1)%cells.length;
    int u=(b+cells.length-1)%cells.length;
    int d=(b+1)%cells.length;    
    
    int summ=cells[l][b]+cells[a][b]+cells[r][b]
             +cells[a][u]+cells[a][d];
             
    //Modulo rule for synchronic 
    newcells[a][b]=summ%5;
  }  
}
//OR 
/// Your cells change over time (SYNCHRONIC 1D version)
/// (Example "modulo 5" model)
public void synchChangeCellsModulo(int[] cells,int[] newcells)
{
  int N=cells.length;
  for(int a=0;a<N;a++)
  {
    int l=(a+cells.length-1)%cells.length;
    int r=(a+1)%cells.length;
    
    //Synchronic modulo rule
    newcells[a]=(cells[l]+cells[a]+cells[r])%4;
  }    
}

/// Your cells change over time (ASYNCHRONIC 2D version)
/// (Example "modulo 5" model)
public void  asyncChangeCellsModulo(int[][] cells)
{
  int MC=cells.length*cells[0].length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,cells.length);
    int l=(a+cells.length-1)%cells.length;
    int r=(a+1)%cells.length;
    int b=(int)random(0,cells[a].length);
    int u=(b+cells.length-1)%cells.length;
    int d=(b+1)%cells.length;    
    
    int summ=cells[l][b]+cells[a][b]+cells[r][b]
             +cells[a][u]+cells[a][d];
             
    //Modulo rule for Monte Carlo mode      
    cells[a][b]=summ%6;
  }
}
//OR
/// Your cells change over time (ASYNCHRONIC 1D version)
/// (Example "modulo 5" model)
public void  asyncChangeCellsModulo(int[] cells)
{
  int MC=cells.length;
  for(int i=0;i<MC;i++)
  {
    int a=(int)random(0,cells.length);
    int l=(a+cells.length-1)%cells.length;
    int r=(a+1)%cells.length;
    
    //Modulo rule for Monte Carlo mode
    cells[a]=(cells[l]+cells[a]+cells[r])%4;
  }  
}

//*//////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - CA (Cellular Automaton) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*//////////////////////////////////////////////////////////////////////////////////////////////
/// Simulation have to collect and write down statistics from every step
//* CA: STATISTICS LOG TEMPLATE
//*////////////////////////////////////////////////////////////////////////////////

PrintWriter outstat; ///> Handle to the text file with the record of model statistics

/// It prepares a unique statistics file name, opens the file 
/// and enters the header line.
public void initializeStats()
{
  String FileName=modelName+="_"+year()+'.'+nf(month(),2)+'.'+nf(day(),2)+'.'+nf(hour(),2)+'.'+nf(minute(),2)+'.'+nf(second(),2)+'.'+millis();
  outstat=createWriter(FileName+".out");
  outstat.println("$STEP\tAlive\t.....");//<-- complete the header fields!
}

float meanDummy=0;///> the average of the non-zero cell values
int   liveCount=0;///> number of non-zero cells

/// The function calculates all world statistics after the simulation step
public void doStatistics(World world)
{
  doStatisticsOnCells(world.cells);
  /// ... statistics of other things
}

/// Cell statistics. One-dimensional version
/// outstat file should be closed in exit() --> see Exit.pde
public void doStatisticsOnCells(int[] cells)
{  
  int curr;
  long summ=0;
  
  liveCount=0;
  
  for(int a=0;a<cells.length;a++)
    if( (curr=cells[a]) != 0 )
    {
      //Dummy stat
      summ+=curr;
      
      //if(curr==1) 
      //.....THIS PART IS FOR YOU!
      
      liveCount++;//Alive cells
    }
  
   if(liveCount>0)
   {
     meanDummy=summ/liveCount;
     if(outstat!=null)
        outstat.println(StepCounter+"\t"+liveCount+"\t"+meanDummy);
   }
   else
   {
     simulationRun=false;
     if(outstat!=null)
        outstat.println(StepCounter+"\t"+liveCount+"\tFINISHED");
   }
}

/// Cell statistics. Two-dimensional version
/// outstat file should be closed in exit() --> see Exit.pde
public void doStatisticsOnCells(int[][] cells)
{  
  long summ=0;
  int curr;
  
  liveCount=0;
  
  for(int a=0;a<cells.length;a++)
   for(int b=0;b<cells[a].length;b++)
    if( (curr=cells[a][b]) != 0 )
    {
      //Dummy stat
      summ+=curr;
      
      //if(curr==1) 
      //.....THIS PART IS FOR YOU!
      
      liveCount++;//Alive cells
    }
  
   if(liveCount>0)
   {
      meanDummy=summ/liveCount;
      if(outstat!=null)
         outstat.println(StepCounter+"\t"+liveCount+"\t"+meanDummy);
   }
   else
   {
     simulationRun=false;
     if(outstat!=null)
        outstat.println(StepCounter+"\t"+liveCount+"\tFINISHED");
   }
}

//*//////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - CA (Cellular Automaton) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*//////////////////////////////////////////////////////////////////////////////////////////////
/// World full of cells need method of visualisation on screen/window
//* CA: BASIC VISUALISATION
//*//////////////////////////////////////////////////////////////////////////

/// Visualization of cells. Two-dimensional version
public void visualizeCells(int[][] cells)
{
  for(int a=0;a<cells.length;a++)
   for(int b=0;b<cells[a].length;b++)
   {
    //Colorisation
    switch(cells[a][b]){
    case 0: fill(0);break;
    case 1: fill(255,0,0);break;
    case 2: fill(0,255,0);break;
    case 3: fill(0,0,255);break;
    case 4: fill(255,255,0);break;
    case 5: fill(0,255,255);break;
    case 6: fill(255,0,255);break;
    default:
      fill(128);break;
    }
    
    rect(b*cwidth,a*cwidth,cwidth,cwidth);//'a' is vertical!
   }
}
//OR
/// Visualization of cells. One-dimensional version
public void visualizeCells(int[] cells)
{
   for(int a=0;a<cells.length;a++)
   {
    //Colorisation
    switch(cells[a]){
    case 0: fill(0);break;
    case 1: fill(255,0,0);break;
    case 2: fill(0,255,0);break;
    case 3: fill(0,0,255);break;
    default:
      fill(128);break;
    }
    
    int t=(StepCounter/STEPSperVIS)%side;//Uwzględniamy różne częstości wizualizacji
    noStroke();
    rect(a*cwidth,t*cwidth,cwidth,cwidth);
    stroke(255);
    line(0,(t+1)*cwidth+1,width,(t+1)*cwidth+1);
   }
}

//*//////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - CA (Cellular Automaton) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*//////////////////////////////////////////////////////////////////////////////////////////////
/// Model-specific event handler. 
/// Of course, the creator of a specific application has to match actions.
//*  CA: KEYBOARD EVENTS HANDLING
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
  case ' ': save(modelName+"."+nf((float)StepCounter,6,5)+".PNG");
            //write(world,modelName+"."+nf((float)StepCounter,6,5));//Aktualny stan systemu
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
          println("SPACE for dump the current screen\n"); 
  break;
  }
  
  if (key == ESC) 
  {
    key = 0;  // Fools! don't let them escape!
  }
}

//*//////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - CA (Cellular Automaton) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*//////////////////////////////////////////////////////////////////////////////////////////////
/// Everything that needs to be done when the application is terminated.
//* CA: EXIT TEMPLATE
//*/////////////////////////////////////////////////////////////////////

/// It is called whenever a window is closed.
public void exit()          
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
  
  super.exit();       //What library superclass have to do at exit()
} 

//*//////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - CA (Cellular Automaton) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*//////////////////////////////////////////////////////////////////////////////////////////////
//*  Obsługa wyszukiwania obiektu po kliknięciu myszy
//*  CA: MOUSE EVENTS HANDLING
//*//////////////////////////////////////////////////////

// Last read mouse data
int searchedX=-1; ///> The horizontal coordinate of the mouse cursor
int searchedY=-1; ///> The vertical coordinate of the mouse cursor
boolean Clicked=false; ///> Was there a click too?

// Last selection
int selectedX=-1; ///> Converted into "world" indices, the agent's horizontal coordinate
int selectedY=-1; ///> Converted into "world" indices, the agent's vertical coordinate


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
  searchedY=mouseY; //Searching may be implemented in visualisation!
  
  PairOfInt result=findCell(TheWorld.cells);//But 1D searching is belong to you!
  if(result!=null)//Znaleziono
  {
    selectedX=result.a;
    selectedY=result.b;
    println("Cell",selectedX,selectedY,TheWorld.cells[selectedY][selectedX]);
    //... more info about cell?
  }
}

/// Convert mouse coordinates to cell coordinates
/// The parameter is only for checking type and SIZES
/// Works as long as the cell visualization starts at point 0,0
public PairOfInt findCell(int[][] cells)
{ 
  int x=mouseX/cwidth;
  int y=mouseY/cwidth;
  if(0<=y && y<cells.length
  && 0<=x && x<cells[y].length)
      return new PairOfInt(x,y);
  else
      return null;
}

//*//////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - CA (Cellular Automaton) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*//////////////////////////////////////////////////////////////////////////////////////////////
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
  public void settings() {  size(604,644);  noSmooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "CATemplate" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
