
import ddf.minim.*;

Minim minim;
AudioInput in;
AudioRecorder fout;

PImage img;
int smallPoint, largePoint;

//boolean sketchFullScreen() { //Nie w Processingu 3.0
//  return false;//true;
//}

void setup() {
 //size(1024, 1024);
 fullScreen();
 //size(displayWidth, displayHeight);//Nie w Processingu 3.0

  minim = new Minim(this);
  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn(Minim.STEREO, 256);//512
  // uncomment this line to *hear* what is being monitored, in addition to seeing it
  in.enableMonitoring();
  //fout = minim.createRecorder(in, "myrecording.wav", true); //NIE DZIAŁA
  
  img = loadImage("ObazNr110.bmp");
  smallPoint = 4;
  largePoint = 40;
  imageMode(CENTER);
  noStroke();
  background(0);
}

void draw() {
  for(int i = 0; i < in.bufferSize() - 1; i++) {
    //ellipse(20,20,in.left.get(i)*200,in.left.get(i+1)*200);
    //ellipse(320,20,in.right.get(i)*200,in.right.get(i+1)*200);
    if((in.left.get(i)*200+in.left.get(i+1)*200/2) > 0){
      
      float pointillize = (in.left.get(i)*200+in.left.get(i+1)*200);
      
      int x = int(random(img.width));
      int y = int(random(img.height));
      color pix = img.get(x, y);
      fill(pix, 128);
      ellipse(x, y, pointillize, pointillize);
    }
  }
}

void stop()
{
  print("STOP");
  fout.save();
  // always close audio I/O classes
  in.close();
 // fout.close();
  // always stop your Minim object
  minim.stop();
 
  super.exit();
}
