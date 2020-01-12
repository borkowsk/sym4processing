size(500,500);
for(int i=0;i<1000;i++)
{
    fill(random(256),random(256),random(256));
    stroke(random(256),random(256),random(256));
    float x=random(500);
    float y=random(500);   
    float a=random(10,50);
    float b=random(a,50);
    ellipse(x,y,a,b);
}
