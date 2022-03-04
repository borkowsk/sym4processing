// RECURSIVE PATTERNS – CANTOR SET
// Metodą wycinania lini - https://en.wikipedia.org/wiki/Cantor_set
///////////////////////////////////////////////////////////////////////////////////////////////
float limit=3;
 
void setup() 
{
   size(513,514);//Okno powinno być trochę wyższe niż szersze
   noSmooth();
   background(0); strokeWeight(5); strokeCap(SQUARE);
   noLoop();//nie ma potrzeby używać draw()
   cantorSetHor1(0,width);//kolejne iteracje pod sobą 
   cantorSetHor2(0,width);//kolejne iteracje nałożone
}
  
void cantorSetHor1(float x1, float x2)
{
  int d=int(abs(x2-x1));
  //println(d);
  if ( d < limit)//limit długości
      return;
      
  float xA=x1+d*0.333333333;//Obliczenie krańców
  float xB=x1+d*0.666666666;
  
  stroke(255,0,255);
  line(x1,height-d,xA-1,height-d); point((x1+xA)/2,height-d);
  
  stroke(0,255,0);
  line(xA,height-d,xB,height-d); point((xA+xB)/2,height-d);
  
  stroke(255,0,255);
  line(xB+1,height-d,x2,height-d); point((xB+x2)/2,height-d);
  
  cantorSetHor1(x1,xA); cantorSetHor1(xB,x2); 
}

void cantorSetHor2(float x1, float x2)
{
  int d=int(abs(x2-x1));
  //println(d);
  if ( d < limit)//limit długości
      return;
      
  float xA=x1+d*0.333333333;//Obliczenie krańców
  float xB=x1+d*0.666666666;
 
  stroke(255,0,0);
  if(int(x1)<int(xA)) line(x1,height/2,xA-1,height/2);
  else point(xA,height/2);//Gdy za mało miejsca na linie
  
  stroke(0,255,255);
  if(int(xA)<int(xB))line(xA,height/2,xB,height/2);
  else point(xB,height/2);//Gdy za mało miejsca na linie  
  
  stroke(255,0,0);
  if(int(xB)<int(x2)) line(xB+1,height/2,x2,height/2); 
  else point(x2,height/2);//Gdy za mało miejsca na linie
  
  cantorSetHor2(x1,xA);
  cantorSetHor2(xB,x2); 
}
