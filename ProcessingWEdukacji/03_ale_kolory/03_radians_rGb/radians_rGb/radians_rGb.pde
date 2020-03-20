//Sektory koła

size(500,500);
background(0,0,200);//rgB - BLUE
noSmooth();//Bez wygładzania lini 

ellipse(250, 250, 200, 200); //Elipsa pod spodem
for(int i=0;i<256;i+=10)
{
  fill(0,i,0);//rGb - GREEN
  arc(250, 250, 200, 200, radians(i-10),radians(i));//Sektory
}

//https://www.facebook.com/ProcessingWEdukacji/
//http://processingwedukacji.blogspot.com
