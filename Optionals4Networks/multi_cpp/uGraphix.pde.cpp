/// @file
/// @note Automatically made from _uGraphix.pde_ by __Processing to C++__ converter (/data/wb/SCC/public/Processing2C/scripts/procesing2cpp.sh).
/// @date 2024-10-21 19:06:46 (translation)
//
#include "processing_consts.hpp"
#include "processing_templates.hpp"
#include "processing_library.hpp"
#include "processing_window.hpp"
#ifndef _NO_INLINE
#include "processing_inlines.hpp" //...is optional.
#endif // _NO_INLINE
using namespace Processing;
#include "local.h" //???.
#include <iostream>
//================================================================

/// Various helpful drawing procedures, like crosses, polygons & bar3D. ("uGraphix.pde")
/// @date 2024-10-20 (last modification)
//*///////////////////////////////////////////////////////////////////////////////////////////

/// @defgroup Generally usable graphix
/// @{
//*///////////////////////////////////


/// @brief A class to represent two-dimensional points.
#include "pointxy_class.pde.hpp"

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
void regularpoly(float x, float y, float radius, int npoints)  ///< @note Global namespace!
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

/// @brief Drawing a polygon. 
///        This function utilises vertices given as an array of points
void polygon(sarray<ppointxy> lst/*+1*/)                               ///< @note Global namespace!
{
  int N= lst->length;
  beginShape();
  for (int a = 0; a < N; a ++) 
  {
    vertex(lst[a]->x,lst[a]->y);
  }
  endShape(CLOSE);
}

/// @brief Drawing a polygon. 
///        It utilises vertices given as an array of points
/// @param N, size of list, could be smaller than 'lst->lenght'
void polygon(sarray<ppointxy> lst/*+1*/,int N)                        ///< @note Global namespace!
{
  beginShape();
  for (int a = 0; a < N; a ++) 
  {
    vertex(lst[a]->x,lst[a]->y);
  }
  endShape(CLOSE);
}


// Visualisation of BAR3D:
//*///////////////////////

/// @brief Configuration set of BAR3D visualisation.
#include "settings_bar3d_class.pde.hpp"

/// @brief Default configuration set of BAR3D visualisation.
psettings_bar3d bar3dsett=new settings_bar3d();                       ///< Default settings of bar3d

/// @brief Rhomb polygon used for draving bar3D
sarray<ppointxy> bar3dromb =                                                ///< @note Global namespace!
  {
	new pointxy(),new pointxy(),new pointxy(),new pointxy(),new pointxy(),new pointxy()
	};

/// @brief Function which draving bar3d using current configuration.
void bar3dRGB(float x,float y,float h,int R,int G,int B,int Shad)    ///< @note Global namespace!
{
                                                    /*      6 ------ 5    */
  bar3dromb[0]->x= x;                                /*     /        / |   */
  bar3dromb[0]->y= y - h;                            /*    1 ------ 2  |   */
  bar3dromb[1]->x= x + bar3dsett->a;                  /*    |        |  |   */
  bar3dromb[1]->y= bar3dromb[1-1]->y;                 /*    |        |  |   */
  bar3dromb[2]->x= bar3dromb[2-1]->x;                 /*    |        |  |   */
  bar3dromb[2]->y= y;                                /*    |        |  4   */
  bar3dromb[3]->x= x + bar3dsett->a + bar3dsett->b;    /*    |        | /  c */
  bar3dromb[3]->y= y - bar3dsett->c;                  /*  x,y ------ 3      */
  bar3dromb[4]->x= bar3dromb[4-1]->x;                 /*         a      b   */
  bar3dromb[4]->y= y - h - bar3dsett->c;
  bar3dromb[5]->x= x + bar3dsett->b;
  bar3dromb[5]->y= bar3dromb[5-1]->y;

  fill(R,G,B);
  rect(x,y-h,bar3dsett->a,h+1);               //front

  fill(R/Shad,G/Shad,B/Shad);
  polygon(bar3dromb/*+1*/,6);              //bok i gora

  stroke(bar3dsett->wire);
  //rect(bar3dromb[1-1]->x,bar3dromb[1-1]->y,bar3dromb[2-1]->x+1,bar3dromb[2-1]->y+1); //gorny poziom
  //rect(x,y,bar3dromb[3-1]->x+1,bar3dromb[3-1]->y+1);       //dolny poziom

  line(bar3dromb[2-1]->x,bar3dromb[2-1]->y,bar3dromb[5-1]->x,bar3dromb[5-1]->y); //blik?

  //point(bar3dromb[5]->x,bar3dromb[5]->y,wire_col-1);
  line(bar3dromb[1-1]->x,bar3dromb[1-1]->y,bar3dromb[6-1]->x,bar3dromb[6-1]->y); //lewy ukos
  line(bar3dromb[2-1]->x,bar3dromb[2-1]->y,bar3dromb[3-1]->x,bar3dromb[3-1]->y); //prawy ukos
  line(bar3dromb[3-1]->x,bar3dromb[3-1]->y,bar3dromb[4-1]->x,bar3dromb[4-1]->y); //dolny ukos
  line(bar3dromb[4-1]->x,bar3dromb[4-1]->y,bar3dromb[5-1]->x,bar3dromb[5-1]->y); //tyl bok
  line(bar3dromb[5-1]->x,bar3dromb[5-1]->y,bar3dromb[6-1]->x,bar3dromb[6-1]->y); //tyl bok

 // rect(x,y-h,1,h+1,wire_col);       // the left vertical edge is additionally marked
} /* end of bar3dRGB */

 

//*////////////////////////////////////////////////////////////////////////////
//*  -> "https://www->researchgate.net/profile/WOJCIECH_BORKOWSKI" 
//*   - OPTIONAL TOOLS: FUNCTIONS & CLASSES
//*  -> "https://github.com/borkowsk/sym4processing"
/// @}
//*////////////////////////////////////////////////////////////////////////////
//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 19:06:46 !

