/// Examples for handling mouse events
//*//////////////////////////////////////

/// Mouse movement support. It shouldn't be too time consuming.
/// see: //https://processing.org/reference/mouseMoved_.html
void mouseMoved()
{
  fill(random(255),random(255),random(255));
  ellipse(mouseX,mouseY,10,10);
}

/* The alternatives are in UtilsRectAreas
void mousePressed() 
{
        println("Pressed "+mouseX+" x "+mouseY);
}

void mouseReleased()
{
        println("Released "+mouseX+" x "+mouseY);
}
*/

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
