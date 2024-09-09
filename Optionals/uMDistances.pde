/// @file 
/// @brief Different ways to calculate Euclid distances in 2D ("uMDistances.pde", flat and torus).
/// @date 2024-09-09 (Last modification)                        @author borkowsk 
/// @details ...
//*////////////////////////////////////////////////////////////////////////////////////////////////

final float fNaN = 2.1f % 0.0f;  ///< `float` not a number !
final double NaN = 2.1 % 0.0;    ///< `double` not a number !

/// @brief Shortcuts for square value.
/// @note Comment they out, if defined elsewhere.
int     sqr(int x)       ///< @note GLOBAL!
{ return x*x; }

/// @copybrief 
float   sqr(float x)     ///< @note GLOBAL!  
{ return x*x; }

/// @copybrief 
double  sqr(double x)    ///< @note GLOBAL! 
{ return x*x; }

/// @brief Default Euclidean distance on float numbers.
/// @details Often needed in simulation programs.
///          Actually similar as `dist()` already shipped in Processing 3.xx. but slower.
/// @note Parameter order is different than in Processing::dist()!
float distance(float X1,float X2,float Y1,float Y2)                             ///< @note Global namespace!  
{
  float dX=X2-X1;
  float dY=Y2-Y1;
  if(dX!=0 || dY!=0)
  {
    dX=sqr(dX); dY=sqr(dY);
    return sqrt( dX + dY );
  }
  else
    return 0;
}

/// @brief 2D Euclidean distance on float numbers.
/// @details Often needed in simulation programs.
///          Version with `float` parameters.
/// @note Parameter order is different than in Processing::dist()!
float distanceEucl(float X1,float X2,float Y1,float Y2)                         ///< @note Global namespace!  
{
  float dX=X2-X1;
  float dY=Y2-Y1;
  if(dX!=0 || dY!=0)
    return sqrt(dX*dX+dY*dY);
  else
    return 0;
}

/// @brief 2D Euclidean distance on double numbers.
/// @details Sometimes needed in simulation programs.
///          Version with `double` parameters.
/// @note Parameter order is different than in Processing::dist()!
double distanceEucl(double X1,double X2,double Y1,double Y2)                    ///< @note Global namespace!  
{
  double dX=X2-X1;
  double dY=Y2-Y1;

  if(dX!=0 || dY!=0)
    return Math.sqrt(dX*dX+dY*dY);
  else
    return 0;
}

/// @brief Euclidean like distance on torus (float numbers).
/// @details Sometimes needed in simulation programs.
///          Version with `float` parameters.
/// @param Xdd & @param Ydd are the horizontal and vertical perimeter of the torus
/// @note Parameter order is different than in Processing::dist()!
float distanceTorus(float X1,float X2,float Y1,float Y2,float Xdd,float Ydd)    ///< @note Global namespace!  
{ //println("float torus dist");
  float dX=abs(X2-X1);
  float dY=abs(Y2-Y1);
  if(dX > (Xdd/2) ) dX=Xdd-dX;
  if(dY > (Ydd/2) ) dY=Ydd-dY;
  if(dX!=0 || dY!=0)
    return sqrt(dX*dX+dY*dY);
  else
    return 0;
}

/// @brief Euclidean like distance on torus (double numbers).
/// @details Sometimes needed in simulation programs.
///          Version with `double` parameters.
/// @param Xdd & @param Ydd are the horizontal and vertical perimeter of the torus.
/// @note Parameter order is different than in Processing::dist()!
double distanceTorus(double X1,double X2,double Y1,double Y2,double Xdd,double Ydd) ///< @note Global namespace!  
{ //println("double torus dist");
  double dX=Math.abs(X2-X1);
  double dY=Math.abs(Y2-Y1);
  if( dX > (Xdd/2) ) dX=Xdd-dX;
  if( dY > (Ydd/2) ) dY=Ydd-dY;
  if(dX!=0 || dY!=0)
    return Math.sqrt(dX*dX+dY*dY);
  else
    return 0;
}

/// @brief Euclidean like distance on torus (int numbers).
/// @details Sometimes needed in simulation programs.
///          Version with `int` parameters.
/// @param Xdd & @param Ydd are the horizontal and vertical perimeter of the torus.
/// @note Parameter order is different than in Processing::dist()!
double distanceTorusInt(int X1,int X2,int Y1,int Y2,int Xdd,int Ydd)            ///< @note Global namespace!  
{ //println("int torus dist");
  int dX=abs(X2-X1);
  int dY=abs(Y2-Y1);
  if( dX > (Xdd/2) ) dX=Xdd-dX;
  if( dY > (Ydd/2) ) dY=Ydd-dY;
  if(dX!=0 || dY!=0)
    return Math.sqrt(dX*dX+dY*dY);
  else
    return 0;
}

/* 
/// Default Euclidean.
/// It is considering window length but why not width?
double distance(double X1,double X2,double Y1,double Y2)
{
  double dX=X2-X1;
  double dY=Y2-Y1;

  if(dX>(length/2)) dX=length-dX;
  if(dY>(length/2)) dY=length-dY;
  
  if(dX!=0 || dY!=0)
    return Math.sqrt(dX*dX+dY*dY);
  else
    return 0;
}
*/

//*/////////////////////////////////////////////////////////////////////////////
//*  -> "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" 
//*   - OPTIONAL TOOLS: FUNCTIONS & CLASSES
//*  -> "https://github.com/borkowsk/sym4processing"
//*/////////////////////////////////////////////////////////////////////////////
