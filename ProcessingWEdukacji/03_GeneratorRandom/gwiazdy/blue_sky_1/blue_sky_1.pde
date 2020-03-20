//Gwiazdy na granatowym niebie
size(500,500);
background(0,0,50);

//STARS
for(int i=0;i<1500;i++) //POWTARZAJ 1500 razy
{
  float R=random(255);
  float G=random(255);
  float B=random(255);
  stroke(R,G,B);
  point(random(500),random(500));
}

//http://processingwedukacji.blogspot.com
