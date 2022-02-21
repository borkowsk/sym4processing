void clientGameDraw()
{          
    fill(255,0,0);
    for(int i = 0; true; i++)
    {
      if (myClient.available() > 0) 
      {
        if(DEBUG>2) print(playerName,"is reciving:");
        String msg = myClient.readStringUntil(Opts.NOPE);
        if(DEBUG>2) println(msg);
        interpretMessage(msg);
      }
      else
      break;
    }
}

float[] inparr1=new float[1];

void interpretMessage(String msg)
{
  switch(msg.charAt(0)){
  //Obliq. part
  default: println(playerName,"recived UNKNOWN MESSAGE TYPE:",msg.charAt(0));break;
  case Opts.NOPE: if(DEBUG>0) println(playerName,"recived NOPE");break;
  case Opts.HELLO:
  case Opts.IAM: println(playerName,"recived ENEXPECTED MESSAGE TYPE:",msg.charAt(0));break;
  //
  case Opts.YOU: playerName=decodeOptAndVal(msg);
                 if(DEBUG>0) println(playerName,"recived confirmation from the server!");
                 surface.setTitle(Opts.name+";"+playerName);break;
  //rest of message types
  case Opts.EUC: if(msg.charAt(1)=='1')
                 {
                   String who=decodePosition(msg,inparr1);//print(who);
                   background(0);
                   if(who.equals(Opts.sYOU))
                   {
                     stroke(255);
                     line(inparr1[0],0,inparr1[0],height);
                   }  
                 }
                 else
                 {
                   println("Invalid dimension of position message");
                 }
  }//END OF MESSAGE TYPES SWITCH
}
