float initialMaxX=100;
float initialMaxY=100;

void initialiseGame()
{
  mainGameArray=new GameObject[initialSizeOfMainArray];
  for(int i=0;i<initialSizeOfMainArray;i++)
  {
    GameObject tmp=new GameObject("O"+nf(i,2),random(initialMaxX),random(initialMaxY),0);
    tmp.visual="@";
    mainGameArray[i]=tmp;
  }
}

void serverGameDraw()
{
  background(0);fill(255);
  textAlign(LEFT,TOP);
  text(players.length,0,0);//Displays how many clients have connected to the server
  
  for (int i = 0; i < players.length; i++)
  if(players[i]!=null 
  && players[i].netLink !=null
  && players[i].netLink.available()>0)
  {
        if(DEBUG>0) print("Server is reciving from",players[i].name,":");
        String msg = players[i].netLink.readStringUntil(Opts.NOPE);
        if(DEBUG>0) println(msg);
        //interpretMessage(msg,i);
  }
  
  visualise2D(0,0,width,height);
  
  fill(255,0,255);
  for (int i = 0; i < players.length; i++)
  if(players[i]!=null 
  && players[i].netLink !=null
  && players[i].netLink.active())
  {
    players[i].X = (players[i].X+1)%255;//changes the value based on which client number it has (the higher client number, the fast it changes).
    String msg=sayPosition(Opts.EUC,Opts.sYOU,players[i].X);
    players[i].netLink.write(msg);//writes to the right client (using the byte type is not necessary)
    text(players[i].name+": "+players[i].X, width/2., height/2.+15*(i+1));
  }
}
