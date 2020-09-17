//Plik wymuszający ładowanie wszystkich "optionali" z tego folderu 

//for swithbit()
final int    LINK_INTENSITY=2;///
final float  MAX_LINK_WEIGHT=1.0;///
final int    MASKBITS=0xffffffff; /// Redefine, when smaller width is required
int          FRAMEFREQ=10;/// simulation speed
//int        debug_level=0; ///

class Agent //Dummy Agent class
{
  float A;
}

void setup()
{
  size(500,500);
  dashedline(0,0,width,height,3);
  arrow_d(0,100,100,200,5,PI*0.75);
  arrow_d(100,200,200,250,5,PI*0.66);
  arrow_d(200,250,300,0,5,PI*0.9);
  dottedLine(0,100,100,200,3);
}
