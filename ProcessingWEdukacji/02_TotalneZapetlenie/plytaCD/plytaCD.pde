//Obraz płyty CD

size(500,500);
background(0);//Czarne tło (0 jasności)
noFill();//Same kontury elips

stroke(255);//Kontur biały
for(int i=150;i>30;i=i-2) //POWTARZAJ
{
 ellipse(100,100,i,i);
}

point(499,499);//Punkt na koniec rysowania

//http://processingwedukacji.blogspot.com
