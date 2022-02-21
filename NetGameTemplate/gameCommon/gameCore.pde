//*  Game classes and rules
//*///////////////////////////

String plants="☘️";//Koniczyna
String[] pepl={"😃","😐"};
boolean VIS_MIN_MAX=true;///Option for visualisation - with min/max value
boolean KEEP_ASPECT=true;///Option for visualisation - with proportional aspect ratio
boolean WITH_INFO=true;///Information about objects
int     indexOfMe=-1;///Index of object visualising client or supervisor

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

class GameObject extends Position
{
  String name;//Each object has an individual identifier necessary for communication. Better short.
  String visual="?";//Text representation of the visualization. The unicode character or the name of an external file.
  ///constructor
  GameObject(String iniName,float iniX,float iniY,float iniZ){ super(iniX,iniY,iniZ);
    name=iniName;
  }
  
  String info()
  {
    return name+":"+X+":"+Y;
  }
};//EndOfClass GameObject

class Player extends GameObject
{
  Client netLink;
  ///constructor
  Player(Client iniClient,String iniName,float iniX,float iniY,float iniZ){ super(iniName,iniX,iniY,iniZ);
    netLink=iniClient;
  }
};//EndOfClass Player

int initialSizeOfMainArray=10;
GameObject[] mainGameArray=null;

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
 //<>//
void visualise2D(float startX,float startY,float width,float height)///Flat/map visualisation
{                                                                   assert mainGameArray!=null;
  float minX=MAX_FLOAT;
  float maxX=MIN_FLOAT;
  float minY=MAX_FLOAT;
  float maxY=MIN_FLOAT;
  //float minZ=MAX_FLOAT;
  //float maxZ=MIN_FLOAT; //<>//
  
  for(Position p:mainGameArray)
  {
    float X=p.X; //<>//
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
  
  fill(0,255,0);textAlign(CENTER,CENTER);
  for(int i=0;i<mainGameArray.length;i++)
  {
    GameObject tmp=mainGameArray[i];
    if(tmp!=null) //<>//
    { //<>//
      float X=startX+(tmp.X-minX)/(maxX-minX)*width;
      float Y=startY+(tmp.Y-minY)/(maxY-minY)*width;
      
      if(i==indexOfMe)
      {
          fill(128+random(128),255,0);
          text("!"+tmp.visual+"!",X,Y);
          fill(0,255,0);
      }
      else
      text(tmp.visual,X,Y); //<>//
      
      if(WITH_INFO) //<>//
      {
        fill(255,0,0,128);textAlign(LEFT,CENTER);
        text(tmp.info(),X+10,Y);
        fill(0,255,0);textAlign(CENTER,CENTER);
      }
    }
  }
}
