//https://processing.org/reference/setResizable_.html
//Resize sometimes works, sometimes not! 
void setup() {
  size(200, 200);
  //frameRate(1000);
  noLoop();
  surface.setTitle("Hello World!");
  surface.setResizable(true);//Sometimes it works, sometimes not! :-/ On UBUNTU mostly not :-(
  surface.setLocation(100, 100);
  loop();
}

void mousePressed() {
  println("Mouse pressed!");
  surface.setSize(width+1, height+1);
  redraw();
  println(frameCount,width,height);
}

void draw() {
  background(255);
  stroke(random(255),random(255),0);
  line(0, 0, width, height);
  line(width, 0, 0, height); 
  //println(frameCount,width,height);
}
