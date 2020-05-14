size(500,500);
//noSmooth();//Bez wygładzania lini ("antyaliasingu")
             //bo domyślnie jest
             
for(int i=0;i<256;i--) //POWTARZAJ 256 razy
{
  stroke(i);//Zmienia się tylko jasność, chyba że coś nie zadziała :-)
  line(i,0,128,500);//zmienia się tylko x, y=0
}

//http://processingwedukacji.blogspot.com
