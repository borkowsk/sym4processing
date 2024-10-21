/// gameClient - keyboard input & other asynchronous events
/// @date 2024-10-21 (last modification)
//*//////////////////////////////////////////////////////////// 

/// Keyboard events - mostly control of the avatar.
void keyPressed()
{
  if(DEBUG>2) println("KEY:",key,int(key));
  
  if(myClient==null || !myClient.active())
  {
    println("Connection is not active");
    return;
  }
  
  if(key==65535) //arrows  etc...
  {
    if(DEBUG>2) println("keyCode:",keyCode);
    switch(keyCode){
    case UP: key='w'; break;
    case DOWN: key='s'; break;
    case LEFT: key='a'; break;
    case RIGHT: key='d'; break;
    default:
    return; //Other special keys is ignored in this template
    } //end of switch
  }
  
  String msg="";
  switch(key){
  default:println(key,"is not defined for the game client"); return;
  // Navigation
  case 'w':
  case 'W': msg=OpCd.say(OpCd.NAV,"f"); break;
  case 's':
  case 'S': msg=OpCd.say(OpCd.NAV,"b"); break;
  case 'a':
  case 'A': msg=OpCd.say(OpCd.NAV,"l"); break;
  case 'd':
  case 'D': msg=OpCd.say(OpCd.NAV,"r"); break;
  // Perform interaction:
  case ' ': {
              ActiveGameObject me=(ActiveGameObject)(gameWorld[indexOfMe]);                             assert me!=null;
              if(me.interactionObject!=null)
              {
                msg=OpCd.say(OpCd.ACT,"defo"); 
              }
            } break;
  case ESC: println(key,"is ignored for the game client");key=0; return;
} //END of SWITCH

  if(VIEW_MSG>0) println(playerName,"is sending:\n",msg);
  myClient.write(msg);
}

/// ClientEvent message is generated when a client disconnects.
void disconnectEvent(Client client) 
{
  background(0);
  print(playerName,"disconnected from server.");                                                assert client==myClient;
  myClient=null;
  frameRate(1);
}

/// Event handler called on server when a client connects to server.
void serverEvent(Server server,Client client)
{
  println(playerName,"got unexpected serverEvent()"); 
}

/// ClientEvent message is generated when the 
/// server sends data to an existing client.
/// @function clientEvent is alternative, asynchronous way
/// to read messages from the server.
//void clientEvent(Client client) 
//{
  //println(playerName,"got clientEvent()"); 
  //msg=cli.read(...)
  //interpretMessage(String msg)
//}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*  Partly sponsored by the EU project "GuestXR" (https://guestxr.eu/)
//*/////////////////////////////////////////////////////////////////////////////////////////
