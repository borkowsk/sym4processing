//https://forum.processing.org/two/discussion/26317/pixeldensity-not-working-with-exported-application

void setup()
{
  size(400, 400);
  background(128,0,128);
  
  println("displayDensity:",displayDensity());
  pixelDensity(1);//1 or 2, expecially for "Retina"
 
  rectMode(CENTER);
}
 
void draw()
{
  rect(width/2, height/2, 150, 150);
}
