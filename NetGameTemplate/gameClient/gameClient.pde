//*  Client for gameServer
//*////////////////////////
//My particular client code is basically just a copy of the example (which helps demonstrate that each client is indeed getting its own data):
//https://forum.processing.org/one/topic/how-do-i-send-data-to-only-one-client-using-the-network-library.html
import processing.net.*;
//long pid = ProcessHandle.current().pid();//JAVA9 :-(

String  playerName="";

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
    
void draw() 
{
  background(128);
 
  if(frameCount<5)
  {
    textAlign(CENTER,CENTER);
    fill(random(255),random(255),random(255));
    text("PLAYER: "+playerName,width/2,height/2);        
  }
  else
  if(myClient==null || !myClient.active() )
  {
    fill(random(255),random(255),random(255));
    text("Not connected", width/2., height/2.);
    
    //Next attempt
    myClient = new Client(this,serverIP,servPORT);
    if(!myClient.active())
      myClient=null;
    else
    {
      println(myClient,"connected!");
      frameRate(60);//Udało się, zasuwamy!
    }
  }
  else
  {
    // you can replace #clientNumber with whatever number you wish
    text(myClient+"\n recived "+int(dataIn), width/2., height/2.);
          
    fill(255,0,0);
    for(int i = 0; true; i++)
    {
      if (myClient.available() > 0) 
      {
        dataIn = myClient.read();
        //println(dataIn);
      }
      else
      break;
    }
  }
  
  textAlign(CENTER,BOTTOM);
  text(nf(frameRate,2,2)+"fps",width/2.,height);
}
    
// ClientEvent message is generated when a client disconnects.
void disconnectEvent(Client someClient) 
{
  background(0);
  print(someClient,"Server disconnected? ");
  //myClient=null;
}

// Loads the player's name from the file "player.txt"
void loadName()
{
  BufferedReader reader=createReader("player.txt");
  try {
    playerName = reader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    playerName = "Unknown player";
  }
  //reader.close();//Exception?
}
