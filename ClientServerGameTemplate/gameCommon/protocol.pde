/// Source file with declarations of common symbols for client and server.
/// (op.codes and coding/decoding functions).
/// @date 2024-10-21 (last modification)
/// @note Use "link_commons.sh" script for make symbolic connections
///       to "gameServer/" & "gameClient/" directories.
//*/////////////////////////////////////////////////////////////////////////////////////////////
//* NOTE: /*_inline*/ is a Processing2C directive translated to keyword 'inline' in C++ output
import processing.net.*;

//long pid = ProcessHandle.current().pid(); //JAVA9 :-(
int     servPORT=5205;  	         ///< Theoretically it could be any above 1024.
String  serverIP="127.0.0.1";      ///< localhost.

//String  serverIP="192.168.55.201"; ///< at home.
//String  serverIP="192.168.55.104"; ///< 2.
//String  serverIP="10.3.24.216";    ///< at work.
//String  serverIP="10.3.24.4";      ///< workstation local.

/// Protocol dictionary ("opcodes") & general code/decode methods.
static abstract class OpCd { 
  static final String name="sampleGame"; ///< ASCII IDENTIFIER OF PROTOCOL.
  static final String sYOU="Y"; ///< REPLACER OF CORESPONDENT NAME as a ready to use String.
                                ///< Character.toString(YOU);<-not for static.
  //Record defining characters:
  static final char EOR=0x03; ///< End of record (EOR). EOL is not used, because of it use inside data starings.
  static final char SPC='\t'; ///< Field separator
                              ///< Maybe something less popular would be better? Why not ';' ?
  //Record headers (bidirectional):
  static final char ERR='e'; ///< Error message for partner.
  static final char HEL='H'; ///< Hello message (client-server handshake).
  static final char IAM='I'; ///< I am "name of server/name of client".
  static final char YOU='Y'; ///< Redefining player name if not suitable.
  //Named variables/resources:
  static final char GET='G'; ///< Get global resource by name (NOT IMPLEMENTED).
  static final char BIN='B'; ///< Binary hunk of resources (name.type\tsize\tthen data). (NOT IMPLEMENTED)
                             ///< Data hunk is received exactly "as is"!
  static final char TXT='X'; ///< Text hunk of resources (name.type\tsize\tthen data). (NOT IMPLEMENTED)
                             ///< Text may be recoded on the receiver side if needed!
  static final char OBJ='O'; ///< Objects management: "On(-ew) typename objectName" or "Od(-elete) objectName".
  //Game scene/state 
  static final char UPD='U'; ///< Request for update about a whole scene.
  static final char VIS='V'; ///< Visualisation info for a particular object.
  static final char COL='C'; ///< Colors of a particular object.
  static final char STA='S'; ///< Named state attribute of a particular object. (ex.: objname\thp\tval, objname\tsc\tval etc.)
  static final char EUC='E'; ///< Euclidean position of an object.
  static final char POL='P'; ///< Polar position of an object.
  //Interactions
  static final char TCH='T'; ///< Active "Touch" with other object. (info about name & possible actions)
  static final char DTC='D'; ///< Detach with any of previously touched object. (name provided)
  //Player controls of avatar
  static final char NAV='N'; ///< Navigation of the avatar. (wsad and arrows in the template)
  static final char ACT='A'; ///< 'defo'(-ult) or user defined actions of the avatar.
  //...
  //static final char XXX='c'; // something more...
  
  /// It composes one OPC info. 
  /// For which, when received, only charAt(0) is important.
  /// @return message PREPARED to send. 
  /*_inline*/ static final String say(char opc)
  {
    return Character.toString(opc)+SPC+EOR;
  }
  
  /// It composes simple string info. 
  /// Take care about Opcs.SPC inside 'inf'!
  /// @return message PREPARED to send. 
  /*_inline*/ static final String say(char opc,String inf)
  {
    return Character.toString(opc)+SPC+inf+SPC+EOR;
  }
  
  /// It composes multiple strings message. 
  /// Take care about Opcs.SPC inside parameters!!!
  /// @return message PREPARED to send.  
  /*_inline*/ static final String say(char opc,String... varargParam) //NOT TESTED JET
  {
    String ret=Character.toString(opc);
    for (int f=0; f < varargParam.length; f++)
    {
      ret+=SPC;
      ret+=varargParam[f];
    }
    ret+=SPC;
    ret+=EOR;
    return ret;
  }
  
  /// It decodes multiple strings message into array of String. 
  /// Note: The item containing EOR is removed from the end of array.
  /// @return array of strings with opcode string at 0 position
  /*_inline*/ static final String[] decode(String msg) //NOT TESTED JET
  {
    String[] fields=split(msg,SPC);
    return shorten(fields); // remove the item containing EOR from the end of array and @return the array
  }
} //EndOfClass Opcs

// Specific code/decode functions
//*////////////////////////////////////

/// It composes server-client handshake.
/// @return message PREPARED to send. 
/*_inline*/ static final String sayHELLO(String myName)
{
    return ""+OpCd.HEL+OpCd.SPC+OpCd.IAM+OpCd.SPC
             +myName+OpCd.SPC+OpCd.EOR;
}

/// It decodes handshake.
/// @return Name of client or name of game implemented on server
/*_inline*/ static final String decodeHELLO(String msgHello)
{
  String[] fields=split(msgHello,OpCd.SPC);
  if(DEBUG>2) println(fields[0],fields[1],fields[2]);
  if(fields[0].charAt(0)==OpCd.HEL && fields[1].charAt(0)==OpCd.IAM )
      return fields[2];
  else
      return null;
}

/// Decode one string message.
/// @return All characters between a message header (OpCode+SPC) and a final pair (SPC+EOR)
/*_inline*/ static final String decodeOptAndInf(String msg)
{
  int beg=2;
  int end=msg.length()-2;
  String ret=msg.substring(beg,end);
  return ret;
}

/// Compose one string info - SPC inside info is NOT allowed.
/// @return message PREPARED to send. 
/*_inline*/ static final String sayOptAndInfos(char opCode,String objName,String info)
{
  return ""+opCode+"1"+OpCd.SPC
           +objName+OpCd.SPC
           +info+OpCd.SPC
           +OpCd.EOR;
}

/// Compose many(=2) string info - SPC inside infos is NOT allowed.
/// @return message PREPARED to send. 
/*_inline*/ static final String sayOptAndInfos(char opCode,String objName,String info1,String info2)
{
  return ""+opCode+"2"+OpCd.SPC
           +objName+OpCd.SPC
           +info1+OpCd.SPC
           +info2+OpCd.SPC
           +OpCd.EOR;
}

/// Compose many(=3) string info - SPC inside infos is NOT allowed.
/// @return message PREPARED to send. 
/*_inline*/ static final String sayOptAndInfos(char opCode,String objName,String info1,String info2,String info3)
{
  return ""+opCode+"3"+OpCd.SPC
           +objName+OpCd.SPC
           +info1+OpCd.SPC
           +info2+OpCd.SPC
           +info3+OpCd.SPC
           +OpCd.EOR;
}

/// It decodes 1-9 infos message. Dimension of the array must be proper
/// @return object name, and fill the infos
/*_inline*/ static final String decodeInfos(String msgInfos,String[] infos)
{
  String[] fields=split(msgInfos,OpCd.SPC);
  if(DEBUG>2) println(fields.length,fields[1]);

  int dimension=fields[0].charAt(1)-'0';
  
  if(dimension!=infos.length) 
        println("Invalid size",dimension,"of infos array!",infos.length);
        
  for(int i=0;i<infos.length;i++)
    infos[i]=fields[i+2];
  return fields[1]; //Nazwa
}

/// It constructs touch message with only one possible action.
/// @return message PREPARED to send. 
/*_inline*/ static final String sayTouch(String nameOfTouched,float distance,String actionDef)
{
  return ""+OpCd.TCH+"1"+OpCd.SPC
           +nameOfTouched+OpCd.SPC
           +actionDef+OpCd.SPC
           +nf(distance)+OpCd.SPC
           +OpCd.EOR;
}

/// It constructs touch message with two possible actions.
/// @return message PREPARED to send.
/*_inline*/ static final String sayTouch(String nameOfTouched,float distance,String action1,String action2)
{
  return ""+OpCd.TCH+"2"+OpCd.SPC
           +nameOfTouched+OpCd.SPC
           +action1+OpCd.SPC
           +action2+OpCd.SPC
           +nf(distance)+OpCd.SPC
           +OpCd.EOR;
}

/// It constructs touch message with many possible actions.
/// @return message PREPARED to send.
/*_inline*/ static final String sayTouch(String nameOfTouched,float distance,String[] actions)
{
  String ret=""+OpCd.TCH;
  if(actions.length<9)
    ret+=""+actions.length+OpCd.SPC;
  else
    ret+="0"+actions.length+OpCd.SPC;
  ret+=nameOfTouched+OpCd.SPC;  
  for(int i=0;i<actions.length;i++)
    ret+=actions[i]+OpCd.SPC;
  ret+=nf(distance)+OpCd.SPC+OpCd.EOR;  
  return ret;
}

/// It decodes touch message. 
/// @return distance.
/// The infos will be filled with name of touched object and up to 9 possible actions.
/// (0 or more than 9 - NOT TESTED!)
/*_inline*/ static final float decodeTouch(String msg,String[] infos)
{
  String[] fields=split(msg,OpCd.SPC);
  
  int dimension=fields[0].charAt(1)-'0';
  if(dimension==0)
  {  //<>//
    dimension=Integer.parseInt(fields[0].substring(1)); // NOT TESTED! //<>//
  } //<>//
  
  if(dimension+1 != infos.length) 
        println("Invalid size",dimension,"of infos array!",infos.length,"for",fields[0],"message!");
        
  for(int i=0;i<dimension+1;i++)
    infos[i]=fields[i+1];
    
  return  Float.parseFloat(fields[dimension+2]);
}

/// It composes message about object position (1 dimension).
/// E1 OName Data @ - Euclidean position float(X)
/// P1 OName Data @ - Polar position float(Alfa +-180)
/// @return message PREPARED to send
/*_inline*/ static final String sayPosition(char EUCorPOL,String objName,float coord)
{
  return ""+EUCorPOL+"1"+OpCd.SPC
           +objName+OpCd.SPC
           +coord+OpCd.SPC
           +OpCd.EOR;
}
                   
/// It composes message about object position (2 dimensions).                  
/// E2 OName Data*2 @ - Euclidean position float(X) float(Y)
/// P2 OName Data*2 @ - Polar position float(Alfa +-180) float(DISTANCE)
/// OName == object identification or name of player or 'Y'
/// @return message PREPARED to send
/*_inline*/ static final String sayPosition(char EUCorPOL,String objName,float coord1,float coord2)
{
  return ""+EUCorPOL+"2"+OpCd.SPC
           +objName+OpCd.SPC
           +coord1+OpCd.SPC
           +coord2+OpCd.SPC
           +OpCd.EOR;
}

/// It composes message about object position (3 dimensions).
/// E3 OName Data*3 @ - Euclidean position float(X) float(Y) float(H) 
/// P3 OName Data*3 @ - Polar position float(Alfa +-180) float(DISTANCE) float(Beta +-180)
/// OName == object identification or name of player or 'Y'
/// @return message PREPARED to send
/*_inline*/ static final String sayPosition(char EUCorPOL,String objName,float coord1,float coord2,float coord3)
{
  return ""+EUCorPOL+"3"+OpCd.SPC
           +objName+OpCd.SPC
           +coord1+OpCd.SPC
           +coord2+OpCd.SPC
           +coord3+OpCd.SPC
           +OpCd.EOR;
}

/// It composes message about object position (1-9 dimensions).
/// En OName Data*n @ - Euclidean position float(X) float(Y) float(H) "class name of object or name of player"
/// Pn OName Data*n @ - Polar position float(Alfa +-180) float(DISTANCE) float(Beta +-180) "class name of object or name of player"
/// OName == object identification or name of player or 'Y'
/// @return message PREPARED to send
/*_inline*/ static final String sayPosition(char EUCorPOL,String objName,float[] coordinates)
{
  String ret=EUCorPOL
            +nf(coordinates.length+1,1)+OpCd.SPC;
  ret+=objName+OpCd.SPC;
  for(int i=0;i<coordinates.length;i++)
  {
    ret+=coordinates[i];
    ret+=OpCd.SPC;
  }
  ret+=OpCd.EOR;
  return ret;
}

/// It decodes 1-9 dimensional positioning message. Dimension of the array must be proper.
/// @return name of object and also fill coordinates.
/*_inline*/ static final String decodePosition(String msgPosition,float[] coordinates)
{
  String[] fields=split(msgPosition,OpCd.SPC);
  if(DEBUG>2) println(fields[0],fields[1],fields[2]);
  if(fields[0].charAt(0)==OpCd.EUC || fields[0].charAt(0)==OpCd.POL )
  {
    int dimension=fields[0].charAt(1)-'0';
    
    if(dimension!=coordinates.length) 
          println("Invalid size",dimension,"of coordinate array!");
          
    for(int i=0;i<coordinates.length;i++)
      coordinates[i]=Float.parseFloat(fields[i+2]);
      
    return fields[1]; //Name
  }
  else
  return null; //Invalid message
}

/// For objects types management - type of object.
/// @return message PREPARED to send.
/*_inline*/ static final String sayObjectType(String type,String objectName)
{
  return OpCd.OBJ+"n"+OpCd.SPC
         +type+OpCd.SPC
         +objectName+OpCd.SPC
         +OpCd.EOR;  
}

/// For objects types management - object removing from the game world.
/// @return message PREPARED to send
/*_inline*/ static final String sayObjectRemove(String objectName)
{
  return OpCd.OBJ+"d"+OpCd.SPC
         +objectName+OpCd.SPC
         +OpCd.EOR;  
}

/// It decodes message of objects types management - decoding.
/// @return array of strings with "del" action and objectName
/// or "new" action, type name and object name.
/// Other actions are possible in the future.
/*_inline*/ static final String[] decodeObjectMng(String msg)
{
  String[] fields=split(msg,OpCd.SPC);
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
  
  return shorten(fields); // remove one item from the end of array and @return the array
}

//*/////////////////////////////////////////////////////////////////////////////////////////
///  Partly sponsored by the EU project "GuestXR" (https://guestxr.eu/)
///  @author  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
///  @project https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////
