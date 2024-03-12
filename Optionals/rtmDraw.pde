/// @file 
/// @brief `draw()` example with possibility of non-visible window. ("rtmDraw.pde")
/// @date 2023.03.04 (Last modification)
//*////////////////////////////////////////////////////////////////////////////////////
/// @details 
/// Console only apps. is possible when draw() function set window visibility to false, 
/// then can do anything but drawing :-D
/// Need extern definition of:
///  final boolean WINDOW_INVISIBLE=true; ///< ... is used in template draw() for swith on window invisibility.
void draw() 
{
  if(WINDOW_INVISIBLE && frameCount==1)
  {
    surface.setVisible(false); //Console only applet? - Does it work?
    println("Windows is set to invisible in draw function!");
  }
  //... Your code here or in event handlers. But... WITHOUT ANY DRAWING.
}

//*/////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////
