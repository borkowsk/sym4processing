//Plik wymuszający ładowanie wszystkich "optionali" z tego folderu 

//for swithbit()
final int MASKBITS=0xffffffff;//Redefine, when smaller width is required

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
