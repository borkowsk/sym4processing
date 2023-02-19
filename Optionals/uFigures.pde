/// Various shapes drawing procedures
//*//////////////////////////////////////////////////////////////

/// The bald head of a man seen from above
void baldhead_hor(int x,int y,int r,float direction)
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
}

/// Vertical view on agava plant.
void agava_ver(float x,float y,float visual_size,float num_of_leafs)
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

void gas_bottle_droid_ver(float x,float y,float visual_size,float direction)
{
  rect(x-visual_size/4, y-visual_size,     visual_size/2,   visual_size-3*visual_size/5,   visual_size/10); //Głowa
  rect(x-visual_size/3, y-3*visual_size/5, 2*visual_size/3, 3*visual_size/5-visual_size/10,visual_size/10); //Tułów
  rect(x-visual_size/4, y-visual_size/10,  visual_size/2,   visual_size/10);  //Stopy
  
  if(-.25*PI<=direction && direction<=PI*1.25) //Przód
  {
    float rotx=x+cos(direction)*visual_size/4.;
    float rots=visual_size/8.*sin(direction);

    fill(200);
    arc(rotx,y-visual_size+visual_size/5.,rots,visual_size/10.,1./2.*PI,6./4.*PI,PIE); //nos lewo
    arc(rotx,y-visual_size+visual_size/5.,rots,visual_size/10.,6./4.*PI,  2.5*PI,PIE); //nos prawo
        
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

float def_arrow_size=15; ///< Default size of arrows heads
float def_arrow_theta=PI/6.0+PI;///< Default arrowhead spacing //3.6651914291881

/// Function that draws an arrow with default settings
void arrow(float x1,float y1,float x2,float y2)
{
  arrow_d(int(x1),int(y1),int(x2),int(y2),def_arrow_size,def_arrow_theta);
}

/// Function that draws an arrow with changable settings
void arrow_d(int x1,int y1,int x2,int y2,float size,float theta)
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
  float alfa=atan2(poY,poX);            if(abs(alfa)>PI+0.0000001)
                                             println("Alfa=%e\n",alfa);
                                      //assert(fabs(alfa)<=M_PI);//cerr<<alfa<<endl;
  float xo1=A*cos(theta+alfa);
  float yo1=A*sin(theta+alfa);
  float xo2=A*cos(alfa-theta);
  float yo2=A*sin(alfa-theta);        //cross(x2,y2,128);DEBUG!

  line(int(x2+xo1),int(y2+yo1),x2,y2);
  line(int(x2+xo2),int(y2+yo2),x2,y2);
  line(x1,y1,x2,y2);
}


//*////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
