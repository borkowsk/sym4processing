/// @file
/// @note Automatically made from _uFigures.pde_ by __Processing to C++__ converter (/data/wb/SCC/public/Processing2C/scripts/procesing2cpp.sh).
/// @date 2024-10-21 19:06:46 (translation)
//
#include "processing_consts.hpp"
#include "processing_templates.hpp"
#include "processing_library.hpp"
#include "processing_window.hpp"
#ifndef _NO_INLINE
#include "processing_inlines.hpp" //...is optional.
#endif // _NO_INLINE
#include "processing_console.hpp"   //...is optional. Should be deleted when not needed.
using namespace Processing;
#include "local.h" //???.
#include <iostream>
//================================================================

/// Various shapes drawing procedures. ("uFigures.pde")
/// @date 2024-10-20 (last modification)                        @author borkowsk
//*/////////////////////////////////////////////////////////////////////////////

/// @defgroup Generally usable graphix
/// @{
//*///////////////////////////////////

//color BALDHEAD_NOSE_COLOR=0xff000011;
float BALDHEAD_MUN_ANGLE=PI/10;   ///< Baldhead draving GLOBAL parameter.
float BALDHEAD_NOSE_DIVIDER=5;    ///< Baldhead draving GLOBAL parameter.
float BALDHEAD_NOSE_RADIUS=1;     ///< Baldhead nose-lenght as ratio of maximal R
float BALDHEAD_EARS_DIVIDER=4;    ///< Baldhead draving GLOBAL parameter.

float BALDHEAD_EYES_RADIUS=0.75;  ///< Baldhead eyes size as ratio of maximal R
float BALDHEAD_PUPIL_RADIUS=0.83; ///< Baldhead pupil size as ratio of maximal R
color BALDHEAD_EYES_COLOR=color(0,100,150);    ///< Baldhead draving GLOBAL parameter.
float BALDHEAD_PUPIL_DIV=14;      ///< Baldhead draving GLOBAL parameter.
int   BALDHEAD_HAIRS_DENS=10;     ///< Baldhead - How many hairs
float BALDHEAD_HAIRS_START=0.2;   ///< Range 0..0.5
float BALDHEAD_HAIRS_END=0.8;     ///< Range BALDHEAD_HAIRS_START..0.99
color BALDHEAD_HAIRS_COLOR=color(111,50,50); ///< As you wish->It is used in `stroke()` function.

/// @brief Horizontal view of a bald head of a man seen from above.
void baldhead_hor(float x,float y,float r,float direction)         ///< @note Global namespace!
{
  float xn,yn,D=2*r; //średnica głowy
    
  xn=x+0.95*r*cos(direction+PI/2);
  yn=y+0.95*r*sin(direction+PI/2);
  ellipse(xn,yn,D/BALDHEAD_EARS_DIVIDER,D/BALDHEAD_EARS_DIVIDER);  //Ucho  1
  
  xn=x+0.95*r*cos(direction-PI/2);
  yn=y+0.95*r*sin(direction-PI/2);
  ellipse(xn,yn,D/BALDHEAD_EARS_DIVIDER,D/BALDHEAD_EARS_DIVIDER);  //Ucho  2
  
  ellipse(x,y,D,D); //GŁOWA
  strokeWeight(3);
  arc(x,y,D,D,direction-BALDHEAD_MUN_ANGLE/2,direction+BALDHEAD_MUN_ANGLE/2);
  strokeWeight(1);
  
  xn=x+BALDHEAD_NOSE_RADIUS*r*cos(direction);
  yn=y+BALDHEAD_NOSE_RADIUS*r*sin(direction);
  ellipse(xn,yn,D/BALDHEAD_NOSE_DIVIDER,D/BALDHEAD_NOSE_DIVIDER);  //Nos
  
  //OCZY
  xn=x+BALDHEAD_EYES_RADIUS*r*cos(direction+PI/5);
  yn=y+BALDHEAD_EYES_RADIUS*r*sin(direction+PI/5);
  fill(200);
  arc(xn,yn,D/5,D/5,-PI/2+direction,PI/2+direction,CHORD);  //Oko  1
  
  xn=x+BALDHEAD_EYES_RADIUS*r*cos(direction-PI/5);
  yn=y+BALDHEAD_EYES_RADIUS*r*sin(direction-PI/5);
  fill(200);
  arc(xn,yn,D/5,D/5,-PI/2+direction,PI/2+direction,CHORD);  //Oko  2

  xn=x+BALDHEAD_PUPIL_RADIUS*r*cos(direction+PI/6);
  yn=y+BALDHEAD_PUPIL_RADIUS*r*sin(direction+PI/6); 
  fill(BALDHEAD_EYES_COLOR);noStroke();
  ellipse(xn,yn,D/10,D/10);
  fill(0);
  ellipse(xn,yn,D/BALDHEAD_PUPIL_DIV,D/BALDHEAD_PUPIL_DIV); //Tęczówka 1
  
  xn=x+BALDHEAD_PUPIL_RADIUS*r*cos(direction-PI/6);
  yn=y+BALDHEAD_PUPIL_RADIUS*r*sin(direction-PI/6);
  fill(BALDHEAD_EYES_COLOR);noStroke();
  ellipse(xn,yn,D/10,D/10);
  fill(0);
  ellipse(xn,yn,D/BALDHEAD_PUPIL_DIV,D/BALDHEAD_PUPIL_DIV); //Tęczówka 2
  
  // JUŻ TYLKO WŁOSY
  stroke(BALDHEAD_HAIRS_COLOR);
  
  for(int i=0;i<=BALDHEAD_HAIRS_DENS;i++)
  {
      float angle=PI/2+PI/BALDHEAD_HAIRS_DENS*i;
      xn=x+BALDHEAD_HAIRS_END*r*cos(angle+direction);
      yn=y+BALDHEAD_HAIRS_END*r*sin(angle+direction);
      float xm=x+BALDHEAD_HAIRS_START*r*cos(angle+direction);
      float ym=y+BALDHEAD_HAIRS_START*r*sin(angle+direction);
      line(xm,ym,xn,yn);
  }
}

/// @brief Vertical view on agave plant.
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

/// @brief Horizontal view on agave plant.
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


/// @brief Vertical view of simple droid.
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
/// ARROW IN ANY DIRECTION:
//*////////////////////////

float def_arrow_size=15;                   ///< Default size of arrows heads
float def_arrow_theta=PI/6.0+PI;           ///< Default arrowhead spacing //3.6651914291881

/// Function that draws an arrow with default settings.
void arrow(float x1,float y1,float x2,float y2)                          ///< @note Global namespace!
{
  arrow_d(int(x1),int(y1),int(x2),int(y2),def_arrow_size,def_arrow_theta);
}

/// @brief Function that draws an arrow with changeable settings.
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
  float alfa=atan2(poY,poX);                if(std::abs(alfa)>PI+0.0000001)
                                                 println("Alfa=%e\n",alfa);
                                          //assert(fstd::abs(alfa)<=M_PI); //cerr<<alfa<<endl;
  float xo1=A*cos(theta+alfa);
  float yo1=A*sin(theta+alfa);
  float xo2=A*cos(alfa-theta);
  float yo2=A*sin(alfa-theta);            //cross(x2,y2,128);DEBUG!

  line(int(x2+xo1),int(y2+yo1),x2,y2);
  line(int(x2+xo2),int(y2+yo2),x2,y2);
  line(x1,y1,x2,y2);
}

//*////////////////////////////////////////////////////////////////////////////
//*  -> "https://www->researchgate.net/profile/WOJCIECH_BORKOWSKI" 
//*   - OPTIONAL TOOLS: FUNCTIONS & CLASSES
//*  -> "https://github.com/borkowsk/sym4processing"
/// @}
//*////////////////////////////////////////////////////////////////////////////
//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 19:06:46 !

