void setup()
{
  size(600,300);
  background(0,0,50);
  frameRate(16);
  //STARS
  for(int i=0;i<250;i+=1) //POWTARZAJ
  {
    float R=random(255);
    float G=random(255);
    float B=random(255);
    stroke(R,G,B);
    point(random(width),random(height));
  }
}

int SIZE=2;

void draw()
{
  //side A
  int topX=width/2;
  int topY=height/2;
  float fR=random(1);
  float fG=random(1);
  float fB=random(1);
  for(int i=0;i<SIZE;i++)
  {
    stroke(fR*min(i,255),fG*min(i,255),fB*min(i,255));
    line(topX,topY,topX-SIZE+i,topY+i/2);
  }
  fR=random(1);
  fG=random(1);
  fB=random(1);
  for(int i=0;i<SIZE;i++)
  {
    stroke(fR*min(i,255),fG*min(i,255),fB*min(i,255));
    line(topX,topY,topX+SIZE-i,topY+i/2);
  }
  fR=random(1);
  fG=random(1);
  fB=random(1);
  for(int i=0;i<SIZE;i++)
  {
    stroke(100-fR*min(i,255),100-fG*min(i,255),100-fB*min(i,255));
    line(topX,topY,topX-SIZE+i,topY-i/2);
  }
  fR=random(1);
  fG=random(1);
  fB=random(1);
  for(int i=0;i<SIZE;i++)
  {
    stroke(100-fR*i,100-fG*i,100-fB*i);
    line(topX,topY,topX+SIZE-i,topY-i/2);
  }
  SIZE++;
  if(SIZE>height) 
    SIZE=height;
}
