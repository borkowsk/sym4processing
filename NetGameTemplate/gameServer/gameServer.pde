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

int    val[] = new int[0];
String names[]= new String[0];
Client clients[] = new Client[0];//the array of clients

void setup() 
{
  size(500, 500);  
  noStroke();
  mainServer = new Server(this,servPORT,serverIP);
  if(mainServer.active())
  {
    println("Server for '"+Opts.name+"' started!");
    println("IP:",serverIP,"PORT:",servPORT);
    val = expand(val, val.length+1);
  }
  else exit();
}

void draw() 
{
  if(clients.length==0)
      serverWaitingDraw();
  else
      serverGameDraw();
      
  textAlign(CENTER,BOTTOM);fill(255,0,0);
  text(nf(frameRate,2,2)+"fps",width/2.,height);
}

///this is extra stuff that can be done, when new client connected
void whenConnected(Client newClient,String playerName)
{
  for(int i=0;i<names.length;i++)
  if(playerName.equals(names[i]))
  {
    if(clients[i]==null) 
    {
      println("Player",playerName,"reconnected to server!");
      clients[i]=newClient;
      if(DEBUG>0) print("Server confirms the client's registration: ");
      String msg=sayOptAndVal(Opts.YOU,playerName);
      if(DEBUG>0) println(msg);
      newClient.write(msg);
      return; //Już był taki, ale zdechł!
    }
    else
    {
      print("New",playerName,"will be ");
      playerName+='X';
      println(playerName);
    }
  }
  
  clients = (Client[]) expand(clients,clients.length+1);//expand the array of clients
  clients[clients.length-1] = newClient;//sets the last client to be the newly connected client
  names = expand(names, names.length+1);
  names[names.length-1]=playerName;
  val = expand(val, val.length+1);//in this case expanding a value array to have a value for each client.
  
  if(DEBUG>0) print("Server confirms the client's registration: ");
  String msg=sayOptAndVal(Opts.YOU,playerName);
  if(DEBUG>0) println(msg);
  newClient.write(msg);
}

///Event handler called when a client connects.
void serverEvent(Server me,Client newClient)
{
  noLoop();//CRITICAL SECTION!!!
  while(newClient.available() <= 0) delay(10);
  
  if(DEBUG>0) print("Server is READING FROM CLIENT: ");
  String msg=newClient.readStringUntil(Opts.NOPE);
  if(DEBUG>0) println(msg);
  String playerName=decodeHELLO(msg);
  //...
  msg=sayHELLO(Opts.name);
  if(DEBUG>0) println("Server is SENDING: ",msg);
  newClient.write(msg);
    
  whenConnected(newClient,playerName);
  
  loop(); 
}

///ClientEvent message is generated when a client disconnects.
void disconnectEvent(Client someClient) 
{
  println(mainServer,"Disconnect event happened.");
  println(someClient);
  for(int i=0;i<clients.length;i++)
  if(clients[i]==someClient)
  {
    println(names[i]," disconnected");
    clients[i]=null;
    break;
  }
}
