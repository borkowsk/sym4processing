/*void setup() {
  size(500,500);
  background(0,0,200);
  frameRate(100);
  noSmooth();
  ellipse(250,250,width,height);
  surface.setResizable(true);
}

int i=0;
int j=0;
float pos=0;
int a=0;


void draw() 
{
  point(random(width),random(height));
  
  
  
  //background(210,300,210);
  pos=random(500);
  //strokeWeight(4);
  line(pos,0,pos,height);
  a+=2;
  line(a,0,a,height);
  if (a>width) 
  {
    a=0;
  }

  if (i>255)
  {
    i=0;
  }
  fill(0,i % 256,0);
  arc(width/2,height/2,width,height, radians(j-10), radians(j));
  j+=5;
  i+=5;
}


void keyPressed() {
 surface.setSize(round(random(200,500)),
                 round(random(200,500)));
}
*/









float FR=50;
float vh=200;//prędkość
float vx=100;
float maxV=100;
float h=0;
float x=0;
float count=0;

float B=1.00; //wydajność odbicia sprężystego

void setup()
{
  size(500,500);
  noSmooth();
  surface.setResizable(true);
  frameRate(FR);
}



void draw()
{
  if(floor(random(FR))==0)
  {
    vh=random(-maxV,maxV);
    vx=random(-maxV,maxV);
    fill(random(250),random(250),0);
    stroke(random(250),random(250),0);
    strokeWeight(4);
  }
  
 // background (0,0,200);
  //ellipse(random(3*width/7,4*width/7),height-h,width/20,height/20);
  ellipse(x,height-h,width/20,height/20);
  //vh+=ah*1/FR;
  h+=vh*1/FR;
  x+=vx*1/FR;
  
  //fill(x,h,random(x+h));
  
  
 
  
  
  count++;
  if(count % FR==0)
  {
    vh=random(-maxV,maxV);
    vx=random(-maxV,maxV);
  }

  if(h<0)
  {
  vh=-vh*B; h=0;
  }
  else
  if(height<h)
  {
    vh=-vh*B;    h=height;
  }
  else
  if(x<0)
  {
    vx=-vx*B; x=0;
  }
  else
  if(width<x)
  {
    vx=-vx*B; x= width;
  }
}