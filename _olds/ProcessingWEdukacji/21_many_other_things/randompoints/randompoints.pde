
void setup()
{
  background(0);
  size(1000,1000);
  frameRate(1000);
}

int i=0;
void draw()
{
  stroke(random(255),random(255),random(255));
  point(random(width),random(height));
  i++;
  if(i%1000==0)//Co tysiąc
    println(i,' ',frameCount);//Ile klatek udało się już wyświetlić 
                              //wg. licznika processingu
}
