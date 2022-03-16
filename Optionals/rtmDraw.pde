/// draw() template with possibility of non-visible window
//*///////////////////////////////////////////////////////////////////////////////////////// 

/// Console only apps. is possible when draw() function set window visibility to false, 
/// then can do anything but drawing :-D
/// final boolean WINDOW_INVISIBLE=true; ... is used in template draw() for swith on window invisibility
void draw() 
{
  if(WINDOW_INVISIBLE && frameCount==1)
  {
    surface.setVisible(false);//Console only applet? - Does it work?
    println("Windows is set to invisible in draw function!");
  }
  //... Your code here or in event handlers!
}

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
