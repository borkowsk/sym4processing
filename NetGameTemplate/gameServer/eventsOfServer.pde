//*  Server for gameClients - keyboard input & other asynchronic events
//*///////////////////////////////////////////////////////////////////// 

/// Keyboard handler for the server.
/// In most cases not useable. 
void keyPressed()
{
  //ignore!?
  if(key==ESC)
  {
    println("Keyboard is ignored for the game server");
    key=0;
  }
}

/// Event handler called when a client connects to server
void serverEvent(Server me,Client newClient)
{
  noLoop();//KIND OF CRITICAL SECTION!!!
  
  while(newClient.available() <= 0) delay(10);
  
  if(DEBUG>1) print("Server is READING FROM CLIENT: ");
  String msg=newClient.readStringUntil(Opts.EOR);
  if(DEBUG>1) println(msg);
  String playerName=decodeHELLO(msg);
  
  msg=sayHELLO(Opts.name);
  if(DEBUG>1) println("Server is SENDING: ",msg);
  newClient.write(msg);
    
  whenClientConnected(newClient,playerName);
  
  loop(); 
}

/// ClientEvent message is generated 
/// when a client disconnects from server
void disconnectEvent(Client someClient) 
{
  if(DEBUG>2) println("Disconnect event happened on server.");
  if(DEBUG>2) println(mainServer,someClient);
  
  noLoop();//KIND OF CRITICAL SECTION!!!
  
  for(int i=0;i<players.length;i++)
  if(players[i].netLink == someClient )
  {
    println("Server registered",players[i].name," disconnection.");
    players[i].netLink=null;
    players[i].visual=avatars[0];
    players[i].flags|=VISUAL_MSK;
    break;
  }
  
  loop(); 
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////
