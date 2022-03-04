float a=random(1.0);//Liczba losowa z zakres 0..1

for(int i=0;i<100;i++)
{
  println(a); //Wypisana na konsole - dlaczego pierwsze?
  a=random(1.0);//Liczba losowa z zakres 0..1
  point(i,a*100);
}  

//http://processingwedukacji.blogspot.com
