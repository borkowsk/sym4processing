///  gameClient - more communication logic 
//*/////////////////////////////////////////////// 

StringDict inventory=new StringDict();

/// Simple object type management
void implementObjectMenagement(String[] cmd)
{
  if(cmd[0].equals("del"))
     removeObject(gameWorld,cmd[2]);
  else
  if(cmd[0].equals("new"))
  {
     if(DEBUG>1) println("type:'"+cmd[2]+"' object:'"+cmd[1]+"'");
     inventory.set(cmd[1],cmd[2]);//println(inventory.get(cmd[1]));
  }
  else
  println(playerName,"UNKNOWN object management command:",cmd[0]);
}

/// Very simple placeholder for use types dictionary 
GameObject makeGameObject(String name,float X,float Y,float Z,float R)
{
  String type=inventory.get(name); 
  if(DEBUG>1) println("type:'"+type+"' object:'"+name+"'");
  switch(type.charAt(0)){
  default:
      println("Type",type,"unknown. Replaced by ActiveGameObject.");
  case 'A':return new ActiveGameObject(name,X,Y,Z,R);
  case 'G':return new GameObject(name,X,Y,Z);
  case 'P':return new Player(null,name,X,Y,X,R);
  }
}

/// Handle changes in visualisation type of any game object
void visualisationChanged(GameObject[] table,String name,String vtype)
{
  int pos=(name.equals(Opcs.sYOU)?indexOfMe:localiseByName(table,name));
  if(pos==-1)//FIRST TIME
  {
    gameWorld = (GameObject[]) expand(gameWorld,gameWorld.length+1);
    pos=gameWorld.length-1;
    gameWorld[pos]=makeGameObject(name,0,0,0,0);
  }
  gameWorld[pos].visual=vtype;
}

/// Handle changes in colors of any game object
void colorChanged(GameObject[] table,String name,String hexColor)
{
  color newColor=unhex(hexColor);
  int pos=(name.equals(Opcs.sYOU)?indexOfMe:localiseByName(table,name));
  if(pos==-1)//FIRST TIME
  {
    gameWorld = (GameObject[]) expand(gameWorld,gameWorld.length+1);
    pos=gameWorld.length-1;
    gameWorld[pos]=makeGameObject(name,0,0,0,0);
    gameWorld[pos].foreground=newColor;
  }
  gameWorld[pos].foreground=newColor;
}

/// Handle changes in position of any game object
void positionChanged(GameObject[] table,String name,float[] inpos)
{
  int pos=(name.equals(Opcs.sYOU)?indexOfMe:localiseByName(table,name));
  if(pos==-1)//FIRST TIME
  {
    gameWorld = (GameObject[]) expand(gameWorld,gameWorld.length+1);
    pos=gameWorld.length-1;
    gameWorld[pos]=makeGameObject(name,inpos[0],inpos[1],0,0);
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

/// Handle changes in states of agents/objects
void stateChanged(GameObject[] table,String objectName,String field,String val)
{
  int pos=localiseByName(table,objectName);
  if(pos>=0)
  {
      GameObject me=table[pos]; assert me!=null;
      if(!me.setState(field,val))
      println(objectName+"."+field," NOT FOUND. Change ignored!"); 
  }
  else
  {
    println(objectName,"not found!");
    println("DATA INCONSISTENCY! CALL SERVER FOR FULL UPDATE");
    String msg=Opcs.say(Opcs.UPD);
    if(DEBUG>1) print(playerName,"is SENDING:");
    if(VIEWMESG>0 || DEBUG>1) println(msg);
    myClient.write(msg);
  }  
}

/// Handling for getting the avatar in contact with the game object
void beginInteraction(GameObject[] table,String[]  objectAndActionsNames)
{
  int pos=localiseByName(table,objectAndActionsNames[0]);
  if(pos>=0)
  {
    if( table[indexOfMe] instanceof ActiveGameObject )
    {
      ActiveGameObject me=(ActiveGameObject)(table[indexOfMe]); assert me!=null;
      if(me.interactionObject!=null) me.interactionObject.flags^=Masks.TOUCHED;
      me.interactionObject=table[pos];
    }
    table[pos].flags|=Masks.TOUCHED;
  }
  else
  {
    println(objectAndActionsNames[0],"not found!");
    println("DATA INCONSISTENCY! CALL SERVER FOR FULL UPDATE");
    String msg=Opcs.say(Opcs.UPD);
    if(DEBUG>1) print(playerName,"is SENDING:");
    if(VIEWMESG>0 || DEBUG>1) println(msg);
    myClient.write(msg);
  }
}

/// Handling for getting out of the avatar's contact with the game object
void finishInteraction(GameObject[] table,String objectName)
{
  int pos=localiseByName(table,objectName);
  if(pos>=0)//It may happen that in the meantime it has disappeared
  {
    table[pos].flags^=Masks.TOUCHED;
  }
  //Any way, you have to forget about him! 
  if( table[indexOfMe] instanceof ActiveGameObject )
  {
    ActiveGameObject me=(ActiveGameObject)(table[indexOfMe]); assert me!=null;
    me.interactionObject=null;
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
  case Opcs.EOR: if(DEBUG>0) println(playerName,"recived NOPE");break;
  case Opcs.HEL:
  case Opcs.IAM: println(playerName,"recived UNEXPECTED MESSAGE TYPE:",msg.charAt(0));break;
  case Opcs.ERR: { String emessage=decodeOptAndInf(msg);
                   println(playerName,"recived error:\n\t",emessage);
                  } break;
  case Opcs.OBJ: { String[] cmd=decodeObjectMng(msg);
                   implementObjectMenagement(cmd);
                 } break;
  //Normal interactions
  case Opcs.YOU: { playerName=decodeOptAndInf(msg);
                 if(DEBUG>1) println(playerName,"recived confirmation from the server!");
                 surface.setTitle(serverIP+"//"+Opcs.name+";"+playerName);
                 } break;
  case Opcs.VIS: { String objectName=decodeInfos(msg,instr1);
                   if(DEBUG>1) println(objectName,"change visualisation into",instr1[0]); 
                   visualisationChanged(gameWorld,objectName,instr1[0]);
                 } break;
  case Opcs.COL: { String objectName=decodeInfos(msg,instr1);
                   if(DEBUG>1) println(objectName,"change color into",instr1[0]); 
                   colorChanged(gameWorld,objectName,instr1[0]);
                 } break;   
  case Opcs.STA: {
                   String objectName=decodeInfos(msg,instr2);
                   if(DEBUG>2) println(objectName,"change state",instr2[0],"<==",instr2[1]);
                   stateChanged(gameWorld,objectName,instr2[0],instr2[1]);
                 } break;
  // interactions               
  case Opcs.TCH: { String[] inputs;
                   switch(msg.charAt(1)){
                   case '1':inputs=instr2;break;
                   case '2':inputs=instr3;break;
                   default: inputs=new String[msg.charAt(1)-'0'+1];//NOT TESTED TODO!
                   }
                   float dist=decodeTouch(msg,inputs);
                   if(DEBUG>1) println(playerName,"touched",inputs[0],inputs[1]);
                   beginInteraction(gameWorld,inputs);
                 }break;
  case Opcs.DTC: { String objectName=decodeOptAndInf(msg);
                 if(DEBUG>1) println(playerName,"detached from",objectName);
                 finishInteraction(gameWorld,objectName);//--> beginInteraction(inputs);
                 }break;                  
  //... rest of message types
  case Opcs.EUC: if(msg.charAt(1)=='1')
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
      if (myClient!=null && myClient.available() > 0) 
      {
        if(DEBUG>2) print(playerName,"is reciving:");
        String msg = myClient.readStringUntil(Opcs.EOR);
        if(VIEWMESG>0 || DEBUG>2) println(msg);
        
        if(msg==null || msg.equals("") || msg.charAt(msg.length()-1)!=Opcs.EOR)
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
