import processing.net.*;
Server myServer;
int val = 0;

void setup() {
  size(200, 200);
  // Starts a myServer on port 5204
  myServer = new Server(this, 5204); 
  frameRate(20);
}

void draw() {
  val = (val + 1) % 255;
  myServer.write(val);
  background(val);
  //fill(255-val);
  text(" "+val,10,10);
}

