//*  Server for gameClients
//*////////////////////////// 
//
// Base on:
// Example code for a server with multiple clients communicating to only one at a time.
// https://forum.processing.org/one/topic/how-do-i-send-data-to-only-one-client-using-the-network-library.html
//
import processing.net.*;
//import processing.pdf.*;//Działa jako server, ale plik PDF jest pusty
import processing.svg.*;

int DEBUG=0; ///> Level of debug logging

Server mainServer; ///> Object representing server's TCP/IP input port

Player[] players= new Player[0]; ///> The array of clients (players)

/// Startup of a game server. 
/// It initialises window (if required) and TCP/IP port.
/// It exits, if is not able to do that.
void setup() 
{
  size(700, 500);//Other possibilities: P2D,P3D,FX2D,PDF,SVG
  //size(700, 500,SVG,"screen_file.svg");//Without window
  //size(700, 500,PDF, "screen_file.pdf");//Without window
  Xmargin=200;
  noStroke();
  mainServer = new Server(this,servPORT,serverIP);
  if(mainServer.active())
  {
    println("Server for '"+Opts.name+"' started!");
    println("IP:",serverIP,"PORT:",servPORT);
    initialiseGame();
    surface.setTitle(serverIP+"//"+Opts.name+":"+servPORT);
  }
  else exit();
}

/// This function is called many times per second.
/// Real work of server depends of current state of clients connections.
void draw() 
{
  if(players.length==0)
      serverWaitingDraw();
  else
      serverGameDraw();
      
  textAlign(LEFT,BOTTOM);fill(255,0,0);
  text(nf(frameRate,2,2)+"fps",0,height);
}

/// Waiting view placeholder ;-)
void serverWaitingDraw()
{
  background(128);
  //... any picture?
  visualise2D(Xmargin,0,width-Xmargin,height);
  fill(0);
  textAlign(CENTER,CENTER);
  text("Waiting for clients\n"+pepl[0]+plants+pepl[1],width/2,height/2);
}

/// Confirm client registration and send correct current name
void confirmClient(Client newClient,Player player)
{
  if(DEBUG>1) print("Server confirms the client's registration: ");
  
  String msg=sayOptAndInf(Opts.YOU,player.name);
  if(DEBUG>1) println(msg);
  newClient.write(msg);
  
  msg=sayOptAndInfos(Opts.VIS,Opts.sYOU,player.visual);
  if(DEBUG>1) println(msg);
  newClient.write(msg);
}

/// This is stuff that should be done,  
/// when new client was connected
void whenClientConnected(Client newClient,String playerName)
{
  for(int i=0;i<players.length;i++)
  if(players[i]!=null
  && playerName.equals(players[i].name))
  {
    if(players[i].netLink==null)//Już był taki, ale połączenie zdechło albo klient!
    {
      println("Player",playerName,"reconnected to server!");
      players[i].netLink=newClient;
      players[i].visual=pepl[1];
      players[i].flags|=VISUAL_MSK;
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
    
  Player tmp=new Player(newClient,playerName,int(random(initialMaxX)),int(random(initialMaxY)),1);
  tmp.visual=pepl[0];
  confirmClient(newClient,tmp);
  
  players = (Player[]) expand(players,players.length+1);//expand the array of clients
  players[players.length-1] = tmp;//sets the last player to be the newly connected client
   
  gameWorld = (GameObject[]) expand(gameWorld,gameWorld.length+1);//expand the array of game objects 
  gameWorld[gameWorld.length-1] = tmp;//Player is also one of GameObjects
  println("Player",tmp.name,"connected to server!");
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////
