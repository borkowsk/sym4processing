//"BILA" - MODEL RUCHU PUNKTU MATERIALNEGO - kolejne przybliżenia
//////////////////////////////////////////////////////////////////
//Program Processingu w trybie 2 - z widocznymi funkcjami
//////////////////////////////////////////////////////////
void setup() //Jest wykonywane raz - po uruchomieniu
{
size(500,500);
noSmooth();//Bez wygładzania lini 
fill(250,250,0);
}

int h=0;
void draw() //Jest wykonywane w niewidocznej pętli
{
  background(0,0,200);//rgB - malowanie tła
  
  ellipse(width/2,  //W środku okna niezaleznie jaką wielkość ustawimy
          h, //Ruch z góry na dół, niezaleznie jaka wielkośc okna
          25,25);
  h++;
  h=h % height;
}