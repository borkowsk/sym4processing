//Animacja lini  

void setup() {
  frameRate(16);
  size(300,100);
}

int pos = 0;

void draw() 
{
  background(204);
  pos++;
  line(pos, 20, pos, 80);
}
