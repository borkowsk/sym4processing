// RECURSIVE PATTERNS – "BISECT" LINE
// Po prostu linia, opcjonalnie przerywana, powstająca rekurencyjnie
/////////////////////////////////////////////////////////////////////
float limit=10;
 
void setup() 
{
   size(500, 500);
   noSmooth();
   background(255);
   stroke(222,222,0); line(0,0,width,height/2);//inny algorytm
   stroke(0); bline(0,0,width,height/2);//<---
}
  
void bline(float x1, float y1,float x2, float y2)
{
   float d=sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));//Dlugość
   
   if ( d < limit)//czy mięścimy się w limicie długości
      return; //println(d);//kontrola

   int xs=(int)(x1+x2)/2;//Obliczenie środka
   int ys=(int)(y1+y2)/2;   
      
   bline(x1,y1,xs,ys);//Wywołanie rekurencyjnie 
   bline(xs,ys,x2,y2);//--//--
   
   point(xs,ys);//Właściwe rysowanie
   //point(x1,y1);point(x2,y2);//Końcówki.Ale wtedy się "powtarzamy".
}
