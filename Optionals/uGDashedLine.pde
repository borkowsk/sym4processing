/// Function for drawing dashed lines. ( "uGDashedLine.pde" )
/// @date 2024-10-21 (Last modification)
//*//////////////////////////////////////////////////////////////////

/// @defgroup Generally usable graphix
/// @{
//*///////////////////////////////////

///  Draw a dashed line with given set of dashes and gap lengths. 
///  @param x0 starting x-coordinate of line. 
///  @param y0 starting y-coordinate of line. 
///  @param x1 ending x-coordinate of line. 
///  @param y1 ending y-coordinate of line. 
///  @param spacing is an array giving lengths of dashes and gaps in pixels; 
///  an array with values {5, 3, 9, 4} will draw a line with a 
///  5-pixel dash, 3-pixel gap, 9-pixel dash, and 4-pixel gap. 
///  if the array has an odd number of entries, the values are 
///  recycled, so an array of {5, 3, 2} will draw a line with a 
///  5-pixel dash, 3-pixel gap, 2-pixel dash, 5-pixel gap, 
///  3-pixel dash, and 2-pixel gap, then repeat.
///  NOTE: uses the Processing specific function lerp()
///  See: https://processing.org/discourse/beta/num_1202486379.html 
void dashedLine(float x0, float y0, float x1, float y1, float[ ] spacing) ///< @note GLOBAL!
{ 
  float distance = dist(x0, y0, x1, y1); 
  float [ ] xSpacing = new float[spacing.length]; 
  float [ ] ySpacing = new float[spacing.length]; 
  float drawn = 0.0;  // amount of distance drawn 
 
  if (distance > 0) 
  { 
    int i; 
    boolean drawLine = true; // alternate between dashes and gaps 
 
    /* 
      Figure out x and y distances for each of the spacing values 
      I decided to trade memory for time; I'd rather allocate 
      a few dozen bytes than have to do a calculation every time 
      I draw. 
    */ 
    for (i = 0; i < spacing.length; i++) 
    { 
      xSpacing[i] = lerp(0, (x1 - x0), spacing[i] / distance); 
      ySpacing[i] = lerp(0, (y1 - y0), spacing[i] / distance); 
    } 
 
    i = 0; 
    while (drawn < distance) 
    { 
      if (drawLine) 
      { 
        line(x0, y0, x0 + xSpacing[i], y0 + ySpacing[i]); 
      } 
      x0 += xSpacing[i]; 
      y0 += ySpacing[i]; 
      /* Add distance "drawn" by this line or gap */ 
      drawn = drawn + mag(xSpacing[i], ySpacing[i]); 
      i = (i + 1) % spacing.length;  // cycle through array 
      drawLine = !drawLine;  // switch between dash and gap 
    } 
  } 
}

/// Simplified function for drawing dotted lines.
void dashedline(float x0, float y0, float x1, float y1,float dens) ///< @note GLOBAL!
{
  dashedLine(x0,y0,x1,y1,new float[]{dens,dens});
}

/*
/// Obsolete form 
void dashedline(float x0, float y0, float x1, float y1, float[ ] spacing) 
{ 
  float distance = dist(x0, y0, x1, y1); 
  float [ ] xSpacing = new float[spacing.length]; 
  float [ ] ySpacing = new float[spacing.length]; 
  float drawn = 0.0;  // amount of distance drawn 
 
  if (distance > 0) 
  { 
    int i; 
    boolean drawLine = true; // alternate between dashes and gaps 
 
    // Figure out x and y distances for each of the spacing values 
    // I decided to trade memory for time; I'd rather allocate 
    // a few dozen bytes than have to do a calculation every time I draw. 
    for (i = 0; i < spacing.length; i++) 
    { 
      xSpacing[i] = lerp(0, (x1 - x0), spacing[i] / distance); 
      ySpacing[i] = lerp(0, (y1 - y0), spacing[i] / distance); 
    } 
 
    i = 0; 
    while (drawn < distance) 
    { 
      if (drawLine) 
      { 
        line(x0, y0, x0 + xSpacing[i], y0 + ySpacing[i]); 
      } 
      x0 += xSpacing[i]; 
      y0 += ySpacing[i]; 
      // Add distance "drawn" by this line or gap
      drawn = drawn + mag(xSpacing[i], ySpacing[i]); 
      i = (i + 1) % spacing.length;  // cycle through array 
      drawLine = !drawLine;  // switch between dash and gap 
    } 
  } 
} 
*/

//*/////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
/// @}
//*/////////////////////////////////////////////////////////////////////////////


 
