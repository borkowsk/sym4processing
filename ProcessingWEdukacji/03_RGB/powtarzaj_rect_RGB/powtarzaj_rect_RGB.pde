size(500,500);
background(0,0,200);//rgB
smooth();//Z wygładzaniem lini ("antyaliasingiem")
rectMode(CORNERS);  // Set rectMode to CORNERS

for(int i=0;i<256;i+=10) //POWTARZAJ CO DZIESIĄTY!
{//POCZĄTEK POWTARZANEJ AKCJI
  fill(i,0,0);//Rgb
  rect(i,i,0,500); //I rysuj "kartkę"
}//KONIEC POWTARZANEJ AKCJI