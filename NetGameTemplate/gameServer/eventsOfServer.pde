//*  Server for gameClients - keyboard input 
//*/////////////////////////////////////////////// 

/// Keyboard handler for the server.
/// In most cases not useable. 
void keyPressed()
{
  //ignore!?
  if(key==ESC)
  {
    println("Keyboard is ignored for the game server");
    key=0; //<>//
  }    
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////