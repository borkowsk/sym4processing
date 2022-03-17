import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.net.*; 
import processing.svg.*; 
import processing.net.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class gameServer extends PApplet {

/// Server for gameClients - setup() & draw() SOURCE FILE
//*////////////////////////////////////////////////////////////////// 
//
/// Losely base on
/// example code for a server with multiple clients communicating to only one at a time.
/// (see: https://forum.processing.org/one/topic/how-do-i-send-data-to-only-one-client-using-the-network-library.html)
//
  //Needed for network communication
//import processing.pdf.*;//It acts as a server, but the PDF file is empty
  //No-window server!

static int DEBUG=0;       ///< Level of debug logging (have to be static because of use inside static functions)

Server mainServer; ///< Object representing server's TCP/IP COMMUNICATION

Player[] players= new Player[0]; ///< The array of clients (players)

/// Startup of a game server. 
/// It initialises window (if required) and TCP/IP port.
/// It exits, if is not able to do that.
public void setup() 
{
  //Other possibilities: P2D,P3D,FX2D,PDF,SVG
  //size(700, 500,SVG,"screen_file.svg");//No-window server!
  //size(700, 500,PDF, "screen_file.pdf");//Without window
  Xmargin=200;
  noStroke();
  //textSize(16);//Does not work with UNICODE icons! :-(
  mainServer = new Server(this,servPORT,serverIP);
  if(mainServer.active())
  {
    println("Server for '"+Opcs.name+"' started!");
    println("IP:",serverIP,"PORT:",servPORT);
    initialiseGame();
    surface.setTitle(serverIP+"//"+Opcs.name+":"+servPORT);
  }
  else exit();
}

/// This function is called many times per second.
/// Real work of server depends of current state of clients connections.
public void draw() 
{
  if(players.length==0)
      serverWaitingDraw();
  else
      serverGameDraw();
      
  textAlign(LEFT,BOTTOM);fill(255,0,0);
  text(nf(frameRate,2,2)+"fps",0,height);
}

/// Waiting view placeholder ;-)
public void serverWaitingDraw()
{
  background(128);
  //... any picture?
  visualise2D(Xmargin,0,width-Xmargin,height);
  fill(0);
  textAlign(CENTER,CENTER);
  text("Waiting for clients\n"+avatars[1]+plants[1]+avatars[2],width/2,height/2);
}

/// Confirm client registration and send correct current name
public void confirmClient(Client newClient,Player player)
{
  if(DEBUG>1) print("Server confirms the client's registration: ");
  
  String msg=Opcs.say(Opcs.YOU,player.name);
  if(DEBUG>1) println(msg);
  newClient.write(msg);
    
  msg=sayOptAndInfos(Opcs.VIS,Opcs.sYOU,player.visual);
  if(DEBUG>1) println(msg);
  newClient.write(msg);
  
  // Send the dictionary of types to new player
  msg=makeAllTypeInfo(gameWorld);
  if(DEBUG>0) println(msg);
  newClient.write(msg);
  
  // Send the new Player to other players
  msg=sayObjectType(player.name,player.myClassName());
  if(DEBUG>0) println(msg);
  mainServer.write(msg);
}

/// This is stuff that should be done,  
/// when new client was connected
public void whenClientConnected(Client newClient,String playerName)
{
  for(int i=0;i<players.length;i++)
  if(players[i]!=null
  && playerName.equals(players[i].name))
  {
    if(players[i].netLink==null)//Już był taki, ale połączenie zdechło albo klient!
    {
      println("Player",playerName,"reconnected to server!");
      players[i].netLink=newClient;
      players[i].visual=avatars[2];
      players[i].flags|=Masks.VISUAL;
      confirmClient(newClient,players[i]);
      return;
    }
    else// Taka nazwa dotyczy wciąż aktywnego gracza - trzeba zmienić
    {
      print("New",playerName,"will be ");//Jest już taki, trzeba jakoś zmienić nazwę
      playerName+='X';
      println(playerName);
    }
  }
    
  Player tmp=new Player(newClient,playerName,PApplet.parseInt(random(initialMaxX)),PApplet.parseInt(random(initialMaxY)),1,1.5f);
  
  players = (Player[]) expand(players,players.length+1);//expand the array of clients
  players[players.length-1] = tmp;//sets the last player to be the newly connected client
   
  gameWorld = (GameObject[]) expand(gameWorld,gameWorld.length+1);//expand the array of game objects 
  gameWorld[gameWorld.length-1] = tmp;// Player is also one of GameObjects
  
  //tmp.indexInGameWorld=gameWorld.length-1;// It should also be filled in as an emergency during the first use
  tmp.visual=avatars[1];
    
  println("Player",tmp.name,"connected to server!");
  confirmClient(newClient,tmp);
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////
/// gameServer (dummy) keyboard input & other asynchronic events
//*///////////////////////////////////////////////////////////////////// 

/// Keyboard handler for the server.
/// In most cases not useable. However, it protects the server against 
/// accidental stopping with the ESC key
public void keyPressed()
{
  //ignore!?
  if(key==ESC)
  {
    println("Keyboard is ignored for the game server");
    key=0;
  }
}

/// Event handler called when a client connects to server
public void serverEvent(Server me,Client newClient)
{
  noLoop();//KIND OF CRITICAL SECTION!!!
  
  while(newClient.available() <= 0) delay(10);
  
  if(DEBUG>1) print("Server is READING FROM CLIENT: ");
  String msg=newClient.readStringUntil(Opcs.EOR);
  if(DEBUG>1) println(msg);
  String playerName=decodeHELLO(msg);
  
  msg=sayHELLO(Opcs.name);
  if(DEBUG>1) println("Server is SENDING: ",msg);
  newClient.write(msg);
    
  whenClientConnected(newClient,playerName);
  
  loop(); 
}

/// ClientEvent message is generated 
/// when a client disconnects from server
public void disconnectEvent(Client someClient) 
{
  if(DEBUG>2) println("Disconnect event happened on server.");
  if(DEBUG>2) println(mainServer,someClient);
  
  noLoop();//KIND OF CRITICAL SECTION!!!
  
  for(int i=0;i<players.length;i++)
  if(players[i].netLink == someClient )
  {
    println("Server registered",players[i].name," disconnection.");
    players[i].netLink=null;
    players[i].visual=avatars[0];
    players[i].flags|=Masks.VISUAL;
    break;
  }
  
  loop(); 
}

/// ClientEvent handler is called when the 
/// server recives data from an existing client.
/// This is alternative, asynchronous way to
/// read messages from clients.
//void clientEvent(Client client) 
//{
  //println("Server got clientEvent()"); 
  //msg=cli.read(...)
  //interpretMessage(String msg)
//}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////
/// Game classes and its basic behaviours
//* Use link_commons.sh script for make symbolic connections to gameServer & gameClient directories
//*/////////////////////////////////////////////////////////////////////////////////////////////////

// Game board attributes
int initialSizeOfMainArray=30;  ///< Initial number of @GameObjects in @gameWorld
float initialMaxX=100;          ///< Initial horizontal size of game "board" 
float initialMaxY=100;          ///< Initial vertical size of game "board" 
int     indexOfMe=-1;           ///< Index of object visualising the client or the server supervisor

// For very basic visualistion
String[] plants= {"_","O","...\nI","_\\|/_\nI ","|/",":","☘️"}; ///< plants... 
String[] avatars={".","^v^" ,"o^o","@","&","😃","😐"};///< peoples...

static abstract class Masks { //Changes of GameObject atributes (rather specific for server side)
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
static final int STATES   = HPOINT | SCORE | PASRAD | ACTRAD ;///< object changed its states
static final int ALL_CHNG = MOVED | VISUAL | COLOR | STATES ; ///< All initial changes
}//EndOfClass Masks 

// Options for visualisation 
int     INFO_LEVEL =1 | Masks.SCORE;///< Visualisation with information about objects (name & score by default)
boolean VIS_MIN_MAX=true;    ///< Visualisation with min/max value
boolean KEEP_ASPECT=true;    ///< Visualisation with proportional aspect ratio

/// Server side implementation part of any game object
/// needs modification flags, but client side are free to use 
/// this parts.
abstract class implNeeded 
{ 
  int flags=0;//!< Masks. alloved here
  
  public String myClassName()//> Shortened class name (see: https://docs.oracle.com/javase/8/docs/api/java/lang/Class.html)
  {
    String typeStr=getClass().getName(); // TODO? Use getSimpleName() ?
    int dolar=typeStr.indexOf("$"); //println(typeStr,dolar);
    typeStr=typeStr.substring(dolar+1);
    return typeStr;
  }
}//EndOfClass implNeeded

/// Representation of 3D position in the game world
/// However, the value of Z is not always used.
abstract class Position extends implNeeded
{
  float X,Y;//!< 2D coordinates
  float Z;  //!< Even on a 2D board, objects can pass each other without collision.
  
  /// constructor
  Position(float iniX,float iniY,float iniZ){
    X=iniX;Y=iniY;Z=iniZ;
  }
  
  /// 2D distance calculation
  public float distance2D(Position toWhat)
  {
    return dist(X,Y,toWhat.X,toWhat.Y);
  }
  
  /// 3D distance calculation
  public float distance3D(Position toWhat)
  {
    return dist(X,Y,Z,toWhat.X,toWhat.Y,toWhat.Z);
  }
}//EndOfClass Position

/// Representation of simple game object
class GameObject extends Position
{
  String name;      //!< Each object has an individual identifier necessary for communication. Better short.
  String visual="?";//!< Text representation of the visualization. The unicode character or the name of an external file.
  int  foreground=0xff00ff00;//> Main color of object
  
  float  hpoints=1; //!< Health points
  
  float[] distances=null;      //!< Array of distances to other objects. Not always in use!
                               
  float  passiveRadius=1;      //!< Radius of passive interaction
  
  ///constructor
  GameObject(String iniName,float iniX,float iniY,float iniZ){ super(iniX,iniY,iniZ);
    name=iniName;
  }
  
  /// @return: List of actions that this object can performed
  /*_interfunc*/ public String[] abilities() { return null;} 
  
  /// @return: List of actions that can be performed on this object
  /*_interfunc*/ public String[] possibilities() { return null;} 
  
  /// Interface for changing the state of the game object 
  /// over the network (mostly)
  /// @return: true if field is found
  /*_interfunc*/ public boolean  setState(String field,String val)
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
    }
    return false;
  }
  
   /// The function creates a message list (for network streaming) 
   /// from those object state elements that have change flag sets
   /// @return: Ready to send list of all changes made on object (based on flags)
   /*_interfunc*/ public String sayState()
   {
     String msg="";
     if((flags & Masks.VISUAL )!=0)
        msg+=sayOptAndInfos(Opcs.VIS,name,visual);
     if((flags & Masks.MOVED )!=0)  
        msg+=sayPosition(Opcs.EUC,name,X,Y);
     if((flags & Masks.COLOR  )!=0)
        msg+=sayOptAndInfos(Opcs.COL,name,hex(foreground));
     if((flags & Masks.HPOINT )!=0) 
        msg+=sayOptAndInfos(Opcs.STA,name,"hp",nf(hpoints)); 
     if((flags & Masks.PASRAD )!=0)
        msg+=sayOptAndInfos(Opcs.STA,name,"pasr",nf(passiveRadius));
     return msg;
   }
  
  /// It can make string info about object. 
  /// 'level' is level of details, when 0 means "name only".  
  /*_interfunc*/ public String info(int level)
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
}//EndOfClass GameObject

class ActiveGameObject extends GameObject
{
  float activeRadius=1;             //!< Radius for active interaction with others objects
  GameObject interactionObject=null;//!< Only one in a time
  
  ///constructor
  ActiveGameObject(String iniName,float iniX,float iniY,float iniZ,float iniRadius){ super(iniName,iniX,iniY,iniZ);
    activeRadius=iniRadius;
  }
  
  /// Interface for changing the state of the game object 
  /// over the network (mostly)
  /*_interfunc*/ public boolean  setState(String field,String val)
  {
    if(field.charAt(0)=='a' && field.charAt(1)=='c' && field.charAt(2)=='t')//act-Radius
    {
       activeRadius=Float.parseFloat(val);
       return true;
    }
    return super.setState(field,val);
  }
  
  /// The function creates a message block from those object 
  /// state elements that have change flags (for network streaming)
  /// @return: Ready to send list of all changes made on object (based on flags)
  /*_interfunc*/ public String sayState()
  {
     String msg=super.sayState();
     if((flags & Masks.ACTRAD )!=0) 
        msg+=sayOptAndInfos(Opcs.STA,name,"actr",nf(activeRadius));
     return msg;
  }  
}//EndOfClass ActiveGameObject

/// Representation of generic player
class Player extends ActiveGameObject
{
  float  score=0;  //!< Result
  Client netLink;  //!< Network connection to client application
  
  int    indexInGameWorld=-1;//!< Index/shortcut to game board array/container

  ///constructor
  Player(Client iniClient,String iniName,float iniX,float iniY,float iniZ,float iniRadius){ super(iniName,iniX,iniY,iniZ,iniRadius);
    netLink=iniClient;
  }
  
  /// Interface for changing the state of the game object 
  /// over the network (mostly)
  /// @return: true if field is found
  /*_interfunc*/ public boolean  setState(String field,String val)
  {
    if(field.charAt(0)=='s' && field.charAt(1)=='c')//sc-ore
    {
       score=Float.parseFloat(val);
       return true;
    }
    return super.setState(field,val);
  }
  
  /// The function creates a message block from those object 
  /// state elements that have change flags (for network streaming)
  /// @return: Ready to send list of all changes made on object (based on flags)
  /*_interfunc*/ public String sayState()
  {
     String msg=super.sayState();
     if((flags & Masks.SCORE )!=0) 
        msg+=sayOptAndInfos(Opcs.STA,name,"sc",nf(score));
     return msg;
  }  
  
  /// It can make string info about object. 
  /// 'level' is level of details, when 0 means "name only".  
  /*_interfunc*/ public String info(int level)
  {
    String ret=super.info(level);
    if((level & Masks.SCORE)!=0)
      ret+=";"+score;
    return ret;
  }
  
}//EndOfClass Player

/// Determines the index of the object with the specified proper name 
/// in an array of objects or players. 
/// Simple implementation for now, but you can change into dictionary or 
/// something after that.
/// @return: index or -1 if not found.
public int localiseByName(GameObject[] table,String name)
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

/// It removes object reffered by name from the table.
/// The object may remains somowhere else, so no any destruction will be performed.
public void removeObject(GameObject[] table,String name)
{
  int index=localiseByName(table,name);
  if(index>=0) table[index]=null;
}

/// It finds the index of the first collided object
/// 'indexOfMoved' is the index of the object for which we check for collisions.
/// The first time 'startIndex' should be 0, but thanks to this parameter 
/// you can continue searching for more collisions.
/// Whem withZ parameter is false, only 2D distance is calculated.
/// @returns: index or -1 if nothing collidend with object reffered by indexOfMoved
public int findCollision(GameObject[] table,int indexOfMoved,int startIndex,boolean withZ)
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
    if(table[i].distances!=null) table[i].distances[indexOfMoved]=dist;
    if(table[indexOfMoved].distances!=null) table[indexOfMoved].distances[i]=dist;
                    
    if(dist<=table[indexOfMoved].passiveRadius+table[i].passiveRadius)
    return i; //DETECTED
    
    if(activeRadius>0 && dist<=activeRadius+table[i].passiveRadius)
    return i; //ALSO DETECTED
  }
  return -1;//NO COLLISION DETECTED!
}

/// Prepares information about the types and names 
/// of all objects on the game board.
/// Mainly needed when a new client connects.
/// @return: Ready to send list of type infos messages for whole table
public String makeAllTypeInfo(GameObject[] table)
{
  String ret="";
  
  for(int i=0;i<table.length;i++)
     ret+=sayObjectType(table[i].name,table[i].myClassName());
     
  return ret;
}

/// Simplest flat map visualisation of game board
public void visualise2D(float startX,float startY,float width,float height)
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
/// @return: false if dir string contains unknow command, otherwise true
public boolean playerMove(String dir,Player player)
{
  switch(dir.charAt(0)){
  case 'f': player.Y--; break;
  case 'b': player.Y++; break;
  case 'l': player.X--; break;
  case 'r': player.X++; break;
  default:
       println(player.name,"did unknown move");
       if(player.netLink!=null && player.netLink.active())
          player.netLink.write( Opcs.say(Opcs.ERR,dir+" move is unknown in this game!") );
       return false;
  }//end of moves switch
  return true;
}

/// The actions of agents and players in the game are defined by names 
/// in the protocol, thanks to which their set is expandable.
public void playerAction(String action,Player player)
{
  if(player.netLink!=null && player.netLink.active())
  {
     if(player.interactionObject==null)
       player.netLink.write( Opcs.say(Opcs.ERR,"Action "+action+" is undefined in this context!"));
     else
       performAction(player,action,player.interactionObject);
  }
}

/// Actions placeholder.
public void performAction(ActiveGameObject subject,String action,GameObject object)
{
  if(object.visual.equals(plants[1]))
  {
    subject.hpoints+=object.hpoints;subject.flags|=Masks.HPOINT;
    
    if(subject instanceof Player)
    {
      Player pl=(Player)(subject);
      pl.score++;pl.flags|=Masks.SCORE;
    }
    
    object.hpoints=0;object.flags|=Masks.HPOINT;
    object.visual=plants[0];object.flags|=Masks.VISUAL;
  }
  //println(player.name,"did undefined or not allowed action:",action);
}

GameObject[] gameWorld=null;    ///< MAIN ARRAY OF GameObjects

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////
/// Declaration common for client and server (op.codes and coding/decoding functions)
//* Use link_commons.sh script for make symbolic connections to gameServer & gameClient directories
//*///////////////////////////////////////////////////////////////////////////////////////////////////
//* NOTE: /*_inline*/ is a Processing2C directive translated to inline in C++ output


//long pid = ProcessHandle.current().pid();//JAVA9 :-(

//String  serverIP="192.168.55.201";///< at home 
//String  serverIP="192.168.55.104";///< 2. 
//String  serverIP="10.3.24.216";   ///< at work
//String  serverIP="10.3.24.4";     ///< workstation local
int     servPORT=5205;  	          ///< Teoretically it could be any above 1024
String  serverIP="127.0.0.1";       ///< localhost

/// Protocol dictionary ("opcodes") & general code/decode methods
static abstract class Opcs { 
  static final String name="sampleGame";///< ASCI IDENTIFIER OF PROTOCOL
  static final String sYOU="Y";///< REPLACER OF CORESPONDENT NAME as a ready to use String. 
                               ///< Character.toString(YOU);<-not for static
  //Record defining characters
  static final char EOR=0x03;///< End of record (EOR). EOL is not used, because of it use inside data starings.
  static final char SPC='\t';///< Field separator
                             ///< Maybe something less popular would be better? TODO
  //Record headers (bidirectorial)
  static final char ERR='e'; ///< Error message for partner
  static final char HEL='H'; ///< Hello message (client-server handshake)
  static final char IAM='I'; ///< I am "name of server/name of client"
  static final char YOU='Y'; ///< Redefining player name if not suitable
  //Named variables/resources
  static final char GET='G'; ///< Get global resource by name TODO
  static final char BIN='B'; ///< Binary hunk of resources (name.type\tsize\tthen data) TODO
                             ///< Data hunk is recived exactly "as is"!
  static final char TXT='X'; ///< Text hunk of resources (name.type\tsize\tthen data) TODO
                             ///< Text may be recoded on the reciver side if needed!
  static final char OBJ='O'; ///< Objects managment: "On typename objectName" or "Od objectName"
  //Game scene/state 
  static final char UPD='U'; ///< Request for update about a whole scene
  static final char VIS='V'; ///< Visualisation info for a particular object
  static final char COL='C'; ///< Colors of a particular object
  static final char STA='S'; ///< Named state attribute of a particular object (ex.: objname\thp\tval, objname\tsc\tval etc.)
  static final char EUC='E'; ///< Euclidean position of an object
  static final char POL='P'; ///< Polar position of an object
  //Interactions
  static final char TCH='T'; ///< Active "Touch" with other object (info about name & possible actions)
  static final char DTC='D'; ///< Detouch with any of previously touched object (name provided)
  //Player controls of avatar
  static final char NAV='N'; ///< Navigation of the avatar (wsad and arrows in the template)
  static final char ACT='A'; ///< 'defo'(-ult) or user defined actions of the avatar
  //...
  //static final char XXX='c';// something more...
  
  /// It composes one OPC info. 
  /// For which, when recieved, only charAt(0) is important.
  /// @return message PREPARED to send. 
  /*_inline*/ public static final String say(char opc)
  {
    return Character.toString(opc)+SPC+EOR;
  }
  
  /// It composes simple string info. 
  /// Take care about Opcs.SPC inside 'inf'!
  /// @return message PREPARED to send. 
  /*_inline*/ public static final String say(char opc,String inf)
  {
    return Character.toString(opc)+SPC+inf+SPC+EOR;
  }
  
  /// It composes multiple strings message. 
  /// Take care about Opcs.SPC inside parameters!!!
  /// @return message PREPARED to send.  
  /*_inline*/ public static final String say(char opc,String... varargParam)//NOT TESTED JET
  {
    String ret=Character.toString(opc);
    for (int f=0; f < varargParam.length; f++)
    {
      ret+=SPC;
      ret+=varargParam[f];
    }
    ret+=SPC;
    ret+=EOR;
    return ret;
  }
  
  /// It decodes multiple strings message into array of String. 
  /// Note: The item containing EOR is removed from the end of array.
  /// @return array of strings with opcode string at 0 position
  /*_inline*/ public static final String[] decode(String msg) //NOT TESTED JET
  {
    String[] fields=split(msg,SPC);
    return shorten(fields);// remove the item containing EOR from the end of array and @return the array
  }
}//EndOfClass Opcs

// Specific code/decode functions
//*////////////////////////////////////

/// It composes server-client handshake
/// @return message PREPARED to send. 
/*_inline*/ public static final String sayHELLO(String myName)
{
    return ""+Opcs.HEL+Opcs.SPC+Opcs.IAM+Opcs.SPC
             +myName+Opcs.SPC+Opcs.EOR;
}

/// It decodes handshake
/// @return Name of client or name of game implemented on server
/*_inline*/ public static final String decodeHELLO(String msgHello)
{
  String[] fields=split(msgHello,Opcs.SPC);
  if(DEBUG>2) println(fields[0],fields[1],fields[2]);
  if(fields[0].charAt(0)==Opcs.HEL && fields[1].charAt(0)==Opcs.IAM )
      return fields[2];
  else
      return null;
}

/// Decode one string message.
/// @return All characters between a message header (OpCode+SPC) and a final pair (SPC+EOR)
/*_inline*/ public static final String decodeOptAndInf(String msg)
{
  int beg=2;
  int end=msg.length()-2;
  String ret=msg.substring(beg,end);
  return ret;
}

/// Compose one string info - SPC inside info is NOT allowed.
/// @return message PREPARED to send. 
/*_inline*/ public static final String sayOptAndInfos(char opCode,String objName,String info)
{
  return ""+opCode+"1"+Opcs.SPC
           +objName+Opcs.SPC
           +info+Opcs.SPC
           +Opcs.EOR;
}

/// Compose many(=2) string info - SPC inside infos is NOT allowed.
/// @return message PREPARED to send. 
/*_inline*/ public static final String sayOptAndInfos(char opCode,String objName,String info1,String info2)
{
  return ""+opCode+"2"+Opcs.SPC
           +objName+Opcs.SPC
           +info1+Opcs.SPC
           +info2+Opcs.SPC
           +Opcs.EOR;
}

/// Compose many(=3) string info - SPC inside infos is NOT allowed.
/// @return message PREPARED to send. 
/*_inline*/ public static final String sayOptAndInfos(char opCode,String objName,String info1,String info2,String info3)
{
  return ""+opCode+"3"+Opcs.SPC
           +objName+Opcs.SPC
           +info1+Opcs.SPC
           +info2+Opcs.SPC
           +info3+Opcs.SPC
           +Opcs.EOR;
}

/// It decodes 1-9 infos message. Dimension of the array must be proper
/// @return object name, and fill the infos
/*_inline*/ public static final String decodeInfos(String msgInfos,String[] infos)
{
  String[] fields=split(msgInfos,Opcs.SPC);
  if(DEBUG>2) println(fields.length,fields[1]);

  int dimension=fields[0].charAt(1)-'0';
  
  if(dimension!=infos.length) 
        println("Invalid size",dimension,"of infos array!",infos.length);
        
  for(int i=0;i<infos.length;i++)
    infos[i]=fields[i+2];
  return fields[1];//Nazwa
}

/// It constructs touch message with only one possible action
/// @return message PREPARED to send. 
/*_inline*/ public static final String sayTouch(String nameOfTouched,float distance,String actionDef)
{
  return ""+Opcs.TCH+"1"+Opcs.SPC
           +nameOfTouched+Opcs.SPC
           +actionDef+Opcs.SPC
           +nf(distance)+Opcs.SPC
           +Opcs.EOR;
}

/// It constructs touch message with two possible actions
/// @return message PREPARED to send
/*_inline*/ public static final String sayTouch(String nameOfTouched,float distance,String action1,String action2)
{
  return ""+Opcs.TCH+"2"+Opcs.SPC
           +nameOfTouched+Opcs.SPC
           +action1+Opcs.SPC
           +action2+Opcs.SPC
           +nf(distance)+Opcs.SPC
           +Opcs.EOR;
}

/// It constructs touch message with many possible actions
/// @return message PREPARED to send
/*_inline*/ public static final String sayTouch(String nameOfTouched,float distance,String[] actions)
{
  String ret=""+Opcs.TCH;
  if(actions.length<9)
    ret+=""+actions.length+Opcs.SPC;
  else
    ret+="0"+actions.length+Opcs.SPC;
  ret+=nameOfTouched+Opcs.SPC;  
  for(int i=0;i<actions.length;i++)
    ret+=actions[i]+Opcs.SPC;
  ret+=nf(distance)+Opcs.SPC+Opcs.EOR;  
  return ret;
}

/// It decodes touch message. 
/// @return distance
/// The infos will be filled with name of touched object and up to 9 possible actions
/// (or more - NOT TESTED!)
/*_inline*/ public static final float decodeTouch(String msg,String[] infos)
{
  String[] fields=split(msg,Opcs.SPC);
  
  int dimension=fields[0].charAt(1)-'0';
  if(dimension==0)
  { 
    dimension=Integer.parseInt(fields[0].substring(1));// TODO: TEST!
  }
  
  if(dimension+1 != infos.length) 
        println("Invalid size",dimension,"of infos array!",infos.length,"for",fields[0],"message!");
        
  for(int i=0;i<dimension+1;i++)
    infos[i]=fields[i+1];
    
  return  Float.parseFloat(fields[dimension+2]);
}

/// It composes message about object position (1 dimension)
/// E1 OName Data @ - Euclidean position float(X)
/// P1 OName Data @ - Polar position float(Alfa +-180)
/// @return message PREPARED to send
/*_inline*/ public static final String sayPosition(char EUCorPOL,String objName,float coord)
{
  return ""+EUCorPOL+"1"+Opcs.SPC
           +objName+Opcs.SPC
           +coord+Opcs.SPC
           +Opcs.EOR;
}
                   
/// It composes message about object position (2 dimensions)                   
/// E2 OName Data*2 @ - Euclidean position float(X) float(Y)
/// P2 OName Data*2 @ - Polar position float(Alfa +-180) float(DISTANCE)
/// OName == object identification or name of player or 'Y'
/// @return message PREPARED to send
/*_inline*/ public static final String sayPosition(char EUCorPOL,String objName,float coord1,float coord2)
{
  return ""+EUCorPOL+"2"+Opcs.SPC
           +objName+Opcs.SPC
           +coord1+Opcs.SPC
           +coord2+Opcs.SPC
           +Opcs.EOR;
}

/// It composes message about object position (3 dimensions)
/// E3 OName Data*3 @ - Euclidean position float(X) float(Y) float(H) 
/// P3 OName Data*3 @ - Polar position float(Alfa +-180) float(DISTANCE) float(Beta +-180)
/// OName == object identification or name of player or 'Y'
/// @return message PREPARED to send
/*_inline*/ public static final String sayPosition(char EUCorPOL,String objName,float coord1,float coord2,float coord3)
{
  return ""+EUCorPOL+"3"+Opcs.SPC
           +objName+Opcs.SPC
           +coord1+Opcs.SPC
           +coord2+Opcs.SPC
           +coord3+Opcs.SPC
           +Opcs.EOR;
}

/// It composes message about object position (1-9 dimensions)
/// En OName Data*n @ - Euclidean position float(X) float(Y) float(H) "class name of object or name of player"
/// Pn OName Data*n @ - Polar position float(Alfa +-180) float(DISTANCE) float(Beta +-180) "class name of object or name of player"
/// OName == object identification or name of player or 'Y'
/// @return message PREPARED to send
/*_inline*/ public static final String sayPosition(char EUCorPOL,String objName,float[] coordinates)
{
  String ret=EUCorPOL
            +nf(coordinates.length+1,1)+Opcs.SPC;
  ret+=objName+Opcs.SPC;
  for(int i=0;i<coordinates.length;i++)
  {
    ret+=coordinates[i];
    ret+=Opcs.SPC;
  }
  ret+=Opcs.EOR;
  return ret;
}

/// It decodes 1-9 dimensional positioning message. Dimension of the array must be proper
/// @return name of object and also fill coordinates.
/*_inline*/ public static final String decodePosition(String msgPosition,float[] coordinates)
{
  String[] fields=split(msgPosition,Opcs.SPC);
  if(DEBUG>2) println(fields[0],fields[1],fields[2]);
  if(fields[0].charAt(0)==Opcs.EUC || fields[0].charAt(0)==Opcs.POL )
  {
    int dimension=fields[0].charAt(1)-'0';
    
    if(dimension!=coordinates.length) 
          println("Invalid size",dimension,"of coordinate array!");
          
    for(int i=0;i<coordinates.length;i++)
      coordinates[i]=Float.parseFloat(fields[i+2]);
      
    return fields[1];//Name
  }
  else
  return null;//Invalid message
}

/// For objects types management - type of object
/// @return message PREPARED to send
/*_inline*/ public static final String sayObjectType(String type,String objectName)
{
  return Opcs.OBJ+"n"+Opcs.SPC
         +type+Opcs.SPC
         +objectName+Opcs.SPC
         +Opcs.EOR;  
}

/// For objects types management - object removing from the game world
/// @return message PREPARED to send
/*_inline*/ public static final String sayObjectRemove(String objectName)
{
  return Opcs.OBJ+"d"+Opcs.SPC
         +objectName+Opcs.SPC
         +Opcs.EOR;  
}

/// It decodes message of objects types management - decoding
/// @return array of strings with "del" action and objectName
/// or "new" action, type name and object name.
/// Other actions are possible in the future.
/*_inline*/ public static final String[] decodeObjectMng(String msg)
{
  String[] fields=split(msg,Opcs.SPC);
  if(fields[0].charAt(1)=='n')
    fields[0]="new";
  else
  if(fields[0].charAt(1)=='d')
    fields[0]="del";
  else
  {
    println("Invalid object management command:'"+fields[0].charAt(1)+"' for",fields[1],"! IGNORED!");
    return null;
  }
  
  return shorten(fields);// remove one item from the end of array and @return the array
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////


                   
/// gameServer - more communication & game logic 
//*//////////////////////////////////////////////////// 

int   Xmargin=0;                   ///< Left margin of server screen (status column)
boolean wholeUpdateRequested=false;///< Information about a client requesting information about the entire scene.
                                   ///< In such a case, it is sent to all clients (in this template of the server)

/// This function sends a full game board update to all clients
public void sendWholeUpdate()
{
  noLoop();//KIND OF CRITICAL SECTION!?!?!
  
  GameObject curr=null;
  for(int i=0;i<gameWorld.length;i++)
  if((curr=gameWorld[i])!=null)
  {
    curr.flags|=Masks.ALL_CHNG;
    String msg=curr.sayState();
    //sayOptAndInfos(Opts.VIS,curr.name,curr.visual);
    //msg+=sayPosition(Opts.EUC,curr.name,curr.X,curr.Y);
    //msg+=sayOptAndInfos(Opts.COL,curr.name,hex(curr.foreground));
    if(msg.length()>0)  
      mainServer.write(msg);
    curr.flags=0;//Whatever was there, was sent
  }
    
  wholeUpdateRequested=false;// Now all is sent.
  loop();
}

/// This function sends all recent changes to all clients.
public void sendUpdateOfChangedAgents()
{
  noLoop();//KIND OF CRITICAL SECTION!?!?!
  
  GameObject curr=null;
  
  for(int i=0;i<gameWorld.length;i++)
  if((curr=gameWorld[i])!=null
  && (curr.flags & Masks.ALL_CHNG)!=0
  )
  {
      String msg=curr.sayState();
        
      if(msg.length()>0)  
        mainServer.write(msg);
 
     curr.flags=0;//Whatever was there, was sent
  }
  
  loop();
}

/// It reads pending messages from all players
public void readMessagesFromPlayers()
{
  for(int i = 0; i < players.length; i++) // Always in the same order :-/ TODO?
  if(players[i]!=null 
  && players[i].netLink !=null
  && players[i].netLink.available()>0)
  {
        if(DEBUG>1) print("Server is reciving from",players[i].name,":");
        String msg = players[i].netLink.readStringUntil(Opcs.EOR);
        if(msg==null || msg.equals("") || msg.charAt(msg.length()-1)!=Opcs.EOR)
        {
          println("Server recived invalid message. IGNORED");
          return;
        }
        if(DEBUG>1) println(msg);
        
        textAlign(LEFT,TOP);fill(random(255),random(255),random(255));
        text(players[i].name+": "+players[i].X+" "+players[i].X,
             0, 15*(i+1) );
        
        interpretMessage(msg,players[i]);
  }
}

/// initialisation of game world
public void initialiseGame()
{
  gameWorld=new GameObject[initialSizeOfMainArray];
  for(int i=0;i<initialSizeOfMainArray;i++)
  {
    GameObject tmp=new GameObject("o"+nf(i,2),PApplet.parseInt(random(initialMaxX)),PApplet.parseInt(random(initialMaxY)),0);
    tmp.visual=plants[1];
    tmp.foreground=color(PApplet.parseInt(random(100)),128+PApplet.parseInt(random(128)),100+PApplet.parseInt(random(100)));
    if(DEBUG>2) println(hex(tmp.foreground));
    tmp.flags=Masks.ALL_CHNG;
    gameWorld[i]=tmp;
  }
}

/// Do in game world all, what is independent of players actions
public void stepOfGameMechanics()
{
  for (int i = 0; i < players.length; i++)
  if(players[i]!=null 
  && players[i].netLink !=null
  && players[i].netLink.active())
  {
    //players[i].X = (players[i].X+1)%255;//changes the value based on which client number it has (the higher client number, the fast it changes).
    //String msg=sayPosition(Opts.EUC,Opts.sYOU,players[i].X,players[i].Y);
    //players[i].netLink.write(msg);//writes to the right client (using the byte type is not necessary)
    //players[i].changed=MOVED_MSK;
    fill(players[i].foreground); textAlign(LEFT,TOP);
    text(players[i].name,0,15*(i+1));
  }
}

/// Checks for collisions and sends information about them to clients
/// In the example game, only the players move, so only they can cause collisions
public void checkCollisions()
{
  for(int i=0;i<players.length;i++)
  if(players[i]!=null && players[i].netLink!=null) //Not a ghost
  {
    int indexInGameWorld=players[i].indexInGameWorld; //println(indexInGameWorld);
    if(indexInGameWorld<0) // SAFEGUARD
    {
      indexInGameWorld=localiseByName(gameWorld,players[i].name);
      if(indexInGameWorld>=0) players[i].indexInGameWorld=indexInGameWorld;
      else
      {
        println("Data inconsistency error:",players[i].name,"is not in the game world!");
        continue;
      }
    }
    
    int indexOfTouched=findCollision(gameWorld,indexInGameWorld,0,false);
    if(indexOfTouched>=0) //COLLISION DETECTED!
    {
        if(players[i].interactionObject!=gameWorld[indexOfTouched])//New interaction
        {
          if(DEBUG>0)
            println("New touch beetween",gameWorld[indexInGameWorld].name,"&",gameWorld[indexOfTouched].name);
          players[i].interactionObject=gameWorld[indexOfTouched];
          String[] possib=gameWorld[indexOfTouched].possibilities();
          String msg;
          if(possib==null)
            msg=sayTouch(gameWorld[indexOfTouched].name,0,"defo");//DISTANCE IS IGNORED in THIS GAME
          else
            msg=sayTouch(gameWorld[indexOfTouched].name,0,possib);
          players[i].netLink.write(msg);
        }
    }
    else
    {
      //println("No collision for",gameWorld[indexInGameWorld].name);//DEBUG ONLY!
      if(players[i].interactionObject!=null)
      {
         String msg=Opcs.say(Opcs.DTC,players[i].interactionObject.name);
         players[i].interactionObject=null;
         players[i].netLink.write(msg);
      }
    }
  }
}

/// Server real jobs during game:
/// - Displays how many clients have connected to the server
/// - Visualises the current state of the game
/// - Does what players decided to do (if doable)
/// - If any client requested update, send whole update to clients!
/// - If not, send to clients only last changed things
public void serverGameDraw()
{
  background(0);
  fill(255,0,255);textAlign(LEFT,TOP);
  text(players.length,0,0);//Displays how many clients have connected to the server
  
  visualise2D(Xmargin,0,width-Xmargin,height);// current state of the game
  
  readMessagesFromPlayers();// Do what players decided to do (if doable)
  
  stepOfGameMechanics();//Do what is independent of player actions!
  
  if(wholeUpdateRequested)//If any client requested update
  {
     sendWholeUpdate(); //Send whole update to clients
  }
  else
  {
     sendUpdateOfChangedAgents();// Send to clients only last changed things
  }
  
  checkCollisions();// checks for collisions and sends information about them to clients
}

/// This function interprets message from a particular player
public void interpretMessage(String msg,Player player)
{
  switch(msg.charAt(0)){
  // Future use
  case Opcs.OBJ: // From a neighboring server?
  case Opcs.GET: // RESOURCES NOT IMPLEMENTED FOR NOW! TODO
  //Obliq. part
  default: println("Server recived from",player.name,"UNKNOWN MESSAGE TYPE:",msg.charAt(0));break;
  case Opcs.EOR: println("Server recived empty record from",player.name); break;
  case Opcs.HEL: 
  case Opcs.IAM: // SHOULD NOT APPEAR WHEN REGULAR MESSAGE LOOP IS ACTIVE!
      println("Server recived from",player.name,"UNEXPECTED MESSAGE TYPE:",msg.charAt(0));break;
  //Normal interactions
  case Opcs.UPD: 
                  wholeUpdateRequested=true; 
                break;
  case Opcs.NAV:{ String direction=decodeOptAndInf(msg);     
                  playerMove(direction,player);
                  player.flags|=Masks.MOVED;
                } break;
  case Opcs.ACT:{ String action=decodeOptAndInf(msg);     
                  playerAction(action,player);
                } break;
  }//END OF MESSAGE TYPES SWITCH
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////
  public void settings() {  size(700, 500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "gameServer" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
