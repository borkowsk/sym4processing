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
  text(clients.length,0,0);//Displays how many clients have connected to the server
  
  for (int i = 0; i < clients.length; i++)
  if(clients[i]!=null &&  clients[i].available()>0)
  {
        if(DEBUG>0) print("Server is reciving from",names[i],":");
        String msg = clients[i].readStringUntil(Opts.NOPE);
        if(DEBUG>0) println(msg);
        //interpretMessage(msg,i);
  }
  
  visualise2D(0,0,width,height);
  
  fill(255,0,255);
  for (int i = 0; i < clients.length; i++)
  if(clients[i]!=null && clients[i].active())
  {
    val[i] = (val[i]+1)%255;//changes the value based on which client number it has (the higher client number, the fast it changes).
    String msg=sayPosition(Opts.EUC,Opts.sYOU,val[i]);
    clients[i].write(msg);//writes to the right client (using the byte type is not necessary)
    text(names[i]+": "+val[i], width/2., height/2.+15*(i+1));
  }
}
