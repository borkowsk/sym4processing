void setup()
{
  size(600,300);
  background(0,0,50);
  //STARS
  for(int i=0;i<2000;i+=10) //POWTARZAJ
  {
    float R=random(255);
    float G=random(255);
    float B=random(255);
    stroke(R,G,B);
    point(random(width),random(height));
  }
}

void draw()
{
  //side A
  int topX=width/2;
  int topY=height/2;
  float fR=random(1);
  float fG=random(1);
  float fB=random(1);
  for(int i=0;i<100;i++)
  {
    stroke(fR*i,fG*i,fB*i);
    line(topX,topY,topX-100+i,topY+i/2);
  }
  for(int i=0;i<100;i++)
  {
    stroke(0,0,i);
    line(topX,topY,topX+100-i,topY+i/2);
  }
  for(int i=0;i<100;i++)
  {
    stroke(100-i,100-i,0);
    line(topX,topY,topX-100+i,topY-i/2);
  }
  for(int i=0;i<100;i++)
  {
     stroke(100-i,0,100-i);
    line(topX,topY,topX+100-i,topY-i/2);
  }
}