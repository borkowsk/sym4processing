//"BILA" - MODEL RUCHU PUNKTU MATERIALNEGO - BŁĄDZENIE LOSOWE
//////////////////////////////////////////////////////////////////
int FR=200; //Na ile kroków dzielimy sekundę?
float maxd=4;//Jaki największy ruch 
float h=0;//height/2; //Położenie pionowe
float x=0;//width/2;  //Położenie poziome

void setup() //Jest wykonywane raz - po uruchomieniu. Nie musi być na poczatku kodu ale jest
{
size(500,500);
noSmooth();
h=height/2; x=width/2;
background(0,0,200);//rgB
frameRate(FR);
}
              
int count=0;//Licznik klatek obrazu
void draw() //Jest wykonywane w niewidocznej pętli
{
  //Wizualizacja w losowym kolorze: stroke((count+random(255))%256);
  stroke(count % 256);
  point(x,height-h);
  count++; //Zliczanie klatek
  
   //Właściwy model
  float newh=(h+random(maxd*2)-maxd); //Zmień wysokość o mały losowy składnik
  float newx=(x+random(maxd*2)-maxd); //Analogicznie powiększ położenie poziome

  //Odbijamy od ścianek okna! Upraszczamy mechanizm odbicia
  if(newh<0) 
    newh=0;//Trochę oszukujemy - nie może trafić w ścianę
  else
  if(height<newh)
    newh=height;//Trochę oszukujemy

  if(newx<0)
     newx=0;//Trochę oszukujemy
  else
  if(width<newx)
     newx=width;//Trochę oszukujemy
  
  x=newx;
  h=newh;
}