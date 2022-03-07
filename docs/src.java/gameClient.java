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

///  Client for gameServer - setup() & draw() SOURCE FILE
//*//////////////////////////////////////////////////////////
//
/// Losely based on:
/// --> https://forum.processing.org/one/topic/how-do-i-send-data-to-only-one-client-using-the-network-library.html
//


int DEBUG=1;           //> Program trace level
int VIEWMESG=0;        //> Game protocol message tracing level
int INTRO_FRAMES=3;    //> How long the intro lasts?
int DEF_FRAME_RATE=60; //> Desired frame rate during game

String  playerName=""; //> ASCII IDENTIFIER OF THE PLAYER. It is from player.txt file.

Client  myClient=null; //> Network client object representing connection to the server
    
/// Startup of a game client. Still not connected after that.
public void setup() 
{
      //Init window in particular size!
  loadSettings();   //Loads playerName from the 'player.txt' file!
  println("PLAYER:",playerName);
  println("Expected server IP:",serverIP,"\nExpected server PORT:",servPORT);
  frameRate(1);     //Only for intro (->INTRO_FRAMES) and establishing connection time.
  VIS_MIN_MAX=false;//Option for visualisation - with min/max value
  KEEP_ASPECT=true; //Option for visualisation - with proportional aspect ratio
  INFO_LEVEL=SCORE_MSK;    //Information about objects (-1 - no information printed)
  //textSize(16);   //... not work well with default font :-(
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
    if(VIEWMESG>0 || DEBUG>1) println(playerName,"is sending:\n",msg);
    myClient.write(msg);
    
    while(myClient.available() <= 0) delay(10);
    
    if(DEBUG>1) print(playerName,"is READING FROM SERVER:");
    msg=myClient.readStringUntil(Opcs.EOR);
    if(VIEWMESG>0 || DEBUG>1) println(msg);
    
    String serverType=decodeHELLO(msg);
    if(serverType.equals(Opcs.name) )
    {
      surface.setTitle(serverIP+"//"+Opcs.name+":"+playerName);
      gameWorld=new GameObject[1];
      gameWorld[0]=new Player(myClient,playerName,10,10,0,1);//float iniX,float iniY,float iniZ,float iniRadius
      gameWorld[0].visual="???";
      indexOfMe=0;
      msg=sayOptCode(Opcs.UPD);
      if(DEBUG>1) print(playerName,"is SENDING:");
      if(VIEWMESG>0 || DEBUG>1) println(msg);
      myClient.write(msg);
    }
    else
    {
      println("Protocol mismatch: '"
              +serverType+"'<>'"+Opcs.name+"'");
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
      noLoop();//???
      whenConnectedToServer();//If you can't talk to the server then it doesn't come back from this function!
      frameRate(DEF_FRAME_RATE);//OK, it work, go fast!
      loop();
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
  //reader.close();//Exception?
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////
///  gameClient - more communication logic 
//*/////////////////////////////////////////////// 

StringDict inventory=new StringDict();

/// Simple object type management
public void implementObjectMenagement(String[] cmd)
{
  if(cmd[0].equals("del"))
     removeObject(gameWorld,cmd[2]);
  else
  if(cmd[0].equals("new"))
  {
     if(DEBUG>1) println("type:'"+cmd[2]+"' object:'"+cmd[1]+"'");
     inventory.set(cmd[1],cmd[2]);//println(inventory.get(cmd[1]));
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

/// Handle changes in visualisation type of any game object
public void visualisationChanged(GameObject[] table,String name,String vtype)
{
  int pos=(name.equals(Opcs.sYOU)?indexOfMe:localiseByName(table,name));
  if(pos==-1)//FIRST TIME
  {
    gameWorld = (GameObject[]) expand(gameWorld,gameWorld.length+1);
    pos=gameWorld.length-1;
    gameWorld[pos]=makeGameObject(name,0,0,0,0);
  }
  gameWorld[pos].visual=vtype;
}

/// Handle changes in colors of any game object
public void colorChanged(GameObject[] table,String name,String hexColor)
{
  int newColor=unhex(hexColor);
  int pos=(name.equals(Opcs.sYOU)?indexOfMe:localiseByName(table,name));
  if(pos==-1)//FIRST TIME
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
  int pos=(name.equals(Opcs.sYOU)?indexOfMe:localiseByName(table,name));
  if(pos==-1)//FIRST TIME
  {
    gameWorld = (GameObject[]) expand(gameWorld,gameWorld.length+1);
    pos=gameWorld.length-1;
    gameWorld[pos]=makeGameObject(name,inpos[0],inpos[1],0,0);
    if(inpos.length==3)
      gameWorld[pos].Z=inpos[2];
  }
  else
  {
    gameWorld[pos].X=inparr2[0];
    gameWorld[pos].Y=inparr2[1];
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
    String msg=sayOptCode(Opcs.UPD);
    if(DEBUG>1) print(playerName,"is SENDING:");
    if(VIEWMESG>0 || DEBUG>1) println(msg);
    myClient.write(msg);
  }  
}

/// Handling for getting the avatar in contact with the game object
public void beginInteraction(GameObject[] table,String[]  objectAndActionsNames)
{
  int pos=localiseByName(table,objectAndActionsNames[0]);
  if(pos>=0)
  {
    if( table[indexOfMe] instanceof ActiveGameObject )
    {
      ActiveGameObject me=(ActiveGameObject)(table[indexOfMe]); assert me!=null;
      if(me.interactionObject!=null) me.interactionObject.flags^=TOUCH_MSK;
      me.interactionObject=table[pos];
    }
    table[pos].flags|=TOUCH_MSK;
  }
  else
  {
    println(objectAndActionsNames[0],"not found!");
    println("DATA INCONSISTENCY! CALL SERVER FOR FULL UPDATE");
    String msg=sayOptCode(Opcs.UPD);
    if(DEBUG>1) print(playerName,"is SENDING:");
    if(VIEWMESG>0 || DEBUG>1) println(msg);
    myClient.write(msg);
  }
}

/// Handling for getting out of the avatar's contact with the game object
public void finishInteraction(GameObject[] table,String objectName)
{
  int pos=localiseByName(table,objectName);
  if(pos>=0)//It may happen that in the meantime it has disappeared
  {
    table[pos].flags^=TOUCH_MSK;
  }
  //Any way, you have to forget about him! 
  if( table[indexOfMe] instanceof ActiveGameObject )
  {
    ActiveGameObject me=(ActiveGameObject)(table[indexOfMe]); assert me!=null;
    me.interactionObject=null;
  }
}

// Arrays for decoding more complicated messages
float[] inparr1=new float[1];
float[] inparr2=new float[2];
float[] inparr3=new float[3];
String[] instr1=new String[1];
String[] instr2=new String[2];
String[] instr3=new String[3];

/// Handling interpretation of messages from server
public void interpretMessage(String msg)
{
  switch(msg.charAt(0)){
  //Obliq. part
  default: println(playerName,"recived UNKNOWN MESSAGE TYPE:",msg.charAt(0));break;
  case Opcs.EOR: if(DEBUG>0) println(playerName,"recived NOPE");break;
  case Opcs.HEL:
  case Opcs.IAM: println(playerName,"recived UNEXPECTED MESSAGE TYPE:",msg.charAt(0));break;
  case Opcs.ERR: { String emessage=decodeOptAndInf(msg);
                   println(playerName,"recived error:\n\t",emessage);
                  } break;
  case Opcs.OBJ: { String[] cmd=decodeObjectMng(msg);
                   implementObjectMenagement(cmd);
                 } break;
  //Normal interactions
  case Opcs.YOU: { playerName=decodeOptAndInf(msg);
                 if(DEBUG>1) println(playerName,"recived confirmation from the server!");
                 surface.setTitle(serverIP+"//"+Opcs.name+";"+playerName);
                 } break;
  case Opcs.VIS: { String objectName=decodeInfos(msg,instr1);
                   if(DEBUG>1) println(objectName,"change visualisation into",instr1[0]); 
                   visualisationChanged(gameWorld,objectName,instr1[0]);
                 } break;
  case Opcs.COL: { String objectName=decodeInfos(msg,instr1);
                   if(DEBUG>1) println(objectName,"change color into",instr1[0]); 
                   colorChanged(gameWorld,objectName,instr1[0]);
                 } break;   
  case Opcs.STA: {
                   String objectName=decodeInfos(msg,instr2);
                   if(DEBUG>2) println(objectName,"change state",instr2[0],"<==",instr2[1]);
                   stateChanged(gameWorld,objectName,instr2[0],instr2[1]);
                 } break;
  // interactions               
  case Opcs.TCH: { String[] inputs;
                   switch(msg.charAt(1)){
                   case '1':inputs=instr2;break;
                   case '2':inputs=instr3;break;
                   default: inputs=new String[msg.charAt(1)-'0'+1];//NOT TESTED TODO!
                   }
                   float dist=decodeTouch(msg,inputs);
                   if(DEBUG>1) println(playerName,"touched",inputs[0],inputs[1]);
                   beginInteraction(gameWorld,inputs);
                 }break;
  case Opcs.DTC: { String objectName=decodeOptAndInf(msg);
                 if(DEBUG>1) println(playerName,"detached from",objectName);
                 finishInteraction(gameWorld,objectName);//--> beginInteraction(inputs);
                 }break;                  
  //... rest of message types
  case Opcs.EUC: if(msg.charAt(1)=='1')
                 {
                   //String who=decodePosition(msg,inparr1);//print(who);
                   //positionChanged(gameWorld,who,inparr1);
                   println("Invalid position message:",msg);
                 }
                 else
                 if(msg.charAt(1)=='2')
                 {
                   String who=decodePosition(msg,inparr2);//print(who);
                   positionChanged(gameWorld,who,inparr2);
                 }
                 else
                 if(msg.charAt(1)=='3')
                 {
                   String who=decodePosition(msg,inparr3);//print(who);
                   positionChanged(gameWorld,who,inparr3);
                 }
                 else
                 {
                   println("Invalid dimension of position message",msg.charAt(1));
                 }
  }//END OF MESSAGE TYPES SWITCH
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
        if(DEBUG>2) print(playerName,"is reciving:");
        String msg = myClient.readStringUntil(Opcs.EOR);
        if(VIEWMESG>0 || DEBUG>2) println(msg);
        
        if(msg==null || msg.equals("") || msg.charAt(msg.length()-1)!=Opcs.EOR)
        {
          println(playerName,"recived invalid message. IGNORED");
          return;
        }
        
        interpretMessage(msg);// Handling interpretation
      }
      else
      break;
    }
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////
///  gameClient - keyboard input & other asynchronic events 
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
  
  if(key==65535)//arrows  etc...
  {
    if(DEBUG>2) println("keyCode:",keyCode);
    switch(keyCode){
    case UP: key='w'; break;
    case DOWN: key='s'; break;
    case LEFT: key='a'; break;
    case RIGHT: key='d'; break;
    default:
    return;//Other special keys is ignored in this template
    }//end of switch
  }
  
  String msg="";
  switch(key){
  default:println(key,"is not defined for the game client");return;
  //Navigation
  case 'w':
  case 'W': msg=sayOptAndInf(Opcs.NAV,"f"); break;
  case 's':
  case 'S': msg=sayOptAndInf(Opcs.NAV,"b"); break;
  case 'a':
  case 'A': msg=sayOptAndInf(Opcs.NAV,"l"); break;
  case 'd':
  case 'D': msg=sayOptAndInf(Opcs.NAV,"r"); break;
  //Perform interaction:
  case ' ': {
              ActiveGameObject me=(ActiveGameObject)(gameWorld[indexOfMe]); assert me!=null;
              if(me.interactionObject!=null)
              {
                msg=sayOptAndInf(Opcs.ACT,"defo"); 
              }
            } break;
  case ESC: println(key,"is ignored for the game client");key=0; return;
}//END of SWITCH

  if(VIEWMESG>0) println(playerName,"is sending:\n",msg);
  myClient.write(msg);
}

/// ClientEvent message is generated when a client disconnects.
public void disconnectEvent(Client client) 
{
  background(0);
  print(playerName,"disconnected from server.");      assert client==myClient;
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
/// This is alternative, asynchronous way to
/// read messages from the server.
void clientEvent(Client client) 
{
  //println(playerName,"got clientEvent()"); 
  //msg=cli.read(...)
  //interpretMessage(String msg)
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////
/// Game classes and its basic behaviours
//* Use link_commons.sh script for make symbolic connections to gameServer & gameClient directories
//*/////////////////////////////////////////////////////////////////////////////////////////////////

// Game board attributes
int initialSizeOfMainArray=30;  ///< Initial number of @GameObjects in @gameWorld
float initialMaxX=100; ///< Initial horizontal size of game "board" 
float initialMaxY=100; ///< Initial vertical size of game "board" 
int     indexOfMe=-1;  ///< Index of object visualising the client or the server supervisor

// For very basic visualistion
String[] plants= {"_","O","...\nI","_\\|/_\nI ","|/",":","☘️"}; ///< plants... 
String[] avatars={".","^v^" ,"o^o","@","&","😃","😐"};///< peoples...

//Changes of GameObject atributes (rather specific for server side)
final int VISSWITH   = unbinary("000000001"); ///< object is invisible (but in info level name is visible)
final int MOVED_MSK  = unbinary("000000010"); ///< object was moved (0x1)
final int VISUAL_MSK = unbinary("000000100"); ///< object changed its type of view
final int COLOR_MSK  = unbinary("000001000"); ///< object changed its colors
final int HPOINT_MSK = unbinary("000010000"); ///< object changed its hp state (most frequently changed state)
final int SCORE_MSK  = unbinary("000100000"); ///< object changed its score (for players it is most frequently changed state)
final int PASRAD_MSK = unbinary("001000000"); ///< object changed its passive radius (ex. grow);
final int ACTRAD_MSK = unbinary("010000000"); ///< object changed its radius of activity (ex. go to sleep);
final int STATE_MSK  = HPOINT_MSK | SCORE_MSK | PASRAD_MSK | ACTRAD_MSK ;///< object changed its states
//....any more?
/// To visualize the interaction between background objects
final int TOUCH_MSK  = unbinary("1000000000000000"); ///<16bits
/// All initial changes
final int ALL_CHNG_MSK = MOVED_MSK | VISUAL_MSK | COLOR_MSK | STATE_MSK ; 

// Options for visualisation 
int     INFO_LEVEL =1 | SCORE_MSK;///< Visualisation with information about objects (name & score by default)
boolean VIS_MIN_MAX=true;    ///< Visualisation with min/max value
boolean KEEP_ASPECT=true;    ///< Visualisation with proportional aspect ratio

/// Server side implementation part of any game object
/// needs modification flags, but client side are free to use 
/// this parts.
abstract class implNeeded 
{ 
  int flags=0;//!< *_MSK alloved here
  
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
  
  float[] distances=null;      //!< Array of distances to other objects.
                               //!< Not always in use!
                               
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
     if((flags & VISUAL_MSK )!=0)
        msg+=sayOptAndInfos(Opcs.VIS,name,visual);
     if((flags & MOVED_MSK )!=0)  
        msg+=sayPosition(Opcs.EUC,name,X,Y);
     if((flags & COLOR_MSK  )!=0)
        msg+=sayOptAndInfos(Opcs.COL,name,hex(foreground));
     if((flags & HPOINT_MSK )!=0) 
        msg+=sayOptAndInfos(Opcs.STA,name,"hp",nf(hpoints)); 
     if((flags & PASRAD_MSK )!=0)
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
    if((level & MOVED_MSK)!=0)
      ret+=";"+nf(X)+";"+nf(Y);
    if((level & PASRAD_MSK)!=0)
      ret+=";pr:"+passiveRadius;
    return ret;
  }
}//EndOfClass GameObject

class ActiveGameObject extends GameObject
{
  float activeRadius=1; //!< Radius for active interaction with others objects
  GameObject interactionObject=null; //!< Only one in a time
  
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
     if((flags & ACTRAD_MSK )!=0) 
        msg+=sayOptAndInfos(Opcs.STA,name,"actr",nf(activeRadius));
     return msg;
  }  
}//EndOfClass ActiveGameObject

/// Representation of generic player
class Player extends ActiveGameObject
{
  float  score=0; //!< Result
  Client netLink; //!< Network connection to client application
  int    indexInGameWorld=-1;

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
     if((flags & SCORE_MSK )!=0) 
        msg+=sayOptAndInfos(Opcs.STA,name,"sc",nf(score));
     return msg;
  }  
  
  /// It can make string info about object. 
  /// 'level' is level of details, when 0 means "name only".  
  /*_interfunc*/ public String info(int level)
  {
    String ret=super.info(level);
    if((level & SCORE_MSK)!=0)
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
          player.netLink.write( sayOptAndInf(Opcs.ERR,dir+" move is unknown in this game!") );
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
       player.netLink.write( sayOptAndInf(Opcs.ERR,"Action "+action+" is undefined in this context!"));
     else
       performAction(player,action,player.interactionObject);
  }
}

/// Actions placeholder.
public void performAction(ActiveGameObject subject,String action,GameObject object)
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

GameObject[] gameWorld=null;    ///< MAIN ARRAY OF GameObjects

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////
/// Declaration common for client and server (op.codes and coding/decoding functions)
//* Use link_commons.sh script for make symbolic connections to gameServer & gameClient directories
//*///////////////////////////////////////////////////////////////////////////////////////////////////
//


//long pid = ProcessHandle.current().pid();//JAVA9 :-(
String  serverIP="127.0.0.1";     ///< localhost
int     servPORT=5205;  ///< Teoretically it could be any above 1024

/// Protocol dictionary ("opcodes" etc.)
class Opcs { 
  static final String name="sampleGame";//> ASCI IDENTIFIER OF PROTOCOL
  static final String sYOU="Y";///< REPLACER OF CORESPONDENT NAME as a ready to use String. 
                               ///< Character.toString(YOU);<-not for static
  //Record defining characters
  static final char EOR=0x03;///< End of record (EOR). EOL is not used, because of it use inside data starings.
  static final char SPC='\t';///< Field separator
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
};

/// It composes server-client handshake
/// @return message PREPARED to send. 
public String sayHELLO(String myName)
{
    return ""+Opcs.HEL+Opcs.SPC+Opcs.IAM+Opcs.SPC
             +myName+Opcs.SPC+Opcs.EOR;
}

/// It decodes handshake
/// @return: Name of client or name of game implemented on server
public String decodeHELLO(String msgHello)
{
  String[] fields=split(msgHello,Opcs.SPC);
  if(DEBUG>2) println(fields[0],fields[1],fields[2]);
  if(fields[0].charAt(0)==Opcs.HEL && fields[1].charAt(0)==Opcs.IAM )
      return fields[2];
  else
      return null;
}

/// It composes one OPC info. For which, when recieved, only charAt(0) is important.
/// @return: message PREPARED to send. 
public String sayOptCode(char optCode)
{
  return Character.toString(optCode)+Opcs.SPC+Opcs.EOR;
}

/// It composes simple string info - Opcs.SPC inside 'inf' is allowed.
/// @return: message PREPARED to send. 
public String sayOptAndInf(char opCode,String inf)
{
  return Character.toString(opCode)+Opcs.SPC+inf+Opcs.SPC+Opcs.EOR;
}

/// Decode one string message.
/// @return: All characters between a message header (OpCode+SPC) and a final pair (SPC+EOR)
public String decodeOptAndInf(String msg)
{
  int beg=2;
  int end=msg.length()-2;
  String ret=msg.substring(beg,end);
  return ret;
}

/// Compose one string info - SPC inside info is NOT allowed.
/// @return: message PREPARED to send. 
public String sayOptAndInfos(char opCode,String objName,String info)
{
  return ""+opCode+"1"+Opcs.SPC
           +objName+Opcs.SPC
           +info+Opcs.SPC
           +Opcs.EOR;
}

/// Compose many(=2) string info - SPC inside infos is NOT allowed.
/// @return: message PREPARED to send. 
public String sayOptAndInfos(char opCode,String objName,String info1,String info2)
{
  return ""+opCode+"2"+Opcs.SPC
           +objName+Opcs.SPC
           +info1+Opcs.SPC
           +info2+Opcs.SPC
           +Opcs.EOR;
}

/// Compose many(=3) string info - SPC inside infos is NOT allowed.
/// @return: message PREPARED to send. 
public String sayOptAndInfos(char opCode,String objName,String info1,String info2,String info3)
{
  return ""+opCode+"3"+Opcs.SPC
           +objName+Opcs.SPC
           +info1+Opcs.SPC
           +info2+Opcs.SPC
           +info3+Opcs.SPC
           +Opcs.EOR;
}

/// It decodes 1-9 infos message. Dimension of the array must be proper
/// @return: object name, and fill the infos
public String decodeInfos(String msgInfos,String[] infos)
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
/// @return: message PREPARED to send. 
public String sayTouch(String nameOfTouched,float distance,String actionDef)
{
  return ""+Opcs.TCH+"1"+Opcs.SPC
           +nameOfTouched+Opcs.SPC
           +actionDef+Opcs.SPC
           +nf(distance)+Opcs.SPC
           +Opcs.EOR;
}

/// It constructs touch message with two possible actions
/// @return: message PREPARED to send
public String sayTouch(String nameOfTouched,float distance,String action1,String action2)
{
  return ""+Opcs.TCH+"2"+Opcs.SPC
           +nameOfTouched+Opcs.SPC
           +action1+Opcs.SPC
           +action2+Opcs.SPC
           +nf(distance)+Opcs.SPC
           +Opcs.EOR;
}

/// It constructs touch message with many possible actions
/// @return: message PREPARED to send
public String sayTouch(String nameOfTouched,float distance,String[] actions)// NOT TESTED! TODO
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
/// @return: distance
/// The infos will be filled with name of touched object and up to 9 possible actions
/// (or more - NOT TESTED!)
public float decodeTouch(String msg,String[] infos)
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
/// @return: message PREPARED to send
public String sayPosition(char EUCorPOL,String objName,float coord)
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
/// @return: message PREPARED to send
public String sayPosition(char EUCorPOL,String objName,float coord1,float coord2)
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
/// @return: message PREPARED to send
public String sayPosition(char EUCorPOL,String objName,float coord1,float coord2,float coord3)
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
/// @return: message PREPARED to send
public String sayPosition(char EUCorPOL,String objName,float[] coordinates)
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
/// @return: name of object and also fill coordinates.
public String decodePosition(String msgPosition,float[] coordinates)
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
/// @return: message PREPARED to send
public String sayObjectType(String type,String objectName)
{
  return Opcs.OBJ+"n"+Opcs.SPC
         +type+Opcs.SPC
         +objectName+Opcs.SPC
         +Opcs.EOR;  
}

/// For objects types management - object removing from the game world
/// @return: message PREPARED to send
public String sayObjectRemove(String objectName)
{
  return Opcs.OBJ+"d"+Opcs.SPC
         +objectName+Opcs.SPC
         +Opcs.EOR;  
}

/// It decodes message of objects types management - decoding
/// @return: array of strings with "del" action and objectName
/// or "new" action, type name and object name.
/// Other actions are possible in the future.
public String[] decodeObjectMng(String msg)
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
