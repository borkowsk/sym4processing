//Animacja lini z if

void setup() {
  size(300,130);
  frameRate(25);
}

int pos = 0;

void draw() 
{
  background(204);
  pos++;
  line(pos, 20, pos, height-20 );
  
  if (pos > width) 
  {
    pos = 0;
  }
}

//http://processingwedukacji.blogspot.com/2016/10/
