//"BILA" - MODEL RUCHU PUNKTU MATERIALNEGO - kolejne przybliżenia
//////////////////////////////////////////////////////////////////
//Program Processingu w trybie 2 - z widocznymi funkcjami
//////////////////////////////////////////////////////////////////
int FR=10; //Na ile kroków dzielimy sekundę?
float h=height/2;
float x=width/2;
float vh=0;//prędkość pionowa w pikselach/SEKUNDE (!)
float vx=0;//prędkość pozioma
float maxV=50;
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
  //Wizualizacja
  fill(random(250),random(250),0);
  stroke(random(250),random(250),0);
  ellipse(x,height-h,25,25);
  
  //Właściwy model
  count++;
  if(count % FR ==0) //Raz na sekundę zmienia wektor prędkości
  {
    vh=random(-maxV,maxV); 
    vx=random(-maxV,maxV); 
  }
  
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
  else //A jakby to wykomentować?
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
     //print(x,' ');
  }
}
//Efekt końcowy jest ciekawy. Skąd się bierze?