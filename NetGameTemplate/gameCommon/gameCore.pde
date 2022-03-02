//*  Game classes and rules and parameters
//*/////////////////////////////////////////

float initialMaxX=100; ///> Initial horizontal size of game "board" 
float initialMaxY=100; ///> Initial vertical size of game "board" 
int initialSizeOfMainArray=30;  ///> Initial number of @GameObjects in @gameWorld
int     indexOfMe=-1;    ///> Index of object visualising client or server supervisor

String[] plants= {"_","O","...\nI","_\\|/_\nI ","|/",":","☘️"}; ///> plants... 
String[] avatars={".","^v^" ,"o^o","@","&","😃","😐"};///> peoples...

//Changes of GameObject atributes (specific for server side)
final int VISSWITH   = unbinary("000000001"); ///> object is invisible (but in info level name is visible)
final int MOVED_MSK  = unbinary("000000010"); ///> object was moved (0x1)
final int VISUAL_MSK = unbinary("000000100"); ///> object changed its type of view
final int COLOR_MSK  = unbinary("000001000"); ///> object changed its colors
final int HPOINT_MSK = unbinary("000010000"); ///> object changed its hp state (most frequently changed state)
final int SCORE_MSK  = unbinary("000100000"); ///> object changed its score (for players it is most frequently changed state)
final int PASRAD_MSK = unbinary("001000000"); ///> object changed its passive radius (ex. grow);
final int ACTRAD_MSK = unbinary("010000000"); ///> object changed its radius of activity (ex. go to sleep);
final int STATE_MSK  = HPOINT_MSK | SCORE_MSK | PASRAD_MSK | ACTRAD_MSK ;///> object changed its states
//....any more?
/// To visualize the interaction between background objects
final int TOUCH_MSK  = unbinary("1000000000000000"); ///>16bits
/// All initial changes
final int ALL_CHNG_MSK = MOVED_MSK | VISUAL_MSK | COLOR_MSK | STATE_MSK ; 

// Options for visualisation 
int     INFO_LEVEL =1 | SCORE_MSK;///> Visualisation with information about objects (name & score by default)
boolean VIS_MIN_MAX=true;    ///> Visualisation with min/max value
boolean KEEP_ASPECT=true;    ///> Visualisation with proportional aspect ratio


/// Server side implementation part of any game object
/// needs modification flags, but client side are free to use 
/// this parts.
abstract class implNeeded 
{ 
  int flags=0;//> *_MSK alloved here
  String myClassName()//Shortened class name
  {
    String typeStr=getClass().getName(); 
    int dolar=typeStr.indexOf("$"); //println(typeStr,dolar);
    typeStr=typeStr.substring(dolar+1);
    return typeStr;
  }
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
  
  float  hpoints=1;//Health points
  
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
  
  /// Interface for changing the state of the game object 
  /// over the network (mostly)
  /*_interfunc*/ boolean  setState(String field,String val)
  {
    if(field.charAt(0)=='h' && field.charAt(1)=='p')//hp-points
    {
       hpoints=Float.parseFloat(val);
       return true;
    }
    else
    if(field.charAt(0)=='p' && field.charAt(1)=='a' && field.charAt(2)=='s')//pas-Radius
    {
       passiveRadius=Float.parseFloat(val);
       return true;
    } //<>//
    return false;
  }
  
   /// The function creates a message block from those object 
   /// state elements that have change flags  (for network streaming)
   /*_interfunc*/ String sayState()
   {
     String msg=""; //<>//
     if((flags & VISUAL_MSK )!=0)
        msg+=sayOptAndInfos(Opts.VIS,name,visual);
     if((flags & MOVED_MSK )!=0)  
        msg+=sayPosition(Opts.EUC,name,X,Y);
     if((flags & COLOR_MSK  )!=0)
        msg+=sayOptAndInfos(Opts.COL,name,hex(foreground));
     if((flags & HPOINT_MSK )!=0) 
        msg+=sayOptAndInfos(Opts.STA,name,"hp",nf(hpoints)); 
     if((flags & PASRAD_MSK )!=0)  //<>//
        msg+=sayOptAndInfos(Opts.STA,name,"pasr",nf(passiveRadius));
     return msg;
   }
  
  /// It can make string info about object. 
  /// 'level' is level of details, when 0 means "name only".  
  /*_interfunc*/ String info(int level)
  { //<>//
    String ret="";
    if((level & 0x1)!=0)
      ret+=name;
    if((level & MOVED_MSK)!=0)
      ret+=";"+nf(X)+";"+nf(Y);
    if((level & PASRAD_MSK)!=0)
      ret+=";pr:"+passiveRadius;
    return ret;
  }
}//EndOfClass GameObject

class ActiveGameObject extends GameObject
{
  float activeRadius=1;// Radius for active interaction with others objects
  GameObject interactionObject=null;// Only one in a time
  
  ///constructor
  ActiveGameObject(String iniName,float iniX,float iniY,float iniZ,float iniRadius){ super(iniName,iniX,iniY,iniZ); //<>//
    activeRadius=iniRadius;
  }
  
  /// Interface for changing the state of the game object 
  /// over the network (mostly)
  /*_interfunc*/ boolean  setState(String field,String val)
  {
    if(field.charAt(0)=='a' && field.charAt(1)=='c' && field.charAt(2)=='t')//act-Radius //<>//
    {
       activeRadius=Float.parseFloat(val);
       return true;
    }
    return super.setState(field,val);
  }
  
  /// The function creates a message block from those object 
  /// state elements that have change flags (for network streaming) //<>//
  /*_interfunc*/ String sayState()
  {
     String msg=super.sayState();
     if((flags & ACTRAD_MSK )!=0) 
        msg+=sayOptAndInfos(Opts.STA,name,"actr",nf(activeRadius));
     return msg;
  }  
}//EndOfClass ActiveGameObject //<>// //<>//

/// Representation of generic player
class Player extends ActiveGameObject //<>//
{
  float  score=0;// Result
  Client netLink;// Network connection to client application
  int    indexInGameWorld=-1;
   //<>//
  ///constructor
  Player(Client iniClient,String iniName,float iniX,float iniY,float iniZ,float iniRadius){ super(iniName,iniX,iniY,iniZ,iniRadius); //<>//
    netLink=iniClient; //<>//
  }
  
  /// Interface for changing the state of the game object 
  /// over the network (mostly)
  /*_interfunc*/ boolean  setState(String field,String val)
  {
    if(field.charAt(0)=='s' && field.charAt(1)=='c')//sc-ore //<>//
    {
       score=Float.parseFloat(val);
       return true;
    }
    return super.setState(field,val);
  }
  
  /// The function creates a message block from those object 
  /// state elements that have change flags (for network streaming)
  /*_interfunc*/ String sayState()
  {
     String msg=super.sayState();
     if((flags & SCORE_MSK )!=0) 
        msg+=sayOptAndInfos(Opts.STA,name,"sc",nf(score));
     return msg;
  }  
  
  /// It can make string info about object. 
  /// 'level' is level of details, when 0 means "name only".  
  /*_interfunc*/ String info(int level) //<>//
  {
    String ret=super.info(level);
    if((level & SCORE_MSK)!=0) //<>//
      ret+=";"+score;
    return ret;
  }
  
}//EndOfClass Player //<>//

GameObject[] gameWorld=null;    ///> MAIN ARRAY OF GameObjects
 //<>//
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
    return i;
  }
  return -1;
}

void removeObject(GameObject[] table,String name)
{
  int index=localiseByName(table,name);
  if(index>=0) table[index]=null;
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
  if(active!=null) //<>//
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
    return i; //DETECTED //<>//
    
    if(activeRadius>0 && dist<=activeRadius+table[i].passiveRadius)
    return i; //ALSO DETECTED
  }
  return -1;//NO COLLISION DETECTED!
}

/// Prepares information about the types and names 
/// of all objects on the game board.
/// Mainly needed when a new client connects.
String makeAllTypeInfo(GameObject[] table)
{
  String ret="";
  
  for(int i=0;i<table.length;i++)
     ret+=sayObjectType(table[i].name,table[i].myClassName());
     
  return ret;
}

/// Flat map visualisation
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
    if(tmp!=null && (tmp.flags & VISSWITH)==0 )
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
        if((tmp.flags & TOUCH_MSK)!=0)
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
  if(player.netLink!=null && player.netLink.active())
  {
     if(player.interactionObject==null)
       player.netLink.write( sayOptAndInf(Opts.ERR,"Action "+action+" is undefined in this context!"));
     else
       performAction(player,action,player.interactionObject);
  }
  return false;
}

/// Actions placeholder.
void performAction(ActiveGameObject subject,String action,GameObject object)
{
  if(object.visual.equals(plants[1]))
  {
    subject.hpoints+=object.hpoints;subject.flags|=HPOINT_MSK;
    
    if(subject instanceof Player)
    {
      Player pl=(Player)(subject);
      pl.score++;pl.flags|=SCORE_MSK;
    }
    
    object.hpoints=0;object.flags|=HPOINT_MSK;
    object.visual=plants[0];object.flags|=VISUAL_MSK;
  }
  //println(player.name,"did undefined or not allowed action:",action);
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////
