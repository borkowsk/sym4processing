//30 kartek

size(500,500);

smooth();//Z wygładzaniem lini ("antyaliasingiem")
rectMode(CORNERS);  // Set rectMode to CORNERS
for(int i=0;i<300;i+=10) //POWTARZAJ CO DZIESIĄTY!
  rect(i,i,0,500); //I rysuj "kartkę"

//https://www.facebook.com/ProcessingWEdukacji/
