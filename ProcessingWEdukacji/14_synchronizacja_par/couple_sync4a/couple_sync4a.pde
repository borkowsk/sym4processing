// Synchronizacja w parze dwu iteracji równania logistycznego 
/////////////////////////////////////////////////////////////////////
static float DefaultAlfa=0.20000000000;//Siła symetrycznego związku

//Parametry wizualizacji
static boolean Clean=true; //Czy czyścić poprzedni stan
static boolean Continuous=true; //Czy morfować pośrednie stany ("oszustwo" dla tego modelu!)
static int  VISUAL=20; //Co ile klatek liczymy nowy stan?

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
float xfo,xso;//Przed poprzednie stany - do wizualizacji "continous"

void setup()
{
  frameRate(200);
  //noSmooth();
  background(128);
  size(1600,600);
  First=new singiel(random(1000)/1000.0,3.5+random(500)/1000.0,DefaultAlfa);
  Second=new singiel(random(1000)/1000.0,3.5+random(500)/1000.0,DefaultAlfa);
  xfo=First.getX1();
  xso=Second.getX1();
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
  rectMode(CENTER); 
}

void draw()
{
  stroke(0);
  if(Clean)
  {
     fill(128);
     noStroke();
     rect(pos  ,vert,radius+3,radius+3);
     rect(pos*3,vert,radius+3,radius+3);
  }
  
  if(Continuous)
  {
    //noStroke();
    fill(0,160,120);
    float pp=(float)viscounter/VISUAL;
    float af=pp*(First.getX1()-xfo);
    float bf=pp*(First.getX2()-First.getX1());
    //println("pp:"+pp+" A:"+round((xfo+af)*radius)+" B:"+round((First.getX1()+bf)*radius)+" af:"+af+" bf:"+bf);
    ellipse(pos  ,vert,round((xfo+af)*radius),round((First.getX1()+bf)*radius));
    af=pp*(Second.getX1()-xso);
    bf=pp*(Second.getX2()-Second.getX1());
    ellipse(pos*3,vert,round((xso+af)*radius),round((Second.getX1()+bf)*radius));
  }
  else
  {
   if(stecounter%2==0)
     fill(0,150+viscounter*5,100+viscounter*10);
    else
     fill(0,100+viscounter*10,150+viscounter*5);
   ellipse(pos  ,vert,round(First.getX1()*radius),round(First.getX2()*radius));
   ellipse(pos*3,vert,round(Second.getX1()*radius),round(Second.getX2()*radius));
  }
  
  if(++viscounter==VISUAL)
  { 
   xfo=First.getX1();//Stany przed-poprzednie
   xso=Second.getX1();//Do wizualizacji ciągłej
   next4couple(First,Second);
   //println("x:"+xfo+" "+First.getX1()+" "+First.getX2());
   stroke(30+stecounter,30+stecounter/2,stecounter/4);
   point(pos*1.5+pos*First.getX2(),vert+radius/2-pos*Second.getX2());
   viscounter=0;
   stecounter++;
  }
  
}