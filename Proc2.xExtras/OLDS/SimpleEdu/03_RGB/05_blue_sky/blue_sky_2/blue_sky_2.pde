size(700,700);
background(0,0,50);

//STARS
for(int i=0;i<(height*width)/100;i++) //POWTARZAJ
{
  float R=random(255);
  float G=random(255);
  float B=random(255);
  stroke(R,G,B);
  point(random(width),random(height));
}

//http://processingwedukacji.blogspot.com
