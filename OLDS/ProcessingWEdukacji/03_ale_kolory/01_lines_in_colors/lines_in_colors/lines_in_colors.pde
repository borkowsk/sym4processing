//50 linii w odcieniach błękitu pruskiego

size(500,500);
background(100,0,0);

//Zakomentuj jedno albo drugie
noSmooth();//Z antyaliasingiem
//smooth();//Tak uruchamiamy antyaliasing

for(int i=0;i<500;i+=10) //POWTARZAJ 50x co 10
{
  stroke(0,i,i);
  line(i,i,0,500);
}

//https://www.facebook.com/ProcessingWEdukacji/
//http://processingwedukacji.blogspot.com
