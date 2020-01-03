//"BILA" - MODEL RUCHU PUNKTU MATERIALNEGO - kolejne przybliżenia
//////////////////////////////////////////////////////////////////
//Program Processingu w trybie 2 - z widocznymi funkcjami
//////////////////////////////////////////////////////////////////
int FR=50; //Na ile kroków dzielimy sekundę?

void setup() //Jest wykonywane raz - po uruchomieniu
{
size(500,500);
//noSmooth();//Bez wygładzania lini? Po prostu odkomentować 
fill(250,250,0);
frameRate(FR);
background(0,0,200);//rgB
}

float h=0;
float x=0;
float vh=300;//prędkość pionowa w pikselach/SEKUNDE (!)
float vx=100;//prędkość pozioma
float ah=-50;//Przyśpieszenie/hamowanie - tylko w pionie
float B=0.90; //Wydajność odbicia sprężystego 1-B = ile energi kinetycznej się rozprasza nie wraca do prędkości po odbiciu

void draw() //Jest wykonywane w niewidocznej pętli
{
  //Wizualizacja
  //background(0,0,200);//rgB
  ellipse(x,height-h,25,25);
  
  //Właściwy model
  vh+=ah*1/FR; //Powiększ prędkość o zmianę prędkości czyli przyśpieszenie pomnozone przez jednostkę czasu 
  h+=vh*1/FR; //Powieksz wysokość o drogę czyli prędkość pomnożąną przez jednostkę czasu
  x+=vx*1/FR; //Powiększ położenie poziome

  //Odbijamy od ścianek okna! Upraszczamy mechanizm odbicia
  if(h<0) 
  {
    vh=-vh*B;
    h=0; //Trochę oszukujemy
  }
  else
  if(height<h)
  {
    vh=-vh*B;
    h=height;//Trochę oszukujemy
  }
  else
  if(x<0)
  {
     vx=-vx*B;
     x=0;//Trochę oszukujemy
  }
  else
  if(width<x)
  {
     vx=-vx*B;
     x=width;//Trochę oszukujemy
  }
}
//Efekt końcowy jest ciekawy. Skąd się bierze?