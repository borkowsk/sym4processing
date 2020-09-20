//if you use alot of dotted lines maybe something like this is usefull for you... 
//just call dottedLine() like you would call line()
//https://processing.org/discourse/beta/num_1219255354.html

void dottedLine(float x1, float y1, float x2, float y2, float steps)
{
 for(int i=0; i<=steps; i++) 
 {
   float x = lerp(x1, x2, i/steps);//funkcja lerp() jest sednem tego rozwiązania
   float y = lerp(y1, y2, i/steps);
   point(x,y);
   //noStroke();ellipse(x, y,2,2);//Używanie elipsy zamiast punktu nie jest zbyt wydajne
                                  //ale używa koloru zdefiniowanego przez fill() zamiast stroke()
 }
} 
