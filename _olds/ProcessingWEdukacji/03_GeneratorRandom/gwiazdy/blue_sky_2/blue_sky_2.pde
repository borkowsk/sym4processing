//Gwiazdy na niebie z oknem dowolnego rozmiaru
size(1000,700);
background(0,0,50);
//noSmooth();

//STARS
for(int i=0;i<(height*width)/100;i++) //POWTARZAJ
{
  float R=55+random(200);//Gwiazdy nieco bardziej jaskrawe
  float G=55+random(200);
  float B=55+random(200);
  stroke(R,G,B);
  strokeWeight(random(2));//Różne wielkości gwiazd
  point(random(width),random(height));//Położenie dopasowane do rozmiarów okna 
                                      //ustawionych w size() 
}

//http://processingwedukacji.blogspot.com
