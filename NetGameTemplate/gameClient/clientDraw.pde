//*  gameClient - more comm. logic 
//*/////////////////////////////////////////////// 

/// Handle changes in visualisation type of any game object
void visualisationChanged(GameObject[] table,String name,String vtype)
{
  int pos=(name.equals(Opts.sYOU)?indexOfMe:localiseByName(table,name));
  if(pos==-1)//FIRST TIME
  {
    gameWorld = (GameObject[]) expand(gameWorld,gameWorld.length+1);
    pos=gameWorld.length-1;
    gameWorld[pos]=new GameObject(name,0,0,0);
  }
  gameWorld[pos].visual=vtype;
}

/// Handle changes in colors of any game object
void colorChanged(GameObject[] table,String name,String hexColor)
{
  color newColor=unhex(hexColor);
  int pos=(name.equals(Opts.sYOU)?indexOfMe:localiseByName(table,name));
  if(pos==-1)//FIRST TIME
  {
    gameWorld = (GameObject[]) expand(gameWorld,gameWorld.length+1);
    pos=gameWorld.length-1;
    gameWorld[pos]=new GameObject(name,0,0,0);
    gameWorld[pos].foreground=newColor;
  }
  gameWorld[pos].foreground=newColor;
}

/// Handle changes in position of any game object
void positionChanged(GameObject[] table,String name,float[] inpos)
{
  int pos=(name.equals(Opts.sYOU)?indexOfMe:localiseByName(table,name));
  if(pos==-1)//FIRST TIME
  {
    gameWorld = (GameObject[]) expand(gameWorld,gameWorld.length+1);
    pos=gameWorld.length-1;
    gameWorld[pos]=new GameObject(name,inpos[0],inpos[1],0);
    if(inpos.length==3)
      gameWorld[pos].Z=inpos[2];
  }
  else
  {
    gameWorld[pos].X=inparr2[0];
    gameWorld[pos].Y=inparr2[1];
    if(inpos.length==3)
      gameWorld[pos].Z=inpos[2];
  }
}

// Arrays for decoding more complicated messages
float[] inparr1=new float[1];
float[] inparr2=new float[2];
float[] inparr3=new float[3];
String[] instr1=new String[1];
String[] instr2=new String[2];
String[] instr3=new String[3];

/// Handling interpretation of messages from server
void interpretMessage(String msg)
{
  switch(msg.charAt(0)){
  //Obliq. part
  default: println(playerName,"recived UNKNOWN MESSAGE TYPE:",msg.charAt(0));break;
  case Opts.EOR: if(DEBUG>0) println(playerName,"recived NOPE");break;
  case Opts.HEL:
  case Opts.IAM: println(playerName,"recived UNEXPECTED MESSAGE TYPE:",msg.charAt(0));break;
  case Opts.ERR: { String emessage=decodeOptAndInf(msg);
                   println(playerName,"recived error:\n\t",emessage);
                  } break;
  //Normal interactions
  case Opts.YOU: { playerName=decodeOptAndInf(msg);
                 if(DEBUG>1) println(playerName,"recived confirmation from the server!");
                 surface.setTitle(serverIP+"//"+Opts.name+";"+playerName);
                 } break;
  case Opts.VIS: { String objectName=decodeInfos(msg,instr1);
                 if(DEBUG>1) println(objectName,"change visualisation into",instr1[0]); 
                 visualisationChanged(gameWorld,objectName,instr1[0]);
  } break;
  case Opts.COL: { String objectName=decodeInfos(msg,instr1);
                 if(DEBUG>1) println(objectName,"change color into",instr1[0]); 
                 colorChanged(gameWorld,objectName,instr1[0]);
                 } break;               
  //... rest of message types
  case Opts.EUC: if(msg.charAt(1)=='1')
                 {
                   //String who=decodePosition(msg,inparr1);//print(who);
                   //positionChanged(gameWorld,who,inparr1);
                   println("Invalid position message:",msg);
                 }
                 else
                 if(msg.charAt(1)=='2')
                 {
                   String who=decodePosition(msg,inparr2);//print(who);
                   positionChanged(gameWorld,who,inparr2);
                 }
                 else
                 if(msg.charAt(1)=='3')
                 {
                   String who=decodePosition(msg,inparr3);//print(who);
                   positionChanged(gameWorld,who,inparr3);
                 }
                 else
                 {
                   println("Invalid dimension of position message",msg.charAt(1));
                 }
  }//END OF MESSAGE TYPES SWITCH
}

/// This function performs communication with server & visualisation of the game world 
void clientGameDraw()
{          
    //Visualisation:
    background(0);
    visualise2D(0,0,width,height);
    fill(255,0,0);
    
    //communication with server:
    for(int i = 0; true; i++) //why not while(true) ?
    {
      if (myClient.available() > 0) 
      {
        if(DEBUG>2) print(playerName,"is reciving:");
        String msg = myClient.readStringUntil(Opts.EOR);
        if(VIEWMESG>0 || DEBUG>2) println(msg);
        
        if(msg==null || msg.equals("") || msg.charAt(msg.length()-1)!=Opts.EOR)
        {
          println(playerName,"recived invalid message. IGNORED");
          return;
        }
        
        interpretMessage(msg);// Handling interpretation
      }
      else
      break;
    }
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////
