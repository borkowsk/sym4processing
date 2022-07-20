/// Game classes and its basic behaviours
//* Use link_commons.sh script for make symbolic connections to gameServer & gameClient directories
//*/////////////////////////////////////////////////////////////////////////////////////////////////

// Game board attributes
int initialSizeOfMainArray=30;  ///< Initial number of @GameObjects in @gameWorld
float initialMaxX=100;          ///< Initial horizontal size of game "board" 
float initialMaxY=100;          ///< Initial vertical size of game "board" 
int     indexOfMe=-1;           ///< Index of object visualising the client or the server supervisor

// For very basic visualisation
String[] plants= {"_","O","...\nI","_\\|/_\nI ","|/",":","☘️"}; ///< plants... 
String[] avatars={".","^v^" ,"o^o","@","&","😃","😐"}; ///< peoples...

static abstract class Masks { //Changes of GameObject attributes (rather specific for server side)
static final int VISSWITH   = unbinary("000000001"); ///< object is invisible (but in info level name is visible)
static final int MOVED  = unbinary("000000010"); ///< object was moved (0x1)
static final int VISUAL = unbinary("000000100"); ///< object changed its type of view
static final int COLOR  = unbinary("000001000"); ///< object changed its colors
static final int HPOINT = unbinary("000010000"); ///< object changed its hp state (most frequently changed state)
static final int SCORE  = unbinary("000100000"); ///< object changed its score (for players it is most frequently changed state)
static final int PASRAD = unbinary("001000000"); ///< object changed its passive radius (ex. grow);
static final int ACTRAD = unbinary("010000000"); ///< object changed its radius of activity (ex. go to sleep);
//....any more?
/// To visualize the interaction between background objects
static final int TOUCHED= unbinary("1000000000000000"); ///<16bits
// Composed masks below:
static final int ALL_STATES  = HPOINT | SCORE | PASRAD | ACTRAD ;     ///< Object changed any of its states
static final int ALL_CHANGED = MOVED | VISUAL | COLOR | ALL_STATES ;  ///< All initial changes
} //EndOfClass Masks

// Options for visualisation 
int     INFO_LEVEL =1 | Masks.SCORE; ///< Visualisation with information about objects (name & score by default)
boolean VIS_MIN_MAX=true;    ///< Visualisation with min/max value
boolean KEEP_ASPECT=true;    ///< Visualisation with proportional aspect ratio

/// Server side implementation part of any game object
/// needs modification flags, but client side are free to use 
/// this parts.
abstract class implNeeded 
{ 
  int flags=0; //!< Masks. allowed here
  
  String myClassName() //!< Shortened class name (see: https://docs.oracle.com/javase/8/docs/api/java/lang/Class.html)
  {
    String typeStr=getClass().getName(); // Alternatively use 'getSimpleName()'
    int dolar=typeStr.indexOf("$"); 
    if(DEBUG!=0) println(typeStr,dolar);
    typeStr=typeStr.substring(dolar+1);
    return typeStr;
  }
} //EndOfClass implNeeded

/// Representation of 3D position in the game world
/// However, the value of Z is not always used.
abstract class Position extends implNeeded
{
  float X,Y; //!< 2D coordinates
  float Z;  //!< Even on a 2D board, objects can pass each other without collision.
  
  /// constructor
  Position(float iniX,float iniY,float iniZ){
    X=iniX;Y=iniY;Z=iniZ;
  }
  
  /// 2D distance calculation
  float distance2D(Position toWhat)
  {
    return dist(X,Y,toWhat.X,toWhat.Y);
  }
  
  /// 3D distance calculation
  float distance3D(Position toWhat)
  {
    return dist(X,Y,Z,toWhat.X,toWhat.Y,toWhat.Z);
  }
} //EndOfClass Position

/// Representation of simple game object
class GameObject extends Position
{
  String name;       //!< Each object has an individual identifier necessary for communication. Better short.
  String visual="?"; //!< Text representation of the visualization. The unicode character or the name of an external file.
  color  foreground=0xff00ff00; //> Main color of object
  
  float  h_points=1; //!< Health points
  
  float[] distances=null; //!< Array of distances to other objects. Not always in use!
                               
  float  passiveRadius=1; //!< Radius of passive interaction
  
  /// constructor
  GameObject(String iniName,float iniX,float iniY,float iniZ){ super(iniX,iniY,iniZ);
    name=iniName;
  }
  
  /// Information, what object can do.
  /// @return: List of actions that this object can performed
  /*_interfunc*/ String[] abilities() { return null;} 
  
  /// Information on what can be done with the object.
  /// @return: List of actions that can be performed on this object
  /*_interfunc*/ String[] possibilities() { return null;} 
  
  /// Interface for changing the state of the game object 
  /// over the network (mostly)
  /// @return: true if field is found
  /*_interfunc*/ boolean  setState(String field,String val)
  {
    if(field.charAt(0)=='h' && field.charAt(1)=='p') //hp-points
    {
       h_points=Float.parseFloat(val);
       return true;
    }
    else
    if(field.charAt(0)=='p' && field.charAt(1)=='a' && field.charAt(2)=='s') //pas-Radius
    {
       passiveRadius=Float.parseFloat(val);
       return true;
    }
    return false;
  }
  
   /// The function creates a message list (for network streaming) 
   /// from those object state elements that have change flag sets
   /// @return: Ready to send list of all changes made on object (based on flags)
   /*_interfunc*/ String sayState()
   {
     String msg="";
     if((flags & Masks.VISUAL )!=0)
        msg+=sayOptAndInfos(OpCd.VIS,name,visual);
     if((flags & Masks.MOVED )!=0)  
        msg+=sayPosition(OpCd.EUC,name,X,Y);
     if((flags & Masks.COLOR  )!=0)
        msg+=sayOptAndInfos(OpCd.COL,name,hex(foreground));
     if((flags & Masks.HPOINT )!=0) 
        msg+=sayOptAndInfos(OpCd.STA,name,"hp",nf(h_points)); 
     if((flags & Masks.PASRAD )!=0)
        msg+=sayOptAndInfos(OpCd.STA,name,"pasr",nf(passiveRadius));
     return msg;
   }
  
  /// It can make string info about object. 
  /// 'level' is level of details, when 0 means "name only".  
  /*_interfunc*/ String info(int level)
  {
    String ret="";
    if((level & 0x1)!=0)
      ret+=name;
    if((level & Masks.MOVED)!=0)
      ret+=";"+nf(X)+";"+nf(Y);
    if((level & Masks.PASRAD)!=0)
      ret+=";pr:"+passiveRadius;
    return ret;
  }
} //EndOfClass GameObject

class ActiveGameObject extends GameObject
{
  float activeRadius=1;              //!< Radius for active interaction with others objects
  GameObject interactionObject=null; //!< Only one in a time
  
  ///constructor
  ActiveGameObject(String iniName,float iniX,float iniY,float iniZ,float iniRadius){ super(iniName,iniX,iniY,iniZ);
    activeRadius=iniRadius;
  }
  
  /// Interface for changing the state of the game object 
  /// over the network (mostly)
  /*_interfunc*/ boolean  setState(String field,String val)
  {
    if(field.charAt(0)=='a' && field.charAt(1)=='c' && field.charAt(2)=='t') //act-Radius
    {
       activeRadius=Float.parseFloat(val);
       return true;
    }
    return super.setState(field,val);
  }
  
  /// The function creates a message block from those object 
  /// state elements that have change flags (for network streaming)
  /// @return: Ready to send list of all changes made on object (based on flags)
  /*_interfunc*/ String sayState()
  {
     String msg=super.sayState();
     if((flags & Masks.ACTRAD )!=0) 
        msg+=sayOptAndInfos(OpCd.STA,name,"actr",nf(activeRadius));
     return msg;
  }  
} //EndOfClass ActiveGameObject

/// Representation of generic player
class Player extends ActiveGameObject
{
  float  score=0;  //!< Result
  Client netLink;  //!< Network connection to client application
  
  int    indexInGameWorld=-1; //!< Index/shortcut to game board array/container

  ///constructor
  Player(Client iniClient,String iniName,float iniX,float iniY,float iniZ,float iniRadius){ super(iniName,iniX,iniY,iniZ,iniRadius);
    netLink=iniClient;
  }
  
  /// Interface for changing the state of the game object 
  /// over the network (mostly)
  /// @return: true if field is found
  /*_interfunc*/ boolean  setState(String field,String val)
  {
    if(field.charAt(0)=='s' && field.charAt(1)=='c') //sc-ore
    {
       score=Float.parseFloat(val);
       return true;
    }
    return super.setState(field,val);
  }
  
  /// The function creates a message block from those object 
  /// state elements that have change flags (for network streaming)
  /// @return: Ready to send list of all changes made on object (based on flags)
  /*_interfunc*/ String sayState()
  {
     String msg=super.sayState();
     if((flags & Masks.SCORE )!=0) 
        msg+=sayOptAndInfos(OpCd.STA,name,"sc",nf(score));
     return msg;
  }  
  
  /// It can make string info about object. 
  /// 'level' is level of details, when 0 means "name only".  
  /*_interfunc*/ String info(int level)
  {
    String ret=super.info(level);
    if((level & Masks.SCORE)!=0)
      ret+=";"+score;
    return ret;
  }
  
} //EndOfClass Player

/// Determines the index of the object with the specified proper name 
/// in an array of objects or players. 
/// Simple implementation for now, but you can change into dictionary or 
/// something after that.
/// @return: index or -1 if not found.
int localiseByName(GameObject[] table,String name)
{
  for(int i=0;i<table.length;i++)
  if(table[i]!=null
  && name.equals(table[i].name)
  )
  {
    return i;
  }
  return -1;
}

/// It removes object referred by name from the table.
/// The object may remains somewhere else, so no any destruction will be performed.
void removeObject(GameObject[] table,String name)
{
  int index=localiseByName(table,name);
  if(index>=0) table[index]=null;
}

/// It finds the index of the first collided object
/// 'indexOfMoved' is the index of the object for which we check for collisions.
/// The first time 'startIndex' should be 0, but thanks to this parameter 
/// you can continue searching for more collisions.
/// When 'withZ' parameter is false, only 2D distance is calculated.
/// @returns: index or -1 if nothing collided with object referred by 'indexOfMoved'
int findCollision(GameObject[] table,int indexOfMoved,int startIndex,boolean withZ)
{
  float activeRadius=-1; //By default active radius is disabled
  
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
    if(table[i].distances!=null) table[i].distances[indexOfMoved]=dist;
    if(table[indexOfMoved].distances!=null) table[indexOfMoved].distances[i]=dist;
                    
    if(dist<=table[indexOfMoved].passiveRadius+table[i].passiveRadius)
    return i; //DETECTED
    
    if(activeRadius>0 && dist<=activeRadius+table[i].passiveRadius)
    return i; //ALSO DETECTED
  }
  return -1; //NO COLLISION DETECTED!
}

/// Prepares information about the types and names 
/// of all objects on the game board.
/// Mainly needed when a new client connects.
/// @return: Ready to send list of type infos messages for whole table
String makeAllTypeInfo(GameObject[] table)
{
  String ret="";
  
  for(int i=0;i<table.length;i++)
     ret+=sayObjectType(table[i].name,table[i].myClassName());
     
  return ret;
}

/// Simplest flat map visualisation of game board
void visualise2D(float startX,float startY,float width,float height)
{                                                            assert gameWorld!=null;
  float minX=MAX_FLOAT;
  float maxX=MIN_FLOAT;
  float minY=MAX_FLOAT;
  float maxY=MIN_FLOAT;
  //float minZ=MAX_FLOAT;
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
  if(DEBUG>3) println("INFO_LEVEL:",binary(INFO_LEVEL));
  for(int i=0;i<gameWorld.length;i++)
  {
    GameObject tmp=gameWorld[i];
    if(tmp!=null && (tmp.flags & Masks.VISSWITH)==0 )
    {
      float X=startX+(tmp.X-minX)/(maxX-minX)*width;
      float Y=startY+(tmp.Y-minY)/(maxY-minY)*width;
      
      if(i==indexOfMe)
      {
          fill(red(tmp.foreground),green(tmp.foreground),blue(tmp.foreground));
          text("-"+tmp.visual+"-",X,Y);
          if(DEBUG>0){ stroke(255,0,0);point(X,Y);}
      }
      else
      {
        fill(red(tmp.foreground),green(tmp.foreground),blue(tmp.foreground));
        text(tmp.visual,X,Y);
        if(DEBUG>0){ stroke(255,0,0);point(X,Y);}
        if((tmp.flags & Masks.TOUCHED)!=0)
        {
          stroke(255,0,0);
          point(X,Y);
          noFill();
          ellipseMode(RADIUS);
          ellipse(X,Y,10,10);
        }
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
/// @return: false if dir string contains unknown command, otherwise true
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
          player.netLink.write( OpCd.say(OpCd.ERR,dir+" move is unknown in this game!") );
       return false;
  } //end of moves switch
  return true;
}

/// The actions of agents and players in the game are defined by names 
/// in the protocol, thanks to which their set is expandable.
void playerAction(String action,Player player)
{
  if(player.netLink!=null && player.netLink.active())
  {
     if(player.interactionObject==null)
       player.netLink.write( OpCd.say(OpCd.ERR,"Action "+action+" is undefined in this context!"));
     else
       performAction(player,action,player.interactionObject);
  }
}

/// Actions placeholder.
void performAction(ActiveGameObject subject,String action,GameObject object)
{
  if(object.visual.equals(plants[1]))
  {
    subject.h_points+=object.h_points;subject.flags|=Masks.HPOINT;
    
    if(subject instanceof Player)
    {
      Player pl=(Player)(subject);
      pl.score++;pl.flags|=Masks.SCORE;
    }
    
    object.h_points=0;object.flags|=Masks.HPOINT;
    object.visual=plants[0];object.flags|=Masks.VISUAL;
  }
  //println(player.name,"did undefined or not allowed action:",action);
}

GameObject[] gameWorld=null;    ///< MAIN ARRAY OF GameObjects

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  Partly sponsored by the EU project "GuestXR" (https://guestxr.eu/)
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////

