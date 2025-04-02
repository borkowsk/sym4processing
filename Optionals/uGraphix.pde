/// Various helpful drawing procedures, like crosses, polygons & bar3D. ("uGraphix.pde")
/// @date 2025-04-02 (last modification)
//-///////////////////////////////////////////////////////////////////////////////////////////

/// @defgroup Generally usable graphic
/// @{
//-///////////////////////////////////


/// @brief A class to represent two-dimensional points.
class pointXY
{
  float x,y;
  
  pointXY()
  {
    x=y=0;
  }
  
  pointXY(float ix,float iy)
  {
    x=ix;y=iy;
  }
} //EndOfClass pointxy

/// @brief Frame drawn with a default line.
void surround(int x1,int y1,int x2,int y2)                     ///< @note Global namespace!.
{
  line(x1,y1,x2,y1); //--->
  line(x2,y1,x2,y2); //vvv
  line(x1,y2,x2,y2); //<---
  line(x1,y1,x1,y2); //^^^
}

/// @brief Cross drawn with a default line.
void cross(float x,float y,float cross_width)                  ///< @note Global namespace!
{
  line(x-cross_width,y,x+cross_width,y);
  line(x,y-cross_width,x,y+cross_width);
}

/// @brief Cross drawn with a default line.
///        The version that uses parameters of type int.
void cross(int x,int y,int cross_width)                        ///< @note Global namespace!
{
  line(x-cross_width,y,x+cross_width,y);
  line(x,y-cross_width,x,y+cross_width);
}

// POLYGONS:
//*/////////

/// @brief A regular polygon with a given radius and number of vertices.
void regular_poly(float x, float y, float radius, int nPoints)  ///< @note Global namespace!
{
  float angle = TWO_PI / nPoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) 
  {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

/// @brief Drawing a polygon. 
///        This function utilises vertices given as an array of points
void polygon(pointXY[] lst/*+1*/)                               ///< @note Global namespace!
{
  int N= lst.length;
  beginShape();
  for (int a = 0; a < N; a ++) 
  {
    vertex(lst[a].x,lst[a].y);
  }
  endShape(CLOSE);
}

/// @brief Drawing a polygon. 
///        It utilises vertices given as an array of points
/// @param N, size of list, could be smaller than 'lst.lenght'
void polygon(pointXY[] lst/*+1*/,int N)                        ///< @note Global namespace!
{
  beginShape();
  for (int a = 0; a < N; a ++) 
  {
    vertex(lst[a].x,lst[a].y);
  }
  endShape(CLOSE);
}


// Visualisation of BAR3D:
//*///////////////////////

/// @brief Configuration set of BAR3D visualisation.
class settings_bar3d
{
int a=10;
int b=6;
int c=6;
color wire=color(255,255,255); //Kolor ramek
color back=color(0,0,0); //Informacja o kolorze tla
} //EndOfClass

/// @brief Default configuration set of BAR3D visualisation.
settings_bar3d bar_3D_settings=new settings_bar3d();                       ///< Default settings of bar3d

/// @brief The rhombus polygon used for driving `bar3D`.
pointXY[] bar_3D_rhombus =                                                ///< @note Global namespace!
  {new pointXY(),new pointXY(),new pointXY(),new pointXY(),new pointXY(),new pointXY()};

/// @brief Function which driving `bar3d` using current configuration.
void bar3dRGB(float x,float y,float h,int R,int G,int B,int Shad)    ///< @note Global namespace!
{
                                                                  /*      6 ------ 5    */
  bar_3D_rhombus[0].x= x;                                         /*     /        / |   */
  bar_3D_rhombus[0].y= y - h;                                     /*    1 ------ 2  |   */
  bar_3D_rhombus[1].x= x + bar_3D_settings.a;                     /*    |        |  |   */
  bar_3D_rhombus[1].y= bar_3D_rhombus[1-1].y;                     /*    |        |  |   */
  bar_3D_rhombus[2].x= bar_3D_rhombus[2-1].x;                     /*    |        |  |   */
  bar_3D_rhombus[2].y= y;                                         /*    |        |  4   */
  bar_3D_rhombus[3].x= x + bar_3D_settings.a + bar_3D_settings.b; /*    |        | /  c */
  bar_3D_rhombus[3].y= y - bar_3D_settings.c;                     /*  x,y ------ 3      */
  bar_3D_rhombus[4].x= bar_3D_rhombus[4-1].x;                     /*         a      b   */
  bar_3D_rhombus[4].y= y - h - bar_3D_settings.c;
  bar_3D_rhombus[5].x= x + bar_3D_settings.b;
  bar_3D_rhombus[5].y= bar_3D_rhombus[5-1].y;

  fill(R,G,B);
  rect(x,y-h,bar_3D_settings.a,h+1);         //front

  fill(R/Shad,G/Shad,B/Shad);
  polygon(bar_3D_rhombus/*+1*/,6);           //bok i gora

  stroke(bar_3D_settings.wire);
  //rect(bar_3D_rhombus[1-1].x,bar_3D_rhombus[1-1].y,bar_3D_rhombus[2-1].x+1,bar_3D_rhombus[2-1].y+1); //górny poziom
  //rect(x,y,bar_3D_rhombus[3-1].x+1,bar_3D_rhombus[3-1].y+1);       //dolny poziom

  line(bar_3D_rhombus[2-1].x,bar_3D_rhombus[2-1].y,bar_3D_rhombus[5-1].x,bar_3D_rhombus[5-1].y); //blik?

  //point(bar_3D_rhombus[5].x,bar_3D_rhombus[5].y,wire_col-1);
  line(bar_3D_rhombus[1-1].x,bar_3D_rhombus[1-1].y,bar_3D_rhombus[6-1].x,bar_3D_rhombus[6-1].y); //lewy ukos
  line(bar_3D_rhombus[2-1].x,bar_3D_rhombus[2-1].y,bar_3D_rhombus[3-1].x,bar_3D_rhombus[3-1].y); //prawy ukos
  line(bar_3D_rhombus[3-1].x,bar_3D_rhombus[3-1].y,bar_3D_rhombus[4-1].x,bar_3D_rhombus[4-1].y); //dolny ukos
  line(bar_3D_rhombus[4-1].x,bar_3D_rhombus[4-1].y,bar_3D_rhombus[5-1].x,bar_3D_rhombus[5-1].y); //tyl bok
  line(bar_3D_rhombus[5-1].x,bar_3D_rhombus[5-1].y,bar_3D_rhombus[6-1].x,bar_3D_rhombus[6-1].y); //tyl bok

 // rect(x,y-h,1,h+1,wire_col);       // the left vertical edge is additionally marked
} /* end of bar3dRGB */

 

//*////////////////////////////////////////////////////////////////////////////
//*  -> "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" 
//*   - OPTIONAL TOOLS: FUNCTIONS & CLASSES
//*  -> "https://github.com/borkowsk/sym4processing"
/// @}
//*////////////////////////////////////////////////////////////////////////////
