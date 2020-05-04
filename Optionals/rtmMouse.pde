// Obsluga zdarzeń myszy
//////////////////////////////

/* Alternatywne są w UtilsRectAreas
void mousePressed() 
{
        println("Pressed "+mouseX+" x "+mouseY);
}

void mouseReleased()
{
        println("Released "+mouseX+" x "+mouseY);
}
*/

void mouseMoved()
//https://processing.org/reference/mouseMoved_.html
{
  fill(random(255),random(255),random(255));
  ellipse(mouseX,mouseY,10,10);
}
