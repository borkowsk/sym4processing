//Losowe linie wzdłuż x
size(300,200);

for(int i=0;i<300;i++)
{
  float a=random(200);//Liczba z zakresu 0..200
  line(i,0,i,a);
}

//http://processingwedukacji.blogspot.com 
