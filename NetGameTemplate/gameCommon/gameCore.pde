//*  Game classes and rules
//*///////////////////////////
boolean VIS_MIN_MAX=true;///Option for visualisation

abstract class Position
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

void visualise2D(float startX,float startY,float width,float height)///Flat/map visualisation
{                                                                   assert mainGameArray!=null;
  float minX=MAX_FLOAT;
  float maxX=MIN_FLOAT;
  float minY=MAX_FLOAT;
  float maxY=MIN_FLOAT;
  //float minZ=MAX_FLOAT;
  //float maxZ=MIN_FLOAT;
  
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
  
  if(VIS_MIN_MAX)
  {
    fill(255,255,0);
    textAlign(LEFT,TOP);text(minX+";"+minY,0,0);
    textAlign(LEFT,BOTTOM);text(minX+";"+maxY,0,height);
    textAlign(RIGHT,TOP);text(maxX+";"+minY,width,0);
    textAlign(RIGHT,BOTTOM);text(maxX+";"+maxY,width,height);
    textAlign(CENTER,CENTER);
  }
  
  fill(0,255,0);
  for(int i=0;i<mainGameArray.length;i++)
  {
    GameObject tmp=mainGameArray[i];
    if(tmp!=null)
    {
      float X=startX+(tmp.X-minX)/(maxX-minX)*width;
      float Y=startY+(tmp.Y-minY)/(maxY-minY)*width;
      text(tmp.visual,X,Y);
    }
  }
}
