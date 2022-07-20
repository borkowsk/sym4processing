/// gameServer - more communication & game logic 
//*//////////////////////////////////////////////////// 

int   x_margin=0;                   ///< Left margin of server screen (status column)
boolean wholeUpdateRequested=false; ///< Information about a client requesting information about the entire scene.
                                    ///< In such a case, it is sent to all clients (in this template of the server)

/// This function sends a full game board update to all clients
void sendWholeUpdate()
{
  noLoop(); //KIND OF CRITICAL SECTION!?!?!
  
  GameObject curr=null;
  for(int i=0;i<gameWorld.length;i++)
  if((curr=gameWorld[i])!=null)
  {
    curr.flags|=Masks.ALL_CHANGED;
    String msg=curr.sayState();
    //sayOptAndInfos(Opts.VIS,curr.name,curr.visual);
    //msg+=sayPosition(Opts.EUC,curr.name,curr.X,curr.Y);
    //msg+=sayOptAndInfos(Opts.COL,curr.name,hex(curr.foreground));
    if(msg.length()>0)  
      mainServer.write(msg);
    curr.flags=0; //Whatever was there, was sent
  }
    
  wholeUpdateRequested=false; // Now all is sent.
  loop();
}

/// This function sends all recent changes to all clients.
void sendUpdateOfChangedAgents()
{
  noLoop(); //KIND OF CRITICAL SECTION ;-)
  
  GameObject curr=null;
  
  for(int i=0;i<gameWorld.length;i++)
  if((curr=gameWorld[i])!=null
  && (curr.flags & Masks.ALL_CHANGED)!=0
  )
  {
      String msg=curr.sayState();
        
      if(msg.length()>0)  
        mainServer.write(msg);
 
     curr.flags=0; //Whatever was there, was sent
  }
  
  loop(); //END of CRITICAL SECTION ;-)
}

/// It reads pending messages from all players
void readMessagesFromPlayers()
{
  for(int i = 0; i < players.length; i++) // Always in the same order! REIMPLEMENT WHEN IT MAY BE IMPORTANT!
  if(players[i]!=null 
  && players[i].netLink !=null
  && players[i].netLink.available()>0)
  {
        if(DEBUG>1) print("Server is receiving from",players[i].name,":");
        String msg = players[i].netLink.readStringUntil(OpCd.EOR);
        if(msg==null || msg.equals("") || msg.charAt(msg.length()-1)!=OpCd.EOR)
        {
          println("Server received invalid message. IGNORED");
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
    tmp.visual=plants[1];
    tmp.foreground=color(int(random(100)),128+int(random(128)),100+int(random(100)));
    if(DEBUG>2) println(hex(tmp.foreground));
    tmp.flags=Masks.ALL_CHANGED;
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
    //players[i].X = (players[i].X+1)%255; //changes the value based on which client number it has (the higher client number, the fast it changes).
    //String msg=sayPosition(Opts.EUC,Opts.sYOU,players[i].X,players[i].Y);
    //players[i].netLink.write(msg); //writes to the right client (using the byte type is not necessary)
    //players[i].changed=MOVED_MSK;
    fill(players[i].foreground); textAlign(LEFT,TOP);
    text(players[i].name,0,15*(i+1));
  }
}

/// Checks for collisions and sends information about them to clients
/// In the example game, only the players move, so only they can cause collisions
void checkCollisions()
{
  for(int i=0;i<players.length;i++)
  if(players[i]!=null && players[i].netLink!=null) //Not a ghost
  {
    int indexInGameWorld=players[i].indexInGameWorld; //println(indexInGameWorld);
    if(indexInGameWorld<0) // SAFEGUARD
    {
      indexInGameWorld=localiseByName(gameWorld,players[i].name);
      if(indexInGameWorld>=0) players[i].indexInGameWorld=indexInGameWorld;
      else
      {
        println("Data inconsistency error:",players[i].name,"is not in the game world!");
        continue;
      }
    }
    
    int indexOfTouched=findCollision(gameWorld,indexInGameWorld,0,false);
    if(indexOfTouched>=0) //COLLISION DETECTED!
    {
        if(players[i].interactionObject!=gameWorld[indexOfTouched]) //New interaction
        {
          if(DEBUG>0)
            println("New touch between",gameWorld[indexInGameWorld].name,"&",gameWorld[indexOfTouched].name);
          players[i].interactionObject=gameWorld[indexOfTouched];
          String[] possible=gameWorld[indexOfTouched].possibilities();
          String msg;
          if(possible==null)
            msg=sayTouch(gameWorld[indexOfTouched].name,0,"defo"); //DISTANCE IS IGNORED in THIS EXAMPLE GAME
          else
            msg=sayTouch(gameWorld[indexOfTouched].name,0,possible);
          players[i].netLink.write(msg);
        }
    }
    else
    {
      //println("No collision for",gameWorld[indexInGameWorld].name); //DEBUG ONLY!
      if(players[i].interactionObject!=null)
      {
         String msg=OpCd.say(OpCd.DTC,players[i].interactionObject.name);
         players[i].interactionObject=null;
         players[i].netLink.write(msg);
      }
    }
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
  text(players.length,0,0); //Displays how many clients have connected to the server
  
  visualise2D(x_margin,0,width-x_margin,height); // current state of the game
  
  readMessagesFromPlayers(); // Do what players decided to do (if doable)
  
  stepOfGameMechanics(); //Do what is independent of player actions!
  
  if(wholeUpdateRequested) //If any client requested update
  {
     sendWholeUpdate(); //Send whole update to clients
  }
  else
  {
     sendUpdateOfChangedAgents(); // Send to clients only last changed things
  }
  
  checkCollisions(); // checks for collisions and sends information about them to clients
}

/// This function interprets message from a particular player
void interpretMessage(String msg,Player player)
{
  switch(msg.charAt(0)){
  // Future use NOT IMPLEMENTED FOR NOW!
  case OpCd.OBJ: // What about multiserver games? Objects from a neighboring server?
  case OpCd.GET: // GET global RESOURCES by name.
  case OpCd.BIN: // GET binary hunk of RESOURCES
  case OpCd.TXT: // GET TeXT hunk of RESOURCES
  //Obliq. part
  default: println("Server received from",player.name,"UNKNOWN MESSAGE TYPE:",msg.charAt(0));break;
  case OpCd.EOR: println("Server received empty record from",player.name); break;
  case OpCd.HEL: 
  case OpCd.IAM: // SHOULD NOT APPEAR WHEN REGULAR MESSAGE LOOP IS ACTIVE!
      println("Server received from",player.name,"UNEXPECTED MESSAGE TYPE:",msg.charAt(0));break;
  //Normal interactions
  case OpCd.UPD: 
                  wholeUpdateRequested=true; 
                break;
  case OpCd.NAV:{ String direction=decodeOptAndInf(msg);     
                  playerMove(direction,player);
                  player.flags|=Masks.MOVED;
                } break;
  case OpCd.ACT:{ String action=decodeOptAndInf(msg);     
                  playerAction(action,player);
                } break;
  } //END OF MESSAGE TYPES SWITCH
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  Partly sponsored by the EU project "GuestXR" (https://guestxr.eu/)
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - TCP/IP GAME TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////////////////

