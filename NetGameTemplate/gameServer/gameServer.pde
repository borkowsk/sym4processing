//*  Server for gameClients
//*////////////////////////// 
//
// Base on:
// Example code for a server with multiple clients communicating to only one at a time.
// It will work for any client. 
// https://forum.processing.org/one/topic/how-do-i-send-data-to-only-one-client-using-the-network-library.html
import processing.net.*;

int DEBUG=2;//Level of debug logging

Server mainServer;

//int[]    val     = new int[0];
//String[] names   = new String[0];
//Client[] clients = new Client[0];//the array of clients

Player[] players= new Player[0];//the array of clients (players)

void setup() 
{
  size(500, 500);  
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
      
  textAlign(CENTER,BOTTOM);fill(255,0,0);
  text(nf(frameRate,2,2)+"fps",width/2.,height);
}

/// Waiting view placeholder ;-)
void serverWaitingDraw()
{
  background(255);
  //... any picture?
  visualise2D(0,0,width,height);
  fill(0);
  textAlign(CENTER,CENTER);
  text("Waiting for clients",width/2,height/2);
}

/// Confirm client registration and send correct current name
void confirmClient(Client newClient,String playerName)
{
  if(DEBUG>0) print("Server confirms the client's registration: ");
  String msg=sayOptAndVal(Opts.YOU,playerName);
  if(DEBUG>0) println(msg);
  newClient.write(msg);
}

///This is extra stuff that should be done, when new client was connected
void whenClientConnected(Client newClient,String playerName)
{
  for(int i=0;i<players.length;i++)
  if(players[i]!=null
  && playerName.equals(players[i].name))
  {
    if(players[i].client==null) 
    {
      println("Player",playerName,"reconnected to server!");
      clients[i]=newClient;
      confirmClient(newClient,playerName);
      return; //Już był taki, ale zdechł!
    }
    else
    {
      print("New",playerName,"will be ");//Jest już taki, trzeba jakoś zmienić nazwę
      playerName+='X';
      println(playerName);
    }
  }
  
  clients = (Client[]) expand(clients,clients.length+1);//expand the array of clients
  clients[clients.length-1] = newClient;//sets the last client to be the newly connected client
  names = expand(names, names.length+1);
  names[names.length-1]=playerName;
  val = expand(val, val.length+1);//in this case expanding a value array to have a value for each client.
  
  confirmClient(newClient,playerName);
}

///Event handler called when a client connects.
void serverEvent(Server me,Client newClient)
{
  noLoop();//KIND OF CRITICAL SECTION!!!
  
  while(newClient.available() <= 0) delay(10);
  
  if(DEBUG>0) print("Server is READING FROM CLIENT: ");
  String msg=newClient.readStringUntil(Opts.NOPE);
  if(DEBUG>0) println(msg);
  String playerName=decodeHELLO(msg);
  
  msg=sayHELLO(Opts.name);
  if(DEBUG>0) println("Server is SENDING: ",msg);
  newClient.write(msg);
    
  whenClientConnected(newClient,playerName);
  
  loop(); 
}

///ClientEvent message is generated when a client disconnects.
void disconnectEvent(Client someClient) 
{
  println("Disconnect event happened on server.");
  if(DEBUG>2) println(mainServer,someClient);
  
  for(int i=0;i<clients.length;i++)
  if(clients[i]==someClient)
  {
    println(names[i]," disconnected!");
    clients[i]=null;
    break;
  }
}
