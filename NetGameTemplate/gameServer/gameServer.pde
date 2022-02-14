//*  Server for many clients
//*////////////////////////// 
// Example code for a server with multiple clients communicating to only one at a time.
// It will work for any client. 
// Warning, is just an example, and could probably be improved upon!
// https://forum.processing.org/one/topic/how-do-i-send-data-to-only-one-client-using-the-network-library.html

import processing.net.*;

int    servPORT=5204;
Server mainServer;

int    val[] = new int[0];
Client clients[] = new Client[0];//the array of clients

void setup() 
{
  size(200, 200);
  mainServer = new Server(this,servPORT);
  noStroke();
  val = expand(val, val.length+1);
}

void draw() 
{
  background(0);
  textAlign(CENTER);
  text(clients.length, width/2., height/2.);//Displays how many clients have connected to the server
  for (int i = 0; i < clients.length; i++)
  if(clients[i].active())
  {
    val[i] = (val[i]+i+1)%255;//changes the value based on which client number it has (the higher client number, the fast it changes).
    clients[i].write(byte(val[i]));//writes to the right client (using the byte type is not necessary)
    text(val[i], width/2., height/2.+15*(i+1));
  }
}

///this is extra stuff that can be done, when new client connected
void whenConnected()
{//in this case expanding a value array to have a value for each client.
  val = expand(val, val.length+1);
}

///Event handler called when a client connects.
void serverEvent(Server srvr, Client clnt)
{
  clients = (Client[]) expand(clients,clients.length+1);//expand the array of clients
  clients[clients.length-1] = clnt;//sets the last client to be the newly connected client
  whenConnected();
}

///ClientEvent message is generated when a client disconnects.
void disconnectEvent(Client someClient) 
{
  println(mainServer,"Disconnect event happened.");
  println(someClient);
}
