size(500,500);
//noSmooth();//Tak by bylo bez wygładzania lini ("antyaliasingu")
             
for(int i=0;i<256;i--) //POWTARZAJ 256 razy (odliczając wstecz)
{
  stroke(i);//Zmienia się tylko jasność, chyba że coś nie zadziała :-)
  line(i,0,128,500);//zmienia się tylko x, y==0
}
