import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.awt.MenuBar; 
import java.awt.Menu; 
import java.awt.MenuItem; 
import java.awt.event.ActionListener; 
import java.awt.event.ActionEvent; 
import processing.awt.PSurfaceAWT; 
import com.hamoid.*; 
import java.io.BufferedWriter; 
import java.io.FileWriter; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Optionals extends PApplet {

//* File forcing all "optionales" to be loaded from this folder 
//*///////////////////////////////////////////////////////////////////////

/// mandatory globals
int          FRAMEFREQ=10;        ///< application speed
int          VISFREQ=1;           ///< how often full visualisation is performed
int          debug_level=0; ///< or DEBUG or DEBUG_LEVEL ???

final boolean WINDOW_INVISIBLE=false; ///< used in template draw for swith on window invisibility
final int    LINK_INTENSITY=2;    ///< For network visualisation
final float  MAX_LINK_WEIGHT=1.0f; ///< Also for network visualisation
final int    MASKBITS=0xffffffff; ///< Redefine, when smaller width is required

/// Dummy class of Agent neded for makeHistogramOfA()
class Agent { float A; }

/// Dummy setup - some gr. primitives are tested here:
public void setup()
{
  
  //setupMenu();//Have error in size of draweable area!
  dashedline(0,0,width,height,3);
  arrow_d(0,100,100,200,5,PI*0.75f);
  arrow_d(100,200,200,250,5,PI*0.66f);
  arrow_d(200,250,300,0,5,PI*0.9f);
  dottedLine(0.0f,0.0f,300.0f,200.0f,55);
}

//*////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
/// COMMON TEMPLATES 
///*/////////////////////////////////////////////////////////////////////////////////////////
/// USE /*_interfunc*/ &  /*_forcbody*/ for interchangeable function 
/// if you need translate the code into C++ (--> Processing2C )

/// Templates:
//*/////////////////////////////////

/// Simple version of Pair template useable for returning a pair of values
public class Pair<A,B> {
    public final A a;
    public final B b;

    public Pair(A a, B b) 
    {
        this.a = a;
        this.b = b;
    }
}//EndOfClass

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
/// Classes for taking an object from a simple variable of type int, boolean, float & double.
/// Useful when you need a REFERENCE to a value.
//*///////////////////////////////////////////////////////////////////////////////////////////

/// In Processing as hell :-) I can't find how to pass something other than an object by reference
/// However, the existing Integer or Float classes are not suitable for this because they are "final". 
/// They will behave like constants.
/// And sometimes such an opportunity is needed!

/// A class for taking an object from a simple variable of type int. 
/// Needed for common configuration values or to pass to functions by reference.
class DummyInt
{int val=0;}

/// A class for taking an object from a simple logic variable (true-false). 
/// Needed for common configuration values or to pass to functions by reference.
class DummyBool
{ boolean val=false; }

/// A class for taking an object from a simple variable of type float. 
/// Needed for common configuration values or to pass to functions by reference.
class DummyFloat
{ float val=0; }

/// A class for taking an object from a simple variable of type double. 
/// Needed for common configuration values or to pass to functions by reference.
class DummyDouble
{ double val=0; }

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
/// COMMON INTERFACES
/// See: "https://github.com/borkowsk/RTSI_public"
//*//////////////////////////////////////////////////////////////////////////////
/// USE /*_interfunc*/ &  /*_forcbody*/ for interchangeable function 
/// if you need translate the code into C++ (--> Processing2C )

//*
/// Generally useable interfaces:
//*
//*//////////////////////////////

/// Forcing name available as String (planty of usage)
interface iNamed {
  /*_interfunc*/ public String    name() /*_forcbody*/;
}//EndOfClass

/// Any object which have description as (potentially) long, multi line string
interface iDescribable { 
  /*_interfunc*/ public String Description() /*_forcbody*/;
}//EndOfClass

//*
/// MATH INTERFACES:
//*
//*////////////////////////////////////////////////////////////////////////////

final float INF_NOT_EXIST=Float.MAX_VALUE;  ///< Missing value marker

/// A function of two values in the form of a class - a functor
interface Function2D {
  /*_interfunc*/ public float calculate(float X,float Y)/*_forcbody*/;
  /*_interfunc*/ public float getMin()/*_forcbody*/;//MIN_RANGE_VALUE?
  /*_interfunc*/ public float getMax()/*_forcbody*/;//Always must be different!
}//EndOfClass

//*
/// VISUALISATION INTERFACES:
//*
//*///////////////////////////

/// Forcing setFill & setStroke methods for visualisation
interface iColorable {
  /*_interfunc*/ public void setFill(float intensity)/*_forcbody*/;
  /*_interfunc*/ public void setStroke(float intensity)/*_forcbody*/;
}//EndOfClass

/// Forcing posX() & posY() & posZ() methods for visualisation and mapping  
interface iPositioned {              
  /*_interfunc*/ public float    posX()/*_forcbody*/;
  /*_interfunc*/ public float    posY()/*_forcbody*/;
  /*_interfunc*/ public float    posZ()/*_forcbody*/;
}//EndOfClass

//*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//*  Last modification 2022.03.16
//*  See: "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" - USEFULL COMMON INTERFACES
//*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Template handling of program call parameters, if available.
//*/////////////////////////////////////////////////////////////

/// Parsing command line, if available.
public void checkCommandLine() 
{ 
    //extern int debug_level;// EXPECTED!
    
    //Is passing parameters possible?
    if(args==null)
    {
       if(debug_level>0) println("Command line parameters not available");
       return; //Not available!!!
    }

    if(debug_level>0)
    {
      println("args length is " + args.length);
      for(int a=0;a<args.length;a++)
          print(args[a]," ");
      println();
    }
    
    //... UTILISE PARAMETERS BELOW ...
    int Fcount=0;
    for(int a=0;a<args.length;a++)
    {
      String[] list = split(args[a], ':');
      if(debug_level>1)
      {
        for(String s:list) 
          print("'"+s+"'"+' ');
        println();
      }
      
      if(list[0].equals("FRAMEFREQ"))
      {
        //*_extern* int           FRAMEFREQ=10;/// simulation speed
        FRAMEFREQ=Integer.parseInt(list[1]);
        println("Speed vel FRAMEFREQ:",FRAMEFREQ);
      }
      else
      if(list[0].equals("DEBUG"))
      {
        //*_extern* int           debug_level=0;/// level of debugging messages
        debug_level=Integer.parseInt(list[1]);
        println("debug_level:",debug_level);
      }
      else
      /* if(list[0].equals("PARAMETER"))
      {
        //*_extern* int           parameter;//=20;/// Side of area
        //*_extern* int           fromParam1;//=40; /// Min & max...
        //*_extern* int           fromParam2;//=40; /// random number
        parameter=int(list[1]);
        fromParam1=parameter*-2;
        fromParam2=parameter*2;
        println("PARAMETER:",parameter,"fromParam:",fromParam1,fromParam2);
      }
      else */
      {
        Fcount++;
      }
    }
    
    if(Fcount>0 ) println("Failed to understand",Fcount,"parameters");
}

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
/// draw() template with possibility of non-visible window
//*///////////////////////////////////////////////////////////////////////////////////////// 

/// Console only apps. is possible when draw() function set window visibility to false, 
/// then can do anything but drawing :-D
/// final boolean WINDOW_INVISIBLE=true; ... is used in template draw() for swith on window invisibility
public void draw() 
{
  if(WINDOW_INVISIBLE && frameCount==1)
  {
    surface.setVisible(false);//Console only applet? - Does it work?
    println("Windows is set to invisible in draw function!");
  }
  //... Your code here or in event handlers!
}

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
///  Keyboard Event Handling.
/////////////////////////////////////////////////////////////////////////////////////

/// The handler called every time when keyboard key is pressed
/// You can use 'key' and 'keyCode' Processing variable inside. 
public void keyPressed() 
{
  fill(128);  //print(CODED);//DEBUG
  if(key!=CODED) println("Key:'",key,'\''); else println("Key coded:'",keyCode,'\'');
  switch(key)
  {
  case 'q':
  case 'Q': exit();break;
  
  case 'o': FRAMEFREQ/=2;frameRate(FRAMEFREQ);println("Requested",FRAMEFREQ,"frames/sec");break;
  case '0': FRAMEFREQ*=2;frameRate(FRAMEFREQ);println("Requested",FRAMEFREQ,"frames/sec");break;
  case '1': VISFREQ=1;println(VISFREQ,"step/frame");text("StPerV: "+VISFREQ,0,height-16);break;
  case '2': VISFREQ=2;println(VISFREQ,"step/frame");text("StPerV: "+VISFREQ,0,height-16);break;
  case '3': VISFREQ=5;println(VISFREQ,"step/frame");text("StPerV: "+VISFREQ,0,height-16);break;
  case '4': VISFREQ=10;println(VISFREQ,"step/frame");text("StPerV: "+VISFREQ,0,height-16);break;
  case '5': VISFREQ=25;println(VISFREQ,"step/frame");text("StPerV: "+VISFREQ,0,height-16);break;
  case '6': VISFREQ=50;println(VISFREQ,"step/frame");text("StPerV: "+VISFREQ,0,height-16);break;
  case '7': VISFREQ=100;println(VISFREQ,"step/frame");text("StPerV: "+VISFREQ,0,height-16);break;
  case '8': VISFREQ=150;println(VISFREQ,"step/frame");text("StPerV: "+VISFREQ,0,height-16);break;
  case '9': VISFREQ=200;println(VISFREQ,"step/frame");text("StPerV: "+VISFREQ,0,height-16);break;
  case ' ': //SPACE - dump the current screen             
            save("screen"+nf(frameCount,6,5)+".PNG");
            println("screen"+nf(frameCount,6,5)+".PNG","SAVED!");
            break;
  default:println("Command '"+key+"' unknown");
  case '\t':
       {  //HELP
          int startX=75;
          int startY=10;
          int fsize=8;
          textSize(fsize);
          fill(64);textAlign(LEFT,TOP);
          println("USE:");
          println("\u2423 \t for dump the current screen"); text("SPACE \t for dump the current screen",startX,startY);         
          println("1-9 \t for less frequent visualisation");text("1-9 \t for less frequent visualisation",startX,startY+=fsize);         
          println("o 0 \t for less & more frequent frames");text("o 0 \t for less & more frequent frames",startX,startY+=fsize);         
          println("q,Q \t exit");                           text("q,Q \t exit",startX,startY+=fsize);         
          println("\n");
          //see: http://blog.elliottcable.name/posts/useful_unicode.xhtml
       }    
  break;
  }
  
  if (key == ESC) 
  {
    key = 0;  // Don't let them escape!
  }
}

//*//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//*  Last modification 2022.03.16
//*  https://github.com/borkowsk/sym4processing
//*  See: "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" - KEYBOARD EVENTS TEMPLATE
//*//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///  Handling of exit from aplication - mainly closing open files! 
//*///////////////////////////////////////////////////////////////////////////////////

/// It is called whenever a window is closed. 
public void exit()          
{
  noLoop();          //For to be sure...
  delay(100);        // it is possible to close window when function draw( ) is still working!
  
  //Close any open global files!
  //if(statisticsLogEnabled)
  //      CloseStatistics();

  //Finalise of VIDEO export!
  //if(videoExportEnabled) 
  //        CloseVideo();    
          
  println("Thank You");
  super.exit();       //What library superclass have to do at exit
} 

//*//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//*  Last modification 2022.03.16
//*  https://github.com/borkowsk/sym4processing
//*  See: "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" - EXIT from TEMPLATE
//*//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Template of the function that allows to construct the window menu in the setup. 
/// Unfortunately, this breaks the calculation of the built-in variable height in Processing!
//*///////////////////////////////////////////////////////////////////////////////////////////








MenuBar myMenu;///!< Handle to menu. 
               
/// A function that constructs an example menu.
/// Processig does not see the height of MenuBar added to Window!
public void setupMenu() 
{
  myMenu = new MenuBar();
  
  Menu fileMenu = new Menu("File");
  myMenu.add(fileMenu);
  
  MenuItem closeItem=new MenuItem("Close");
  closeItem.addActionListener(new ActionListener() {
        public void actionPerformed(ActionEvent ev) {
                exit();//Local exit function
            }
          } 
        );
  fileMenu.add(closeItem);
  
  PSurfaceAWT awtSurface = (PSurfaceAWT)surface;
  PSurfaceAWT.SmoothCanvas smoothCanvas = (PSurfaceAWT.SmoothCanvas)awtSurface.getNative();
  smoothCanvas.getFrame().setMenuBar(myMenu);
}

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////

 
/// Examples for handling mouse events
//*//////////////////////////////////////

/// Mouse movement support. It shouldn't be too time consuming.
/// see: //https://processing.org/reference/mouseMoved_.html
public void mouseMoved()
{
  fill(random(255),random(255),random(255));
  ellipse(mouseX,mouseY,10,10);
}

/* The alternatives are in UtilsRectAreas
void mousePressed() 
{
        println("Pressed "+mouseX+" x "+mouseY);
}

void mouseReleased()
{
        println("Released "+mouseX+" x "+mouseY);
}
*/

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
/// Tool for made video from simulation 
//* PL: Narzędzie do tworzenia wideo z symulacji
//*////////////////////////////////////////////////////////////////////////////////////
/// See: http://funprogramming.org/VideoExport-for-Processing/examples/basic/basic.pde
//*
/// USAGE: Apart from the "hamoid" library, you also need to install 
/// the ffmpeg program to make it work !!! 
///
//!< Here we import the necessary library containing the VideoExport class

/// USAGE
//* UŻYCIE:
/// This initVideoExport function call must be in setup() for the Video module to work:
//* To wywołanie funkcji initVideoExport musi być w setup(), aby moduł Video zadziałał:
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
//* NextVideoFrame wywołujemy dla każdej klatki filmu, najczęściej w funkcji draw():
///
///  NextVideoFrame();//Video frame
///
/// ... and at the end of the video we call CloseVideo:
//* ... a na koniec filmu wywołujemy CloseVideo:
///
///  CloseVideo(); // Ideally in exit ()
//*                // Najlepiej w exit()
///

VideoExport        videoExport;  ///< Obiekt KLASY z dodatkowej biblioteki - trzeba zainstalować
                                 //*  CLASS object from additional library - must be installed
static int         videoFramesFreq=0;///< How many frames per second for the movie. It doesn't have to be the same as in frameRate!
                                     //*  Ile klatek w sekundzie filmu. Nie musi być to samo co w frameRate!   
static boolean     videoExportEnabled=false;///< Has film making been initiated?
                                            //*   Czy tworzenie filmu zostało zainicjowane?
String copyrightNote="(c) W.Borkowski @ ISS University of Warsaw";///< Change it to your copyright. Best in setup().
                                                                  //*  To zmień na swój copyright. Najlepiej w setup().  
/// The beginning of the movie file
//*  Początek pliku filmowego
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
//* Początkowa sekundowa sekwencja na tytuł i copyright
public void FirstVideoFrame()
{
  if(videoExportEnabled)
  {  
     fill(0,128,255);text(copyrightNote,1,height); 
     //text(videoExport.VERSION,width/2,height);
     delay(200);
     for(int i=0;i<videoFramesFreq;i++)//Musi trwać sekundę czy coś...
       videoExport.saveFrame();//Video frame
  }
}

/// Each subsequent frame of the movie
//* Każda kolejna klatka filmu
public void NextVideoFrame()
{  
   if(videoExportEnabled)
     videoExport.saveFrame();//Video frame
}
                     
/// This is what we call when we want to close the movie file.
/// This function adds an ending second sequence with an author's note
//* PL: To wołamy gdy chcemy zamknąć plik filmu.
//* PL: Funkcja dodaje kończącą sekundową sekwencje z notą autorską.
/// NOTE: there should be some "force screen update", but not found
/// If you x-click the window while drawing, it is the last frame
/// will probably be incomplete
//* UWAGA: powinno być jakieś "force screen update", ale nie znalazłem
//* Jeśli kliknięcie x okna nastąpi w trakcie rysowania to ostatnia klatka
//* będzie prawdopodobnie niekompletna.
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

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
/// Functions & classes for chart making
//*/////////////////////////////////////////////////////////////////////////////////////////

//final float INF_NOT_EXIST=Float.MAX_VALUE;///< needed somewhere

/// A class that implements only the interface having a proper object name
class NamedData implements iNamed
{
  String myName;
  NamedData(String Name){ myName=Name; }
  public String name() {return myName;}
}//EndOfClass

/// Class of a NAMED range of real (float) numbers
class Range extends NamedData
{
  float min=+Float.MAX_VALUE;//!< Current minimal value
  float max=-Float.MAX_VALUE;//!< Current maximal value
  
  /// Constructor need only a name
  Range(String Name){ super(Name); }
  
  /// Adding a value to a range can make it wider 
  public void addValue(float value) 
  {
    if(value==INF_NOT_EXIST) return;
    if(max<value)
    {
      max=value;
    }
    if(min>value)
    {
      min=value;
    }
  }
}//EndOfClass

/// This class represents a NAMED series of real (float) numbers
/// Should it also be a descendant of the Range? 
/// ... Or at least implements the same interface? TODO?
class Sample  extends NamedData
{
  FloatList data=null;
  
  // For statistics
  int    count=0;              //!< How much data has been entered (not counting INF_NOT_EXIST)
  float   min=+Float.MAX_VALUE;//!< Current minimal value
  int   whmin=-1;              //!< Position of the current minimal value
  float   max=-Float.MAX_VALUE;//!< Current maximal value
  int   whmax=-1;              //!< Position of the current maximal value
  double   sum=0;              //!< The current sum of values 
  
  /// Constructor need only a name
  Sample(String Name) { super(Name); data=new FloatList(); }
  
  /// Adding values to a series immediately updates the base stats
  public void addValue(float value)
  {        
    data.append(value);
    
    if(value==INF_NOT_EXIST) return;//Nic więcej do zrobienia
    
    sum+=value;
    count++;//Real value, not empty one!
    
    if(max<value)
    {
      max=value;
      whmax=data.size()-1; //print("^");
    }
    if(min>value)
    {
      min=value;
      whmin=data.size()-1; //print("v");
    }
  }
  
  /// Number of recorded values
  /// Together with empty entries equal to INF_NOT_EXIST
  public int  numOfElements() { return data.size(); }
  
  /// Ready to start collecting data again
  public void reset()
  {
    data.clear();
    min=-Float.MAX_VALUE;
    whmin=-1;
    max=-Float.MAX_VALUE;
    whmax=-1;
    sum=0;  
    count=0;
  }
  
  /// Secured reading of the minimum
  public float getMin()
  {
    if(count>0) return min;
    else return INF_NOT_EXIST;
  }
  
  /// Secured reading of the maximum
  public float getMax()
  {
    if(count>0) return max;
    else return INF_NOT_EXIST;
  }
  
  /// Secured reading of the the mean
  public float getMean()
  {
    if(count>0) return (float)(sum/count);
    else return INF_NOT_EXIST;
  }
  
  /// Secured reading of the standard deviation
  public float getStdDev()
  {
    if(count==0) return INF_NOT_EXIST;
    
    int    N=0;
    double kwadraty=0;
    double mean=getMean();
    for(float val:data)
    if(val!=INF_NOT_EXIST)
    {
      kwadraty+=sqr(val-mean);
      N++;
    }
                                  assert N==count;
    return (float)(kwadraty/N);
  }
}//EndOfClass

/// This class represens a named histogram of frequencies 
class Frequencies extends NamedData
{
  private int[]   buckets=null;
  float   sizeOfbucket=0;//(Max-Min)/N;
  float   lowerb=+Float.MAX_VALUE;
  float   upperb=-Float.MAX_VALUE;
  int     outsideLow=0;
  int     outsideHig=0;
  int     inside=0;
  int     higherBucket=0;
  int     higherBucketIndex=-1;

  /// Constructor needs more than a name
  Frequencies(int numberOfBuckets,float lowerBound, float upperBound,String Name)
  {
    super(Name);
    buckets=new int[numberOfBuckets];
    lowerb=lowerBound;
    upperb=upperBound;
    sizeOfbucket=(upperBound-lowerBound)/numberOfBuckets;
  }
  
  /// In this case, the items are histogram buckets
  public int  numOfElements() { return buckets.length;}
  
  /// Ready to start collecting data again
  public void reset()
  {
    for(int i=0;i<buckets.length;i++)
            buckets[i]=0;
    outsideLow=0;
    outsideHig=0;
    inside=0;
    higherBucket=0;
    higherBucketIndex=-1;    
  }
  
  /// Adding the real value updates the corresponding bucket
  public void addValue(float value)
  {
    if(value==INF_NOT_EXIST) return;
    
    if(value<lowerb)
      {outsideLow++;return;}
    
    if(value>upperb) 
      {outsideHig++;return;}    
    
    int index=(int)((value-lowerb)/sizeOfbucket);
         
    buckets[index]++;
    
    if(higherBucket<buckets[index])
      {higherBucket=buckets[index];higherBucketIndex=index;}
    
    inside++;
  }
}//EndOfClass

/// Visualizes the axes of the coordinate system
public void viewAxis(int startX,int startY,int width,int height)
{
  line(startX,startY,startX+width,startY);
  line(startX+width-5,startY-5,startX+width,startY);
  line(startX,startY,startX,startY-height);
  line(startX+5,startY-height+5,startX,startY-height);
  line(startX-5,startY-height+5,startX,startY-height);
}

/// Visualizes a box around the area
public void viewFrame(float startX,float startY,int width,int height)
{
  line(startX,startY,startX+width,startY);
  line(startX,startY,startX,startY-height);
  line(startX+width,startY,startX+width,startY-height);
  line(startX,startY-height,startX+width,startY-height);
}

/// Draws tics along the vertical axis
public void viewTicsV(int startX,int startY,int width,int height,float space)
{
  for(int y=startY;y>startY-height;y-=space)
     line(startX,y,startX+width,y);
}

/// Draws tics along the horizontal axis
public void viewTicsH(float startX,float startY,float width,float height,float space)
{
  for(int x=PApplet.parseInt(startX);x<startX+width;x+=space)
     line(x,startY,x,startY-height);
}

/// Visualizes the limits of the vertical scale
/// NOTE: We're not drawing dashes here yet (tics)
public void viewScaleV(Range MinMax,int startX,int startY,int width,int height)//,boolean logaritm)
{
   //float min=(logaritm?(float)Math.log10(MinMax.min+1):MinMax.min);//+1 wizualnie niewiele zmienia a gwarantuje obliczalność
   //float max=(logaritm?(float)Math.log10(MinMax.max+1):MinMax.max);//+1 wizualnie niewiele zmienia a gwarantuje obliczalność
   textAlign(LEFT,TOP);
   text(""+MinMax.min,startX+width,startY);
   text(""+MinMax.max,startX+width,startY-height);
}

/// Visualization of data series as a series of points or a continuous line
public void viewAsPoints(Sample data,    //!< Data source. The object containing the data to be visualized
                  int startD,     //!< Data starting point, or end-to-end number if negative
                  float startX,   //!< The horizontal starting point of the display area 
                  float startY,   //!< The vertical starting point of the display area 
                  int width,      //!< The width of the display area
                  int height,     //!< Height of the display area
                  boolean logaritm,//!< Should the data be transformed by logarith?
                  Range commMinMax,//!< Optionally common Range for multiple series or null
                  boolean connect  //!< Should data points be combined into a single line?
                  )
{
  float min,max;
  if(commMinMax!=null)
  {
    min=(logaritm?(float)Math.log10(commMinMax.min+1):commMinMax.min);//+1 wizualnie niewiele zmienia a gwarantuje obliczalność
    max=(logaritm?(float)Math.log10(commMinMax.max+1):commMinMax.max);//+1 wizualnie niewiele zmienia a gwarantuje obliczalność    
  }
  else
  {
    min=(logaritm?(float)Math.log10(data.min+1):data.min);//+1 wizualnie niewiele zmienia a gwarantuje obliczalność
    max=(logaritm?(float)Math.log10(data.max+1):data.max);//+1 wizualnie niewiele zmienia a gwarantuje obliczalność
  }
  
  int     N=data.numOfElements();       assert startD<N-1;
  if(startD<0)
  {
      startD=-startD; //Ujemne było tylko umownie!!!
      startD=N-startD;//Ileś od końca
  }
  if(startD<0) //Nadal ujemne!?
  {
      startD=0;//Czyli zabrakło danych
      //print("?");
  }
  float wid=PApplet.parseFloat(width)/(N-startD);  //println(width,N,startD,wid,min,max);
  float oldy=-Float.MIN_VALUE;
  
  for(int t=startD;t<N;t++)
  {
    float val=data.data.get(t);
    if(val==INF_NOT_EXIST) 
    {
      oldy=-Float.MIN_VALUE;
      continue;
    }
    
    if(logaritm)
      val=map((float)Math.log10(val+1),min,max,0,height);    
    else 
      val=map(val,min,max,0,height);
    
    float x=(t-startD)*wid;
    if(connect && oldy!=-Float.MIN_VALUE)
    {
      line (startX+x-wid,startY-oldy,startX+x,startY-val);//println(wid,x-wid,oldy,x,val);
    }
    else
    {
                                                          //println(startX+x,startY-val);
      line(startX+x+2,startY-val,startX+x-1,startY-val); 
      line(startX+x,startY-val+2,startX+x,startY-val-1); 
    }
    
    if(connect) oldy=val;
    
    if(t==data.whmax || t==data.whmin)
    {
      textAlign(LEFT,TOP);
      text(""+data.data.get(t),startX+x,startY-val);
    }
  }
}

/// Bar visualization of a histogram or something similar
public float viewAsColumns(Frequencies hist,//!< Data source. The object containing the data to be visualized
                    float startX,    //!< The horizontal starting point of the display area 
                    float startY,    //!< The vertical starting point of the display area 
                    int width,       //!< The width of the display area
                    int height,      //!< The height of the display area
                    boolean logaritm //!< Should the data be transformed by logarith?
                    )
{
  float max=(logaritm?(float)Math.log10(hist.higherBucket+1):hist.higherBucket);//+1 wizualnie niewiele zmienia a gwarantuje obliczalność
  int wid=width/hist.buckets.length; //println(width,wid);
  if(wid<1) wid=1;
  
  for(int i=0;i<hist.buckets.length;i++)
  {
    float hei;
    if(logaritm)
      hei=map((float)Math.log10(hist.buckets[i]+1),0,max,0,height);    
    else 
      hei=map(hist.buckets[i],0,max,0,height);
    
    rect(startX+i*wid,startY,wid,-hei);
  }
  
  textAlign(LEFT,BOTTOM);
  text(""+max+(logaritm?"<="+hist.higherBucket+" @ "+hist.higherBucketIndex:" @ "+hist.higherBucketIndex),startX,startY-height);
  //Real width of histogram
  float realwidth=(hist.buckets.length)*wid;//println(realwidth);noLoop();
  return realwidth;
}

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
/// Tools for CSV files.
/// See: https://stackoverflow.com/questions/17010222/how-do-i-append-text-to-a-csv-txt-file-in-processing
//*/////////////////////////////////////////////////////////////////////////////////////////////////////////



/// Appends text to the end of a text file located in the data directory, 
/// creates the file if it does not exist.
/// Can be used for big files with lots of rows, 
/// existing lines will not be rewritten
public void appendTextToFile(String filename, String text)
{
  File f = new File(dataPath(filename));
  if(!f.exists()){
    createFile(f);
  }
  try {
    PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(f, true)));
    out.println(text);
    out.close();
  }catch (IOException e){
      e.printStackTrace();
  }
}

/// Creates a new file including all subfolders in the path
public void createFile(File f)
{
  File parentDir = f.getParentFile();
  try{
    parentDir.mkdirs(); 
    f.createNewFile();
  }catch(Exception e){
    e.printStackTrace();
  }
}    

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
///  Function for drawing dashed lines.
//*//////////////////////////////////////////////////////////////////

///  Draw a dashed line with given set of dashes and gap lengths. 
///  @param x0 starting x-coordinate of line. 
///  @param y0 starting y-coordinate of line. 
///  @param x1 ending x-coordinate of line. 
///  @param y1 ending y-coordinate of line. 
///  @param spacing is an array giving lengths of dashes and gaps in pixels; 
///  an array with values {5, 3, 9, 4} will draw a line with a 
///  5-pixel dash, 3-pixel gap, 9-pixel dash, and 4-pixel gap. 
///  if the array has an odd number of entries, the values are 
///  recycled, so an array of {5, 3, 2} will draw a line with a 
///  5-pixel dash, 3-pixel gap, 2-pixel dash, 5-pixel gap, 
///  3-pixel dash, and 2-pixel gap, then repeat.
///  NOTE: uses the Processing specific function lerp()
///  See: https://processing.org/discourse/beta/num_1202486379.html 
public void dashedLine(float x0, float y0, float x1, float y1, float[ ] spacing) 
{ 
  float distance = dist(x0, y0, x1, y1); 
  float [ ] xSpacing = new float[spacing.length]; 
  float [ ] ySpacing = new float[spacing.length]; 
  float drawn = 0.0f;  // amount of distance drawn 
 
  if (distance > 0) 
  { 
    int i; 
    boolean drawLine = true; // alternate between dashes and gaps 
 
    /* 
      Figure out x and y distances for each of the spacing values 
      I decided to trade memory for time; I'd rather allocate 
      a few dozen bytes than have to do a calculation every time 
      I draw. 
    */ 
    for (i = 0; i < spacing.length; i++) 
    { 
      xSpacing[i] = lerp(0, (x1 - x0), spacing[i] / distance); 
      ySpacing[i] = lerp(0, (y1 - y0), spacing[i] / distance); 
    } 
 
    i = 0; 
    while (drawn < distance) 
    { 
      if (drawLine) 
      { 
        line(x0, y0, x0 + xSpacing[i], y0 + ySpacing[i]); 
      } 
      x0 += xSpacing[i]; 
      y0 += ySpacing[i]; 
      /* Add distance "drawn" by this line or gap */ 
      drawn = drawn + mag(xSpacing[i], ySpacing[i]); 
      i = (i + 1) % spacing.length;  // cycle through array 
      drawLine = !drawLine;  // switch between dash and gap 
    } 
  } 
}

/// Simplified function for drawing dotted lines.
public void dashedline(float x0, float y0, float x1, float y1,float dens)
{
  dashedLine(x0,y0,x1,y1,new float[]{dens,dens});
}

/*
/// Obsolete name 
void dashedline(float x0, float y0, float x1, float y1, float[ ] spacing) 
{ 
  float distance = dist(x0, y0, x1, y1); 
  float [ ] xSpacing = new float[spacing.length]; 
  float [ ] ySpacing = new float[spacing.length]; 
  float drawn = 0.0;  // amount of distance drawn 
 
  if (distance > 0) 
  { 
    int i; 
    boolean drawLine = true; // alternate between dashes and gaps 
 
    // Figure out x and y distances for each of the spacing values 
    // I decided to trade memory for time; I'd rather allocate 
    // a few dozen bytes than have to do a calculation every time I draw. 
    for (i = 0; i < spacing.length; i++) 
    { 
      xSpacing[i] = lerp(0, (x1 - x0), spacing[i] / distance); 
      ySpacing[i] = lerp(0, (y1 - y0), spacing[i] / distance); 
    } 
 
    i = 0; 
    while (drawn < distance) 
    { 
      if (drawLine) 
      { 
        line(x0, y0, x0 + xSpacing[i], y0 + ySpacing[i]); 
      } 
      x0 += xSpacing[i]; 
      y0 += ySpacing[i]; 
      // Add distance "drawn" by this line or gap
      drawn = drawn + mag(xSpacing[i], ySpacing[i]); 
      i = (i + 1) % spacing.length;  // cycle through array 
      drawLine = !drawLine;  // switch between dash and gap 
    } 
  } 
} 
*/

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////


 
///  Function for drawing dotted lines.
//*////////////////////////////////////////////////////////////////////////////////////

/// if you use a lot of dotted lines maybe something like this is usefull for you... 
/// just call dottedLine() like you would call line()
/// See: https://processing.org/discourse/beta/num_1219255354.html
public void dottedLine(float x1, float y1, float x2, float y2, int steps)
{                                 //println("dottedLine(float,float,float,float,int steps)");
 for(int i=0; i<=steps; i++) 
 {
   float d = i/(float)steps;      //println(d);
   float x = lerp(x1, x2, d);//funkcja lerp() jest sednem tego rozwiązania
   float y = lerp(y1, y2, d);
   point(x,y);
   //noStroke();ellipse(x, y,2,2);//Używanie elipsy zamiast punktu nie jest zbyt wydajne
                                  //ale używa koloru zdefiniowanego przez fill() zamiast stroke()
 }
} 

/// Alternative function for drawing dotted lines.
/// Uses 'int' as a parameter type.
public void dottedline(int x1, int y1, int x2, int y2, int dens)
{                                  print("dottedline(int x1,int y1,int x2,int y2,int dens)");
  for (int i = 0; i <= dens; i++) 
  {
    float x = lerp(x1, x2, i/(float)dens);
    float y = lerp(y1, y2, i/(float)dens);
    point(x, y);
  }
}

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////

/// "Active rectangles" - proprietary application interface module in Processing
//*////////////////////////////////////////////////////////////////////////////////
/// USE /*_interfunc*/ &  /*_forcbody*/ for interchangeable function 
/// if you need translate the code into C++ (--> Processing2C )

ArrayList<RectArea>   allAreas = new ArrayList<RectArea>();     ///< Global list of areas to be displayed.
ArrayList<TextButton> allButtons = new ArrayList<TextButton>(); ///< Global button list.

int iniTxButtonSize=16;       ///< The initial size of the button.
int iniTxButtonCornerRadius=6;///< The default rounding of the corners of the buttons

/// Mouse click support for buttons.
/// If the program may also respond to clicks differently, this must be taken into account here.
public void mousePressed() 
{
  println("Pressed "+mouseX+" x "+mouseY);
  for(TextButton button : allButtons) 
  {
    if(button.hitted(mouseX,mouseY))
    {
      button.set_state(1,true);
    }
  }
}

/// Mouse button relase support.
/// If the program may also respond to clicks differently, this must be taken into account here.
public void mouseReleased() 
{
  println("Released "+mouseX+" x "+mouseY);
  for(TextButton button : allButtons) 
  {
    if(button.hitted(mouseX,mouseY))
    {
      button.flip_state(true);//println(button.title);
    } 
  }
}  

/// View all interface elements.
/// Should be called in draw() or in an event handlers.
public void view_all_areas()
{
  for( RectArea area: allAreas)
  {
    area.view();
  }
}

/// Rectangular screen area class as the basis for various active areas
class RectArea
{
  int    x1,y1,x2,y2;//!< Corners of the area
  int  back;       //!< Colour of background
  
  /// Constructor. 
  /// Requires data on the corners of the area.
  RectArea(float iX1,float iY1,float iX2,float iY2)
  {
    back=color(178,178,178);
    if(iX1<iX2) { x1=round(iX1);x2=round(iX2);}
      else {x1=round(iX2);x2=round(iX1);}
    if(iY1<iY2) { y1=round(iY1);y2=round(iY2);}
      else {y1=round(iY2);y2=round(iY1);}
    //println(x1+" "+y1+" "+x2+" "+y2);
  }
  
  /// Area display function.
  /*_interfunc*/ public void view()
  {
        rectMode(CORNERS);
        fill(back);
        noStroke();
        rect(x1,y1,x2,y2);
  }
  
  /// The function of checking if you click on an area
  /*_interfunc*/ public boolean hitted(int x,int y)
  {
    return x1<=x && x<=x2
        && y1<=y && y<=y2;
  }
}//EndOfClass

/// A class of a panel that contains many buttons
class PanelOfTextButtons extends RectArea
{
  ArrayList<TextButton> list; 
  
  /// Constructor.
  /// Requires data on the corners of the area.
  PanelOfTextButtons(float iX1,float iY1,float iX2,float iY2)
  {
    super(iX1,iY1,iX2,iY2);
    list = new ArrayList<TextButton>();
  }
  
  /// Area display function.
  public void view()
  {
     super.view();
     for( RectArea area: list)
     {
      area.view();
     }
  }
  
  /// Filling the panel with buttons.
  public void add(TextButton but)
  {
    list.add(but);
    but.x1+=x1;
    but.x2+=x1;
    but.y1+=y1;
    but.y2+=y1; //Przy move() trzeba z powrotem odjąć, a potem dodać nowe
  }
  
}//EndOfClass

/// Rectangular button with text content
class TextButton extends RectArea implements iNamed
{
  int  txt,strok;
  int strokW;
  int txtSiz;
  int corner=iniTxButtonCornerRadius;
  
  String title;
  protected int state;
  
  /// Constructor.
  /// Requires data on the corners of the area and text content ("title")
  TextButton(String iTitle,float iX1,float iY1,float iX2,float iY2)
  {
    super(iX1,iY1,iX2,iY2);
    state=0; 
    txt=color(255,255,255); back=color(0,0,0);corner=iniTxButtonCornerRadius;
    strok=color(100,100,100); strokW=3;
    title=iTitle; 
    txtSiz=iniTxButtonSize; //Wartość domyślna
    
    //Dopasowywanie rozmiaru fontu żeby się zmieściło title
    textSize(txtSiz);
    while(textWidth(title) > x2-x1) textSize(--txtSiz);
    while(textAscent()+textDescent() > y2-y1) textSize(--txtSiz);
  }
  
  /// Implements the iNamed interface requirement.
  public String name() { return title; }
  
  /// Area display function.
  public void view()
  {
    int cfill=(state==0?txt:back);
    int afill=(state==0?back:txt);
    
    rectMode(CORNERS);
    fill(red(afill),green(afill),blue(afill));
    stroke(strok);
    strokeWeight(strokW);  
    rect(x1,y1,x2,y2,corner);
    fill(cfill);
    textSize(txtSiz);
    textAlign(CENTER, CENTER);
    text(title,x1,y1,x2,y2); 
  }
  
  /// Change to the opposite state (0 to 1, other to 0) and possibly visualize
  /*_interfunc*/ public void flip_state(boolean visual)
  {
    if(state==0) state=1;
    else state=0;
    if(visual)
        view();
  }
  
  /// It changes the state to 0 or 1 and optionally visualizes
  /*_interfunc*/ public void set_state(int new_state,boolean visual)
  {
    if(new_state!=state)
    {
      state=new_state;
      if(visual)
          view();
    }
  }
  
}//EndOfClass


/// A pseudo-button class that displays the state, not the name, 
/// Also ignores flip_state() and that changes to state through set_state() are "protected"
class StateLabel extends TextButton 
{
  /// Normally using set_state() in this class does not change anything. 
  /// You have to set this field, which clears always after changing, 
  /// so only code working on objects of this class can do it, 
  /// but code working on base class can't :-)
  private boolean allowChng;
  
  /// Constructor.
  /// Requires data on the corners of the area, text "title" and initial state.
  StateLabel(int iState,String iTitle,float iX1,float iY1,float iX2,float iY2)
  {
    super(iTitle,iX1,iY1,iX2,iY2);
    state=iState;allowChng=false;
  }
 
  /// Area display function.
  public void view()
  {
    int bfill=(allowChng?strok:back);
    int dfill=(allowChng?back:strok);

    rectMode(CORNERS);
    fill(red(txt),green(txt),blue(txt));
    stroke(dfill);
    strokeWeight(strokW);  
    rect(x1,y1,x2,y2);
    fill(bfill);
    textSize(txtSiz);
    textAlign(CENTER, CENTER);
    text(state+"",x1,y1,x2,y2); 
  }
 
  /// A function that allows you to change the state
  /*_interfunc*/ public void allow()
  {
    allowChng=true;
    view();
  }
  
  /// Specific for the class. It does not change the state by flip, 
  /// at most it repeats the display - although it is probably useless
  public void flip_state(boolean visual)   
  { 
    if(visual)
        view();
  }
  
  /// Specific for the class. It uses allowChng field and then clears it.
  public void set_state(int new_state,boolean visual)
  {
    if(allowChng)
    {
      if(new_state!=state)
      {
        state=new_state;
      }
      
      allowChng=false;// Whether there was an actual change or not, it will no longer be possible
      
      if(visual)
          view();
    }
  }
}//EndOfClass

/// A button class that increments a state label, 
/// possibly undoing the operation of the opposite pair
class StateLabelInc extends TextButton
{
  StateLabel     target;
  StateLabelInc  opponent;
  
  /// Constructor.
  /// Requires data on the corners of the area, text "title" and connected areas.
  StateLabelInc(String iTitle,
                float iX1,float iY1,float iX2,float iY2,
                StateLabel iTarget,
                StateLabelInc iOpponent)
  {
    super(iTitle,iX1,iY1,iX2,iY2);
    target=iTarget;opponent=iOpponent;
  }
  
  /// Class-specific overlay of the inherited method.
  /// It increases or decreses the state.
  public void flip_state(boolean visual)
  { 
    super.flip_state(visual);
    if(opponent.state!=0) 
            opponent.decrement(visual);
    target.allow(); //Odbezpieczenie        
    if(state>0) target.set_state(target.state+1,visual);
           else target.set_state(target.state-1,visual);
   } 
   
   /// The method that undoes state increments, i.e. decreases the "counter"
   public void decrement(boolean visual)
   {
     state=0;view();
     target.allow(); //Odbezpieczenie       
     target.set_state(target.state-1,visual);
   }
}//EndOfClass

/// Unique button. 
/// The class of the button, which when clicked, resets the state of all the others on the list
class UniqTextButton extends TextButton 
{
  ArrayList<TextButton> siblings; //!< List of mutually exclusive buttons
  
  /// Constructor.
  /// Requires data on the corners of the area, text "title" and a list of mutual siblings.
  UniqTextButton(ArrayList<TextButton> iSibl,String iTitle,float iX1,float iY1,float iX2,float iY2)
  {
    super(iTitle,iX1,iY1,iX2,iY2);
    siblings=iSibl;
  }
  
  /// Normally the method changes the state to the opposite (0 to 1, other to 0) and possibly visualizes.
  /// However, if the button state changes to other than 0 then
  /// his companions (siblings) on the list must be reset.
  public void flip_state(boolean visual)   
  {
    if(state==0) state=1;
    else state=0;
    if(visual)
    {
        view();
        if(state!=0)
        for(TextButton button : siblings)
        if(button!=this)
          button.set_state(0,true); //set_state jest po klasie bazowej żeby uniknąć niechcianej rekurencji
    }
  }
}//EndOfClass

/// A button that remembers the column to which its unique marker is to be saved
class WrTextButton extends TextButton 
{   
  int column;
  String marker; 
  
  /// Constructor.
  /// Requires data on the corners of the area, text "title", text marker and specific output column.
  WrTextButton(String iTitle,float iX1,float iY1,float iX2,float iY2,String iMarker,int iColumn)
  {
    super(iTitle,iX1,iY1,iX2,iY2);
    marker=iMarker;
    column=iColumn;
  }
}//EndOfClass

/// UniqButton additionally remembers the column to which it is to save its unique marker
class WrUniqTextButton extends UniqTextButton 
{   
  int column;
  String marker; 
  
  /// Constructor.
  /// Requires data on the corners of the area, text "title", text marker and specific output column,
  /// and, of course, a list of mutual siblings.
  WrUniqTextButton(ArrayList<TextButton> iSibl,String iTitle,float iX1,float iY1,float iX2,float iY2,String iMarker,int iColumn)
  {
    super(iSibl,iTitle,iX1,iY1,iX2,iY2);
    marker=iMarker;
    column=iColumn;
  }
}//EndOfClass

//*///////////////////////////////////////////////////////////////////////////////////////////////////
///  @Author Wojciech Borkowski
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
/// Various helpful drawing procedures
//*//////////////////////////////////////////////////////////////

/// Frame drawn with a default line
public void surround(int x1,int y1,int x2,int y2)
{
  line(x1,y1,x2,y1);//--->
  line(x2,y1,x2,y2);//vvv
  line(x1,y2,x2,y2);//<---
  line(x1,y1,x1,y2);//^^^
}

/// Cross drawn with a default line
public void cross(float x,float y,float cross_width)
{
  line(x-cross_width,y,x+cross_width,y);
  line(x,y-cross_width,x,y+cross_width);
}

/// Cross drawn with a default line 
/// The version that uses parameters of type int.
public void cross(int x,int y,int cross_width)
{
  line(x-cross_width,y,x+cross_width,y);
  line(x,y-cross_width,x,y+cross_width);
}

/// The bald head of a man seen from above
public void baldhead(int x,int y,int r,float direction)
{
  float D=2*r;
  float xn=x+r*cos(direction);
  float yn=y+r*sin(direction);
  ellipse(xn,yn,D/5,D/5);  //Nos
  xn=x+0.95f*r*cos(direction+PI/2);
  yn=y+0.95f*r*sin(direction+PI/2);
  ellipse(xn,yn,D/4,D/4);  //Ucho  1
  xn=x+0.95f*r*cos(direction-PI/2);
  yn=y+0.95f*r*sin(direction-PI/2);
  ellipse(xn,yn,D/4,D/4);  //Ucho  2
  //Glówny blok
  ellipse(x,y,D,D);
}

//*
/// POLYGONS
//*
//*/////////////////////

/// A regular polygon with a given radius and number of vertices
public void regularpoly(float x, float y, float radius, int npoints) 
{
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) 
  {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

/// A class to represent two-dimensional points
class pointxy 
{
  float x,y;
  
  pointxy()
  {
    x=y=0;
  }
  
  pointxy(float ix,float iy)
  {
    x=ix;y=iy;
  }
}//EndOfClass

/// Drawing a polygon. 
/// It utilises vertices given as an array of points
public void polygon(pointxy[] lst/*+1*/)
{
  int N= lst.length;
  beginShape();
  for (int a = 0; a < N; a ++) 
  {
    vertex(lst[a].x,lst[a].y);
  }
  endShape(CLOSE);
}

/// Drawing a polygon. 
/// It utilises vertices given as an array of points
/// @param N, size of list, could be smaller than 'lst.lenght'
public void polygon(pointxy[] lst/*+1*/,int N)
{
  beginShape();
  for (int a = 0; a < N; a ++) 
  {
    vertex(lst[a].x,lst[a].y);
  }
  endShape(CLOSE);
}

/// Nearest points of two polygons.
public Pair<pointxy,pointxy> nearestPoints(final pointxy[] listA,final pointxy[] listB)
{                                    
                                    assert(listA.length>0);
                                    assert(listB.length>0);
  float mindist=MAX_FLOAT;
  int   minA=-1;
  int   minB=-1;
  for(int i=0;i<listA.length;i++)
    for(int j=0;j<listB.length;j++) //Pętla nadmiarowa (?)
    {
      float x2=(listA[i].x-listB[j].x)*(listA[i].x-listB[j].x);
      float y2=(listA[i].y-listB[j].y)*(listA[i].y-listB[j].y);
      
      if(x2+y2 < mindist)
      {
        mindist=x2+y2;
        minA=i; minB=j;
      }
    }
  return new Pair<pointxy,pointxy>(listA[minA],listB[minB]);
}

//*
/// BAR3D 
//*
//*/////////////////////////////////////////

class settings_bar3d
{
int a=10;
int b=6;
int c=6;
int wire=color(255,255,255); //Kolor ramek
int back=color(0,0,0); //Informacja o kolorze tla
}//EndOfClass

settings_bar3d bar3dsett=new settings_bar3d();///< Default settings of bar3d

pointxy bar3dromb[]={new pointxy(),new pointxy(),new pointxy(),new pointxy(),new pointxy(),new pointxy()};

public void bar3dRGB(float x,float y,float h,int R,int G,int B,int Shad)
{
                                                    /*      6 ------ 5    */
  bar3dromb[0].x= x;                                /*     /        / |   */
  bar3dromb[0].y= y - h;                            /*    1 ------ 2  |   */
  bar3dromb[1].x= x + bar3dsett.a;                  /*    |        |  |   */
  bar3dromb[1].y= bar3dromb[1-1].y;                 /*    |        |  |   */
  bar3dromb[2].x= bar3dromb[2-1].x;                 /*    |        |  |   */
  bar3dromb[2].y= y;                                /*    |        |  4   */
  bar3dromb[3].x= x + bar3dsett.a + bar3dsett.b;    /*    |        | /  c */
  bar3dromb[3].y= y - bar3dsett.c;                  /*  x,y ------ 3      */
  bar3dromb[4].x= bar3dromb[4-1].x;                 /*         a      b   */
  bar3dromb[4].y= y - h - bar3dsett.c;
  bar3dromb[5].x= x + bar3dsett.b;
  bar3dromb[5].y= bar3dromb[5-1].y;

  fill(R,G,B);
  rect(x,y-h,bar3dsett.a,h+1);               //front

  fill(R/Shad,G/Shad,B/Shad);
  polygon(bar3dromb/*+1*/,6);              //bok i gora

  stroke(bar3dsett.wire);
  //rect(bar3dromb[1-1].x,bar3dromb[1-1].y,bar3dromb[2-1].x+1,bar3dromb[2-1].y+1);//gorny poziom
  //rect(x,y,bar3dromb[3-1].x+1,bar3dromb[3-1].y+1);       //dolny poziom

  line(bar3dromb[2-1].x,bar3dromb[2-1].y,bar3dromb[5-1].x,bar3dromb[5-1].y); //blik?

  //point(bar3dromb[5].x,bar3dromb[5].y,wire_col-1);
  line(bar3dromb[1-1].x,bar3dromb[1-1].y,bar3dromb[6-1].x,bar3dromb[6-1].y);//lewy ukos
  line(bar3dromb[2-1].x,bar3dromb[2-1].y,bar3dromb[3-1].x,bar3dromb[3-1].y);//prawy ukos
  line(bar3dromb[3-1].x,bar3dromb[3-1].y,bar3dromb[4-1].x,bar3dromb[4-1].y);//dolny ukos
  line(bar3dromb[4-1].x,bar3dromb[4-1].y,bar3dromb[5-1].x,bar3dromb[5-1].y);//tyl bok
  line(bar3dromb[5-1].x,bar3dromb[5-1].y,bar3dromb[6-1].x,bar3dromb[6-1].y);//tyl bok

 // rect(x,y-h,1,h+1,wire_col);       // the left vertical edge is additionally marked
}/* end of bar3dRGB */

 
//*
/// ARROW IN ANY DIRECTION
//*
//*////////////////////////////////////////

float def_arrow_size=15; ///< Default size of arrows heads
float def_arrow_theta=PI/6.0f+PI;///< Default arrowhead spacing //3.6651914291881

/// Function that draws an arrow with default settings
public void arrow(float x1,float y1,float x2,float y2)
{
  arrow_d(PApplet.parseInt(x1),PApplet.parseInt(y1),PApplet.parseInt(x2),PApplet.parseInt(y2),def_arrow_size,def_arrow_theta);
}

/// Function that draws an arrow with changable settings
public void arrow_d(int x1,int y1,int x2,int y2,float size,float theta)
{
  // CALCULATION METHOD FROM ROTATION OF THE ARROW AXIS
  float A=(size>=1 ? size : size * sqrt( (x1-x2)*(x1-x2)+(y1-y2)*(y1-y2) ));
  float poY=PApplet.parseFloat(y2-y1);
  float poX=PApplet.parseFloat(x2-x1);

  if(poY==0 && poX==0)
  {
    // Rare error, but big problem
    float cross_width=def_arrow_size/2;
    line(x1-cross_width,y1,x1+cross_width,y1);
    line(x1,y1-cross_width,x1,y1+cross_width);
    ellipse(x1+def_arrow_size/sqrt(2.0f),y1-def_arrow_size/sqrt(2.0f)+1,
            def_arrow_size,def_arrow_size);
    return;
  }
                                        assert(!(poY==0 && poX==0));
  float alfa=atan2(poY,poX);            if(abs(alfa)>PI+0.0000001f)
                                             println("Alfa=%e\n",alfa);
                                      //assert(fabs(alfa)<=M_PI);//cerr<<alfa<<endl;
  float xo1=A*cos(theta+alfa);
  float yo1=A*sin(theta+alfa);
  float xo2=A*cos(alfa-theta);
  float yo2=A*sin(alfa-theta);        //cross(x2,y2,128);DEBUG!

  line(PApplet.parseInt(x2+xo1),PApplet.parseInt(y2+yo1),x2,y2);
  line(PApplet.parseInt(x2+xo2),PApplet.parseInt(y2+yo2),x2,y2);
  line(x1,y1,x2,y2);
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - HANDY FUNCTIONS & CLASSES
//*/////////////////////////////////////////////////////////////////////////////////////////
/// Different ways to calculate Euclid distances in 2D (flat and torus)
//*/////////////////////////////////////////////////////////////////////

/// Default Euclidean distance on float numbers
/// Often needed in simulation programs
/// Actually the same as dist already shipped in Processing 3.xx
public float distance(float X1,float X2,float Y1,float Y2)
{
  float dX=X2-X1;
  float dY=Y2-Y1;
  if(dX!=0 || dY!=0)
    return sqrt(dX*dX+dY*dY);
  else
    return 0;
}

/// 2D Euclidean distance on float numbers
/// Often needed in simulation programs
/// Version compatible with int and double versions
public float distanceEucl(float X1,float X2,float Y1,float Y2)
{
  float dX=X2-X1;
  float dY=Y2-Y1;
  if(dX!=0 || dY!=0)
    return sqrt(dX*dX+dY*dY);
  else
    return 0;
}

/// 2D Euclidean distance on double numbers
/// Sometimes needed in simulation programs
/// Version compatible with int and float versions
public double distanceEucl(double X1,double X2,double Y1,double Y2)
{
  double dX=X2-X1;
  double dY=Y2-Y1;

  if(dX!=0 || dY!=0)
    return Math.sqrt(dX*dX+dY*dY);
  else
    return 0;
}

/// Euclidean like distance on torus (float numbers)
/// Sometimes needed in simulation programs
/// Version compatible with int and double versions
/// @param Xdd & @param Ydd are the horizontal and vertical perimeter of the torus
public float distanceTorus(float X1,float X2,float Y1,float Y2,float Xdd,float Ydd)
{ //println("float torus dist");
  float dX=abs(X2-X1);
  float dY=abs(Y2-Y1);
  if(dX > (Xdd/2) ) dX=Xdd-dX;
  if(dY > (Ydd/2) ) dY=Ydd-dY;
  if(dX!=0 || dY!=0)
    return sqrt(dX*dX+dY*dY);
  else
    return 0;
}

/// Euclidean like distance on torus (double numbers)
/// Sometimes needed in simulation programs
/// Version compatible with int and float versions
/// @param Xdd & @param Ydd are the horizontal and vertical perimeter of the torus
public double distanceTorus(double X1,double X2,double Y1,double Y2,double Xdd,double Ydd)
{ //println("double torus dist");
  double dX=Math.abs(X2-X1);
  double dY=Math.abs(Y2-Y1);
  if( dX > (Xdd/2) ) dX=Xdd-dX;
  if( dY > (Ydd/2) ) dY=Ydd-dY;
  if(dX!=0 || dY!=0)
    return Math.sqrt(dX*dX+dY*dY);
  else
    return 0;
}

/// Euclidean like distance on torus (int numbers)
/// Sometimes needed in simulation programs
/// Version compatible with float and double versions
/// @param Xdd & @param Ydd are the horizontal and vertical perimeter of the torus
public double distanceTorusInt(int X1,int X2,int Y1,int Y2,int Xdd,int Ydd)
{ //println("int torus dist");
  int dX=abs(X2-X1);
  int dY=abs(Y2-Y1);
  if( dX > (Xdd/2) ) dX=Xdd-dX;
  if( dY > (Ydd/2) ) dY=Ydd-dY;
  if(dX!=0 || dY!=0)
    return Math.sqrt(dX*dX+dY*dY);
  else
    return 0;
}

/* 
/// Domyslnie Euklidesowy, z uwzględnieniem długości okna
/// ale dlaczego nie szerokości?
double distance(double X1,double X2,double Y1,double Y2)
{
  double dX=X2-X1;
  double dY=Y2-Y1;

  if(dX>(length/2)) dX=length-dX;
  if(dY>(length/2)) dY=length-dY;
  
  if(dX!=0 || dY!=0)
    return Math.sqrt(dX*dX+dY*dY);
  else
    return 0;
}
*/

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
/// Math basics
//*/////////////////

/// Some of my older programs show the constant FLOAT_MAX, while MAX_FLOAT is currently available.
final float FLOAT_MAX=MAX_FLOAT; //3.40282347E+38;

/// Function for determining the sign of a integer number.
public int sign(int val)
{
  if(val>0) return 1;
  else if(val==0) return 0;
  else return -1;
}

/// Function for determining the sign of a float number.
public int sign(float val)
{
  if(val>0) return 1;
  else if(val==0) return 0;
  else return -1;
}

/// Function for determining the sign of a double number.
public int sign(double val)
{
  if(val>0) return 1;
  else if(val==0) return 0;
  else return -1;
}

/// Function for increasing no more than up to a certain threshold value
public float upToTresh(float val,float incr,float tresh)
{
    val+=incr;
    return val<tresh?val:tresh;
}

/// Function to find which of the three values is the largest?
public int whichIsMax(float v0,float v1,float v2)
{
  if(v0 > v1 && v0 > v2) return 0;
  else if( v1 > v0 && v1 > v2) return 1;
  else if( v2 > v0 && v2 > v1) return 2;
  else return -1;//żaden nie jest dominujący
}

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
///  Bit tools
//*///////////////////

/// Function for mutating integer bits.
/// Flip-flop the bit at the given position
public int swithbit(int sou,int pos)
{
  if(pos>=MASKBITS)//Define MASKBITS somewhere
  {
    println("!!! Mutation autside BITMASK");
    return sou;
  }
  
  int bit=0x1<<pos; // There is a correct position
  
  //print(":"+bit+" ");
  return sou^bit;//xor should do the job? TOCO CHECK?
}

/// IBit counting function.
/// Counts the set bits of an integer
public int countbits(int u)
{
  final int BITSPERINT=32; assert Integer.BYTES==4;
  int sum=0;
  for(int i=0;i<BITSPERINT;i++)
    {
    if((u & 1) !=0 )
        sum++;
    u>>=1;
    }
  return sum;
}

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
//* Handy logarithms and around
//*/////////////////////////////////////////////

/// Calculates the base-10 logarithm of a number
public float log10 (float x)
{
  return (log(x) / log(10));
}

/// Calculates the base-2 logarithm of a number
public float log2 (float x)
{
  return (log(x) / log(2));
}

/// Calculates the base-2 logarithm of a number with double precision
public double log2 (double x) 
{
  return (Math.log(x) / Math.log(2)); //Math.log2(x); 
}

/// Calculates the base-10 logarithm of a number with double precision
public double log10 (double x) 
{
  return  Math.log10(x);//  (Math.log(x) / Math.log(10));
}

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
/// Functions for easy and READABLE in squaring expressions
//*//////////////////////////////////////////////////////////////////////

/// A square of an int number
public int sqr(int a)
{
  return a*a;
}

/// A square of an float number
public float sqr(float a)
{
  return a*a;
}

/// A square of an double number
public double sqr(double a)
{
  return a*a;
}

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
/// Functions that improve the use of pseudo-random numbers
///*/////////////////////////////////////////////////////////////

/// Function generates pseudo random number with non-flat distribution.
/// When @p Dist is negative, it is Pareto-like, 
/// when is positive, it is Gaussian-like
public float randomGaussPareto(int Dist)
{
  if(Dist>0)
  {
    float s=0;
    for(int i=0;i<Dist;i++)
      s+=random(0,1);
    return s/Dist;  
  }
  else
  {
    float s=1;
    for(int i=Dist;i<0;i++)
       s*=random(0,1);
    return s;
  }
}

/// XOR SHIFT random number generator with flat distribution
/// Apart from the function, it also needs a variable for storing the grain 
/// and a constant for storing the denominator.
/// See: http://www.javamex.com/tutorials/random_numbers/xorshift.shtml#.WT6NEzekKXI

static long   xl=123456789L; ///< seed for xorshift randomizer
final double denominator=(double)9223372036854775807L; ///< denominator for xorshift randomizer (why double?)
//final  long   denominator=9223372036854775807L;/// 9,223,372,036,854,775,807 <--- max long 

/// Function which generates xorshift random value.
public double RandomXorShift() 
{
  xl ^= (xl << 21);
  xl ^= (xl >>> 35);
  xl ^= (xl << 4);
  return (Math.abs(xl)/denominator);//Is the result of abs() automatically promoted to double? Looks like...
}

/// @Function RandomPareto().
/// It generates pareto distribution from flat distribution
/// See: https://math.stackexchange.com/questions/1777367/how-to-generate-a-random-number-from-a-pareto-distribution
/// Not tested!!! TODO!
/*
double a = 41.4104*(1-0.01); //Kształt- im większe tym ostrzej skośny rozkład
double b =  6.82053374;      //Skalowanie - im większe tym większy zakres. 
			     // Wartość 6.n dobrana do zakresu 0..1
double limit = 1;            //Akceptujemy tylko wartości od 0 do limit. 
			     // Większe powodują ponowne losowanie
  
double RandomPareto()
{
  double rndval;
  do 
  { 
   rndval = ??? ;//random(0,1)?;//MyRandom2();//drand48() ?
   //rndval = 1-rndval;//PO CO?
   double inv_fun_denom = Math.pow(1-rndval , 1/a);
   rndval = (b/inv_fun_denom)-b; //adding the -b did the trick
  }while(rndval>limit);//Akceptujemy tylko wartości od 0 do limit
  return rndval;
}
*/

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
/// A template of making a histogram from an example agent with "A" field
/// It would be difficult to generalize to any field.
/// Easier you can just rename the field as needed.
//* PL: Szablon wykonania histogramu z przykładowego pola .A agenta 
//* PL: Trudno by to było uogólnić na dowolne pola. 
//* PL: Łatwiej po prostu zmieniać nazwę pola w razie potrzeby.
//*/////////////////////////////////////////////////////////////////////////////////////////////////////

/// Version for a two-dimensional array of agents
public int[] makeHistogramOfA(Agent[][] Ags, //!< Two-dimensional "world" of agents - a two-dimensional array  
                       int N,         //!< Number of buckets in the histogram
                       double Min,    //!< Possibility to give the minimum known from other calculations
                       double Max,    //!< Possibility to give the maximum known from other calculations
                       DummyInt Counter, //!< [out] How many values counted in this statistic
                       DummyDouble CMin, //!< [out] MIN calculated - for reference
                       DummyDouble CMax  //!< [out] MAX calculated - for reference
                       )
{
  CMin.val=FLOAT_MAX;
  CMax.val=-FLOAT_MAX;
  if(Min==FLOAT_MAX || Max==-FLOAT_MAX)//Jesli trzeba określić Min i Max
  {
    for(Agent[] Ar: Ags)
      for(Agent  Ag: Ar )
      {
        double val=Ag.A; //Example of getting value - REPLACE WITH YOUR OWN CODE
        
        if(val<Min) Min=val;
        if(val>Max) Max=val;  
      }
    CMin.val=Min;
    CMax.val=Max;
  }
  
  int[] Hist=new int[N];
  
  int Count=0;
  double Basket=(Max-Min)/N;
  //println("Basket width: "+Basket+" MinMax: "+Min+"-"+Max);
   for(Agent[] Ar: Ags)
      for(Agent  Ag: Ar)
      {
        double val=Ag.A; //Example of getting value - REPLACE WITH YOUR OWN CODE
        
        if(val<Min 
        || val>Max) continue; //IGNORE THIS VALUE!
        
        int index=(int)((val-Min)/Basket);
        
        if(index==N)
            index=N-1;
        
        Hist[index]++;
        
        Count++;
      }
      
  Counter.val=Count;
  
  return Hist;
}

/// Version for a two-dimensional array of agents
public int[] makeHistogramOfA(Agent[] Ags,   
                       int N,
                       double Min,
                       double Max,
                       DummyInt Counter,
                       DummyDouble CMin,
                       DummyDouble CMax
                       )

{
  CMin.val=FLOAT_MAX;
  CMax.val=-FLOAT_MAX;
  if(Min==FLOAT_MAX || Max==-FLOAT_MAX)//Jesli trzeba określić Min i Max
  {
      for(Agent  Ag: Ags )
      {
        double val=Ag.A; //Example of getting value - REPLACE WITH YOUR OWN CODE
        
        if(val<Min) Min=val;
        if(val>Max) Max=val;  
      }
    CMin.val=Min;
    CMax.val=Max;
  }
  
  int[] Hist=new int[N];
  
  int Count=0;
  double Basket=(Max-Min)/N;
  //println("Basket width: "+Basket+" MinMax: "+Min+"-"+Max);
      for(Agent  Ag: Ags)
      {
        double val=Ag.A; //Example of getting value - REPLACE WITH YOUR OWN CODE
        
        if(val<Min 
        || val>Max) continue; //IGNORE THIS!
        
        int index=(int)((val-Min)/Basket);
        
        if(index==N)
            index=N-1;
        
        Hist[index]++;
        
        Count++;
      }
      
  Counter.val=Count;
  
  return Hist;
}

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
///  Various simple statistics for one-dimensional arrays
//*  PL: Różne proste statystyki dla tablic jednowymiarowych
//*/////////////////////////////////////////////////////////

/// EN: Arithmetic mean of the float data
//* PL: Średnia arytmetyczna z danych typu float
/// See: https://en.wikipedia.org/wiki/Arithmetic_mean
public float meanArithmetic(float data[],int offset,int limit)
{                       
                                  assert(offset<limit);
                                  assert(limit<data.length);
  double sum = 0;
  
  for (int i = offset ; i < limit; i++)
  {
    sum += data[i];     
  }
                                             
  return (float)(sum/(limit-offset)); 
}

/// Arithmetic mean of the "double" precision data
//* PL: Średnia arytmetyczna z danych o "podwójnej" precyzji
/// See: https://en.wikipedia.org/wiki/Arithmetic_mean
public double meanArithmetic(double data[],int offset,int limit)
{                       
                                    assert(offset<limit);
                                    assert(limit<data.length);
  double sum = 0;
  
  for (int i = offset ; i < limit; i++)
  {
    sum += data[i];     
  }
                                             
  return sum/(limit-offset);
}

/// Pearson's correlation
//* PL: Korelacja Pearsona
/// https://pl.wikipedia.org/wiki/Wsp%C3%B3%C5%82czynnik_korelacji_Pearsona
public double correlation(float data1[],float data2[],
                   int offset1,int offset2,
                   int limit)
{
  double X_s=0,Y_s=0;
  double summ1=0,summ2=0,summ3=0,corelation=0;
  int i,N=0,start=0,ITMAXP=min(limit,data1.length,data2.length);  

  if(offset1==offset2)
  {
    start=offset1;
    offset1=offset2=0;//Niepotrzebne
  }
  else if(offset1>offset2)
  {
    start=offset2;
    offset2=0;
    offset1-=start;
  }
  else// offset1 < offset2
  {
    start=offset1;
    offset1=0;
    offset2-=start;
  }

  //print(start,offset1,offset2,ITMAXP);
  
  for(i = start; i < ITMAXP; i++)
  {
    X_s+=data1[i+offset1];
    Y_s+=data2[i+offset2];
    N++;
  }
  /*println(" ",N);*/ assert(N==ITMAXP);
  
  X_s/=N;  
  Y_s/=N;  
  
  for(i = start; i < ITMAXP; i++)
  {
    summ1+=(X_s-data1[i+offset1])*(Y_s-data2[i+offset2]);
    summ2+=(X_s-data1[i+offset1])*(X_s-data1[i+offset1]);
    summ3+=(Y_s-data2[i+offset2])*(Y_s-data2[i+offset2]);
  }
     
  if(summ2==0 || summ3==0)
    corelation=-0;//Umownie, bo tak naprawdę nie da się wtedy policzyć
  else
    corelation=summ1/( Math.sqrt(summ2) * Math.sqrt(summ3) );
                                             // assert(fabs(corelation)<=1.01);//+0.01 bo moga byc bledy floating-point
  return corelation;
}

/// Mean of the correlation using Z
/// Unfortunately, the = 1 and = -1 correlations are not transformable, so we cheat a bit
//* Średnia z korelacji za pomocą Z
//* Trzeba zmienić korelacje na Z żeby móc je legalnie dodawać. 
//* Niestety korelacje =1 i =-1 są nietransformowalne więc trochę oszukujemy
public double meanCorrelations(double data[],int offset,int limit)
{
                                            assert(offset<limit);
                                            assert(limit<data.length);
  double PomCorrelation=0;          
  
  for (int i = offset ; i < limit; i++)
  {
    double pom = data[i];
    if (pom >= 0.999999f) pom = 0.999999f;
    if (pom <= -0.999999f) pom = -0.999999f;
    double  Z = 0.5f * Math.log( (1.0f + pom) / (1.0f - pom) ); // robimy transformacje w Z/we do Z transformations
    PomCorrelation += Z; //Sumujemy kolejne Z
  }

  PomCorrelation /= limit - offset; //Uśredniamy Z

  PomCorrelation = ( Math.exp(2 * PomCorrelation) - 1 ) 
                              / 
                   ( Math.exp(2 * PomCorrelation) + 1 ); //I z powrotem zmieniamy w korelacje/And we're changing Z back to correlations
      
  return PomCorrelation;
}

/// Informational entropy from the histogram
//* PL: Entropia informacyjna z histogramu
public double entropyFromHist(int[] histogram)
{
  double sum=0; //Ile przypadków. 
                //Double żeby wymusić dokładne dzielenie zmiennoprzecinkowe
  if(sum==0)
    for(int val: histogram)
      sum+=val;
    
  double sumlog=0;
  for(int val: histogram)
  if(val>0)
  {
    double p=val/sum;
    sumlog+=p*log2(p);
  }
  
  return -sumlog;
}

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
  public void settings() {  size(500,500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Optionals" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
