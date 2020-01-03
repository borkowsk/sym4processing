size(500,500);
background(0,0,200);//rgB
noSmooth();//Bez wygładzania lini 
ellipse(250, 250, 200, 200);
for(int i=0;i<256;i+=10)
{
  fill(0,i,0);//rGb
  arc(250, 250, 200, 200, radians(i-10),radians(i));
}