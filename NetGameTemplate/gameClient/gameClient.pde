//*  Client for gameServer
//*////////////////////////
//My particular client code is basically just a copy of the example (which helps demonstrate that each client is indeed getting its own data):
//https://forum.processing.org/one/topic/how-do-i-send-data-to-only-one-client-using-the-network-library.html
import processing.net.*;
//long pid = ProcessHandle.current().pid();//JAVA9 :-(

int DEBUG=3;//Level of debug logging

String  playerName="";//ASCII IDENTIFIER!

Client  myClient=null;

int dataIn;//data buffer
    
void setup() 
{
  size(200, 200);
  loadName();
  println("PLAYER:",playerName);
  println("Expected server IP:",serverIP,"\nExpected server PORT:",servPORT);
  frameRate(1);
}

void drawStartUpInfo()
{
   textAlign(CENTER,CENTER);
   fill(random(255),random(255),random(255));
   text("PLAYER: "+playerName,width/2,height/2);   
}

//Próba połączenia i wstępnej komunikacji
void drawTryConnect()
{
   fill(random(255),random(255),random(255));
   text("Not connected", width/2., height/2.);
   
   myClient = new Client(this,serverIP,servPORT);
   if(!myClient.active())
   {
      if(DEBUG>0) println(playerName," still not connected!");
      myClient=null;
   }
   else
   {
      println(myClient,"connected!");
      String msg=sayHELLO(playerName);
      if(DEBUG>0) println(playerName,"is SENDING",msg);
      myClient.write(msg);
      
      while(myClient.available() <= 0) delay(10);
      
      if(DEBUG>0) print(playerName,"is READING FROM SERVER:");
      msg=myClient.readString();
      if(DEBUG>0) println(msg);
      
      String serverType=decodeHELLO(msg);
      if(serverType.equals(Opts.name) )
      {
        frameRate(60);//Udało się, zasuwamy!
      }
      else
      {
        println("Protocol mismatch: '"
                +serverType+"'<>'"+Opts.name+"'");
        myClient.stop();
        exit();
      }
   }
}
    
void draw() 
{
  background(128);
 
  if(frameCount<5)
  {
       drawStartUpInfo(); 
  }
  else
  if(myClient==null || !myClient.active() )
  {
      drawTryConnect();
  }
  else
  {
      clientDraw();
  }
  
  textAlign(CENTER,BOTTOM);
  text(nf(frameRate,2,2)+"fps",width/2.,height);
}
    
// ClientEvent message is generated when a client disconnects.
void disconnectEvent(Client someClient) 
{
  background(0);
  print(playerName,"Server disconnected? ");
  myClient=null;
}

// Loads the player's name from the file "player.txt"
void loadName()
{
  BufferedReader reader=createReader("player.txt");
  try {
    playerName = reader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    playerName = "Unknown_player";
  }
  //reader.close();//Exception?
}
