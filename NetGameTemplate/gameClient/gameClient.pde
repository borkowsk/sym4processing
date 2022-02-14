//*  Client for multServer
//*////////////////////////
//My particular client code is basically just a copy of the example (which helps demonstrate that each client is indeed getting its own data):
//https://forum.processing.org/one/topic/how-do-i-send-data-to-only-one-client-using-the-network-library.html
import processing.net.*;

String  serverIP="127.0.0.1";
int     servPORT=5204;
Client  myClient=null;

int dataIn;//data buffer
    
void setup() 
{
  //long pid = ProcessHandle.current().pid();//JAVA9 :-(
  size(200, 200);
  //First attempt
  myClient = new Client(this,serverIP,servPORT);
  if(!myClient.active())
    myClient=null;
  else println(myClient);
}
    
void draw() 
{
  background(dataIn);
  textAlign(CENTER);         
  text(nf(frameRate,2,2)+"fps",width/2.,height);

  if(myClient==null || !myClient.active() )
  {
    text("Not connected", width/2., height/2.);
    if(frameRate>2) frameRate(2);//Nie ma już sensu często
    //Next attempt
    myClient = new Client(this,serverIP,servPORT);
    if(!myClient.active())
      myClient=null;
    else
    {
      println(myClient,"connected!");
      frameRate(60);
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
}
    
// ClientEvent message is generated when a client disconnects.
void disconnectEvent(Client someClient) 
{
  background(0);
  print(someClient,"Server disconnected? ");
  //myClient=null;
}
