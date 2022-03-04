//"BILA" - MODEL RUCHU PUNKTU MATERIALNEGO - uproszczenie
//////////////////////////////////////////////////////////////////
//Program Processingu w trybie 2 - z widocznymi funkcjami
//////////////////////////////////////////////////////////////////
int FR=10; //Na ile kroków dzielimy sekundę?
float h=height/2;
float x=width/2;
float maxD=25;
float B=0.90; //Wydajność odbicia sprężystego 1-B = ile energi kinetycznej się rozprasza nie wraca do prędkości po odbiciu


void setup() //Jest wykonywane raz - po uruchomieniu
{
size(500,500);
h=height/2;
x=width/2;
//noSmooth();//Bez wygładzania lini? Po prostu odkomentować 
background(0,0,200);//rgB
frameRate(FR);
}

int count=0;
void draw() //Jest wykonywane w niewidocznej pętli
{
  //float oldh=h,oldx=x;
  
  //Wizualizacja
  fill(random(250),random(250),0);
  stroke(random(250),random(250),0);
  ellipse(x,height-h,25,25);
  
  //Właściwy model 
  h+=random(-maxD,maxD); //Powieksz wysokość o drogę czyli prędkość pomnożąną przez jednostkę czasu
  x+=random(-maxD,maxD); //Powiększ położenie poziome

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