import ddf.minim.*;
 
Minim minim;
AudioInput in;
AudioRecorder fout;

int winwidth=1000;
int winheigh=500;
 
void setup()
{
  winwidth=displayWidth;
  winheigh=displayHeight;
  size(winwidth,winheigh);
  frameRate(1);// 1/s
 
  minim = new Minim(this);
 
  // get a stereo line-in: sample buffer length of 512
  // default sample rate is 44100, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 2048);
  // get a recorder that will record from in to the 
  // filename specified using buffered recording
  fout = minim.createRecorder(in, "myrecording.wav", true);
  fout.beginRecord();
}
 
int maxtime=10;
int curstep=0;

boolean sketchFullScreen() {
  return true;
}


void draw()
{
  // do whatever you're going to do
  curstep++;
  fill(255,255,255);
  rect(winwidth/3,winheigh/7*3-3,winwidth/3,winheigh/7+6);
  fill((int)(255*curstep/((double)maxtime)),0,0);
  rect(winwidth/3,winheigh/7*3,(curstep*winwidth)/(3*maxtime),winheigh/7);
  if(curstep>maxtime)
  {
    noLoop();
    stop();
    super.exit();
  }
}
 
void keyReleased()
{
  // maybe set up keybindings to stop recording
  // and then save to disk
   noLoop();
   stop();
   super.exit();
}
 
void stop() //NIE WYWOŁUJE SIĘ AUTOMATYCZNIE, A CHYBA TAKI BYŁ ZAMYSŁ W PRZYKŁADZIE
{
  print("STOP");
  // shoud save recorded speech
  fout.endRecord(); 
  fout.save(); //NIBY ZAPISUJE, ale nie wszystkie programy to odczytuja
  
  // always close audio I/O classes
  in.close();
  // always stop your Minim object
  minim.stop();

  super.stop();
}
