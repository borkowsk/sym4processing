//*  gameClient - more comm. logic 
//*/////////////////////////////////////////////// 

//GameObject atributes specific for client side
abstract class implNeeded 
{
  //...currently nothing here
};

void clientGameDraw()
{          
    fill(255,0,0);
    for(int i = 0; true; i++)
    {
      if (myClient.available() > 0) 
      {
        if(DEBUG>2) print(playerName,"is reciving:");
        String msg = myClient.readStringUntil(Opts.NOPE);
        if(VIEWMESG>0 || DEBUG>2) println(msg);
        
        if(msg==null || msg.equals("") || msg.charAt(msg.length()-1)!=Opts.NOPE)
        {
          println(playerName,"recived invalid message. IGNORED");
          return;
        }
        
        interpretMessage(msg);
      }
      else
      break;
    }
    background(0);
    visualise2D(0,0,width,height);
}

void visualisationChanged(GameObject[] table,String name,String vtype)
{
  int pos=(name.equals(Opts.sYOU)?indexOfMe:localiseByName(table,name));
  if(pos==-1)//FIRST TIME
  {
    mainGameArray = (GameObject[]) expand(mainGameArray,mainGameArray.length+1);
    pos=mainGameArray.length-1;
    mainGameArray[pos]=new GameObject(name,0,0,0);
  }
  mainGameArray[pos].visual=vtype;
}

void colorChanged(GameObject[] table,String name,String hexColor)
{
  color newColor=unhex(hexColor);
  int pos=(name.equals(Opts.sYOU)?indexOfMe:localiseByName(table,name));
  if(pos==-1)//FIRST TIME
  {
    mainGameArray = (GameObject[]) expand(mainGameArray,mainGameArray.length+1);
    pos=mainGameArray.length-1;
    mainGameArray[pos]=new GameObject(name,0,0,0);
    mainGameArray[pos].foreground=newColor;
  }
  mainGameArray[pos].foreground=newColor;
}

void positionChanged(GameObject[] table,String name,float[] inparr2)
{
  int pos=(name.equals(Opts.sYOU)?indexOfMe:localiseByName(table,name));
  if(pos==-1)//FIRST TIME
  {
    mainGameArray = (GameObject[]) expand(mainGameArray,mainGameArray.length+1);
    pos=mainGameArray.length-1;
    mainGameArray[pos]=new GameObject(name,inparr2[0],inparr2[1],0);
  }
  else
  {
    mainGameArray[pos].X=inparr2[0];
    mainGameArray[pos].Y=inparr2[1];
  }
}

float[] inparr1=new float[1];
float[] inparr2=new float[2];
String[] instr1=new String[1];
String[] instr2=new String[2];

void interpretMessage(String msg)
{
  switch(msg.charAt(0)){
  //Obliq. part
  default: println(playerName,"recived UNKNOWN MESSAGE TYPE:",msg.charAt(0));break;
  case Opts.NOPE: if(DEBUG>0) println(playerName,"recived NOPE");break;
  case Opts.HELLO:
  case Opts.IAM: println(playerName,"recived ENEXPECTED MESSAGE TYPE:",msg.charAt(0));break;
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
                 visualisationChanged(mainGameArray,objectName,instr1[0]);
  } break;
  case Opts.COL: { String objectName=decodeInfos(msg,instr1);
                 if(DEBUG>1) println(objectName,"change color into",instr1[0]); 
                 colorChanged(mainGameArray,objectName,instr1[0]);
                 } break;               
  //... rest of message types
  case Opts.EUC: if(msg.charAt(1)=='1')
                 {
                   String who=decodePosition(msg,inparr1);//print(who);
                   //...
                   println("Invalid position message:",msg);
                 }
                 else
                 if(msg.charAt(1)=='2')
                 {
                   String who=decodePosition(msg,inparr2);//print(who);
                   positionChanged(mainGameArray,who,inparr2);
                 }
                 else
                 {
                   println("Invalid dimension of position message",msg.charAt(1));
                 }
  }//END OF MESSAGE TYPES SWITCH
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////
