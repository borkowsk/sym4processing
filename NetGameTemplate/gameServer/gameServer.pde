//*  Server for gameClients
//*////////////////////////// 
//
// Base on:
// Example code for a server with multiple clients communicating to only one at a time.
// It will work for any client. 
// https://forum.processing.org/one/topic/how-do-i-send-data-to-only-one-client-using-the-network-library.html
import processing.net.*;

int DEBUG=1;//Level of debug logging

Server mainServer;

//int[]    val     = new int[0];
//String[] names   = new String[0];
//Client[] clients = new Client[0];//the array of clients

Player[] players= new Player[0];//the array of clients (players)

void setup() 
{
  size(700, 500);
  Xmargin=200;
  noStroke();
  mainServer = new Server(this,servPORT,serverIP);
  if(mainServer.active())
  {
    println("Server for '"+Opts.name+"' started!");
    println("IP:",serverIP,"PORT:",servPORT);
    initialiseGame();
  }
  else exit();
}

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
  background(255);
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

///This is extra stuff that should be done, when new client was connected
void whenClientConnected(Client newClient,String playerName)
{
  for(int i=0;i<players.length;i++)
  if(players[i]!=null
  && playerName.equals(players[i].name))
  {
    if(players[i].netLink==null) 
    {
      println("Player",playerName,"reconnected to server!");
      players[i].netLink=newClient;
      players[i].visual=pepl[1];
      players[i].changed|=VISUAL_MSK;
      confirmClient(newClient,players[i]);
      return; //Już był taki, ale zdechł!
    }
    else
    {
      print("New",playerName,"will be ");//Jest już taki, trzeba jakoś zmienić nazwę
      playerName+='X';
      println(playerName);
    }
  }
    
  Player tmp=new Player(newClient,playerName,random(initialMaxX),random(initialMaxY),0);
  tmp.visual=pepl[0];
  confirmClient(newClient,tmp);
  
  players = (Player[]) expand(players,players.length+1);//expand the array of clients
  players[players.length-1] = tmp;//sets the last player to be the newly connected client
   
  mainGameArray = (GameObject[]) expand(mainGameArray,mainGameArray.length+1);//expand the array of game objects 
  mainGameArray[mainGameArray.length-1] = tmp;//Player is also one of GameObjects
}

///Event handler called when a client connects.
void serverEvent(Server me,Client newClient)
{
  noLoop();//KIND OF CRITICAL SECTION!!!
  
  while(newClient.available() <= 0) delay(10);
  
  if(DEBUG>1) print("Server is READING FROM CLIENT: ");
  String msg=newClient.readStringUntil(Opts.NOPE);
  if(DEBUG>1) println(msg);
  String playerName=decodeHELLO(msg);
  
  msg=sayHELLO(Opts.name);
  if(DEBUG>1) println("Server is SENDING: ",msg);
  newClient.write(msg);
    
  whenClientConnected(newClient,playerName);
  
  loop(); 
}

///ClientEvent message is generated when a client disconnects.
void disconnectEvent(Client someClient) 
{
  println("Disconnect event happened on server.");
  if(DEBUG>2) println(mainServer,someClient);
  
  for(int i=0;i<players.length;i++)
  if(players[i].netLink == someClient )
  {
    println(players[i].name," disconnected!");
    players[i].netLink=null;
    players[i].visual="_";
    players[i].changed|=VISUAL_MSK;
    break;
  }
}
