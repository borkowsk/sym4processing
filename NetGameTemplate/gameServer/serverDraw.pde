int Xmargin=0;
float initialMaxX=100;
float initialMaxY=100;

void initialiseGame()
{
  mainGameArray=new GameObject[initialSizeOfMainArray];
  for(int i=0;i<initialSizeOfMainArray;i++)
  {
    GameObject tmp=new GameObject("o"+nf(i,2),int(random(initialMaxX)),int(random(initialMaxY)),0);
    tmp.visual="#";
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
    mainServer.write(msg);
  }
  
  loop();
}

boolean wholeUpdateRequested=false;
void interpretMessage(String msg,Player player)
{
  switch(msg.charAt(0)){
  //Obliq. part
  default: println("Server recived UNKNOWN MESSAGE TYPE:",msg.charAt(0));break;
  case Opts.NOPE: if(DEBUG>0) println("Server recived NOPE");break;
  case Opts.HELLO:
  case Opts.IAM: println("Server recived ENEXPECTED MESSAGE TYPE:",msg.charAt(0));break;
  //Normal interactions
  case Opts.UPD: wholeUpdateRequested=true;break;
  }//END OF MESSAGE TYPES SWITCH
}

void serverGameDraw()
{
  background(0);
  fill(255,0,255);textAlign(LEFT,TOP);
  text(players.length,0,0);//Displays how many clients have connected to the server
  
  for (int i = 0; i < players.length; i++)
  if(players[i]!=null 
  && players[i].netLink !=null
  && players[i].netLink.available()>0)
  {
        if(DEBUG>0) print("Server is reciving from",players[i].name,":");
        String msg = players[i].netLink.readStringUntil(Opts.NOPE);
        if(DEBUG>0) println(msg);
        interpretMessage(msg,players[i]);
  }
  
  visualise2D(Xmargin,0,width-Xmargin,height);
  
  if(wholeUpdateRequested)//If any client requested update
  {
      sendWholeUpdate();
      wholeUpdateRequested=false;
  }
  
  fill(255,0,255);textAlign(LEFT,TOP);
  for (int i = 0; i < players.length; i++)
  if(players[i]!=null 
  && players[i].netLink !=null
  && players[i].netLink.active())
  {
    players[i].X = (players[i].X+1)%255;//changes the value based on which client number it has (the higher client number, the fast it changes).
    String msg=sayPosition(Opts.EUC,Opts.sYOU,players[i].X,players[i].Y);
    players[i].netLink.write(msg);//writes to the right client (using the byte type is not necessary)
    text(players[i].name+": "+players[i].X,0, height/2.+15*(i+1));
  }
}
