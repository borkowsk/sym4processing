//"BILA" - MODEL RUCHU PUNKTU MATERIALNEGO - uproszczenie
//////////////////////////////////////////////////////////////////
//Program Processingu w trybie 2 - z widocznymi funkcjami
//////////////////////////////////////////////////////////////////
int FR=100; //Na ile kroków dzielimy sekundę?
float h=height/2;
float x=width/2;
float maxD=25;

void setup() //Jest wykonywane raz - po uruchomieniu
{
size(500,500);
h=height/2;
x=width/2;
//noSmooth();//Bez wygładzania lini? Po prostu odkomentować 
background(0,0,200);//rgB
frameRate(FR);
}

void draw() //Jest wykonywane w niewidocznej pętli
{
  //float oldh=h,oldx=x;
  
  //Wizualizacja
  fill(random(250),random(250),0,50);
  noStroke();//albo stroke(random(250),random(250),0,25);
  ellipse(x,height-h,25,25);
  
  //Właściwy model 
  h+=random(-maxD,maxD); //Zmien wysokość o wylosowaną drogę 
  x+=random(-maxD,maxD); //Zmien położenie poziome o wylosowany odcinek

  //Odbijamy od ścianek okna! Upraszczamy mechanizm odbicia
  if(h<0) 
  {
    h=0; //Trochę oszukujemy
  }
  else
  if(height<h)
  {
    h=height;//Trochę oszukujemy
  }
  else //A jakby to wykomentować?
  if(x<0)
  {
     x=0;//Trochę oszukujemy
  }
  else
  if(width<x)
  {
     x=width;//Trochę oszukujemy
  }
}
