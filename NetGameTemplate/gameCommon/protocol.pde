/// Declaration common for client and server (op.codes and coding/decoding functions)
//* Use link_commons.sh script for make symbolic connections to gameServer & gameClient directories
//*///////////////////////////////////////////////////////////////////////////////////////////////////
//
import processing.net.*;

//long pid = ProcessHandle.current().pid();//JAVA9 :-(


//String  serverIP="192.168.55.201";///< at home 
//String  serverIP="192.168.55.104";///< 2. 
//String  serverIP="10.3.24.216";   ///< at work
//String  serverIP="10.3.24.4";     ///< workstation local
int     servPORT=5205;  	     ///> Teoretically it could be any above 1024
String  serverIP="127.0.0.1";      ///< localhost

/// Protocol dictionary ("opcodes" etc.)
static abstract class Opcs { 
  static final String name="sampleGame";///< ASCI IDENTIFIER OF PROTOCOL
  static final String sYOU="Y";///< REPLACER OF CORESPONDENT NAME as a ready to use String. 
                               ///< Character.toString(YOU);<-not for static
  //Record defining characters
  static final char EOR=0x03;///< End of record (EOR). EOL is not used, because of it use inside data starings.
  static final char SPC='\t';///< Field separator
  //Record headers (bidirectorial)
  static final char ERR='e'; ///< Error message for partner
  static final char HEL='H'; ///< Hello message (client-server handshake)
  static final char IAM='I'; ///< I am "name of server/name of client"
  static final char YOU='Y'; ///< Redefining player name if not suitable
  //Named variables/resources
  static final char GET='G'; ///< Get global resource by name TODO
  static final char BIN='B'; ///< Binary hunk of resources (name.type\tsize\tthen data) TODO
                             ///< Data hunk is recived exactly "as is"!
  static final char TXT='X'; ///< Text hunk of resources (name.type\tsize\tthen data) TODO
                             ///< Text may be recoded on the reciver side if needed!
  static final char OBJ='O'; ///< Objects managment: "On typename objectName" or "Od objectName"
  //Game scene/state 
  static final char UPD='U'; ///< Request for update about a whole scene
  static final char VIS='V'; ///< Visualisation info for a particular object
  static final char COL='C'; ///< Colors of a particular object
  static final char STA='S'; ///< Named state attribute of a particular object (ex.: objname\thp\tval, objname\tsc\tval etc.)
  static final char EUC='E'; ///< Euclidean position of an object
  static final char POL='P'; ///< Polar position of an object
  //Interactions
  static final char TCH='T'; ///< Active "Touch" with other object (info about name & possible actions)
  static final char DTC='D'; ///< Detouch with any of previously touched object (name provided)
  //Player controls of avatar
  static final char NAV='N'; ///< Navigation of the avatar (wsad and arrows in the template)
  static final char ACT='A'; ///< 'defo'(-ult) or user defined actions of the avatar
  //...
  //static final char XXX='c';// something more...
}//EndOfClass Opcs

/// It composes server-client handshake
/// @return message PREPARED to send. 
String sayHELLO(String myName)
{
    return ""+Opcs.HEL+Opcs.SPC+Opcs.IAM+Opcs.SPC
             +myName+Opcs.SPC+Opcs.EOR;
}

/// It decodes handshake
/// @return: Name of client or name of game implemented on server
String decodeHELLO(String msgHello)
{
  String[] fields=split(msgHello,Opcs.SPC);
  if(DEBUG>2) println(fields[0],fields[1],fields[2]);
  if(fields[0].charAt(0)==Opcs.HEL && fields[1].charAt(0)==Opcs.IAM )
      return fields[2];
  else
      return null;
}

/// It composes one OPC info. For which, when recieved, only charAt(0) is important.
/// @return: message PREPARED to send. 
String sayOptCode(char optCode)
{
  return Character.toString(optCode)+Opcs.SPC+Opcs.EOR;
}

/// It composes simple string info - Opcs.SPC inside 'inf' is allowed.
/// @return: message PREPARED to send. 
String sayOptAndInf(char opCode,String inf)
{
  return Character.toString(opCode)+Opcs.SPC+inf+Opcs.SPC+Opcs.EOR;
}

/// Decode one string message.
/// @return: All characters between a message header (OpCode+SPC) and a final pair (SPC+EOR)
String decodeOptAndInf(String msg)
{
  int beg=2;
  int end=msg.length()-2;
  String ret=msg.substring(beg,end);
  return ret;
}

/// Compose one string info - SPC inside info is NOT allowed.
/// @return: message PREPARED to send. 
String sayOptAndInfos(char opCode,String objName,String info)
{
  return ""+opCode+"1"+Opcs.SPC
           +objName+Opcs.SPC
           +info+Opcs.SPC
           +Opcs.EOR;
}

/// Compose many(=2) string info - SPC inside infos is NOT allowed.
/// @return: message PREPARED to send. 
String sayOptAndInfos(char opCode,String objName,String info1,String info2)
{
  return ""+opCode+"2"+Opcs.SPC
           +objName+Opcs.SPC
           +info1+Opcs.SPC
           +info2+Opcs.SPC
           +Opcs.EOR;
}

/// Compose many(=3) string info - SPC inside infos is NOT allowed.
/// @return: message PREPARED to send. 
String sayOptAndInfos(char opCode,String objName,String info1,String info2,String info3)
{
  return ""+opCode+"3"+Opcs.SPC
           +objName+Opcs.SPC
           +info1+Opcs.SPC
           +info2+Opcs.SPC
           +info3+Opcs.SPC
           +Opcs.EOR;
}

/// It decodes 1-9 infos message. Dimension of the array must be proper
/// @return: object name, and fill the infos
String decodeInfos(String msgInfos,String[] infos)
{
  String[] fields=split(msgInfos,Opcs.SPC);
  if(DEBUG>2) println(fields.length,fields[1]);

  int dimension=fields[0].charAt(1)-'0';
  
  if(dimension!=infos.length) 
        println("Invalid size",dimension,"of infos array!",infos.length);
        
  for(int i=0;i<infos.length;i++)
    infos[i]=fields[i+2];
  return fields[1];//Nazwa
}

/// It constructs touch message with only one possible action
/// @return: message PREPARED to send. 
String sayTouch(String nameOfTouched,float distance,String actionDef)
{
  return ""+Opcs.TCH+"1"+Opcs.SPC
           +nameOfTouched+Opcs.SPC
           +actionDef+Opcs.SPC
           +nf(distance)+Opcs.SPC
           +Opcs.EOR;
}

/// It constructs touch message with two possible actions
/// @return: message PREPARED to send
String sayTouch(String nameOfTouched,float distance,String action1,String action2)
{
  return ""+Opcs.TCH+"2"+Opcs.SPC
           +nameOfTouched+Opcs.SPC
           +action1+Opcs.SPC
           +action2+Opcs.SPC
           +nf(distance)+Opcs.SPC
           +Opcs.EOR;
}

/// It constructs touch message with many possible actions
/// @return: message PREPARED to send
String sayTouch(String nameOfTouched,float distance,String[] actions)// NOT TESTED! TODO
{
  String ret=""+Opcs.TCH;
  if(actions.length<9)
    ret+=""+actions.length+Opcs.SPC;
  else
    ret+="0"+actions.length+Opcs.SPC;
  ret+=nameOfTouched+Opcs.SPC;  
  for(int i=0;i<actions.length;i++)
    ret+=actions[i]+Opcs.SPC;
  ret+=nf(distance)+Opcs.SPC+Opcs.EOR;  
  return ret;
}

/// It decodes touch message. 
/// @return: distance
/// The infos will be filled with name of touched object and up to 9 possible actions
/// (or more - NOT TESTED!)
float decodeTouch(String msg,String[] infos)
{
  String[] fields=split(msg,Opcs.SPC);
  
  int dimension=fields[0].charAt(1)-'0';
  if(dimension==0)
  { 
    dimension=Integer.parseInt(fields[0].substring(1));// TODO: TEST!
  }
  
  if(dimension+1 != infos.length) 
        println("Invalid size",dimension,"of infos array!",infos.length,"for",fields[0],"message!");
        
  for(int i=0;i<dimension+1;i++)
    infos[i]=fields[i+1];
    
  return  Float.parseFloat(fields[dimension+2]);
}

/// It composes message about object position (1 dimension)
/// E1 OName Data @ - Euclidean position float(X)
/// P1 OName Data @ - Polar position float(Alfa +-180)
/// @return: message PREPARED to send
String sayPosition(char EUCorPOL,String objName,float coord)
{
  return ""+EUCorPOL+"1"+Opcs.SPC
           +objName+Opcs.SPC
           +coord+Opcs.SPC
           +Opcs.EOR;
}
                   
/// It composes message about object position (2 dimensions)                   
/// E2 OName Data*2 @ - Euclidean position float(X) float(Y)
/// P2 OName Data*2 @ - Polar position float(Alfa +-180) float(DISTANCE)
/// OName == object identification or name of player or 'Y'
/// @return: message PREPARED to send
String sayPosition(char EUCorPOL,String objName,float coord1,float coord2)
{
  return ""+EUCorPOL+"2"+Opcs.SPC
           +objName+Opcs.SPC
           +coord1+Opcs.SPC
           +coord2+Opcs.SPC
           +Opcs.EOR;
}

/// It composes message about object position (3 dimensions)
/// E3 OName Data*3 @ - Euclidean position float(X) float(Y) float(H) 
/// P3 OName Data*3 @ - Polar position float(Alfa +-180) float(DISTANCE) float(Beta +-180)
/// OName == object identification or name of player or 'Y'
/// @return: message PREPARED to send
String sayPosition(char EUCorPOL,String objName,float coord1,float coord2,float coord3)
{
  return ""+EUCorPOL+"3"+Opcs.SPC
           +objName+Opcs.SPC
           +coord1+Opcs.SPC
           +coord2+Opcs.SPC
           +coord3+Opcs.SPC
           +Opcs.EOR;
}

/// It composes message about object position (1-9 dimensions)
/// En OName Data*n @ - Euclidean position float(X) float(Y) float(H) "class name of object or name of player"
/// Pn OName Data*n @ - Polar position float(Alfa +-180) float(DISTANCE) float(Beta +-180) "class name of object or name of player"
/// OName == object identification or name of player or 'Y'
/// @return: message PREPARED to send
String sayPosition(char EUCorPOL,String objName,float[] coordinates)
{
  String ret=EUCorPOL
            +nf(coordinates.length+1,1)+Opcs.SPC;
  ret+=objName+Opcs.SPC;
  for(int i=0;i<coordinates.length;i++)
  {
    ret+=coordinates[i];
    ret+=Opcs.SPC;
  }
  ret+=Opcs.EOR;
  return ret;
}

/// It decodes 1-9 dimensional positioning message. Dimension of the array must be proper
/// @return: name of object and also fill coordinates.
String decodePosition(String msgPosition,float[] coordinates)
{
  String[] fields=split(msgPosition,Opcs.SPC);
  if(DEBUG>2) println(fields[0],fields[1],fields[2]);
  if(fields[0].charAt(0)==Opcs.EUC || fields[0].charAt(0)==Opcs.POL )
  {
    int dimension=fields[0].charAt(1)-'0';
    
    if(dimension!=coordinates.length) 
          println("Invalid size",dimension,"of coordinate array!");
          
    for(int i=0;i<coordinates.length;i++)
      coordinates[i]=Float.parseFloat(fields[i+2]);
      
    return fields[1];//Name
  }
  else
  return null;//Invalid message
}

/// For objects types management - type of object
/// @return: message PREPARED to send
String sayObjectType(String type,String objectName)
{
  return Opcs.OBJ+"n"+Opcs.SPC
         +type+Opcs.SPC
         +objectName+Opcs.SPC
         +Opcs.EOR;  
}

/// For objects types management - object removing from the game world
/// @return: message PREPARED to send
String sayObjectRemove(String objectName)
{
  return Opcs.OBJ+"d"+Opcs.SPC
         +objectName+Opcs.SPC
         +Opcs.EOR;  
}

/// It decodes message of objects types management - decoding
/// @return: array of strings with "del" action and objectName
/// or "new" action, type name and object name.
/// Other actions are possible in the future.
String[] decodeObjectMng(String msg)
{
  String[] fields=split(msg,Opcs.SPC);
  if(fields[0].charAt(1)=='n')
    fields[0]="new";
  else
  if(fields[0].charAt(1)=='d')
    fields[0]="del";
  else
  {
    println("Invalid object management command:'"+fields[0].charAt(1)+"' for",fields[1],"! IGNORED!");
    return null;
  }
  
  return shorten(fields);// remove one item from the end of array and @return the array
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////


                   
