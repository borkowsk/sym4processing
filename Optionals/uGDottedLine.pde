///  Function for drawing dotted lines.
//*////////////////////////////////////////////////////////////////////////////////////

/// if you use a lot of dotted lines maybe something like this is usefull for you... 
/// just call dottedLine() like you would call line()
/// See: https://processing.org/discourse/beta/num_1219255354.html
void dottedLine(float x1, float y1, float x2, float y2, int steps)
{                                 //println("dottedLine(float,float,float,float,int steps)");
 for(int i=0; i<=steps; i++) 
 {
   float d = i/(float)steps;      //println(d);
   float x = lerp(x1, x2, d);//funkcja lerp() jest sednem tego rozwiązania
   float y = lerp(y1, y2, d);
   point(x,y);
   //noStroke();ellipse(x, y,2,2);//Używanie elipsy zamiast punktu nie jest zbyt wydajne
                                  //ale używa koloru zdefiniowanego przez fill() zamiast stroke()
 }
} 

/// Alternative function for drawing dotted lines.
/// Uses 'int' as a parameter type.
void dottedline(int x1, int y1, int x2, int y2, int dens)
{                                  print("dottedline(int x1,int y1,int x2,int y2,int dens)");
  for (int i = 0; i <= dens; i++) 
  {
    float x = lerp(x1, x2, i/(float)dens);
    float y = lerp(y1, y2, i/(float)dens);
    point(x, y);
  }
}

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
