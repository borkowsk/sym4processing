size(500,500);
background(0,0,50);
//STARS
for(int i=0;i<9900;i+=1) //POWTARZAJ 9900
{
  float R=random(255);
  float G=random(255);
  float B=random(255);
  stroke(R,G,B);
  point(random(500),random(500));
}
