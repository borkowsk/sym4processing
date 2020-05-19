// Petla for z operacją += rysująca co drugą linie

size(500,500);
smooth();//Z wygładzaniem lini ("antyaliasingiem")

for(int i=0;i<200;i+=2) //POWTARZAJ CO DRUGI! (100 razy)
  line(i,i,0,500);
  
//http://processingwedukacji.blogspot.com
