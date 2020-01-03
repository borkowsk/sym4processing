size(500,500);
background(100,0,0);
noSmooth();//Zakomentuj jedno albo drugie
//smooth();
for(int i=0;i<500;i+=10) //POWTARZAJ
{
  stroke(0,i,i);
  line(i,i,0,500);
}

//https://www.facebook.com/ProcessingWEdukacji/