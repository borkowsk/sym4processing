//"BILA" - MODEL RUCHU PUNKTU MATERIALNEGO - kolejne przybliżenia
//////////////////////////////////////////////////////////////////
//Program Processingu w trybie 2 - z widocznymi funkcjami
//////////////////////////////////////////////////////////////////
int FR=50; //Na ile kroków dzielimy sekundę?

void setup(){ //Jest wykonywane raz - po uruchomieniu
size(500,500);
//noSmooth();//Bez wygładzania lini? Po prostu odkomentować 
fill(250,250,0);
frameRate(FR);
}

float h=0;
float v=100;//prędkość w pikselach/SEKUNDE (!)

void draw(){ //Jest wykonywane w niewidocznej pętli
  background(0,0,200);//rgB
  ellipse(width/2,height-h,25,25);
  h+=v*1/FR; //Powieksz wysokość o drogę w jednostce czasu
  h=h % height;
}