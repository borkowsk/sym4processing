import processing.net.*; 
Client myClient; 
int dataIn; 
 
void setup() { 
  size(200, 200); 
  // Connect to the local machine at port 5204.
  // This example will not run if you haven't
  // previously started a server on this port.
  myClient = new Client(this, "127.0.0.1", 5204); 
  frameRate(20); 
} 
 
void draw() { 
  while (myClient.available() > 0) { 
    dataIn = myClient.read(); 
    background(dataIn); 
    //println(dataIn);
    text(" "+dataIn,10,10);
  } 

} 

