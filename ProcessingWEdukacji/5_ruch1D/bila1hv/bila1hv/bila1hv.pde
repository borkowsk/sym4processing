//"BILA" - MODEL RUCHU PUNKTU MATERIALNEGO - pierwsze przybliżenie
//////////////////////////////////////////////////////////////////
//Program Processingu w trybie 2 - z widocznymi funkcjami
//////////////////////////////////////////////////////////
void setup() //Jest wykonywane raz - po uruchomieniu
{
size(500,500);
//noSmooth();//Bez wygładzania lini? Po prostu odkomentować 
fill(250,250,0);
frameRate(150);
}

int h=0;
void draw() //Jest wykonywane w niewidocznej pętli
{
  background(0,0,200);//rgB
  ellipse(width/2,height-h,25,25);
  h++;
  h=h % height;
}