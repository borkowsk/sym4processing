//Program Processingu w trybie 2 - z widocznymi funkcjami
//////////////////////////////////////////////////////////
void setup() //Jest wykonywane raz - po uruchomieniu
{
size(500,500);
background(0,0,200);//rgB
noSmooth();//Bez wygładzania lini 
ellipse(250, 250, 200, 200);
}

//for(int i=0;i<inf;i+=2)
int i=0;
void draw() //Jest wykonywane w niewidocznej pętli
{
  fill(0,i % 256 ,0);///Jeśli na i użyjemy reszty z dzielenia czyli operacji modulo
                    //to gdy przekroczy 255 wróci do 0 i tak w nieskończoność
  arc(250, 250, 200, 200, radians(i-2),radians(i));
  i+=2;
}

//http://processingwedukacji.blogspot.com/2016/10/
