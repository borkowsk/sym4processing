static float DefaultAlfa=0.250000000000;

class singiel
{
  double x1,x2;
  double r;
  double alfa;
  float getX1(){ return (float)x1;}
  float getX2(){ return (float)x2;}  
  
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

int radius=400;
int pos=radius;
int viscounter=0;
int stecounter=0;
int vert=300;


void setup()
{
  frameRate(60);
  background(128);
  size(1600,600);
  First=new singiel(random(1000)/1000.0,3.5+random(500)/1000.0,DefaultAlfa);
  Second=new singiel(random(1000)/1000.0,3.5+random(500)/1000.0,DefaultAlfa);
  ellipseMode(CENTER); 
  println(First.x1+" "+First.r+" "+First.alfa);
  println(Second.x1+" "+Second.r+" "+Second.alfa);
  textSize(20);
  textAlign(CENTER);
  text("r="+First.r,pos,20);
  text("r="+Second.r,pos*3,20);
  text("alfa="+DefaultAlfa,pos*2,20);
  fill(0);
  stroke(64);
  rect(pos*1.5,vert-radius/2,pos,pos);
}

void draw()
{
  stroke(0);
  if(stecounter%2==0)
    fill(0,150+viscounter*5,100+viscounter*10);
   else
    fill(0,100+viscounter*10,150+viscounter*5);
  
  ellipse(pos  ,vert,round(First.getX1()*radius),round(First.getX2()*radius));
  
  ellipse(pos*3,vert,round(Second.getX1()*radius),round(Second.getX2()*radius));
  
  if(++viscounter==2)
  { 
   //First.next();
   //Second.next();
   next4couple(First,Second);
   stroke(30+stecounter,30+stecounter/2,stecounter/4);
   point(pos*1.5+pos*First.getX2(),vert+radius/2-pos*Second.getX2());
   viscounter=0;
   stecounter++;
  }
  
}
