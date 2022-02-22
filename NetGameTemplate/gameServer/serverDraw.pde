int   Xmargin=0;
float initialMaxX=100;
float initialMaxY=100;

boolean wholeUpdateRequested=false;

//GameObject atributes specific for server side
final int MOVED_MSK  = 0x1;
final int VISUAL_MSK = 0x2;
final int COLOR_MSK  = 0x4;
final int ALL_MSK = MOVED_MSK | VISUAL_MSK | COLOR_MSK;

abstract class implNeeded 
{ 
  int changed=0;//*_MASK alloved here
};

void initialiseGame()
{
  mainGameArray=new GameObject[initialSizeOfMainArray];
  for(int i=0;i<initialSizeOfMainArray;i++)
  {
    GameObject tmp=new GameObject("o"+nf(i,2),int(random(initialMaxX)),int(random(initialMaxY)),0);
    tmp.visual=plants;
    tmp.foreground=color(int(random(100)),128+int(random(128)),100+int(random(100)));
    if(DEBUG>2) println(hex(tmp.foreground));
    tmp.changed=ALL_MSK;
    mainGameArray[i]=tmp;
  }
}

void sendWholeUpdate()
{
  noLoop();//KIND OF CRITICAL SECTION!?!?!
  
  GameObject curr=null;
  for(int i=0;i<mainGameArray.length;i++)
  if((curr=mainGameArray[i])!=null)
  {
    String msg=sayOptAndInfos(Opts.VIS,curr.name,curr.visual);
    msg+=sayPosition(Opts.EUC,curr.name,curr.X,curr.Y);
    msg+=sayOptAndInfos(Opts.COL,curr.name,hex(curr.foreground));
    mainServer.write(msg);
    curr.changed=0;//Whatever was there was sent
  }
    
  wholeUpdateRequested=false;
  loop();
}

void updateChangedAgents()
{
  noLoop();//KIND OF CRITICAL SECTION!?!?!
  
  GameObject curr=null;
  for(int i=0;i<mainGameArray.length;i++)
  if((curr=mainGameArray[i])!=null
  && curr.changed!=0
  )
  {
    String msg="";
    if((curr.changed & VISUAL_MSK )!=0)
      msg+=sayOptAndInfos(Opts.VIS,curr.name,curr.visual);
    if((curr.changed & MOVED_MSK )!=0)  
      msg+=sayPosition(Opts.EUC,curr.name,curr.X,curr.Y);
    if((curr.changed & COLOR_MSK  )!=0)
      msg+=sayOptAndInfos(Opts.COL,curr.name,hex(curr.foreground));
    if(msg.length()>0)  
      mainServer.write(msg);
    curr.changed=0;//Whatever was there was sent
  }
  
  loop();
}

void playerMove(String dir,Player player)
{
  switch(dir.charAt(0)){
  case 'f': player.Y--; break;
  case 'b': player.Y++; break;
  case 'l': player.X--; break;
  case 'r': player.X++; break;
  default:
       println(player.name,"did unknown move");
       player.netLink.write( sayOptAndInf(Opts.ERR,dir+" move is unknown on the server!"));
  break;
  }//end of moves switch
  player.changed|=MOVED_MSK;
}

void playerAction(String action,Player player)
{
  println(player.name,"did undefined or not allowed action:",action);
  player.netLink.write( sayOptAndInf(Opts.ERR,"Action "+action+" is undefined in this context!"));
}

///It interprets message from a particular client
void interpretMessage(String msg,Player player)
{
  switch(msg.charAt(0)){
  //Obliq. part
  default: println("Server recived UNKNOWN MESSAGE TYPE:",msg.charAt(0));break;
  case Opts.NOPE: if(DEBUG>0) println("Server recived NOPE");break;
  case Opts.HELLO:
  case Opts.IAM: println("Server recived ENEXPECTED MESSAGE TYPE:",msg.charAt(0));break;
  //Normal interactions
  case Opts.UPD: 
                  wholeUpdateRequested=true; 
                break;
  case Opts.NAV:{ String direction=decodeOptAndInf(msg);     
                  playerMove(direction,player);
                } break;
  case Opts.ACT:{ String action=decodeOptAndInf(msg);     
                  playerAction(action,player);
                } break;              
  }//END OF MESSAGE TYPES SWITCH
}

///Read messages from clients
void readMessages()
{
  for(int i = 0; i < players.length; i++)
  if(players[i]!=null 
  && players[i].netLink !=null
  && players[i].netLink.available()>0)
  {
        if(DEBUG>1) print("Server is reciving from",players[i].name,":");
        String msg = players[i].netLink.readStringUntil(Opts.NOPE);
        if(DEBUG>1) println(msg);
        
        interpretMessage(msg,players[i]);
  }
}

///Do what is independent of player actions
void internalMechanics()
{
/*
  for (int i = 0; i < players.length; i++)
  if(players[i]!=null 
  && players[i].netLink !=null
  && players[i].netLink.active())
  {
    players[i].X = (players[i].X+1)%255;//changes the value based on which client number it has (the higher client number, the fast it changes).
    String msg=sayPosition(Opts.EUC,Opts.sYOU,players[i].X,players[i].Y);
    players[i].netLink.write(msg);//writes to the right client (using the byte type is not necessary)
    
    fill(255,0,255);textAlign(LEFT,TOP);
    text(players[i].name+": "+players[i].X,0, height/2.+15*(i+1));
    players[i].changed=MOVED_MSK;
  } */
}

void serverGameDraw()
{
  background(0);
  fill(255,0,255);textAlign(LEFT,TOP);
  text(players.length,0,0);//Displays how many clients have connected to the server
  
  visualise2D(Xmargin,0,width-Xmargin,height);
  
  readMessages();
  internalMechanics();//Do what is independent of player actions
  
  if(wholeUpdateRequested)//If any client requested update
  {
     sendWholeUpdate(); //<>//
  }
  else
  {
     updateChangedAgents(); //<>//
  }
}