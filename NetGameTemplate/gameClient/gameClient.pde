//*  Client for gameServer - MAIN FILE
//*//////////////////////////////////////
//
//Base on:
//https://forum.processing.org/one/topic/how-do-i-send-data-to-only-one-client-using-the-network-library.html
//
import processing.net.*;

int DEBUG=0;///Level of debug logging
int VIEWMESG=1;///
int DEF_FRAME_RATE=60;///Frame rate during game

String  playerName="";//ASCII IDENTIFIER!

Client  myClient=null;
    
void setup() 
{
  size(400,400);
  loadName();
  println("PLAYER:",playerName);
  println("Expected server IP:",serverIP,"\nExpected server PORT:",servPORT);
  frameRate(1);
  VIS_MIN_MAX=false;///Option for visualisation - with min/max value
  KEEP_ASPECT=true;///Option for visualisation - with proportional aspect ratio
  WITH_INFO=false;///Information about objects
  //textSize(16);
}

void draw() 
{ 
  if(frameCount<2)
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
  text("Use WSAD & SPACE ("+nf(frameRate,2,2)+"fps)",width/2.,height);
}

/// Intro view placeholder ;-)
void drawStartUpInfo()
{
   background(255);
   //... any picture?
   textAlign(CENTER,CENTER);
   fill(random(128),random(128),random(128));
   text("PLAYER: "+playerName,width/2,height/2);   
}

/// Initial courtesy exchange with the server
void whenConnectedToServer()
{
    println(playerName,"connected!");
    String msg=sayHELLO(playerName);
    if(VIEWMESG>0 || DEBUG>1) println(playerName,"is sending:\n",msg);
    myClient.write(msg);
    
    while(myClient.available() <= 0) delay(10);
    
    if(DEBUG>1) print(playerName,"is READING FROM SERVER:");
    msg=myClient.readStringUntil(Opts.NOPE);
    if(VIEWMESG>0 || DEBUG>1) println(msg);
    
    String serverType=decodeHELLO(msg);
    if(serverType.equals(Opts.name) )
    {
      surface.setTitle(serverIP+"//"+Opts.name+":"+playerName);
      mainGameArray=new GameObject[1];
      mainGameArray[0]=new GameObject(playerName,10,10,0);
      mainGameArray[0].visual="???";
      indexOfMe=0;
      msg=sayOptCode(Opts.UPD);
      if(DEBUG>1) print(playerName,"is SENDING:");
      if(VIEWMESG>0 || DEBUG>1) println(msg);
      myClient.write(msg);
    }
    else
    {
      println("Protocol mismatch: '"
              +serverType+"'<>'"+Opts.name+"'");
      myClient.stop();
      exit();
    }
}

///Attempting to connect and initial communication
void drawTryConnect()
{
   background(128);
   fill(random(255),random(255),random(255));
   text("Not connected", width/2., height/2.);
   
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
        
/// ClientEvent message is generated when a client disconnects.
void disconnectEvent(Client someClient) 
{
  background(0);
  print(playerName,"disconnected from server.");
  myClient=null;
  frameRate(1);
}

/// Loads the player's name from the file "player.txt"
void loadName()
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
