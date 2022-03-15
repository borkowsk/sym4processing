class singiel
{
  float x1,x2;
  float r;
  float alfa;
  singiel(float iX,float iR,float iAlfa)
  {
    x1=x2=iX;r=iR;alfa=iAlfa;
  }
  void next() //Bez pary
  {
    x1=x2;
    x2=x1*r*(1-x1);
  }
}

singiel First;

void setup()
{
  size(1800,200);
  First=new singiel(random(1000)/1000.0,3.5+random(500)/1000.0,0.5);
  ellipseMode(CENTER); 
  println(First.x1+" "+First.r+" "+First.alfa);
}

int radius=50;
int pos=radius;
void draw()
{
  ellipse(pos,100,round(First.x1*radius),round(First.x2*radius));
  First.next();
  pos+=radius/2;
}
