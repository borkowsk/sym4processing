//*  Game classes and rules
//*///////////////////////////

String plants="☘️";       ///> plants... 
String[] pepl={"😃","😐"};///> peoples...
boolean VIS_MIN_MAX=true;///> Option for visualisation - with min/max value
boolean KEEP_ASPECT=true;///> Option for visualisation - with proportional aspect ratio
boolean WITH_INFO=true;  ///> Information about objects
int     indexOfMe=-1;    ///> Index of object visualising client or server supervisor

//GameObject atributes specific for server side
final int MOVED_MSK  = 0x1; ///> object was moved
final int VISUAL_MSK = 0x2; ///> object changed its type of view
final int COLOR_MSK  = 0x4; ///> object changed its colors
final int ALL_MSK = MOVED_MSK | VISUAL_MSK | COLOR_MSK; ///> all changes

/// Server side implementation part of any game object
/// needs modification flags, but client side are free to use 
/// this parts.
abstract class implNeeded 
{ 
  int flags=0;//*_MSK alloved here
};

/// Representation of 3D position in the game world
abstract class Position extends implNeeded
{
  float X,Y;//2D coordinates
  float Z;//Even on a 2D board, objects can pass each other without collision.
  ///constructor
  Position(float iniX,float iniY,float iniZ)
  {
    X=iniX;Y=iniY;Z=iniZ;
  }
};//EndOfClass Position

/// Representation of generic game object
class GameObject extends Position
{
  String name;//Each object has an individual identifier necessary for communication. Better short.
  String visual="?";//Text representation of the visualization. The unicode character or the name of an external file.
  color  foreground=0xff00ff00;
  ///constructor
  GameObject(String iniName,float iniX,float iniY,float iniZ){ super(iniX,iniY,iniZ);
    name=iniName;
  }
  
  String info()
  {
    return name+":"+X+":"+Y;
  }
};//EndOfClass GameObject

/// Representation of generic player
class Player extends GameObject
{
  Client netLink;
  ///constructor
  Player(Client iniClient,String iniName,float iniX,float iniY,float iniZ){ super(iniName,iniX,iniY,iniZ);
    netLink=iniClient;
  }
};//EndOfClass Player

int initialSizeOfMainArray=30;  ///> ???
GameObject[] gameWorld=null;///> ???

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
    return i; //<>//
  }
  return -1;
}

/// Flat/map visualisation
void visualise2D(float startX,float startY,float width,float height)
{                                                                   assert gameWorld!=null; //<>//
  float minX=MAX_FLOAT;
  float maxX=MIN_FLOAT;
  float minY=MAX_FLOAT;
  float maxY=MIN_FLOAT;
  //float minZ=MAX_FLOAT; //<>//
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
      
      if(WITH_INFO)
      {
        fill(255,0,0,128);textAlign(LEFT,CENTER);
        text(tmp.info(),X+10,Y);
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