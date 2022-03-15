/// Server for gameClients - setup() & draw() SOURCE FILE
//*////////////////////////////////////////////////////////////////// 
//
/// Losely base on
/// example code for a server with multiple clients communicating to only one at a time.
/// (see: https://forum.processing.org/one/topic/how-do-i-send-data-to-only-one-client-using-the-network-library.html)
//
import processing.net.*;  //Needed for network communication
//import processing.pdf.*;//It acts as a server, but the PDF file is empty
import processing.svg.*;  //No-window server!

int DEBUG=0;       ///> Level of debug logging

Server mainServer; ///> Object representing server's TCP/IP COMMUNICATION

Player[] players= new Player[0]; ///> The array of clients (players)

/// Startup of a game server. 
/// It initialises window (if required) and TCP/IP port.
/// It exits, if is not able to do that.
void setup() 
{
  size(700, 500);//Other possibilities: P2D,P3D,FX2D,PDF,SVG
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
  text("Waiting for clients\n"+avatars[1]+plants[1]+avatars[2],width/2,height/2);
}

/// Confirm client registration and send correct current name
void confirmClient(Client newClient,Player player)
{
  if(DEBUG>1) print("Server confirms the client's registration: ");
  
  String msg=sayOptAndInf(Opcs.YOU,player.name);
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
    
  Player tmp=new Player(newClient,playerName,int(random(initialMaxX)),int(random(initialMaxY)),1,1.5);
  
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
