/// @file 
/// @brief Some math basics: sign, upToTresh(-hold) & whichIsMax ("uMathBasic.pde")
/// @date 2024-09-26 (Last modification)
//*/////////////////////////////////////////////////////////////////////////////////

/// @defgroup General math tools and functions
/// @{
//*///////////////////////////////////////////

/// Some of my older programs use the constant FLOAT_MAX,
/// while MAX_FLOAT is currently available in Processing.
final float FLOAT_MAX=MAX_FLOAT; ///< 3.40282347E+38;

/// Function for determining the sign of a integer number.
int sign(int val)  ///< @note GLOBAL
{
  if(val>0) return 1;
  else if(val==0) return 0;
  else return -1;
}

/// Function for determining the sign of a float number.
int sign(float val)  ///< @note GLOBAL
{
  if(val>0) return 1;
  else if(val==0) return 0;
  else return -1;
}

/// Function for determining the sign of a double number.
int sign(double val)  ///< @note GLOBAL
{
  if(val>0) return 1;
  else if(val==0) return 0;
  else return -1;
}

/// Function for increasing a value no more than up to a certain threshold.
float upToTresh(float val,float incr,float tresh)  ///< @note GLOBAL
{
    val+=incr;
    return val<tresh?val:tresh;
}

/// Function to find which of the three values is the largest.
int whichIsMax(float v0,float v1,float v2)  ///< @note GLOBAL
{
  if(v0 > v1 && v0 > v2) return 0;
  else if( v1 > v0 && v1 > v2) return 1;
  else if( v2 > v0 && v2 > v1) return 2;
  else return -1;//żaden nie jest dominujący
}

//*/////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
/// @}
//*/////////////////////////////////////////////////////////////////////////////
