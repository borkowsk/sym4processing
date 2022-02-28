//*  Game classes and rules and parameters
//*/////////////////////////////////////////

float initialMaxX=100; ///> Initial horizontal size of game "board" 
float initialMaxY=100; ///> Initial vertical size of game "board" 
int initialSizeOfMainArray=30;  ///> Initial number of @GameObjects in @gameWorld
int     indexOfMe=-1;    ///> Index of object visualising client or server supervisor

String plants="☘️";       ///> plants... 
String[] pepl={"😃","😐"};///> peoples...

// Options for visualisation 
boolean VIS_MIN_MAX=true;///> Visualisation with min/max value
boolean KEEP_ASPECT=true;///> Visualisation with proportional aspect ratio
int     INFO_LEVEL=0;    ///> Visualisation with information about objects

//Changes of GameObject atributes (specific for server side)
final int MOVED_MSK  = 0x1; ///> object was moved
final int VISUAL_MSK = 0x2; ///> object changed its type of view
final int COLOR_MSK  = 0x4; ///> object changed its colors
final int STATE_MSK  = 0x8; ///> object changed its states
/// To visualize the interaction between background objects
final int TOUCH_MSK  = STATE_MSK*2;
/// All possible changes
final int ALL_MSK = MOVED_MSK | VISUAL_MSK | COLOR_MSK | STATE_MSK | TOUCH_MSK; 

/// Server side implementation part of any game object
/// needs modification flags, but client side are free to use 
/// this parts.
abstract class implNeeded 
{ 
  int flags=0;//> *_MSK alloved here
}//EndOfClass implNeeded

/// Representation of 3D position in the game world
/// However, the value of Z is not always used.
abstract class Position extends implNeeded
{
  float X,Y;//> 2D coordinates
  float Z;  //> Even on a 2D board, objects can pass each other without collision.
  
  ///constructor
  Position(float iniX,float iniY,float iniZ){
    X=iniX;Y=iniY;Z=iniZ;
  }
  
  float distance2D(Position toWhat)
  {
    return dist(X,Y,toWhat.X,toWhat.Y);
  }
  
  float distance3D(Position toWhat)
  {
    return dist(X,Y,Z,toWhat.X,toWhat.Y,toWhat.Z);
  }
}//EndOfClass Position

/// Representation of generic game object
class GameObject extends Position
{
  String name;//> Each object has an individual identifier necessary for communication. Better short.
  String visual="?";//> Text representation of the visualization. The unicode character or the name of an external file.
  color  foreground=0xff00ff00;//> Main color of object
  
  float[] distances=null;      //> Array of distances to other objects.
                               //> Not always in use!
  float  passiveRadius=1;      //> Radius of passive interaction
  
  ///constructor
  GameObject(String iniName,float iniX,float iniY,float iniZ){ super(iniX,iniY,iniZ);
    name=iniName;
  }
  
  /// List of actions that this object can performed
  /*_interfunc*/ String[] abilities() { return null;} 
  
  /// List of actions that can be performed on this object
  /*_interfunc*/ String[] possibilities() { return null;} 
  
  /// It can make string info about object. 
  /// 'level' is level of details, when 0 means "name only".  
  /*_interfunc*/ String info(int level)
  {
    String ret=name;
    if(level>=0)
      ret+=";"+X+";"+Y;
    if(level>1)
      ret+=";"+passiveRadius;
    return ret;
  }
}//EndOfClass GameObject

class ActiveGameObject extends GameObject
{
  float activeRadius=1;// Radius for active interaction with others objects
  GameObject interactionObject=null;// Only one in a time
  
  ///constructor
  ActiveGameObject(String iniName,float iniX,float iniY,float iniZ,float iniRadius){ super(iniName,iniX,iniY,iniZ);
    activeRadius=iniRadius;
  }
}//EndOfClass ActiveGameObject

/// Representation of generic player
class Player extends ActiveGameObject
{
  Client netLink;// Network connection to client application
  int    indexInGameWorld=-1;
  
  ///constructor
  Player(Client iniClient,String iniName,float iniX,float iniY,float iniZ,float iniRadius){ super(iniName,iniX,iniY,iniZ,iniRadius);
    netLink=iniClient;
  }
}//EndOfClass Player

GameObject[] gameWorld=null;    ///> MAIN ARRAY OF GameObjects

/// Determines the index of the object with the specified proper name 
/// in an array of objects or players. 
/// Simple implementation for now, but you can change into dictionary or 
/// something after that.
int localiseByName(GameObject[] table,String name)
{
  for(int i=0;i<table.length;i++)
  if(table[i]!=null
  && name.equals(table[i].name)
  )
  {
    return i; //<>// //<>//
  }
  return -1;
}

/// Returns the index of the first collided object
/// 'indexOfMoved' is the index of the object for which we check for collisions.
/// The first time 'startIndex' should be 0, but thanks to this parameter 
/// you can continue searching for more collisions. 
int findCollision(GameObject[] table,int indexOfMoved,int startIndex,boolean withZ)
{
  float activeRadius=-1;//By default active radius is disabled
  
  //Is moved object of any active type?
  ActiveGameObject active=(ActiveGameObject)(table[indexOfMoved]);
  if(active!=null)
    activeRadius=active.activeRadius;
  
  for(int i=startIndex;i<table.length;i++)
  if(i!=indexOfMoved && table[i]!=null)
  {
    float dist=withZ?table[indexOfMoved].distance3D(table[i])
                    :table[indexOfMoved].distance2D(table[i]);
    
    //If possible, keep the distance for later use
    if(table[i].distances!=null) table[i].distances[indexOfMoved]=dist; //<>//
    if(table[indexOfMoved].distances!=null) table[indexOfMoved].distances[i]=dist;
                    
    if(dist<=table[indexOfMoved].passiveRadius+table[i].passiveRadius)
    return i; //DETECTED //<>//
    
    if(activeRadius>0 && dist<=activeRadius+table[i].passiveRadius)
    return i; //ALSO DETECTED  //<>//
  }
  return -1;//NO COLLISION DETECTED!
}

/// Flat/map visualisation
void visualise2D(float startX,float startY,float width,float height)
{                                                                   assert gameWorld!=null; //<>//
  float minX=MAX_FLOAT;
  float maxX=MIN_FLOAT;
  float minY=MAX_FLOAT;
  float maxY=MIN_FLOAT;
  //float minZ=MAX_FLOAT; //<>// //<>//
  //float maxZ=MIN_FLOAT;
  
  for(Position p:gameWorld)
  {
    float X=p.X;
    if(minX>X) minX=X;
    if(maxX<X) maxX=X;
    
    float Y=p.Y;
    if(minY>Y) minY=Y;
    if(maxY<Y) maxY=Y;
    
    //float Z=p.Z; //Z is not important for now
    //if(minZ>Z) minZ=Z;
    //if(maxZ<Z) maxZ=Z;
  }
  
  if(KEEP_ASPECT)
  {
    float minXY=min(minX,minY);
    float maxXY=max(maxX,maxY);
    minX=minY=minXY;
    maxX=maxY=maxXY;
  }
  
  if(VIS_MIN_MAX)
  {
    fill(255,255,0);
    textAlign(LEFT,TOP);    text(minX+";"+minY,startX      ,startY);
    textAlign(LEFT,BOTTOM); text(minX+";"+maxY,startX      ,startY+height);
    textAlign(RIGHT,TOP);   text(maxX+";"+minY,startX+width,startY);
    textAlign(RIGHT,BOTTOM);text(maxX+";"+maxY,startX+width,startY+height);
    textAlign(CENTER,CENTER);
  }
  
  textAlign(CENTER,CENTER);
  for(int i=0;i<gameWorld.length;i++)
  {
    GameObject tmp=gameWorld[i];
    if(tmp!=null)
    {
      float X=startX+(tmp.X-minX)/(maxX-minX)*width;
      float Y=startY+(tmp.Y-minY)/(maxY-minY)*width;
      
      if(i==indexOfMe)
      {
          fill(128+random(128),255,0);
          text("!"+tmp.visual+"!",X,Y);
      }
      else
      {
        fill(red(tmp.foreground),green(tmp.foreground),blue(tmp.foreground));
        text(tmp.visual,X,Y);
      }
      
      if(INFO_LEVEL>=0)
      {
        fill(255,0,0,128);textAlign(LEFT,CENTER);
        text(tmp.info(INFO_LEVEL),X+10,Y);
        fill(0,255,0);textAlign(CENTER,CENTER);
      }
    }
  }
}

/// Moves allowed for the player. 
/// Intended to be used on the server side.
boolean playerMove(String dir,Player player)
{
  switch(dir.charAt(0)){
  case 'f': player.Y--; break;
  case 'b': player.Y++; break;
  case 'l': player.X--; break;
  case 'r': player.X++; break;
  default:
       println(player.name,"did unknown move");
       if(player.netLink!=null && player.netLink.active())
          player.netLink.write( sayOptAndInf(Opts.ERR,dir+" move is unknown in this game!") );
       return false;
  }//end of moves switch
  return true;
}

/// The actions of agents and players in the game are defined by names 
/// in the protocol, thanks to which their set is expandable.
boolean playerAction(String action,Player player)
{
  println(player.name,"did undefined or not allowed action:",action);
  if(player.netLink!=null && player.netLink.active())
     player.netLink.write( sayOptAndInf(Opts.ERR,"Action "+action+" is undefined in this context!"));
  return false;
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////
