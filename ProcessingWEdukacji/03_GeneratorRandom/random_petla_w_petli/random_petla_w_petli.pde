size(500,500);
for(int i=0;i<500;i+=10)
{
  for(int j=0;j<500;j+=10)
  {
    stroke(random(256),random(256),random(256));
    //ellipse(i+5,j+5,10,10);
    line(i,j,i+10,j+10);
  }
}
