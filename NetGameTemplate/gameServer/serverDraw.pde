//*  Server for gameClients - more comm. & game logic 
//*//////////////////////////////////////////////////// 

int   Xmargin=0;       ///> Left margin of server screen (status column)
float initialMaxX=100; ///> Initial horizontal size of game "board" 
float initialMaxY=100; ///> Initial vertical size of game "board" 

boolean wholeUpdateRequested=false; ///> ???

/// This function sends a full game board update to all clients
void sendWholeUpdate()
{
  noLoop();//KIND OF CRITICAL SECTION!?!?!
  
  GameObject curr=null;
  for(int i=0;i<gameWorld.length;i++)
  if((curr=gameWorld[i])!=null)
  {
    String msg=sayOptAndInfos(Opts.VIS,curr.name,curr.visual);
    msg+=sayPosition(Opts.EUC,curr.name,curr.X,curr.Y);
    msg+=sayOptAndInfos(Opts.COL,curr.name,hex(curr.foreground));
    mainServer.write(msg);
    curr.flags=0;//Whatever was there was sent
  }
    
  wholeUpdateRequested=false;
  loop();
}

/// This function sends all recent changes to all server clients.
void sendUpdateOfChangedAgents()
{
  noLoop();//KIND OF CRITICAL SECTION!?!?!
  
  GameObject curr=null;
  for(int i=0;i<gameWorld.length;i++)
  if((curr=gameWorld[i])!=null
  && curr.flags!=0
  )
  {
    String msg="";
    if((curr.flags & VISUAL_MSK )!=0)
      msg+=sayOptAndInfos(Opts.VIS,curr.name,curr.visual);
    if((curr.flags & MOVED_MSK )!=0)  
      msg+=sayPosition(Opts.EUC,curr.name,curr.X,curr.Y);
    if((curr.flags & COLOR_MSK  )!=0)
      msg+=sayOptAndInfos(Opts.COL,curr.name,hex(curr.foreground));
    //... 
        
    if(msg.length()>0)  
      mainServer.write(msg);
 
    curr.flags=0;//Whatever was there was sent
  }
  
  loop();
}

/// It interprets message from a particular client/player
void interpretMessage(String msg,Player player)
{
  switch(msg.charAt(0)){
  //Obliq. part
  default: println("Server recived from",player.name,"UNKNOWN MESSAGE TYPE:",msg.charAt(0));break;
  case Opts.EOR: println("Server recived empty record from",player.name); break;
  case Opts.HEL:
  case Opts.IAM: println("Server recived from",player.name,"UNEXPECTED MESSAGE TYPE:",msg.charAt(0));break;
  //Normal interactions
  case Opts.UPD: 
                  wholeUpdateRequested=true; 
                break;
  case Opts.NAV:{ String direction=decodeOptAndInf(msg);     
                  playerMove(direction,player);
                  player.flags|=MOVED_MSK;
                } break;
  case Opts.ACT:{ String action=decodeOptAndInf(msg);     
                  playerAction(action,player);
                } break;              
  }//END OF MESSAGE TYPES SWITCH
}

/// It reads messages from clients
void readMessages()
{
  for(int i = 0; i < players.length; i++)
  if(players[i]!=null 
  && players[i].netLink !=null
  && players[i].netLink.available()>0)
  {
        if(DEBUG>1) print("Server is reciving from",players[i].name,":");
        String msg = players[i].netLink.readStringUntil(Opts.EOR);
        if(msg==null || msg.equals("") || msg.charAt(msg.length()-1)!=Opts.EOR)
        {
          println("Server recived invalid message. IGNORED");
          return;
        }
        if(DEBUG>1) println(msg);
        
        textAlign(LEFT,TOP);fill(random(255),random(255),random(255));
        text(players[i].name+": "+players[i].X+" "+players[i].X,
             0, 15*(i+1) );
        
        interpretMessage(msg,players[i]);
  }
}


/// initialisation of game world
void initialiseGame()
{
  gameWorld=new GameObject[initialSizeOfMainArray];
  for(int i=0;i<initialSizeOfMainArray;i++)
  {
    GameObject tmp=new GameObject("o"+nf(i,2),int(random(initialMaxX)),int(random(initialMaxY)),0);
    tmp.visual=plants;
    tmp.foreground=color(int(random(100)),128+int(random(128)),100+int(random(100)));
    if(DEBUG>2) println(hex(tmp.foreground));
    tmp.flags=ALL_MSK;
    gameWorld[i]=tmp;
  }
}

/// Do in game world all, what is independent of players actions
void stepOfGameMechanics()
{
  for (int i = 0; i < players.length; i++)
  if(players[i]!=null 
  && players[i].netLink !=null
  && players[i].netLink.active())
  {
    //players[i].X = (players[i].X+1)%255;//changes the value based on which client number it has (the higher client number, the fast it changes).
    //String msg=sayPosition(Opts.EUC,Opts.sYOU,players[i].X,players[i].Y);
    //players[i].netLink.write(msg);//writes to the right client (using the byte type is not necessary)
    //players[i].changed=MOVED_MSK;
    fill(players[i].foreground); textAlign(LEFT,TOP);
    text(players[i].name,0,15*(i+1));
  }
}

/// Server real jobs during game:
/// - Displays how many clients have connected to the server
/// - Visualises the current state of the game
/// - Does what players decided to do (if doable)
/// - If any client requested update, send whole update to clients!
/// - If not, send to clients only last changed things
void serverGameDraw()
{
  background(0);
  fill(255,0,255);textAlign(LEFT,TOP);
  text(players.length,0,0);//Displays how many clients have connected to the server
  
  visualise2D(Xmargin,0,width-Xmargin,height);// current state of the game
  
  readMessages();// Do what players decided to do (if doable)
  
  stepOfGameMechanics();//Do what is independent of player actions!
  
  if(wholeUpdateRequested)//If any client requested update
  {
     sendWholeUpdate(); //Send whole update to clients //<>//
  }
  else
  {
     sendUpdateOfChangedAgents();// Send to clients only last changed things //<>//
  }
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////
