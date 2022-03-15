static float DefaultAlfa=0.33;

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

  void next4couple(singiel F,singiel S)
  {
    F.x2=F.x2*(1-F.alfa)+S.x2*F.alfa;
    S.x2=S.x2*(1-S.alfa)+F.x2*S.alfa;
    F.next();
    S.next();
  }

singiel First,Second;

void setup()
{
  size(800,300);
  First=new singiel(random(1000)/1000.0,3.5+random(500)/1000.0,DefaultAlfa);
  Second=new singiel(random(1000)/1000.0,3.5+random(500)/1000.0,DefaultAlfa);
  ellipseMode(CENTER); 
  println(First.x1+" "+First.r+" "+First.alfa);
  println(Second.x1+" "+Second.r+" "+Second.alfa);
}

int radius=200;
int pos=radius;
int counter=0;

void draw()
{
  point(pos,150);
  point(pos*3,150);
  stroke(0);
  fill(100+counter*10);
  
  ellipse(pos  ,150,round(First.x1*radius),round(First.x2*radius));
  
  ellipse(pos*3,150,round(Second.x1*radius),round(Second.x2*radius));
  
  if(++counter==2)
  { 
   //First.next();
   //Second.next();
   next4couple(First,Second);
   stroke(255,0,0);
   point(pos*1.5+pos*First.x2,150+radius/2-pos*Second.x2);
   counter=0;
  }
}
