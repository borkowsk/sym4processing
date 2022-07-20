///  gameClient - more communication logic 
//*/////////////////////////////////////////////// 

StringDict inventory=new StringDict();

/// Simple object type management
void implementObjectManagement(String[] cmd) ///< global?
{
  if(cmd[0].equals("del"))
     removeObject(gameWorld,cmd[2]);
  else
  if(cmd[0].equals("new"))
  {
     if(DEBUG>1) println("type:'"+cmd[2]+"' object:'"+cmd[1]+"'");
     inventory.set(cmd[1],cmd[2]); //println(inventory.get(cmd[1]));
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

/// Handling changes in visual representation of any game object.
void visualisationChanged(GameObject[] table,String name,String visual_repr) ///< global?
{
  int pos=(name.equals(OpCd.sYOU)?indexOfMe:localiseByName(table,name));
  if(pos==-1) //FIRST TIME
  {
    gameWorld = (GameObject[]) expand(gameWorld,gameWorld.length+1);
    pos=gameWorld.length-1;
    gameWorld[pos]=makeGameObject(name,0,0,0,0);
  }
  gameWorld[pos].visual=visual_repr;
}

/// Handle changes in colors of any game object
void colorChanged(GameObject[] table,String name,String hexColor)
{
  color newColor=unhex(hexColor);
  int pos=(name.equals(OpCd.sYOU)?indexOfMe:localiseByName(table,name));
  if(pos==-1) //FIRST TIME
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
  int pos=(name.equals(OpCd.sYOU)?indexOfMe:localiseByName(table,name));
  if(pos==-1) //FIRST TIME
  {
    gameWorld = (GameObject[]) expand(gameWorld,gameWorld.length+1);
    pos=gameWorld.length-1;
    gameWorld[pos]=makeGameObject(name,inpos[0],inpos[1],0,0);
    if(inpos.length==3)
      gameWorld[pos].Z=inpos[2];
  }
  else
  {
    gameWorld[pos].X=inPar2[0];
    gameWorld[pos].Y=inPar2[1];
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
    String msg=OpCd.say(OpCd.UPD);
    if(DEBUG>1) print(playerName,"is SENDING:");
    if(VIEW_MSG>0 || DEBUG>1) println(msg);
    myClient.write(msg);
  }  
}

/// Handling for getting the avatar in contact with the game object.
/// @parametr distance is not used in this example method, 
/// but may be used for more complicated interactions.
void beginInteraction(GameObject[] table,String[]  objectAndActionsNames,float distance)
{
  int pos=localiseByName(table,objectAndActionsNames[0]);
  
  if(pos>=0)
  {
    if( table[indexOfMe] instanceof ActiveGameObject )
    {
      ActiveGameObject me=(ActiveGameObject)(table[indexOfMe]);                   assert me!=null;
      if(me.interactionObject!=null) me.interactionObject.flags^=Masks.TOUCHED;
      me.interactionObject=table[pos];
    }
    table[pos].flags|=Masks.TOUCHED;
    if(DEBUG>1)
      println(objectAndActionsNames[0],".distance:",distance); //DISTANCE NOT USED FOR NOW!
  }
  else
  {
    println(objectAndActionsNames[0],"not found!");
    println("DATA INCONSISTENCY! FULL UPDATE IS NEEDED!");
    String msg=OpCd.say(OpCd.UPD);
    if(DEBUG>1) print(playerName,"is SENDING:");
    if(VIEW_MSG>0 || DEBUG>1) println(msg);
    myClient.write(msg);
  }
}

/// Handling for getting out of the avatar's contact with the game object.
void finishInteraction(GameObject[] table,String objectName)
{
  int pos=localiseByName(table,objectName);
  if(pos>=0) //It may happen that in the meantime it has disappeared
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
float[]  inPar1=new  float[1]; ///< global?
float[]  inPar2=new  float[2]; ///< global?
float[]  inPar3=new  float[3]; ///< global?
String[] inStr1=new String[1]; ///< global?
String[] inStr2=new String[2]; ///< global?
String[] inStr3=new String[3]; ///< global?

/// Handling interpretation of messages from server (on client side)
void interpretMessage(String msg)
{
  switch(msg.charAt(0)){
  default: println(playerName,"received UNKNOWN MESSAGE TYPE:",msg.charAt(0));break;
  // Obligatory messages:
  case OpCd.EOR: if(DEBUG>0) println(playerName,"received NOPE");break;
  case OpCd.HEL:
  case OpCd.IAM: println(playerName,"received UNEXPECTED MESSAGE TYPE:",msg.charAt(0));break;
  case OpCd.ERR: { String error_msg=decodeOptAndInf(msg);
                   println(playerName,"received error:\n\t",error_msg);
                  } break;
  case OpCd.OBJ: { String[] cmd=decodeObjectMng(msg);
                   implementObjectManagement(cmd);
                 } break;
  // Normal interactions:
  case OpCd.YOU: { playerName=decodeOptAndInf(msg);
                 if(DEBUG>1) println(playerName,"received confirmation from the server!");
                 surface.setTitle(serverIP+"//"+OpCd.name+";"+playerName);
                 } break;
  case OpCd.VIS: { String objectName=decodeInfos(msg,inStr1);
                   if(DEBUG>1) println(objectName,"change visualisation into",inStr1[0]); 
                   visualisationChanged(gameWorld,objectName,inStr1[0]);
                 } break;
  case OpCd.COL: { String objectName=decodeInfos(msg,inStr1);
                   if(DEBUG>1) println(objectName,"change color into",inStr1[0]); 
                   colorChanged(gameWorld,objectName,inStr1[0]);
                 } break;   
  case OpCd.STA: {
                   String objectName=decodeInfos(msg,inStr2);
                   if(DEBUG>2) println(objectName,"change state",inStr2[0],"<==",inStr2[1]);
                   stateChanged(gameWorld,objectName,inStr2[0],inStr2[1]);
                 } break;
  // Other interactions:
  case OpCd.TCH: { String[] inputs;
                   switch(msg.charAt(1)){
                   case '1':inputs=inStr2;break;
                   case '2':inputs=inStr3;break;
                   default: 
                         inputs=new String[msg.charAt(1)-'0'+1]; //NOT TESTED? //<>//
                         break;
                   }
                   float dist=decodeTouch(msg,inputs);
                   if(DEBUG>1) println(playerName,"touched",inputs[0],inputs[1]);
                   beginInteraction(gameWorld,inputs,dist);
                 }break;
  case OpCd.DTC: { String objectName=decodeOptAndInf(msg);
                 if(DEBUG>1) println(playerName,"detached from",objectName);
                 finishInteraction(gameWorld,objectName); //see: beginInteraction(...);
                 }break;                  
  //... rest of message types
  case OpCd.EUC: if(msg.charAt(1)=='1')
                 {
                   //String who=decodePosition(msg,inparr1); //print(who);
                   //positionChanged(gameWorld,who,inparr1);
                   println("Invalid position message:",msg);
                 }
                 else
                 if(msg.charAt(1)=='2')
                 {
                   String who=decodePosition(msg,inPar2); //print(who);
                   positionChanged(gameWorld,who,inPar2);
                 }
                 else
                 if(msg.charAt(1)=='3')
                 {
                   String who=decodePosition(msg,inPar3); //print(who);
                   positionChanged(gameWorld,who,inPar3);
                 }
                 else
                 {
                   println("Invalid dimension of position message",msg.charAt(1));
                 }
  } //END OF MESSAGE TYPES SWITCH
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
        if(DEBUG>2) print(playerName,"is receiving:");
        String msg = myClient.readStringUntil(OpCd.EOR);
        if(VIEW_MSG>0 || DEBUG>2) println(msg);
        
        if(msg==null || msg.equals("") || msg.charAt(msg.length()-1)!=OpCd.EOR)
        {
          println(playerName,"received invalid message. IGNORED");
          return;
        }
        
        interpretMessage(msg); // Handling interpretation
      }
      else
      break;
    }
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  Partly sponsored by the EU project "GuestXR" (https://guestxr.eu/)
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////

