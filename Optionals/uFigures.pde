/// @file uFigures.pde
/// Various shapes drawing procedures.
/// @date 2023.03.07 (Last modification)
//*//////////////////////////////////////////////////////////////

/// Horizontal view of a bald head of a man seen from above.
void baldhead_hor(float x,float y,float r,float direction)         ///< @note Global namespace!
{
  float D=2*r;
  float xn=x+r*cos(direction);
  float yn=y+r*sin(direction);
  ellipse(xn,yn,D/5,D/5);  //Nos
  
  xn=x+0.95*r*cos(direction+PI/2);
  yn=y+0.95*r*sin(direction+PI/2);
  ellipse(xn,yn,D/4,D/4);  //Ucho  1
  
  xn=x+0.95*r*cos(direction-PI/2);
  yn=y+0.95*r*sin(direction-PI/2);
  ellipse(xn,yn,D/4,D/4);  //Ucho  2
  
  //Glówny blok
  ellipse(x,y,D,D);
  
  for(int i=0;i<=10;i++)
  {
      float angle=PI/2+PI/10*i;
      xn=x+0.75*r*cos(angle+direction);
      yn=y+0.75*r*sin(angle+direction);
      float xm=x+0.35*r*cos(angle+direction);
      float ym=y+0.35*r*sin(angle+direction);
      line(xm,ym,xn,yn);
  }
  
  //OCZY
  fill(200);
  xn=x+0.75*r*cos(direction+PI/5);
  yn=y+0.75*r*sin(direction+PI/5);
  arc(xn,yn,D/5,D/5,-PI/2+direction,PI/2+direction,CHORD);  //Oko  1
  
  fill(0);
  xn=x+0.84*r*cos(direction+PI/6);
  yn=y+0.84*r*sin(direction+PI/6);  
  ellipse(xn,yn,D/12,D/12);
  
  fill(200);
  xn=x+0.75*r*cos(direction-PI/5);
  yn=y+0.75*r*sin(direction-PI/5);
  arc(xn,yn,D/5,D/5,-PI/2+direction,PI/2+direction,CHORD);  //Oko  2
  
  fill(0);
  xn=x+0.84*r*cos(direction-PI/6);
  yn=y+0.84*r*sin(direction-PI/6);
  ellipse(xn,yn,D/12,D/12);
}

/// Vertical view on agava plant.
void agava_ver(float x,float y,float visual_size,float num_of_leafs)    ///< @note Global namespace!
{
  float lstep=PI/(num_of_leafs);
  
  for(float angle=PI+lstep/2;angle<2*PI;angle+=lstep)
  {
    float x2=x+cos(angle)*visual_size/2;
    float y2=y+sin(angle)*visual_size/2;
    triangle(x-visual_size/8,y,x+visual_size/8,y,x2,y2);
    line(x,y,x2,y2);
  }
  
  arc(x,y,visual_size/4,visual_size/4,PI,2*PI,PIE);
}

/// Horizontal view on agava plant.
void agava_hor(float x,float y,float visual_size,float num_of_leafs)      ///< @note Global namespace!
{
  float lstep=(2*PI) / min(num_of_leafs,3)+PI/5;
  float maxan=lstep*num_of_leafs;
  
  for(float angle=lstep/2;angle<=maxan;angle+=lstep)
  {
    visual_size*=0.966;
    float x0=x+cos(angle+PI/2)*visual_size/8;
    float y0=y+sin(angle+PI/2)*visual_size/8;
    float x1=x+cos(angle-PI/2)*visual_size/8;
    float y1=y+sin(angle-PI/2)*visual_size/8;    
    float x2=x+cos(angle)*visual_size/2;
    float y2=y+sin(angle)*visual_size/2;
    triangle(x0,y0,x1,y1,x2,y2);
    line(x,y,x2,y2);
  }
  
  ellipse(x,y,visual_size/4,visual_size/4); //,PI,2*PI,PIE);
  ellipse(x,y,1,1);
}


/// Vertical view of simple droid.
void gas_bottle_droid_ver(float x,float y,float visual_size,float direction)      ///< @note Global namespace!
{
  rect(x-visual_size/4, y-visual_size,     visual_size/2,   visual_size-3*visual_size/5,   visual_size/10); //Głowa
  rect(x-visual_size/3, y-3*visual_size/5, 2*visual_size/3, 3*visual_size/5-visual_size/10,visual_size/10); //Tułów
  rect(x-visual_size/4, y-visual_size/10,  visual_size/2,   visual_size/10);  //Stopy
  
  if(-.25*PI<=direction && direction<=PI*1.25) //Przód
  {
    float rotx=x+cos(direction)*visual_size/4.;
    float rots=visual_size/8.*sin(direction);

    fill(200);
    arc(rotx,y-visual_size+visual_size/5.,rots,visual_size/10.,1. / 2.0*PI,6.0/4.0*PI,PIE); //nos lewo
    arc(rotx,y-visual_size+visual_size/5.,rots,visual_size/10.,6. / 4.0*PI,2.5*PI,PIE); //nos prawo
        
    float lefte=(direction - PI/4 >0  ? x+cos(direction-PI/4)*visual_size/4 : x + visual_size/4);
    float rigte=(direction + PI/4 <PI ? x+cos(direction+PI/4)*visual_size/4 : x-visual_size/4);
    
    stroke(64,0,0);
    line(lefte,y-visual_size+visual_size/5+visual_size/10,rigte,y-visual_size+visual_size/5+visual_size/10); //usta
    stroke(0,0,64);
    line(lefte,y-visual_size+visual_size/16,lefte,y-visual_size+visual_size/8); //jego lewe oko
    line(rigte,y-visual_size+visual_size/16,rigte,y-visual_size+visual_size/8); //jego prawe oko
    
    float lefth=(direction - PI/4 >0  ? x+cos(direction-PI/4)*visual_size/3 : x + visual_size/3);
    float lefts=(direction - PI/5 >0  ? x+cos(direction-PI/5)*visual_size/3 : x + visual_size/3);
    float rigth=(direction + PI/4 <PI ? x+cos(direction+PI/4)*visual_size/3 : x - visual_size/3);
    float rigts=(direction + PI/5 <PI ? x+cos(direction+PI/5)*visual_size/3 : x - visual_size/3);
    
    stroke(0);
    triangle(lefts,y-3*visual_size/5+visual_size/8,lefth,y-3*visual_size/5+visual_size/8,lefth,y-3*visual_size/5+visual_size/3); //jego lewa ręka
    triangle(rigts,y-3*visual_size/5+visual_size/8,rigth,y-3*visual_size/5+visual_size/8,rigth,y-3*visual_size/5+visual_size/3); //jego prawa ręka
  }
  
  if(PI<=direction && direction<=2*PI)
  {
    float leftb=x+cos(direction+PI-PI/10)*visual_size/3; //(direction+PI - PI/4 >0  ? x+cos(direction+PI-PI/4)*visual_size/3 : x + visual_size/3);
    float rigtb=x+cos(direction+PI+PI/10)*visual_size/3; 
    
    fill(64);
    quad(leftb, y-3*visual_size/5+visual_size/8, 
         rigtb, y-3*visual_size/5+visual_size/8,
         rigtb, y-3*visual_size/5+visual_size/4, 
         leftb, y-3*visual_size/5+visual_size/4); 
       
    fill(110);
    leftb=x+cos(direction+PI-PI/10)*visual_size/4;     
    rigtb=x+cos(direction+PI+PI/10)*visual_size/4;
    quad(leftb, y-visual_size+visual_size/8, 
         rigtb, y-visual_size+visual_size/8,
         rigtb, y-visual_size+visual_size/5, 
         leftb, y-visual_size+visual_size/5); 
  }
  
  if(0<=direction && direction<=PI)
  {
    float rotx=x+cos(direction)*visual_size/4.;
    float rots=visual_size/8.*sin(direction);
    fill(0);
    triangle(rotx-rots/2,y-visual_size/10,rotx+rots/2,y-visual_size/10,rotx,y-1);  // granica stóp
  }
  else //Tył
  {
    float rotx0=x+cos(direction+PI)*visual_size/4;
    float rots=visual_size/8.*sin(direction+PI);
    fill(128);
    triangle(rotx0-rots/2,y,rotx0+rots/2,y,rotx0,y-visual_size/10+1);  // granica stóp
  }
  
}

//*
/// ARROW IN ANY DIRECTION
//*
//*////////////////////////////////////////

float def_arrow_size=15;                   ///< Default size of arrows heads
float def_arrow_theta=PI/6.0+PI;           ///< Default arrowhead spacing //3.6651914291881

/// Function that draws an arrow with default settings.
void arrow(float x1,float y1,float x2,float y2)                          ///< @note Global namespace!
{
  arrow_d(int(x1),int(y1),int(x2),int(y2),def_arrow_size,def_arrow_theta);
}

/// Function that draws an arrow with changable settings.
void arrow_d(int x1,int y1,int x2,int y2,float size,float theta)          ///< @note Global namespace!
{
  // CALCULATION METHOD FROM ROTATION OF THE ARROW AXIS
  float A=(size>=1 ? size : size * sqrt( (x1-x2)*(x1-x2)+(y1-y2)*(y1-y2) ));
  float poY=float(y2-y1);
  float poX=float(x2-x1);

  if(poY==0 && poX==0)
  {
    // Rare error, but big problem
    float cross_width=def_arrow_size/2;
    line(x1-cross_width,y1,x1+cross_width,y1);
    line(x1,y1-cross_width,x1,y1+cross_width);
    ellipse(x1+def_arrow_size/sqrt(2.0),y1-def_arrow_size/sqrt(2.0)+1,
            def_arrow_size,def_arrow_size);
    return;
  }
                                            assert(!(poY==0 && poX==0));
  float alfa=atan2(poY,poX);                if(abs(alfa)>PI+0.0000001)
                                                 println("Alfa=%e\n",alfa);
                                          //assert(fabs(alfa)<=M_PI); //cerr<<alfa<<endl;
  float xo1=A*cos(theta+alfa);
  float yo1=A*sin(theta+alfa);
  float xo2=A*cos(alfa-theta);
  float yo2=A*sin(alfa-theta);            //cross(x2,y2,128);DEBUG!

  line(int(x2+xo1),int(y2+yo1),x2,y2);
  line(int(x2+xo2),int(y2+yo2),x2,y2);
  line(x1,y1,x2,y2);
}


//*////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
