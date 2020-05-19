//"BILA" - MODEL RUCHU PUNKTU MATERIALNEGO - kolejne przybliżenia
//////////////////////////////////////////////////////////////////
//Program Processingu w trybie 2 - z widocznymi funkcjami
//////////////////////////////////////////////////////////
void setup() //Jest wykonywane raz - po uruchomieniu
{
size(500,500);
noSmooth();//Bez wygładzania lini 
fill(255,0,0);
}

int h=0;//Wysokość
void draw() //Jest wykonywane w niewidocznej pętli
{
  background(0,0,200);//rgB
  ellipse(width/2,height-h,25,25);
  h++;
  h=h % height;
}