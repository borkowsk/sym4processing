import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.net.*; 
import processing.net.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class gameClient extends PApplet {

///  Client for gameServer - MAIN SOURCE FILE (setup() & draw() defined here)
//*/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/// Loosely based on Processing example:
/// --> https://forum.processing.org/one/topic/how-do-i-send-data-to-only-one-client-using-the-network-library.html
//


static int DEBUG=0;    ///< Level of debug logging (have to be static because of use inside static functions)

int VIEW_MSG=0;        ///< Game protocol message tracing level
int INTRO_FRAMES=3;    ///< How long the intro lasts?
int DEF_FRAME_RATE=60; ///< Desired frame rate during game

String  playerName=""; ///< ASCII IDENTIFIER OF THE PLAYER. It is from "player.txt" file.

Client  myClient=null; ///< Network client object representing connection to the server
    
/// Startup of a game client. Still not connected after that.
public void setup() 
{
       //Init window in particular size!
  loadSettings();    //Loads playerName from the 'player.txt' file!
  println("PLAYER:",playerName);
  println("Expected server IP:",serverIP,"\nExpected server PORT:",servPORT);
  frameRate(1);      //Only for intro (->INTRO_FRAMES) and establishing connection time.
  VIS_MIN_MAX=false; //Option for visualisation - with min/max value
  KEEP_ASPECT=true;  //Option for visualisation - with proportional aspect ratio
  INFO_LEVEL=Masks.SCORE;    //Information about objects (-1 - no information printed)
  //textSize(16);    //... not work well with default font :-(
}

/// A function that is triggered many times per second, 
/// carrying out the main tasks of the client.
/// - First it shows the intro for the first few frames.
/// - Then it is trying to establish connection with server
/// - Finally it realising communication with server & visualisation
/// When connection with server broke, it go back to establishing connection.
public void draw() 
{ 
  if(frameCount<INTRO_FRAMES)
  {
       drawStartUpInfo(); 
  }
  else
  if(myClient==null || !myClient.active() )
  {
      drawTryConnect();
  }
  else
  {
      clientGameDraw();
  }
  
  textAlign(CENTER,BOTTOM);fill(255,0,0);
  text("Use WSAD & SPACE ("+nf(frameRate,2,2)+"fps)",width/2.f,height);
}

/// Intro view placeholder ;-)
public void drawStartUpInfo()
{
   background(255);
   //... any picture?
   textAlign(CENTER,CENTER);
   fill(random(128),random(128),random(128));
   text("PLAYER: "+playerName,width/2,height/2);   
}

/// Initial courtesy exchange with the server
public void whenConnectedToServer()
{
    println(playerName,"connected!");
    String msg=sayHELLO(playerName);
    if(VIEW_MSG>0 || DEBUG>1) println(playerName,"is sending:\n",msg);
    myClient.write(msg);
    
    while(myClient.available() <= 0) delay(10);
    
    if(DEBUG>1) print(playerName,"is READING FROM SERVER:");
    msg=myClient.readStringUntil(OpCd.EOR);
    if(VIEW_MSG>0 || DEBUG>1) println(msg);
    
    String serverType=decodeHELLO(msg);
    if(serverType.equals(OpCd.name) )
    {
      surface.setTitle(serverIP+"//"+OpCd.name+":"+playerName);
      gameWorld=new GameObject[1];
      gameWorld[0]=new Player(myClient,playerName,10,10,0,1); //float iniX,float iniY,float iniZ,float iniRadius
      gameWorld[0].visual="???";
      indexOfMe=0;
      msg=OpCd.say(OpCd.UPD);
      if(DEBUG>1) print(playerName,"is SENDING:");
      if(VIEW_MSG>0 || DEBUG>1) println(msg);
      myClient.write(msg);
    }
    else
    {
      println("Protocol mismatch: '"
              +serverType+"'<>'"+OpCd.name+"'");
      myClient.stop();
      exit();
    }
}

/// Attempting to connect and initial communication
public void drawTryConnect()
{
   background(128);
   fill(random(255),random(255),random(255));
   text("Not connected", width/2.f, height/2.f);
   
   myClient = new Client(this,serverIP,servPORT);
   if(!myClient.active())
   {
      if(DEBUG>1) println(playerName," still not connected!");
      myClient=null;
   }
   else
   {
      noLoop(); //KIND OF CRITICAL SECTION?
      whenConnectedToServer();   //If you can't talk to the server then it doesn't come back from this function!
      frameRate(DEF_FRAME_RATE); //OK, it work, go fast!
      loop(); //END OF "CRITICAL SECTION"
   }
}
        
/// Loads the player's name from the file "player.txt"
/// But may do more...
public void loadSettings()
{
  BufferedReader reader=createReader("player.txt");
  try {
    playerName = reader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    playerName = "Unknown_player";
  }
  //reader.close(); //Exception?
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  Partly sponsored by the EU project "GuestXR" (https://guestxr.eu/)
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////
///  gameClient - more communication logic 
//*/////////////////////////////////////////////// 

StringDict inventory=new StringDict();

/// Simple object type management
public void implementObjectManagement(String[] cmd) ///< global?
{
  if(cmd[0].equals("del"))
     removeObject(gameWorld,cmd[2]);
  else
  if(cmd[0].equals("new"))
  {
     if(DEBUG>1) println("type:'"+cmd[2]+"' object:'"+cmd[1]+"'");
     inventory.set(cmd[1],cmd[2]); //println(inventory.get(cmd[1]));
  }
  else
  println(playerName,"UNKNOWN object management command:",cmd[0]);
}

/// Very simple placeholder for use types dictionary 
public GameObject makeGameObject(String name,float X,float Y,float Z,float R)
{
  String type=inventory.get(name); 
  if(DEBUG>1) println("type:'"+type+"' object:'"+name+"'");
  switch(type.charAt(0)){
  default:
      println("Type",type,"unknown. Replaced by ActiveGameObject.");
  case 'A':return new ActiveGameObject(name,X,Y,Z,R);
  case 'G':return new GameObject(name,X,Y,Z);
  case 'P':return new Player(null,name,X,Y,X,R);
  }
}

/// Handling changes in visual representation of any game object.
public void visualisationChanged(GameObject[] table,String name,String visual_repr) ///< global?
{
  int pos=(name.equals(OpCd.sYOU)?indexOfMe:localiseByName(table,name));
  if(pos==-1) //FIRST TIME
  {
    gameWorld = (GameObject[]) expand(gameWorld,gameWorld.length+1);
    pos=gameWorld.length-1;
    gameWorld[pos]=makeGameObject(name,0,0,0,0);
  }
  gameWorld[pos].visual=visual_repr;
}

/// Handle changes in colors of any game object
public void colorChanged(GameObject[] table,String name,String hexColor)
{
  int newColor=unhex(hexColor);
  int pos=(name.equals(OpCd.sYOU)?indexOfMe:localiseByName(table,name));
  if(pos==-1) //FIRST TIME
  {
    gameWorld = (GameObject[]) expand(gameWorld,gameWorld.length+1);
    pos=gameWorld.length-1;
    gameWorld[pos]=makeGameObject(name,0,0,0,0);
    gameWorld[pos].foreground=newColor;
  }
  gameWorld[pos].foreground=newColor;
}

/// Handle changes in position of any game object
public void positionChanged(GameObject[] table,String name,float[] inpos)
{
  int pos=(name.equals(OpCd.sYOU)?indexOfMe:localiseByName(table,name));
  if(pos==-1) //FIRST TIME
  {
    gameWorld = (GameObject[]) expand(gameWorld,gameWorld.length+1);
    pos=gameWorld.length-1;
    gameWorld[pos]=makeGameObject(name,inpos[0],inpos[1],0,0);
    if(inpos.length==3)
      gameWorld[pos].Z=inpos[2];
  }
  else
  {
    gameWorld[pos].X=inPar2[0];
    gameWorld[pos].Y=inPar2[1];
    if(inpos.length==3)
      gameWorld[pos].Z=inpos[2];
  }
}

/// Handle changes in states of agents/objects
public void stateChanged(GameObject[] table,String objectName,String field,String val)
{
  int pos=localiseByName(table,objectName);
  if(pos>=0)
  {
      GameObject me=table[pos]; assert me!=null;
      if(!me.setState(field,val))
      println(objectName+"."+field," NOT FOUND. Change ignored!"); 
  }
  else
  {
    println(objectName,"not found!");
    println("DATA INCONSISTENCY! CALL SERVER FOR FULL UPDATE");
    String msg=OpCd.say(OpCd.UPD);
    if(DEBUG>1) print(playerName,"is SENDING:");
    if(VIEW_MSG>0 || DEBUG>1) println(msg);
    myClient.write(msg);
  }  
}

/// Handling for getting the avatar in contact with the game object.
/// @parametr distance is not used in this example method, 
/// but may be used for more complicated interactions.
public void beginInteraction(GameObject[] table,String[]  objectAndActionsNames,float distance)
{
  int pos=localiseByName(table,objectAndActionsNames[0]);
  
  if(pos>=0)
  {
    if( table[indexOfMe] instanceof ActiveGameObject )
    {
      ActiveGameObject me=(ActiveGameObject)(table[indexOfMe]);                   assert me!=null;
      if(me.interactionObject!=null) me.interactionObject.flags^=Masks.TOUCHED;
      me.interactionObject=table[pos];
    }
    table[pos].flags|=Masks.TOUCHED;
    if(DEBUG>1)
      println(objectAndActionsNames[0],".distance:",distance); //DISTANCE NOT USED FOR NOW!
  }
  else
  {
    println(objectAndActionsNames[0],"not found!");
    println("DATA INCONSISTENCY! FULL UPDATE IS NEEDED!");
    String msg=OpCd.say(OpCd.UPD);
    if(DEBUG>1) print(playerName,"is SENDING:");
    if(VIEW_MSG>0 || DEBUG>1) println(msg);
    myClient.write(msg);
  }
}

/// Handling for getting out of the avatar's contact with the game object.
public void finishInteraction(GameObject[] table,String objectName)
{
  int pos=localiseByName(table,objectName);
  if(pos>=0) //It may happen that in the meantime it has disappeared
  {
    table[pos].flags^=Masks.TOUCHED;
  }
  //Any way, you have to forget about him! 
  if( table[indexOfMe] instanceof ActiveGameObject )
  {
    ActiveGameObject me=(ActiveGameObject)(table[indexOfMe]); assert me!=null;
    me.interactionObject=null;
  }
}

// Arrays for decoding more complicated messages
float[]  inPar1=new  float[1]; ///< global?
float[]  inPar2=new  float[2]; ///< global?
float[]  inPar3=new  float[3]; ///< global?
String[] inStr1=new String[1]; ///< global?
String[] inStr2=new String[2]; ///< global?
String[] inStr3=new String[3]; ///< global?

/// Handling interpretation of messages from server (on client side)
public void interpretMessage(String msg)
{
  switch(msg.charAt(0)){
  default: println(playerName,"received UNKNOWN MESSAGE TYPE:",msg.charAt(0));break;
  // Obligatory messages:
  case OpCd.EOR: if(DEBUG>0) println(playerName,"received NOPE");break;
  case OpCd.HEL:
  case OpCd.IAM: println(playerName,"received UNEXPECTED MESSAGE TYPE:",msg.charAt(0));break;
  case OpCd.ERR: { String error_msg=decodeOptAndInf(msg);
                   println(playerName,"received error:\n\t",error_msg);
                  } break;
  case OpCd.OBJ: { String[] cmd=decodeObjectMng(msg);
                   implementObjectManagement(cmd);
                 } break;
  // Normal interactions:
  case OpCd.YOU: { playerName=decodeOptAndInf(msg);
                 if(DEBUG>1) println(playerName,"received confirmation from the server!");
                 surface.setTitle(serverIP+"//"+OpCd.name+";"+playerName);
                 } break;
  case OpCd.VIS: { String objectName=decodeInfos(msg,inStr1);
                   if(DEBUG>1) println(objectName,"change visualisation into",inStr1[0]); 
                   visualisationChanged(gameWorld,objectName,inStr1[0]);
                 } break;
  case OpCd.COL: { String objectName=decodeInfos(msg,inStr1);
                   if(DEBUG>1) println(objectName,"change color into",inStr1[0]); 
                   colorChanged(gameWorld,objectName,inStr1[0]);
                 } break;   
  case OpCd.STA: {
                   String objectName=decodeInfos(msg,inStr2);
                   if(DEBUG>2) println(objectName,"change state",inStr2[0],"<==",inStr2[1]);
                   stateChanged(gameWorld,objectName,inStr2[0],inStr2[1]);
                 } break;
  // Other interactions:
  case OpCd.TCH: { String[] inputs;
                   switch(msg.charAt(1)){
                   case '1':inputs=inStr2;break;
                   case '2':inputs=inStr3;break;
                   default: 
                         inputs=new String[msg.charAt(1)-'0'+1]; //NOT TESTED?
                         break;
                   }
                   float dist=decodeTouch(msg,inputs);
                   if(DEBUG>1) println(playerName,"touched",inputs[0],inputs[1]);
                   beginInteraction(gameWorld,inputs,dist);
                 }break;
  case OpCd.DTC: { String objectName=decodeOptAndInf(msg);
                 if(DEBUG>1) println(playerName,"detached from",objectName);
                 finishInteraction(gameWorld,objectName); //see: beginInteraction(...);
                 }break;                  
  //... rest of message types
  case OpCd.EUC: if(msg.charAt(1)=='1')
                 {
                   //String who=decodePosition(msg,inparr1); //print(who);
                   //positionChanged(gameWorld,who,inparr1);
                   println("Invalid position message:",msg);
                 }
                 else
                 if(msg.charAt(1)=='2')
                 {
                   String who=decodePosition(msg,inPar2); //print(who);
                   positionChanged(gameWorld,who,inPar2);
                 }
                 else
                 if(msg.charAt(1)=='3')
                 {
                   String who=decodePosition(msg,inPar3); //print(who);
                   positionChanged(gameWorld,who,inPar3);
                 }
                 else
                 {
                   println("Invalid dimension of position message",msg.charAt(1));
                 }
  } //END OF MESSAGE TYPES SWITCH
}

/// This function performs communication with server & visualisation of the game world 
public void clientGameDraw()
{          
    //Visualisation:
    background(0);
    visualise2D(0,0,width,height);
    fill(255,0,0);
    
    //communication with server:
    for(int i = 0; true; i++) //why not while(true) ?
    {
      if (myClient!=null && myClient.available() > 0) 
      {
        if(DEBUG>2) print(playerName,"is receiving:");
        String msg = myClient.readStringUntil(OpCd.EOR);
        if(VIEW_MSG>0 || DEBUG>2) println(msg);
        
        if(msg==null || msg.equals("") || msg.charAt(msg.length()-1)!=OpCd.EOR)
        {
          println(playerName,"received invalid message. IGNORED");
          return;
        }
        
        interpretMessage(msg); // Handling interpretation
      }
      else
      break;
    }
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  Partly sponsored by the EU project "GuestXR" (https://guestxr.eu/)
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////
///  gameClient - keyboard input & other asynchronous events
//*//////////////////////////////////////////////////////////// 

/// Keyboard events - mostly control of the avatar
public void keyPressed()
{
  if(DEBUG>2) println("KEY:",key,PApplet.parseInt(key));
  
  if(myClient==null || !myClient.active())
  {
    println("Connection is not active");
    return;
  }
  
  if(key==65535) //arrows  etc...
  {
    if(DEBUG>2) println("keyCode:",keyCode);
    switch(keyCode){
    case UP: key='w'; break;
    case DOWN: key='s'; break;
    case LEFT: key='a'; break;
    case RIGHT: key='d'; break;
    default:
    return; //Other special keys is ignored in this template
    } //end of switch
  }
  
  String msg="";
  switch(key){
  default:println(key,"is not defined for the game client"); return;
  // Navigation
  case 'w':
  case 'W': msg=OpCd.say(OpCd.NAV,"f"); break;
  case 's':
  case 'S': msg=OpCd.say(OpCd.NAV,"b"); break;
  case 'a':
  case 'A': msg=OpCd.say(OpCd.NAV,"l"); break;
  case 'd':
  case 'D': msg=OpCd.say(OpCd.NAV,"r"); break;
  // Perform interaction:
  case ' ': {
              ActiveGameObject me=(ActiveGameObject)(gameWorld[indexOfMe]);                             assert me!=null;
              if(me.interactionObject!=null)
              {
                msg=OpCd.say(OpCd.ACT,"defo"); 
              }
            } break;
  case ESC: println(key,"is ignored for the game client");key=0; return;
} //END of SWITCH

  if(VIEW_MSG>0) println(playerName,"is sending:\n",msg);
  myClient.write(msg);
}

/// ClientEvent message is generated when a client disconnects.
public void disconnectEvent(Client client) 
{
  background(0);
  print(playerName,"disconnected from server.");                                                assert client==myClient;
  myClient=null;
  frameRate(1);
}

/// Event handler called on server when a client connects to server
public void serverEvent(Server server,Client client)
{
  println(playerName,"got unexpected serverEvent()"); 
}

/// ClientEvent message is generated when the 
/// server sends data to an existing client.
/// @function clientEvent is alternative, asynchronous way
/// to read messages from the server.
//void clientEvent(Client client) 
//{
  //println(playerName,"got clientEvent()"); 
  //msg=cli.read(...)
  //interpretMessage(String msg)
//}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*  Partly sponsored by the EU project "GuestXR" (https://guestxr.eu/)
//*/////////////////////////////////////////////////////////////////////////////////////////
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
  
  public String myClassName() //!< Shortened class name (see: https://docs.oracle.com/javase/8/docs/api/java/lang/Class.html)
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
  public float distance2D(Position toWhat)
  {
    return dist(X,Y,toWhat.X,toWhat.Y);
  }
  
  /// 3D distance calculation
  public float distance3D(Position toWhat)
  {
    return dist(X,Y,Z,toWhat.X,toWhat.Y,toWhat.Z);
  }
} //EndOfClass Position

/// Representation of simple game object
class GameObject extends Position
{
  String name;       //!< Each object has an individual identifier necessary for communication. Better short.
  String visual="?"; //!< Text representation of the visualization. The unicode character or the name of an external file.
  int  foreground=0xff00ff00; //> Main color of object
  
  float  h_points=1; //!< Health points
  
  float[] distances=null; //!< Array of distances to other objects. Not always in use!
                               
  float  passiveRadius=1; //!< Radius of passive interaction
  
  /// constructor
  GameObject(String iniName,float iniX,float iniY,float iniZ){ super(iniX,iniY,iniZ);
    name=iniName;
  }
  
  /// Information, what object can do.
  /// @return: List of actions that this object can performed
  /*_interfunc*/ public String[] abilities() { return null;} 
  
  /// Information on what can be done with the object.
  /// @return: List of actions that can be performed on this object
  /*_interfunc*/ public String[] possibilities() { return null;} 
  
  /// Interface for changing the state of the game object 
  /// over the network (mostly)
  /// @return: true if field is found
  /*_interfunc*/ public boolean  setState(String field,String val)
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
   /*_interfunc*/ public String sayState()
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
  /*_interfunc*/ public boolean  setState(String field,String val)
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
  /*_interfunc*/ public String sayState()
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
  /*_interfunc*/ public boolean  setState(String field,String val)
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
  /*_interfunc*/ public String sayState()
  {
     String msg=super.sayState();
     if((flags & Masks.SCORE )!=0) 
        msg+=sayOptAndInfos(OpCd.STA,name,"sc",nf(score));
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
  
} //EndOfClass Player

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

/// It removes object referred by name from the table.
/// The object may remains somewhere else, so no any destruction will be performed.
public void removeObject(GameObject[] table,String name)
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
public int findCollision(GameObject[] table,int indexOfMoved,int startIndex,boolean withZ)
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
/// @return: false if dir string contains unknown command, otherwise true
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
          player.netLink.write( OpCd.say(OpCd.ERR,dir+" move is unknown in this game!") );
       return false;
  } //end of moves switch
  return true;
}

/// The actions of agents and players in the game are defined by names 
/// in the protocol, thanks to which their set is expandable.
public void playerAction(String action,Player player)
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
public void performAction(ActiveGameObject subject,String action,GameObject object)
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
/// Source file with declarations of common symbols for client and server. 
/// (op.codes and coding/decoding functions).
/// NOTE! Use "link_commons.sh" script for make symbolic connections 
/// to "gameServer/" & "gameClient/" directories.
//*/////////////////////////////////////////////////////////////////////////////////////////////
//* NOTE: /*_inline*/ is a Processing2C directive translated to keyword 'inline' in C++ output


//long pid = ProcessHandle.current().pid(); //JAVA9 :-(
int     servPORT=5205;  	         ///< Theoretically it could be any above 1024
String  serverIP="127.0.0.1";      ///< localhost

//String  serverIP="192.168.55.201"; ///< at home
//String  serverIP="192.168.55.104"; ///< 2.
//String  serverIP="10.3.24.216";    ///< at work
//String  serverIP="10.3.24.4";      ///< workstation local

/// Protocol dictionary ("opcodes") & general code/decode methods
static abstract class OpCd { 
  static final String name="sampleGame"; ///< ASCII IDENTIFIER OF PROTOCOL
  static final String sYOU="Y"; ///< REPLACER OF CORESPONDENT NAME as a ready to use String.
                                ///< Character.toString(YOU);<-not for static
  //Record defining characters
  static final char EOR=0x03; ///< End of record (EOR). EOL is not used, because of it use inside data starings.
  static final char SPC='\t'; ///< Field separator
                              ///< Maybe something less popular would be better? Why not ';' ?
  //Record headers (bidirectional)
  static final char ERR='e'; ///< Error message for partner
  static final char HEL='H'; ///< Hello message (client-server handshake)
  static final char IAM='I'; ///< I am "name of server/name of client"
  static final char YOU='Y'; ///< Redefining player name if not suitable
  //Named variables/resources
  static final char GET='G'; ///< Get global resource by name (NOT IMPLEMENTED)
  static final char BIN='B'; ///< Binary hunk of resources (name.type\tsize\tthen data) (NOT IMPLEMENTED)
                             ///< Data hunk is received exactly "as is"!
  static final char TXT='X'; ///< Text hunk of resources (name.type\tsize\tthen data) (NOT IMPLEMENTED)
                             ///< Text may be recoded on the receiver side if needed!
  static final char OBJ='O'; ///< Objects management: "On(-ew) typename objectName" or "Od(-elete) objectName"
  //Game scene/state 
  static final char UPD='U'; ///< Request for update about a whole scene
  static final char VIS='V'; ///< Visualisation info for a particular object
  static final char COL='C'; ///< Colors of a particular object
  static final char STA='S'; ///< Named state attribute of a particular object (ex.: objname\thp\tval, objname\tsc\tval etc.)
  static final char EUC='E'; ///< Euclidean position of an object
  static final char POL='P'; ///< Polar position of an object
  //Interactions
  static final char TCH='T'; ///< Active "Touch" with other object (info about name & possible actions)
  static final char DTC='D'; ///< Detach with any of previously touched object (name provided)
  //Player controls of avatar
  static final char NAV='N'; ///< Navigation of the avatar (wsad and arrows in the template)
  static final char ACT='A'; ///< 'defo'(-ult) or user defined actions of the avatar
  //...
  //static final char XXX='c'; // something more...
  
  /// It composes one OPC info. 
  /// For which, when received, only charAt(0) is important.
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
  /*_inline*/ public static final String say(char opc,String... varargParam) //NOT TESTED JET
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
    return shorten(fields); // remove the item containing EOR from the end of array and @return the array
  }
} //EndOfClass Opcs

// Specific code/decode functions
//*////////////////////////////////////

/// It composes server-client handshake
/// @return message PREPARED to send. 
/*_inline*/ public static final String sayHELLO(String myName)
{
    return ""+OpCd.HEL+OpCd.SPC+OpCd.IAM+OpCd.SPC
             +myName+OpCd.SPC+OpCd.EOR;
}

/// It decodes handshake
/// @return Name of client or name of game implemented on server
/*_inline*/ public static final String decodeHELLO(String msgHello)
{
  String[] fields=split(msgHello,OpCd.SPC);
  if(DEBUG>2) println(fields[0],fields[1],fields[2]);
  if(fields[0].charAt(0)==OpCd.HEL && fields[1].charAt(0)==OpCd.IAM )
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
  return ""+opCode+"1"+OpCd.SPC
           +objName+OpCd.SPC
           +info+OpCd.SPC
           +OpCd.EOR;
}

/// Compose many(=2) string info - SPC inside infos is NOT allowed.
/// @return message PREPARED to send. 
/*_inline*/ public static final String sayOptAndInfos(char opCode,String objName,String info1,String info2)
{
  return ""+opCode+"2"+OpCd.SPC
           +objName+OpCd.SPC
           +info1+OpCd.SPC
           +info2+OpCd.SPC
           +OpCd.EOR;
}

/// Compose many(=3) string info - SPC inside infos is NOT allowed.
/// @return message PREPARED to send. 
/*_inline*/ public static final String sayOptAndInfos(char opCode,String objName,String info1,String info2,String info3)
{
  return ""+opCode+"3"+OpCd.SPC
           +objName+OpCd.SPC
           +info1+OpCd.SPC
           +info2+OpCd.SPC
           +info3+OpCd.SPC
           +OpCd.EOR;
}

/// It decodes 1-9 infos message. Dimension of the array must be proper
/// @return object name, and fill the infos
/*_inline*/ public static final String decodeInfos(String msgInfos,String[] infos)
{
  String[] fields=split(msgInfos,OpCd.SPC);
  if(DEBUG>2) println(fields.length,fields[1]);

  int dimension=fields[0].charAt(1)-'0';
  
  if(dimension!=infos.length) 
        println("Invalid size",dimension,"of infos array!",infos.length);
        
  for(int i=0;i<infos.length;i++)
    infos[i]=fields[i+2];
  return fields[1]; //Nazwa
}

/// It constructs touch message with only one possible action
/// @return message PREPARED to send. 
/*_inline*/ public static final String sayTouch(String nameOfTouched,float distance,String actionDef)
{
  return ""+OpCd.TCH+"1"+OpCd.SPC
           +nameOfTouched+OpCd.SPC
           +actionDef+OpCd.SPC
           +nf(distance)+OpCd.SPC
           +OpCd.EOR;
}

/// It constructs touch message with two possible actions
/// @return message PREPARED to send
/*_inline*/ public static final String sayTouch(String nameOfTouched,float distance,String action1,String action2)
{
  return ""+OpCd.TCH+"2"+OpCd.SPC
           +nameOfTouched+OpCd.SPC
           +action1+OpCd.SPC
           +action2+OpCd.SPC
           +nf(distance)+OpCd.SPC
           +OpCd.EOR;
}

/// It constructs touch message with many possible actions
/// @return message PREPARED to send
/*_inline*/ public static final String sayTouch(String nameOfTouched,float distance,String[] actions)
{
  String ret=""+OpCd.TCH;
  if(actions.length<9)
    ret+=""+actions.length+OpCd.SPC;
  else
    ret+="0"+actions.length+OpCd.SPC;
  ret+=nameOfTouched+OpCd.SPC;  
  for(int i=0;i<actions.length;i++)
    ret+=actions[i]+OpCd.SPC;
  ret+=nf(distance)+OpCd.SPC+OpCd.EOR;  
  return ret;
}

/// It decodes touch message. 
/// @return distance
/// The infos will be filled with name of touched object and up to 9 possible actions
/// (0 or more than 9 - NOT TESTED!)
/*_inline*/ public static final float decodeTouch(String msg,String[] infos)
{
  String[] fields=split(msg,OpCd.SPC);
  
  int dimension=fields[0].charAt(1)-'0';
  if(dimension==0)
  { 
    dimension=Integer.parseInt(fields[0].substring(1)); // NOT TESTED!
  } //<>//
  
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
  return ""+EUCorPOL+"1"+OpCd.SPC
           +objName+OpCd.SPC
           +coord+OpCd.SPC
           +OpCd.EOR;
}
                   
/// It composes message about object position (2 dimensions)                   
/// E2 OName Data*2 @ - Euclidean position float(X) float(Y)
/// P2 OName Data*2 @ - Polar position float(Alfa +-180) float(DISTANCE)
/// OName == object identification or name of player or 'Y'
/// @return message PREPARED to send
/*_inline*/ public static final String sayPosition(char EUCorPOL,String objName,float coord1,float coord2)
{
  return ""+EUCorPOL+"2"+OpCd.SPC
           +objName+OpCd.SPC
           +coord1+OpCd.SPC
           +coord2+OpCd.SPC
           +OpCd.EOR;
}

/// It composes message about object position (3 dimensions)
/// E3 OName Data*3 @ - Euclidean position float(X) float(Y) float(H) 
/// P3 OName Data*3 @ - Polar position float(Alfa +-180) float(DISTANCE) float(Beta +-180)
/// OName == object identification or name of player or 'Y'
/// @return message PREPARED to send
/*_inline*/ public static final String sayPosition(char EUCorPOL,String objName,float coord1,float coord2,float coord3)
{
  return ""+EUCorPOL+"3"+OpCd.SPC
           +objName+OpCd.SPC
           +coord1+OpCd.SPC
           +coord2+OpCd.SPC
           +coord3+OpCd.SPC
           +OpCd.EOR;
}

/// It composes message about object position (1-9 dimensions)
/// En OName Data*n @ - Euclidean position float(X) float(Y) float(H) "class name of object or name of player"
/// Pn OName Data*n @ - Polar position float(Alfa +-180) float(DISTANCE) float(Beta +-180) "class name of object or name of player"
/// OName == object identification or name of player or 'Y'
/// @return message PREPARED to send
/*_inline*/ public static final String sayPosition(char EUCorPOL,String objName,float[] coordinates)
{
  String ret=EUCorPOL
            +nf(coordinates.length+1,1)+OpCd.SPC;
  ret+=objName+OpCd.SPC;
  for(int i=0;i<coordinates.length;i++)
  {
    ret+=coordinates[i];
    ret+=OpCd.SPC;
  }
  ret+=OpCd.EOR;
  return ret;
}

/// It decodes 1-9 dimensional positioning message. Dimension of the array must be proper
/// @return name of object and also fill coordinates.
/*_inline*/ public static final String decodePosition(String msgPosition,float[] coordinates)
{
  String[] fields=split(msgPosition,OpCd.SPC);
  if(DEBUG>2) println(fields[0],fields[1],fields[2]);
  if(fields[0].charAt(0)==OpCd.EUC || fields[0].charAt(0)==OpCd.POL )
  {
    int dimension=fields[0].charAt(1)-'0';
    
    if(dimension!=coordinates.length) 
          println("Invalid size",dimension,"of coordinate array!");
          
    for(int i=0;i<coordinates.length;i++)
      coordinates[i]=Float.parseFloat(fields[i+2]);
      
    return fields[1]; //Name
  }
  else
  return null; //Invalid message
}

/// For objects types management - type of object
/// @return message PREPARED to send
/*_inline*/ public static final String sayObjectType(String type,String objectName)
{
  return OpCd.OBJ+"n"+OpCd.SPC
         +type+OpCd.SPC
         +objectName+OpCd.SPC
         +OpCd.EOR;  
}

/// For objects types management - object removing from the game world
/// @return message PREPARED to send
/*_inline*/ public static final String sayObjectRemove(String objectName)
{
  return OpCd.OBJ+"d"+OpCd.SPC
         +objectName+OpCd.SPC
         +OpCd.EOR;  
}

/// It decodes message of objects types management - decoding
/// @return array of strings with "del" action and objectName
/// or "new" action, type name and object name.
/// Other actions are possible in the future.
/*_inline*/ public static final String[] decodeObjectMng(String msg)
{
  String[] fields=split(msg,OpCd.SPC);
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
  
  return shorten(fields); // remove one item from the end of array and @return the array
}

//*/////////////////////////////////////////////////////////////////////////////////////////
///  Partly sponsored by the EU project "GuestXR" (https://guestxr.eu/)
///  @author  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
///  @project https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////
  public void settings() {  size(400,400); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "gameClient" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

