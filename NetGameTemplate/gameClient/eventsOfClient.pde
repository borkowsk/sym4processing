void keyPressed()
{
  if(DEBUG>2) println("KEY:",key,int(key));
  
  if(myClient==null || !myClient.active())
  {
    println("Connection is not active");
    return;
  }
  
  if(key==65535)//arrows  etc...
  {
    if(DEBUG>2) println("keyCode:",keyCode);
    switch(keyCode){
    case UP: key='w'; break;
    case DOWN: key='s'; break;
    case LEFT: key='a'; break;
    case RIGHT: key='d'; break;
    default:
    return;//Other special keys is ignored
    }//end of switch
  }
  
  switch(key){
  default:println(key,"is not defined for the game client");
  //Navigation
  case 'w':
  case 'W': myClient.write(sayOptAndInf(Opts.NAV,"f")); break;
  case 's':
  case 'S': myClient.write(sayOptAndInf(Opts.NAV,"b")); break;
  case 'a':
  case 'A': myClient.write(sayOptAndInf(Opts.NAV,"l")); break;
  case 'd':
  case 'D': myClient.write(sayOptAndInf(Opts.NAV,"r")); break;
  //Interaction:
  case ' ': myClient.write(sayOptAndInf(Opts.ACT,"default")); break; //<>//
  case ESC:
  {
    println(key,"is ignored for the game client");
      key=0;
  } break;
}//END of SWITCH
}
