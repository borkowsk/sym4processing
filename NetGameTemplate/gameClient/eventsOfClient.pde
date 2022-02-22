void keyPressed()
{
  //ignore!?
  switch(key){
  default:println(key,"is not defined for the game client");
  //Navigation
  case 'W': break;
  case 'S': break;
  case 'A': break;
  case 'D': break;
  //Interaction:
  case ' ': break;
  case ESC:
  {
    println(key,"is ignored for the game client");
      key=0;
  } break;
}//END of SWITCH
}
