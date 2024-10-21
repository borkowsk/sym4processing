/// gameServer (dummy) keyboard input & other asynchronic events.
/// @date 2024-10-21 (last modification)
//*///////////////////////////////////////////////////////////////////// 

/// Keyboard handler for the server.
/// In most cases not useable. However, it protects the server against 
/// accidental stopping with the ESC key
void keyPressed()
{
  //ignore!?
  if(key==ESC)
  {
    println("Keyboard is ignored for the game server");
    key=0;
  }
}

/// Event handler called when a client connects to server.
void serverEvent(Server me,Client newClient)
{
  noLoop(); //KIND OF CRITICAL SECTION!!!
  
  while(newClient.available() <= 0) delay(10);
  
  if(DEBUG>1) print("Server is READING FROM CLIENT: ");
  String msg=newClient.readStringUntil(OpCd.EOR);
  if(DEBUG>1) println(msg);
  String playerName=decodeHELLO(msg);
  
  msg=sayHELLO(OpCd.name);
  if(DEBUG>1) println("Server is SENDING: ",msg);
  newClient.write(msg);
    
  whenClientConnected(newClient,playerName);
  
  loop(); 
}

/// ClientEvent message is generated 
/// when a client disconnects from server.
void disconnectEvent(Client someClient) 
{
  if(DEBUG>2) println("Disconnect event happened on server.");
  if(DEBUG>2) println(mainServer,someClient);
  
  noLoop(); //KIND OF CRITICAL SECTION!!!
  
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
//*  Partly sponsored by the EU project "GuestXR" (https://guestxr.eu/)
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////
