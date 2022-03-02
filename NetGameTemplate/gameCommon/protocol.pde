//* Declaration common for client and server
//* Use link script for make symbolic connections to gameServer & gameClient directories
//*//////////////////////////////////////////////////////////////////////////////////////
import processing.net.*;

//long pid = ProcessHandle.current().pid();//JAVA9 :-(
String  serverIP="127.0.0.1";     ///> localhost
//String  serverIP="192.168.55.201";///> at home 
//String  serverIP="192.168.55.104";///> 
//String  serverIP="10.3.24.216";   ///> at work
//String  serverIP="10.3.24.4";     ///> workstation local
//String  serverIP="193.0.101.164"; ///> 
int     servPORT=5205;  ///> Teoretically it could be any above 1024

/// Protocol dictionary ("opcodes" etc.)
class Opts { 
  static final String name="sampleGame";//ASCI IDENTIFIER OF PROTOCOL
  static final String sYOU="Y";//REPLACER OF CORESPONDENT NAME as a ready to use String. 
                               //Character.toString(YOU);<-not for static
  //Record defining characters
  static final char EOR=0x03;//End of record (EOR)
  static final char SPC='\t';//Field separator
  //Record headers (bidirectorial)
  static final char ERR='e'; //Error message for partner
  static final char HEL='H'; //Hello message (client-server handshake)
  static final char IAM='I'; //I am "name of server/name of client"
  static final char YOU='Y'; //Redefining player name if not suitable
  //Named variables/resources
  static final char GET='G'; //Get global resource by name
  static final char BIN='B'; //Binary hunk of resources (name.type\tsize\tthen data)
  static final char TXT='X'; //Text hunk of resources (name.type\tsize\tthen data)
  static final char OBJ='O'; //Objects managment: "On typename objectName" or "Od objectName"
  //Game scene/state 
  static final char UPD='U'; //Request for update about a whole scene
  static final char VIS='V'; //Visualisation info for a particular object
  static final char COL='C'; //Colors of a particular object
  static final char STA='S'; //State of a particular object (ex.: objname\thp\tval, objname\tsc\tval etc.)
  static final char EUC='E'; //Euclidean position of an object
  static final char POL='P'; //Polar position of an object
  //Interactions
  static final char TCH='T'; //Active "Touch" with other object (info about name & possible actions)
  static final char DTC='D'; //Detouch with any of previously touched object (name provided)
  //Player controls of avatar
  static final char NAV='N';//Navigation of the avatar
  static final char ACT='A';//User defined actions of the avatar
  //...
  //static final char XXX='c';// something more...
};

/// For server-client handshake
String sayHELLO(String myName)
{
    return ""+Opts.HEL+Opts.SPC+Opts.IAM+Opts.SPC
             +myName+Opts.SPC+Opts.EOR;
}

/// Decode handshake
String decodeHELLO(String msgHello)
{
  String[] fields=split(msgHello,Opts.SPC);
  if(DEBUG>2) println(fields[0],fields[1],fields[2]);
  if(fields[0].charAt(0)==Opts.HEL && fields[1].charAt(0)==Opts.IAM )
      return fields[2];
  else
      return null;
}

/// Send one char info. When recieved, only charAt(0) is important.
String sayOptCode(char optCode)
{
  return Character.toString(optCode)+Opts.SPC+Opts.EOR;
}

/// Send simple string info - SPC inside 'inf' is allowed.
String sayOptAndInf(char optCode,String inf)
{
  return Character.toString(optCode)+Opts.SPC+inf+Opts.SPC+Opts.EOR;
}

String decodeOptAndInf(String msg)
{
  int beg=2;
  int end=msg.length()-2;
  String ret=msg.substring(beg,end);
  return ret;
}

/// Send many(1) string info - SPC inside val is NOT allowed.
String sayOptAndInfos(char optCode,String objName,String info1)
{
  return ""+optCode+"1"+Opts.SPC
           +objName+Opts.SPC
           +info1+Opts.SPC
           +Opts.EOR;
}

/// Send many(2) string info - SPC inside val is NOT allowed.
String sayOptAndInfos(char optCode,String objName,String info1,String info2)
{
  return ""+optCode+"2"+Opts.SPC
           +objName+Opts.SPC
           +info1+Opts.SPC
           +info2+Opts.SPC
           +Opts.EOR;
}

/// Send many(3) string info - SPC inside val is NOT allowed.
String sayOptAndInfos(char optCode,String objName,String info1,String info2,String info3)
{
  return ""+optCode+"3"+Opts.SPC
           +objName+Opts.SPC
           +info1+Opts.SPC
           +info2+Opts.SPC
           +info3+Opts.SPC
           +Opts.EOR;
}

/// Decode 1-9 infos message. Dimension of the array must be proper
String decodeInfos(String msgInfos,String[] infos)
{
  String[] fields=split(msgInfos,Opts.SPC);
  if(DEBUG>2) println(fields);

  int dimension=fields[0].charAt(1)-'0';
  
  if(dimension!=infos.length) 
        println("Invalid size",dimension,"of infos array!",infos.length);
        
  for(int i=0;i<infos.length;i++)
    infos[i]=fields[i+2];
  return fields[1];//Nazwa
}

String sayTouch(String nameOfTouched,float distance,String actionDef)
{
  return ""+Opts.TCH+"1"+Opts.SPC
           +nameOfTouched+Opts.SPC
           +actionDef+Opts.SPC
           +nf(distance)+Opts.SPC
           +Opts.EOR;
}

String sayTouch(String nameOfTouched,float distance,String action1,String action2)
{
  return ""+Opts.TCH+"2"+Opts.SPC
           +nameOfTouched+Opts.SPC
           +action1+Opts.SPC
           +action2+Opts.SPC
           +nf(distance)+Opts.SPC
           +Opts.EOR;
}

String sayTouch(String nameOfTouched,float distance,String[] actions)// NOT TESTED
{
  String ret=""+Opts.TCH;
  if(actions.length<9)
    ret+=""+actions.length+Opts.SPC;
  else
    ret+="0"+actions.length+Opts.SPC;
  ret+=nameOfTouched+Opts.SPC;  
  for(int i=0;i<actions.length;i++)
    ret+=actions[i]+Opts.SPC;
  ret+=nf(distance)+Opts.SPC+Opts.EOR;  
  return ret;
}

float decodeTouch(String msg,String[] infos)
{
  String[] fields=split(msg,Opts.SPC);
  
  int dimension=fields[0].charAt(1)-'0';
  
  if(dimension+1 != infos.length) 
        println("Invalid size",dimension,"of infos array!",infos.length,"for",fields[0],"message!");
        
  for(int i=0;i<dimension+1;i++)
    infos[i]=fields[i+1];
    
  return  Float.parseFloat(fields[dimension+2]);
}

/// Send position of particular object
/// E1 OName Data @ - Euclidean position float(X)
/// P1 OName Data @ - Polar position float(Alfa +-180)
String sayPosition(char EUCorPOL,String objName,float coord)
{
  return ""+EUCorPOL+"1"+Opts.SPC
           +objName+Opts.SPC
           +coord+Opts.SPC
           +Opts.EOR;
}
                   
/// E2 OName Data*2 @ - Euclidean position float(X) float(Y)
/// P2 OName Data*2 @ - Polar position float(Alfa +-180) float(DISTANCE)
/// OName == object identification or name of player or 'Y'
String sayPosition(char EUCorPOL,String objName,float coord1,float coord2)
{
  return ""+EUCorPOL+"2"+Opts.SPC
           +objName+Opts.SPC
           +coord1+Opts.SPC
           +coord2+Opts.SPC
           +Opts.EOR;
}

/// E3 OName Data*3 @ - Euclidean position float(X) float(Y) float(H) 
/// P3 OName Data*3 @ - Polar position float(Alfa +-180) float(DISTANCE) float(Beta +-180)
/// OName == object identification or name of player or 'Y'
String sayPosition(char EUCorPOL,String objName,float coord1,float coord2,float coord3)
{
  return ""+EUCorPOL+"3"+Opts.SPC
           +objName+Opts.SPC
           +coord1+Opts.SPC
           +coord2+Opts.SPC
           +coord3+Opts.SPC
           +Opts.EOR;
}

/// En OName Data*n @ - Euclidean position float(X) float(Y) float(H) "class name of object or name of player"
/// Pn OName Data*n @ - Polar position float(Alfa +-180) float(DISTANCE) float(Beta +-180) "class name of object or name of player"
/// OName == object identification or name of player or 'Y'
String sayPosition(char EUCorPOL,String objName,float[] coordinates)
{
  String ret=EUCorPOL
            +nf(coordinates.length+1,1)+Opts.SPC;
  ret+=objName+Opts.SPC;
  for(int i=0;i<coordinates.length;i++)
  {
    ret+=coordinates[i];
    ret+=Opts.SPC;
  }
  ret+=Opts.EOR;
  return ret;
}

/// Decode 1-9 positioning message. Dimension of the array must be proper
String decodePosition(String msgPosition,float[] coordinates)
{
  String[] fields=split(msgPosition,Opts.SPC);
  if(DEBUG>2) println(fields[0],fields[1],fields[2]);
  if(fields[0].charAt(0)==Opts.EUC || fields[0].charAt(0)==Opts.POL )
  {
    int dimension=fields[0].charAt(1)-'0';
    
    if(dimension!=coordinates.length) 
          println("Invalid size",dimension,"of coordinate array!");
          
    for(int i=0;i<coordinates.length;i++)
      coordinates[i]=Float.parseFloat(fields[i+2]);
      
    return fields[1];//Nazwa
  }
  else
  return null;//Invalid message
}

/// Object type managment - type of object
String sayObjectType(String type,String objectName)
{
  return Opts.OBJ+"n"+Opts.SPC
         +type+Opts.SPC
         +objectName+Opts.SPC
         +Opts.EOR;  
}

/// Object type managment - object removing from the game world
String sayObjectRemove(String objectName)
{
  return Opts.OBJ+"d"+Opts.SPC
         +objectName+Opts.SPC
         +Opts.EOR;  
}

/// Object type managment - decoding
String[] decodeObjectMng(String msg)
{
  String[] fields=split(msg,Opts.SPC);
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
  
  return shorten(fields);
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////


                   
