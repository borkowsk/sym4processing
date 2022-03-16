/// Various helpful drawing procedures
//*//////////////////////////////////////////////////////////////

/// Frame drawn with a default line
void surround(int x1,int y1,int x2,int y2)
{
  line(x1,y1,x2,y1);//--->
  line(x2,y1,x2,y2);//vvv
  line(x1,y2,x2,y2);//<---
  line(x1,y1,x1,y2);//^^^
}

/// Cross drawn with a default line
void cross(float x,float y,float cross_width)
{
  line(x-cross_width,y,x+cross_width,y);
  line(x,y-cross_width,x,y+cross_width);
}

/// Cross drawn with a default line 
/// The version that uses parameters of type int.
void cross(int x,int y,int cross_width)
{
  line(x-cross_width,y,x+cross_width,y);
  line(x,y-cross_width,x,y+cross_width);
}

/// The bald head of a man seen from above
void baldhead(int x,int y,int r,float direction)
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

//*
/// POLYGONS
//*
//*/////////////////////

/// A regular polygon with a given radius and number of vertices
void regularpoly(float x, float y, float radius, int npoints) 
{
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) 
  {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

/// A class to represent two-dimensional points
class pointxy 
{
  float x,y;
  
  pointxy()
  {
    x=y=0;
  }
  
  pointxy(float ix,float iy)
  {
    x=ix;y=iy;
  }
}//EndOfClass

/// Drawing a polygon. 
/// It utilises vertices given as an array of points
void polygon(pointxy[] lst/*+1*/)
{
  int N= lst.length;
  beginShape();
  for (int a = 0; a < N; a ++) 
  {
    vertex(lst[a].x,lst[a].y);
  }
  endShape(CLOSE);
}

/// Drawing a polygon. 
/// It utilises vertices given as an array of points
/// @param N, size of list, could be smaller than 'lst.lenght'
void polygon(pointxy[] lst/*+1*/,int N)
{
  beginShape();
  for (int a = 0; a < N; a ++) 
  {
    vertex(lst[a].x,lst[a].y);
  }
  endShape(CLOSE);
}

/// Nearest points of two polygons.
Pair<pointxy,pointxy> nearestPoints(final pointxy[] listA,final pointxy[] listB)
{                                    
                                    assert(listA.length>0);
                                    assert(listB.length>0);
  float mindist=MAX_FLOAT;
  int   minA=-1;
  int   minB=-1;
  for(int i=0;i<listA.length;i++)
    for(int j=0;j<listB.length;j++) //Pętla nadmiarowa (?)
    {
      float x2=(listA[i].x-listB[j].x)*(listA[i].x-listB[j].x);
      float y2=(listA[i].y-listB[j].y)*(listA[i].y-listB[j].y);
      
      if(x2+y2 < mindist)
      {
        mindist=x2+y2;
        minA=i; minB=j;
      }
    }
  return new Pair<pointxy,pointxy>(listA[minA],listB[minB]);
}

//*
/// BAR3D 
//*
//*/////////////////////////////////////////

class settings_bar3d
{
int a=10;
int b=6;
int c=6;
color wire=color(255,255,255); //Kolor ramek
color back=color(0,0,0); //Informacja o kolorze tla
}//EndOfClass

settings_bar3d bar3dsett=new settings_bar3d();///< Default settings of bar3d

pointxy bar3dromb[]={new pointxy(),new pointxy(),new pointxy(),new pointxy(),new pointxy(),new pointxy()};

void bar3dRGB(float x,float y,float h,int R,int G,int B,int Shad)
{
                                                    /*      6 ------ 5    */
  bar3dromb[0].x= x;                                /*     /        / |   */
  bar3dromb[0].y= y - h;                            /*    1 ------ 2  |   */
  bar3dromb[1].x= x + bar3dsett.a;                  /*    |        |  |   */
  bar3dromb[1].y= bar3dromb[1-1].y;                 /*    |        |  |   */
  bar3dromb[2].x= bar3dromb[2-1].x;                 /*    |        |  |   */
  bar3dromb[2].y= y;                                /*    |        |  4   */
  bar3dromb[3].x= x + bar3dsett.a + bar3dsett.b;    /*    |        | /  c */
  bar3dromb[3].y= y - bar3dsett.c;                  /*  x,y ------ 3      */
  bar3dromb[4].x= bar3dromb[4-1].x;                 /*         a      b   */
  bar3dromb[4].y= y - h - bar3dsett.c;
  bar3dromb[5].x= x + bar3dsett.b;
  bar3dromb[5].y= bar3dromb[5-1].y;

  fill(R,G,B);
  rect(x,y-h,bar3dsett.a,h+1);               //front

  fill(R/Shad,G/Shad,B/Shad);
  polygon(bar3dromb/*+1*/,6);              //bok i gora

  stroke(bar3dsett.wire);
  //rect(bar3dromb[1-1].x,bar3dromb[1-1].y,bar3dromb[2-1].x+1,bar3dromb[2-1].y+1);//gorny poziom
  //rect(x,y,bar3dromb[3-1].x+1,bar3dromb[3-1].y+1);       //dolny poziom

  line(bar3dromb[2-1].x,bar3dromb[2-1].y,bar3dromb[5-1].x,bar3dromb[5-1].y); //blik?

  //point(bar3dromb[5].x,bar3dromb[5].y,wire_col-1);
  line(bar3dromb[1-1].x,bar3dromb[1-1].y,bar3dromb[6-1].x,bar3dromb[6-1].y);//lewy ukos
  line(bar3dromb[2-1].x,bar3dromb[2-1].y,bar3dromb[3-1].x,bar3dromb[3-1].y);//prawy ukos
  line(bar3dromb[3-1].x,bar3dromb[3-1].y,bar3dromb[4-1].x,bar3dromb[4-1].y);//dolny ukos
  line(bar3dromb[4-1].x,bar3dromb[4-1].y,bar3dromb[5-1].x,bar3dromb[5-1].y);//tyl bok
  line(bar3dromb[5-1].x,bar3dromb[5-1].y,bar3dromb[6-1].x,bar3dromb[6-1].y);//tyl bok

 // rect(x,y-h,1,h+1,wire_col);       // the left vertical edge is additionally marked
}/* end of bar3dRGB */

 
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

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - HANDY FUNCTIONS & CLASSES
//*/////////////////////////////////////////////////////////////////////////////////////////
